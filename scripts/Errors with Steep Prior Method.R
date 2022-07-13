# R CODE FOR ERROR OF BINOMIAL DATA:

  custom_cov1 <- function(x)
    dnorm(x, sqrt(0.02), 1e-6, log = TRUE)
  custom_cov2 <- function(x)
    dnorm(x, sqrt(0.05), 1e-6, log = TRUE)
  library(blme)
  b1 <- bglmer(cbind(expected_y, n - expected_y) ~ 1 + trt + (1 | location) +
                 (1 | location:trt), data = binomial, family = "binomial",
               control = glmerControl(optimizer = "Nelder_Mead", nAGQ0initStep = 0),
               cov.prior = list(location ~ custom(custom_cov1, chol = TRUE, scale = "log")),
               `location:trt` ~ custom(custom_cov2, chol = TRUE, scale = "log"))

# R CODE FOR ERROR OF POISSON DATA:

  cust_cov1 <- function(x)
      dnorm(x, sqrt(0.15), 1e-6, log = TRUE)

  cust_cov2 <- function(x)
    dnorm(x, sqrt(0.25), 1e-6, log = TRUE)

  p2 <- blme::bglmer(exp_count ~ rate + trt * rate + (1 | block:trt) + (1 | block),
               data = ex_poisson, family = "poisson",
               control = glmerControl(nAGQ0initStep = 0), cov.prior =
                 list(block ~ custom(cust_cov1, chol = TRUE, scale = "log"),
                      `block:trt` ~ custom(cust_cov2, chol = TRUE, scale = "log")))
