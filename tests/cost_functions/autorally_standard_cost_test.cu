//
// Created by jason on 1/7/20.
//

#include <gtest/gtest.h>
#include <cost_functions/autorally/ar_standard_cost.cuh>
#include <cost_functions/ar_standard_cost_kernel_test.cuh>

// Auto-generated header file
#include <autorally_test_map.h>

TEST(ARStandardCost, Constructor) {
  ARStandardCost cost;
}

TEST(ARStandardCost, BindStream) {
  cudaStream_t stream;

  HANDLE_ERROR(cudaStreamCreate(&stream));

  ARStandardCost cost(stream);

  EXPECT_EQ(cost.stream_, stream) << "Stream binding failure.";

  HANDLE_ERROR(cudaStreamDestroy(stream));
}

TEST(ARStandardCost, SetGetParamsHost) {
  ARStandardCost::ARStandardCostParams params;
  params.desired_speed = 25;
  params.speed_coeff = 2;
  params.track_coeff = 100;
  params.max_slip_ang = 1.5;
  params.slip_penalty = 1000;
  params.track_slop = 0.2;
  params.crash_coeff = 10000;
  params.steering_coeff = 20;
  params.throttle_coeff = 10;
  params.boundary_threshold = 10;
  params.discount = 0.9;
  params.grid_res = 2;
  params.num_timesteps = 100;

  params.r_c1.x = 0;
  params.r_c1.y = 1;
  params.r_c1.z = 2;
  params.r_c2.x = 3;
  params.r_c2.y = 4;
  params.r_c2.z = 5;
  params.trs.x = 6;
  params.trs.y = 7;
  params.trs.z = 8;
  ARStandardCost cost;

  cost.setParams(params);
  ARStandardCost::ARStandardCostParams result_params = cost.getParams();

  EXPECT_FLOAT_EQ(params.desired_speed, result_params.desired_speed);
  EXPECT_FLOAT_EQ(params.speed_coeff, result_params.speed_coeff);
  EXPECT_FLOAT_EQ(params.track_coeff, result_params.track_coeff);
  EXPECT_FLOAT_EQ(params.max_slip_ang, result_params.max_slip_ang);
  EXPECT_FLOAT_EQ(params.slip_penalty, result_params.slip_penalty);
  EXPECT_FLOAT_EQ(params.track_slop, result_params.track_slop);
  EXPECT_FLOAT_EQ(params.crash_coeff, result_params.crash_coeff);
  EXPECT_FLOAT_EQ(params.steering_coeff, result_params.steering_coeff);
  EXPECT_FLOAT_EQ(params.throttle_coeff, result_params.throttle_coeff);
  EXPECT_FLOAT_EQ(params.boundary_threshold, result_params.boundary_threshold);
  EXPECT_FLOAT_EQ(params.discount, result_params.discount);
  EXPECT_EQ(params.grid_res, result_params.grid_res);
  EXPECT_EQ(params.num_timesteps, result_params.num_timesteps);
  EXPECT_FLOAT_EQ(params.r_c1.x, result_params.r_c1.x);
  EXPECT_FLOAT_EQ(params.r_c1.y, result_params.r_c1.y);
  EXPECT_FLOAT_EQ(params.r_c1.z, result_params.r_c1.z);
  EXPECT_FLOAT_EQ(params.r_c2.x, result_params.r_c2.x);
  EXPECT_FLOAT_EQ(params.r_c2.y, result_params.r_c2.y);
  EXPECT_FLOAT_EQ(params.r_c2.z, result_params.r_c2.z);
  EXPECT_FLOAT_EQ(params.trs.x, result_params.trs.x);
  EXPECT_FLOAT_EQ(params.trs.y, result_params.trs.y);
  EXPECT_FLOAT_EQ(params.trs.z, result_params.trs.z);
}

