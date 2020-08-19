test_that("MCC works", {
  id_ground = MCC(RMCC::rmcc_cloud, 3.5, 0.1)
  expect_equal(length(id_ground), 11559L)

  id_ground = MCC(RMCC::rmcc_cloud, 2, 0.3)
  expect_equal(length(id_ground), 14330L)
})

test_that("MCC fails", {
  expect_error(MCC(RMCC::rmcc_cloud, -3.5, 0.1))
  expect_error(MCC(RMCC::rmcc_cloud, 3.5, -0.1))
})

