id_ground = MCC(RMCC::rmcc_cloud, 3.5, 0.1)
expect_true(length(id_ground) >= 11559L)
expect_true(length(id_ground) <= 11588L) # CRAN M1mac


id_ground = MCC(RMCC::rmcc_cloud, 2, 0.3)
expect_equal(length(id_ground), 14330L)

expect_error(MCC(RMCC::rmcc_cloud, -3.5, 0.1))
expect_error(MCC(RMCC::rmcc_cloud, 3.5, -0.1))