TEST(ARStandardCost, GPUSetupAndParamsToDeviceTest) {

  // TODO make sre GPUMemstatus is false on the GPU so deallocation can be automatic
  ARStandardCost::ARStandardCostParams params;
  ARStandardCost cost;
  params.desired_speed = 25;
  params.speed_coeff = 2;
  params.track_coeff = 100;
  params.max_slip_ang = 1.5;
  params.slip_penalty = 1000;
  params.track_slop = 0.2;
  params.crash_coeff = 10000;
  params.steering_coeff = 20;
  params.throttle_coeff = 10;
  params.boundary_threshold = 10;
  params.discount = 0.9;
  params.grid_res = 2;
  params.num_timesteps = 100;

  params.r_c1.x = 0;
  params.r_c1.y = 1;
  params.r_c1.z = 2;
  params.r_c2.x = 3;
  params.r_c2.y = 4;
  params.r_c2.z = 5;
  params.trs.x = 6;
  params.trs.y = 7;
  params.trs.z = 8;
  cost.setParams(params);

  EXPECT_EQ(cost.GPUMemStatus_, false);
  EXPECT_EQ(cost.cost_d_, nullptr);

  cost.GPUSetup();

  EXPECT_EQ(cost.GPUMemStatus_, true);
  EXPECT_NE(cost.cost_d_, nullptr);


  ARStandardCost::ARStandardCostParams result_params;
  int width, height;
  launchParameterTestKernel(cost, result_params, width, height);

  EXPECT_FLOAT_EQ(params.desired_speed, result_params.desired_speed);
  EXPECT_FLOAT_EQ(params.speed_coeff, result_params.speed_coeff);
  EXPECT_FLOAT_EQ(params.track_coeff, result_params.track_coeff);
  EXPECT_FLOAT_EQ(params.max_slip_ang, result_params.max_slip_ang);
  EXPECT_FLOAT_EQ(params.slip_penalty, result_params.slip_penalty);
  EXPECT_FLOAT_EQ(params.track_slop, result_params.track_slop);
  EXPECT_FLOAT_EQ(params.crash_coeff, result_params.crash_coeff);
  EXPECT_FLOAT_EQ(params.steering_coeff, result_params.steering_coeff);
  EXPECT_FLOAT_EQ(params.throttle_coeff, result_params.throttle_coeff);
  EXPECT_FLOAT_EQ(params.boundary_threshold, result_params.boundary_threshold);
  EXPECT_FLOAT_EQ(params.discount, result_params.discount);
  EXPECT_EQ(params.grid_res, result_params.grid_res);
  EXPECT_EQ(params.num_timesteps, result_params.num_timesteps);
  EXPECT_FLOAT_EQ(params.r_c1.x, result_params.r_c1.x);
  EXPECT_FLOAT_EQ(params.r_c1.y, result_params.r_c1.y);
  EXPECT_FLOAT_EQ(params.r_c1.z, result_params.r_c1.z);
  EXPECT_FLOAT_EQ(params.r_c2.x, result_params.r_c2.x);
  EXPECT_FLOAT_EQ(params.r_c2.y, result_params.r_c2.y);
  EXPECT_FLOAT_EQ(params.r_c2.z, result_params.r_c2.z);
  EXPECT_FLOAT_EQ(params.trs.x, result_params.trs.x);
  EXPECT_FLOAT_EQ(params.trs.y, result_params.trs.y);
  EXPECT_FLOAT_EQ(params.trs.z, result_params.trs.z);
  // neither should be set by this sequence
  EXPECT_EQ(width, -1);
  EXPECT_EQ(height, -1);

  params.desired_speed = 5;
  params.num_timesteps = 50;
  params.r_c1.x = 4;
  params.r_c1.y = 5;
  params.r_c1.z = 6;
  cost.setParams(params);

  launchParameterTestKernel(cost, result_params, width, height);

  EXPECT_FLOAT_EQ(params.desired_speed, result_params.desired_speed);
  EXPECT_FLOAT_EQ(params.speed_coeff, result_params.speed_coeff);
  EXPECT_FLOAT_EQ(params.track_coeff, result_params.track_coeff);
  EXPECT_FLOAT_EQ(params.max_slip_ang, result_params.max_slip_ang);
  EXPECT_FLOAT_EQ(params.slip_penalty, result_params.slip_penalty);
  EXPECT_FLOAT_EQ(params.track_slop, result_params.track_slop);
  EXPECT_FLOAT_EQ(params.crash_coeff, result_params.crash_coeff);
  EXPECT_FLOAT_EQ(params.steering_coeff, result_params.steering_coeff);
  EXPECT_FLOAT_EQ(params.throttle_coeff, result_params.throttle_coeff);
  EXPECT_FLOAT_EQ(params.boundary_threshold, result_params.boundary_threshold);
  EXPECT_FLOAT_EQ(params.discount, result_params.discount);
  EXPECT_EQ(params.grid_res, result_params.grid_res);
  EXPECT_EQ(params.num_timesteps, result_params.num_timesteps);
  EXPECT_FLOAT_EQ(params.r_c1.x, result_params.r_c1.x);
  EXPECT_FLOAT_EQ(params.r_c1.y, result_params.r_c1.y);
  EXPECT_FLOAT_EQ(params.r_c1.z, result_params.r_c1.z);
  EXPECT_FLOAT_EQ(params.r_c2.x, result_params.r_c2.x);
  EXPECT_FLOAT_EQ(params.r_c2.y, result_params.r_c2.y);
  EXPECT_FLOAT_EQ(params.r_c2.z, result_params.r_c2.z);
  EXPECT_FLOAT_EQ(params.trs.x, result_params.trs.x);
  EXPECT_FLOAT_EQ(params.trs.y, result_params.trs.y);
  EXPECT_FLOAT_EQ(params.trs.z, result_params.trs.z);

  // neither should be set by this sequence
  EXPECT_EQ(width, -1);
  EXPECT_EQ(height, -1);
}

