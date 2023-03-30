/*
Created by Bogdan Vlahov on 3/22/2023
*/
#include <mppi/sampling_distributions/sampling_distribution.cuh>

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::GPUSetup()
{
  CLASS_T* derived = static_cast<CLASS_T*>(this);
  if (!GPUMemStatus_)
  {
    sampling_d_ = Managed::GPUSetup<CLASS_T>(derived);
    allocateCUDAMemory();
  }
  else
  {
    std::cout << "GPU Memory already set" << std::endl;
  }
  derived->paramsToDevice();
}

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
__host__ void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::freeCudaMem()
{
  if (GPUMemStatus_)
  {
    HANDLE_ERROR(cudaFree(sampling_d_));
    HANDLE_ERROR(cudaFree(control_samples_d_));
    GPUMemStatus_ = false;
    sampling_d_ = nullptr;
    control_samples_d_ = nullptr;
  }
}

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::initializeDistributions(
    const float* __restrict__ output, const float t_0, const float dt, float* __restrict__ theta_d)
{
  *static_cast<SAMPLING_PARAMS_T*>(theta_d) = this->params_;
}

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
__host__ void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::paramsToDevice(bool synchronize)
{
  if (GPUMemStatus_)
  {
    HANDLE_ERROR(
        cudaMemcpyAsync(&sampling_d_->params_, &params_, sizeof(SAMPLING_PARAMS_T), cudaMemcpyHostToDevice, stream_));
    if (synchronize)
    {
      HANDLE_ERROR(cudaStreamSynchronize(stream_));
    }
  }
}

// By default, call the update from device method by first putting the weights into gpu memory
template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
__host__ void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::updateDistributionParamsFromHost(
    const Eigen::Ref<const Eigen::MatrixXf>& trajectory_weights, float normalizer, const int& distribution_i,
    bool synchronize)
{
  float* trajectory_weights_d;
  HANDLE_ERROR(cudaMallocAsync((void**)&trajectory_weights_d, sizeof(float) this->getNumRollouts(), this->stream_));
  HANDLE_ERROR(cudaMemcpyAsync(trajectory_weights_d, trajectory_weights.data(), NUM_ROLLOUTS * sizeof(float),
                               cudaMemcpyHostToDevice, this->stream_));
  updateDistributionParamsFromDevice(trajectory_weights_d, normalizer, distribution_i, false);
  HANDLE_ERROR(cudaFreeAsync(trajectory_weights_d));
  if (synchronize)
  {
    HANDLE_ERROR(cudaStreamSynchronize(this->stream_));
  }
}

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
__host__ void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::allocateCUDAMemory(bool synchronize)
{
  if (GPUMemStatus_)
  {
    if (control_samples_d_)
    {  // deallocate previous memory for control samples
      HANDLE_ERROR(cudaFreeAsync(control_samples_d_, stream_));
      // control_samples_d_ = nullptr;
    }
    HANDLE_ERROR(cudaMallocAsync((void**)&control_samples_d_,
                                 sizeof(float) * this->getNumDistributions() * this->getNumRollouts() *
                                     this->getNumTimesteps() * CONTROL_DIM,
                                 stream_));
    HANDLE_ERROR(cudaMemcpyAsync(&sampling_d_->control_samples_d_, &control_samples_d_, sizeof(float*),
                                 cudaMemcpyHostToDevice, stream_));
  }
  allocateCUDAMemoryHelper();
  if (synchronize)
  {
    HANDLE_ERROR(cudaStreamSynchronize(stream_));
  }
}

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
__device__ void SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::readControlSample(
    const int& sample_index, const int& t, const int& distribution_index, float* __restrict__ control,
    float* __restrict__ theta_d, const int& block_size, const int& thread_index, const float* __restrict__ output)
{
  SAMPLING_PARAMS_T* params_p = (SAMPLING_PARAMS_T*)theta_d;
  const int distribution_i = distribution_index >= params_p->num_distributions ? 0 : distribution_index;
  const int control_index =
      ((params_p->num_rollouts * distribution_i + sample_idx) * params_p->num_timesteps + t) * CONTROL_DIM;
  if (CONTROL_DIM % 4 == 0)
  {
    float4* u4 = reinterpret_cast<float4*>(control);
    const float4* u4_d = reinterpret_cast<const float4*>(&(this->control_samples_d_[control_index]));
    for (int i = thread_idx; i < CONTROL_DIM / 4; i += block_size)
    {
      u4[j] = u4_d[j];
    }
  }
  else if (CONTROL_DIM % 2 == 0)
  {
    float2* u2 = reinterpret_cast<float2*>(control);
    const float2* u2_d = reinterpret_cast<const float2*>(&(this->control_samples_d_[control_index]));
    for (int i = thread_idx; i < CONTROL_DIM / 2; i += block_size)
    {
      u2[j] = u2_d[j];
    }
  }
  else
  {
    float* u = reinterpret_cast<float*>(control);
    const float* u_d = reinterpret_cast<const float*>(&(this->control_samples_d_[control_index]));
    for (int i = thread_idx; i < CONTROL_DIM; i += block_size)
    {
      u[j] = u_d[j];
    }
  }
}

template <class CLASS_T, template <int> class PARAMS_TEMPLATE, class DYN_PARAMS_T>
__device__ float* SamplingDistribution<CLASS_T, PARAMS_TEMPLATE, DYN_PARAMS_T>::getControlSample(
    const int& sample_index, const int& t, const int& distribution_index, const float* __restrict__ output)
{
  SAMPLING_PARAMS_T* params_p = (SAMPLING_PARAMS_T*)theta_d;
  const int distribution_i = distribution_index >= params_p->num_distributions ? 0 : distribution_index;
  return &this->control_samples_d_[((params_p->num_rollouts * distribution_i + sample_index) * params_p->num_timesteps +
                                    t) *
                                   CONTROL_DIM];
}
