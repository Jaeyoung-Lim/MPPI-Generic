#include <gtest/gtest.h>
#include <dynamics/cartpole/cartpole.cuh>
#include <mppi_core/mppi_common.cuh>
#include <kernel_tests/mppi_core/rollout_kernel_test.cuh>
#include <kernel_tests/test_helper.h>

/*
 * Here we will test various device functions that are related to cuda kernel things.
 */

TEST(RolloutKernel, loadGlobalToShared) {
    std::vector<float> x0_host = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2};
    std::vector<float> u_var_host = {0.8, 0.9, 1.0};

    std::vector<float> x_thread_host(mppi_common::state_dim, 0.f);
    std::vector<float> xdot_thread_host(mppi_common::state_dim, 2.f);

    std::vector<float> u_thread_host(mppi_common::control_dim, 3.f);
    std::vector<float> du_thread_host(mppi_common::control_dim, 4.f);
    std::vector<float> sigma_u_thread_host(mppi_common::control_dim, 0.f);

    launchGlobalToShared_KernelTest(x0_host, u_var_host, x_thread_host, xdot_thread_host, u_thread_host, du_thread_host, sigma_u_thread_host);

    array_expect_float_eq(x0_host, x_thread_host, mppi_common::state_dim);
    array_expect_float_eq(0.f, xdot_thread_host, mppi_common::state_dim);
    array_expect_float_eq(0.f, u_thread_host, mppi_common::control_dim);
    array_expect_float_eq(0.f, du_thread_host, mppi_common::control_dim);
    array_expect_float_eq(sigma_u_thread_host, u_var_host, mppi_common::control_dim);
}

TEST(RolloutKernel, injectControlNoiseOnce) {
    int num_timesteps = 1;
    int num_rollouts = 1000;
    std::vector<float> u_traj_host = {3.f, 4.f, 5.f};

    // Control noise
    std::vector<float> ep_v_host(num_rollouts*num_timesteps*mppi_common::control_dim, 0.f);

    // Control at timestep 1 for all rollouts
    std::vector<float> control_compute(num_rollouts*mppi_common::control_dim, 0.f);

    //launchInjectControlNoiseOnce_KernelTest(u_traj_host, ep_v_host, control_compute);

    // Make sure the first control is undisturbed
    int timestep = 0;
    int rollout = 0;
    for (int i = 0; i < mppi_common::control_dim; ++i) {
        ASSERT_FLOAT_EQ(u_traj_host[i], control_compute[rollout*num_timesteps*mppi_common::control_dim + timestep*mppi_common::control_dim + i]);
    }

    // Make sure the last 99 percent are zero control with noise
    for (int j = num_rollouts*.99; j < num_rollouts; ++j) {
        for (int i = 0; i < mppi_common::control_dim; ++i) {
            ASSERT_FLOAT_EQ(ep_v_host[j*num_timesteps*mppi_common::control_dim + timestep*mppi_common::control_dim + i],
                    control_compute[j*num_timesteps*mppi_common::control_dim + timestep*mppi_common::control_dim + i]);
        }
    }

    // Make sure everything else are initial control plus noise
    for (int j = 0; j < num_rollouts*.99; ++j) {
        for (int i = 0; i < mppi_common::control_dim; ++i) {
            ASSERT_FLOAT_EQ(ep_v_host[j*num_timesteps*mppi_common::control_dim + timestep*mppi_common::control_dim + i] + u_traj_host[i],
                            control_compute[j*num_timesteps*mppi_common::control_dim + timestep*mppi_common::control_dim + i]);
        }
    }
}