TEST(ARStandardCost, coorTransformTest) {
  float x,y,u,v,w;

  ARStandardCost::ARStandardCostParams params;
  ARStandardCost cost;

  x = 0;
  y = 10;

  params.r_c1.x = 0;
  params.r_c1.y = 1;
  params.r_c1.z = 2;
  params.r_c2.x = 3;
  params.r_c2.y = 4;
  params.r_c2.z = 5;
  params.trs.x = 6;
  params.trs.y = 7;
  params.trs.z = 8;
  cost.setParams(params);

  cost.coorTransform(x, y, &u, &v, &w);

  EXPECT_FLOAT_EQ(u, 36);
  EXPECT_FLOAT_EQ(v, 47);
  EXPECT_FLOAT_EQ(w, 58);
}

TEST(ARStandardCost, changeCostmapSizeTestValidInputs) {
  ARStandardCost cost;
  cost.changeCostmapSize(4, 8);

  EXPECT_EQ(cost.getWidth(), 4);
  EXPECT_EQ(cost.getHeight(), 8);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 4*8);

  std::vector<float4> result;

  //launchCheckCudaArray(result, cost.getCudaArray(), 4*8);

  //EXPECT_EQ(result.size(), 4*8);
  // TODO verify that cuda is properly allocating the memory
  /*
  for(int i = 0; i < 4*8; i++) {
    EXPECT_FLOAT_EQ(result[i].x, 0);
    EXPECT_FLOAT_EQ(result[i].y, 0);
    EXPECT_FLOAT_EQ(result[i].z, 0);
    EXPECT_FLOAT_EQ(result[i].w, 0);
  }
   */
}

TEST(ARStandardCost, changeCostmapSizeTestFail) {
  ARStandardCost cost;
  cost.changeCostmapSize(4, 8);

  EXPECT_EQ(cost.getWidth(), 4);
  EXPECT_EQ(cost.getHeight(), 8);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 4*8);

  testing::internal::CaptureStderr();
  cost.changeCostmapSize(-1, -1);
  std::string error_msg = testing::internal::GetCapturedStderr();

  EXPECT_NE(error_msg, "");

  EXPECT_EQ(cost.getWidth(), 4);
  EXPECT_EQ(cost.getHeight(), 8);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 4*8);
}

TEST(ARStandardCost, clearCostmapTest) {
  ARStandardCost cost;
  cost.clearCostmapCPU(4, 8);

  EXPECT_EQ(cost.getWidth(), 4);
  EXPECT_EQ(cost.getHeight(), 8);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 4*8);

  for(int i = 0; i < 4 * 8; i++) {
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).x, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).y, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).z, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).w, 0);
  }
}

TEST(ARStandardCost, clearCostmapTestDefault) {
  ARStandardCost cost;
  cost.clearCostmapCPU(4, 8);

  EXPECT_EQ(cost.getWidth(), 4);
  EXPECT_EQ(cost.getHeight(), 8);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 4*8);

  for(int i = 0; i < 4 * 8; i++) {
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).x, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).y, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).z, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).w, 0);
  }

  testing::internal::CaptureStderr();
  cost.clearCostmapCPU();
  std::string error_msg = testing::internal::GetCapturedStderr();

  EXPECT_NE(error_msg, "");

  EXPECT_EQ(cost.getWidth(), 4);
  EXPECT_EQ(cost.getHeight(), 8);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 4*8);

  for(int i = 0; i < 4 * 8; i++) {
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).x, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).y, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).z, 0);
    EXPECT_FLOAT_EQ(cost.getTrackCostCPU().at(i).w, 0);
  }
}

