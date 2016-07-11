context("Function loadFactor")

source("setup_test_case.R")
opts <- setSimulationPath(studyPath)

mydata <- readAntares(clusters = "all", thermalModulation = TRUE,
                      synthesis = FALSE, showProgress = FALSE)

describe("loadFactor", {

  lf <- loadFactor(mydata)

  it ("returns an antaresDataTable with correct number of row and columns", {
    expect_is(lf, "antaresDataTable")
    expect_true(all(c("loadFactor", "propHoursMaxGen", "propHoursMinGen") %in% names(lf)))
    expect_equal(nrow(lf) / length(simOptions()$mcYears),
                 nrow(unique(mydata[, .(area, cluster)])))
  })

  it("returns values between 0 and 1", {
    expect_true(all(lf$loadFactor %between% c(0, 1)))
    expect_true(all(lf$propHoursMinGen %between% c(0, 1)))
    expect_true(all(lf$propHoursMaxGen %between% c(0, 1)))
    expect_true(all(lf[, propHoursMinGen + propHoursMaxGen] %between% c(0, 1)))
  })

})