TEST(ARStandardCost, clearCostmapTestDefaultFail) {
  ARStandardCost cost;

  testing::internal::CaptureStderr();
  cost.clearCostmapCPU();
  std::string error_msg = testing::internal::GetCapturedStderr();

  EXPECT_NE(error_msg, "");

  EXPECT_EQ(cost.getWidth(), -1);
  EXPECT_EQ(cost.getHeight(), -1);
  EXPECT_EQ(cost.getTrackCostCPU().capacity(), 0);
}

TEST(ARStandardCost, updateTransformCPUTest) {
  ARStandardCost cost;
  Eigen::MatrixXf R(3, 3);
  Eigen::ArrayXf trs(3);
  R(0,0) = 1;
  R(0,1) = 2;
  R(0,2) = 3;

  R(1,0) = 4;
  R(1,1) = 5;
  R(1,2) = 6;

  R(2,0) = 7;
  R(2,1) = 8;
  R(2,2) = 9;

  trs(0) = 10;
  trs(1) = 11;
  trs(2) = 12;

  cost.updateTransform(R, trs);

  /*
   * Prospective transform matrix
   * r_c1.x, r_c2.x, trs.x
   * r_c1.y, r_c2.y, trs.y
   * r_c1.z, r_c2.z, trs.z
   */

  EXPECT_FLOAT_EQ(cost.getParams().r_c1.x, 1);
  EXPECT_FLOAT_EQ(cost.getParams().r_c2.x, 2);
  EXPECT_FLOAT_EQ(cost.getParams().trs.x, 10);

  EXPECT_FLOAT_EQ(cost.getParams().r_c1.y, 4);
  EXPECT_FLOAT_EQ(cost.getParams().r_c2.y, 5);
  EXPECT_FLOAT_EQ(cost.getParams().trs.y, 11);

  EXPECT_FLOAT_EQ(cost.getParams().r_c1.z, 7);
  EXPECT_FLOAT_EQ(cost.getParams().r_c2.z, 8);
  EXPECT_FLOAT_EQ(cost.getParams().trs.z, 12);

  EXPECT_EQ(cost.GPUMemStatus_, false);
}

TEST(ARStandardCost, updateTransformGPUTest) {

  ARStandardCost cost;
  cost.GPUSetup();
  Eigen::MatrixXf R(3, 3);
  Eigen::ArrayXf trs(3);
  R(0,0) = 1;
  R(0,1) = 2;
  R(0,2) = 3;

  R(1,0) = 4;
  R(1,1) = 5;
  R(1,2) = 6;

  R(2,0) = 7;
  R(2,1) = 8;
  R(2,2) = 9;

  trs(0) = 10;
  trs(1) = 11;
  trs(2) = 12;

  cost.updateTransform(R, trs);

  /*
   * Prospective transform matrix
   * r_c1.x, r_c2.x, trs.x
   * r_c1.y, r_c2.y, trs.y
   * r_c1.z, r_c2.z, trs.z
   */

  std::vector<float3> results;
  launchTransformTestKernel(results, cost);

  EXPECT_EQ(results.size(), 3);

  EXPECT_FLOAT_EQ(results.at(0).x, 1);
  EXPECT_FLOAT_EQ(results.at(0).y, 4);
  EXPECT_FLOAT_EQ(results.at(0).z, 7);

  EXPECT_FLOAT_EQ(results.at(1).x, 2);
  EXPECT_FLOAT_EQ(results.at(1).y, 5);
  EXPECT_FLOAT_EQ(results.at(1).z, 8);

  EXPECT_FLOAT_EQ(results.at(2).x, 10);
  EXPECT_FLOAT_EQ(results.at(2).y, 11);
  EXPECT_FLOAT_EQ(results.at(2).z, 12);

  EXPECT_EQ(cost.GPUMemStatus_, true);
}

TEST(ARStandardCost, LoadTrackDataInvalidLocationTest) {
  ARStandardCost cost;

  testing::internal::CaptureStderr();
  cost.loadTrackData("/null");
  std::string error_msg = testing::internal::GetCapturedStderr();

  EXPECT_NE(error_msg, "");
  EXPECT_NE(error_msg.find("/null", 0), std::string::npos);
}


TEST(ARStandardCost, LoadTrackDataTest) {
  ARStandardCost cost;
  // TODO set parameters for cost map
  cost.GPUSetup();

  // load
  std::vector<float4> costmap = cost.loadTrackData(mppi::tests::test_map_file);

  Eigen::Matrix3f R = cost.getRotation();
  Eigen::Array3f trs = cost.getTranslation();

  EXPECT_FLOAT_EQ(costmap.at(0).x, 0);
  EXPECT_FLOAT_EQ(costmap.at(0).y, 0);
  EXPECT_FLOAT_EQ(costmap.at(0).z, 0);
  EXPECT_FLOAT_EQ(costmap.at(0).w, 0);
  EXPECT_FLOAT_EQ(costmap.at(1).x, 1);
  EXPECT_FLOAT_EQ(costmap.at(1).y, 10);
  EXPECT_FLOAT_EQ(costmap.at(1).z, 100);
  EXPECT_FLOAT_EQ(costmap.at(1).w, 1000);

  // check transformation, should not have a rotation
  EXPECT_FLOAT_EQ(R(0,0), 1.0 / (10));
  EXPECT_FLOAT_EQ(R(1,1), 1.0 / (20));
  EXPECT_FLOAT_EQ(R(2,2), 1.0);

  EXPECT_FLOAT_EQ(R(0, 1), 0);
  EXPECT_FLOAT_EQ(R(0, 2), 0);
  EXPECT_FLOAT_EQ(R(1, 0), 0);
  EXPECT_FLOAT_EQ(R(1, 2), 0);
  EXPECT_FLOAT_EQ(R(2, 0), 0);
  EXPECT_FLOAT_EQ(R(2, 1), 0);

  EXPECT_FLOAT_EQ(trs(0), 0.5);
  EXPECT_FLOAT_EQ(trs(1), 0.5);
  EXPECT_FLOAT_EQ(trs(2), 1);

  for(int i = 0; i < 2 * 10; i++) {
    for(int j = 0; j < 2 * 20; j++) {
      EXPECT_FLOAT_EQ(costmap.at(i*2*20 + j).x, i*2*20 + j);
      EXPECT_FLOAT_EQ(costmap.at(i*2*20 + j).y, (i*2*20 + j) * 10);
      EXPECT_FLOAT_EQ(costmap.at(i*2*20 + j).z, (i*2*20 + j) * 100);
      EXPECT_FLOAT_EQ(costmap.at(i*2*20 + j).w, (i*2*20 + j) * 1000);
    }
  }

}

TEST(ARStandardCost, costmapToTextureNoSizeTest) {
  ARStandardCost cost;
  cost.GPUSetup();

  testing::internal::CaptureStderr();
  cost.costmapToTexture();
  std::string error_msg = testing::internal::GetCapturedStderr();

  EXPECT_NE(error_msg, "");
}

TEST(ARStandardCost, costmapToTextureNoLoadTest) {
  ARStandardCost cost;
  cost.GPUSetup();

  cost.changeCostmapSize(4, 8);

  cost.costmapToTexture();

  std::vector<float4> results;
  std::vector<float2> query_points;
  float2 point;
  point.x = 0.0f;
  point.y = 0.0f;
  query_points.push_back(point);
  point.x = 1.0f;
  point.y = 0.0f;
  query_points.push_back(point);

  launchTextureTestKernel(cost, results, query_points);

  EXPECT_EQ(query_points.size(), results.size());

  EXPECT_FLOAT_EQ(results.at(0).x, 0);
  EXPECT_FLOAT_EQ(results.at(0).y, 0);
  EXPECT_FLOAT_EQ(results.at(0).z, 0);
  EXPECT_FLOAT_EQ(results.at(0).w, 0);

  EXPECT_FLOAT_EQ(results.at(1).x, 0);
  EXPECT_FLOAT_EQ(results.at(1).y, 0);
  EXPECT_FLOAT_EQ(results.at(1).z, 0);
  EXPECT_FLOAT_EQ(results.at(1).w, 0);
}

TEST(ARStandardCost, costmapToTextureLoadTest) {
  ARStandardCost cost;
  cost.GPUSetup();

  Eigen::Matrix3f R;
  Eigen::Array3f trs;

  std::vector<float4> costmap = cost.loadTrackData(mppi::tests::test_map_file);
  cost.costmapToTexture();

  std::vector<float4> results;
  std::vector<float2> query_points;
  float2 point;
  point.x = 0;
  point.y = 0;
  query_points.push_back(point);
  point.x = 0.1; // index 1 normalized
  point.y = 0;
  query_points.push_back(point);

  launchTextureTestKernel(cost, results, query_points);

  EXPECT_EQ(query_points.size(), results.size());

  EXPECT_FLOAT_EQ(results.at(0).x, 0);
  EXPECT_FLOAT_EQ(results.at(0).y, 0);
  EXPECT_FLOAT_EQ(results.at(0).z, 0);
  EXPECT_FLOAT_EQ(results.at(0).w, 0);
  EXPECT_FLOAT_EQ(results.at(1).x, 1);
  EXPECT_FLOAT_EQ(results.at(1).y, 10);
  EXPECT_FLOAT_EQ(results.at(1).z, 100);
  EXPECT_FLOAT_EQ(results.at(1).w, 1000);
}


TEST(ARStandardCost, costmapToTextureTransformTest) {
  ARStandardCost cost;
  cost.GPUSetup();


  std::vector<float4> costmap = cost.loadTrackData(mppi::tests::test_map_file);
  cost.costmapToTexture();

  std::vector<float4> results;
  std::vector<float2> query_points;
  float2 point;
  // transform has x = 0.5
  point.x = -4.5; // comes out to index 0
  point.y = -10;
  query_points.push_back(point);
  point.x = -3.5; // 1 meter over, 2ppm = third index
  point.y = -10;
  query_points.push_back(point);

  launchTextureTransformTestKernel(cost, results, query_points);

  EXPECT_EQ(query_points.size(), results.size());

  EXPECT_FLOAT_EQ(results.at(0).x, 0);
  EXPECT_FLOAT_EQ(results.at(0).y, 0);
  EXPECT_FLOAT_EQ(results.at(0).z, 0);
  EXPECT_FLOAT_EQ(results.at(0).w, 0);
  EXPECT_FLOAT_EQ(results.at(1).x, 2);
  EXPECT_FLOAT_EQ(results.at(1).y, 20);
  EXPECT_FLOAT_EQ(results.at(1).z, 200);
  EXPECT_FLOAT_EQ(results.at(1).w, 2000);


  Eigen::Matrix3f R;
  Eigen::Array3f trs;

  R <<  0.1, 0, 0, 0, 0.05, 0, 0, 0, 1;
  trs << 0, 0, 1;
  cost.updateTransform(R, trs);

  query_points[0].x = 0.0;
  query_points[0].y = 0.0;

  query_points[1].x = 0.0;
  query_points[1].y = 1.0;

  launchTextureTransformTestKernel(cost, results, query_points);

  EXPECT_EQ(query_points.size(), results.size());

  EXPECT_FLOAT_EQ(results.at(0).x, 0);
  EXPECT_FLOAT_EQ(results.at(0).y, 0);
  EXPECT_FLOAT_EQ(results.at(0).z, 0);
  EXPECT_FLOAT_EQ(results.at(0).w, 0);
  EXPECT_FLOAT_EQ(results.at(1).x, 20);
  EXPECT_FLOAT_EQ(results.at(1).y, 200);
  EXPECT_FLOAT_EQ(results.at(1).z, 2000);
  EXPECT_FLOAT_EQ(results.at(1).w, 20000);
}


TEST(ARStandardCost, TerminalCostTest) {
  ARStandardCost cost;
  float state[7];
  float result = cost.getTerminalCost(state);
  EXPECT_FLOAT_EQ(result, 0.0);
}

TEST(ARStandardCost, controlCostTest) {

  float u[2] = {0.5, 0.6};
  float du[2] = {0.3, 0.4};
  float nu[2] = {0.2, 0.8};
  ARStandardCost cost;
  ARStandardCost::ARStandardCostParams params;
  params.steering_coeff = 20;
  params.throttle_coeff = 10;
  cost.setParams(params);

  float result = cost.getControlCost(u, du, nu);

  EXPECT_FLOAT_EQ(result, 1.5*20+.125*10);

  params.throttle_coeff = 20;
  params.steering_coeff = 10;
  cost.setParams(params);

  result = cost.getControlCost(u, du, nu);
  EXPECT_FLOAT_EQ(result, 1.5*10+.125*20);
}

TEST(ARStandardCost, getSpeedCostTest) {
  ARStandardCost cost;
  ARStandardCost::ARStandardCostParams params;
  params.desired_speed = 25;
  params.speed_coeff = 10;
  cost.setParams(params);

  float state[7];
  for(int i = 0; i < 7; i++) {
    state[i] = 0;
  }
  int crash = 0;
  state[4] = 10;

  float result = cost.getSpeedCost(state, &crash);

  EXPECT_FLOAT_EQ(result, 15*15*10);

  params.desired_speed = 0;
  params.speed_coeff = 100;
  cost.setParams(params);

  result = cost.getSpeedCost(state, &crash);

  EXPECT_FLOAT_EQ(result, 10*10*100);
}

TEST(ARStandardCost, getStablizingCostTest) {
  ARStandardCost cost;
  ARStandardCost::ARStandardCostParams params;
  params.slip_penalty = 25;
  params.crash_coeff = 1000;
  params.max_slip_ang = 0.5;
  cost.setParams(params);

  float state[7];
  for(int i = 0; i < 7; i++) {
    state[i] = 0;
  }
  state[4] = 0.1;
  state[5] = 0.0;

  float result = cost.getStabilizingCost(state);

  EXPECT_FLOAT_EQ(result, 0);

  state[5] = 0.01;

  result = cost.getStabilizingCost(state);

  EXPECT_FLOAT_EQ(result, 0.2483460072);

  state[5] = 0.2;

  result = cost.getStabilizingCost(state);

  EXPECT_FLOAT_EQ(result, 1030.6444);
}

TEST(ARStandardCost, getCrashCostTest) {

  ARStandardCost cost;
  ARStandardCost::ARStandardCostParams params;
  params.crash_coeff = 10000;
  cost.setParams(params);

  float state[7];
  for(int i = 0; i < 7; i++) {
    state[i] = 0;
  }
  int crash = 0;
  state[4] = 10;

  float result = cost.getCrashCost(state, &crash, 10);

  EXPECT_FLOAT_EQ(result, 0);

  crash = 1;
  result = cost.getCrashCost(state, &crash, 10);

  EXPECT_FLOAT_EQ(result, 10000);
}

TEST(ARStandardCost, getTrackCostTest) {
  ARStandardCost cost;
  ARStandardCost::ARStandardCostParams params;
  params.track_coeff = 100;
  params.track_slop = 1.0;
  params.boundary_threshold = 100.0;
  cost.setParams(params);

  cost.GPUSetup();

  cost.loadTrackData(mppi::tests::test_map_file);

  std::vector<float3> states(1);
  states[0].x = -4.5;
  states[0].y = -10;
  states[0].z = 0.0; // theta

  std::vector<float> cost_results;
  std::vector<int> crash_results;

  launchTrackCostTestKernel(cost, states, cost_results, crash_results);

  EXPECT_FLOAT_EQ(cost_results[0], 0.0);
  EXPECT_FLOAT_EQ(crash_results[0], 0.0);
}

TEST(ARStandardCost, computeCostTest) {
  ARStandardCost cost;
  ARStandardCost::ARStandardCostParams params;
  params.track_coeff = 100;
  params.track_slop = 1.0;
  params.boundary_threshold = 100.0;
  cost.setParams(params);

  cost.GPUSetup();

  cost.loadTrackData(mppi::tests::test_map_file);

  std::vector<std::array<float, 9>> states;

  std::array<float, 9> array = {0.0};
  array[0] = 0.0;
  array[1] = 0.0;
  array[2] = 0.0;
  array[3] = 0.0;
  array[4] = 0.0;
  array[5] = 0.0;
  array[6] = 0.0;
  array[7] = 0.0;
  array[8] = 0.0;
  states.push_back(array);

  std::vector<float> cost_results;

  launchComputeCostTestKernel(cost, states, cost_results);

  EXPECT_FLOAT_EQ(cost_results[0], 0.0);
}
