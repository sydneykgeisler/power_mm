# R CODE FOR INCONSISTENCY WITH GAMMA COVARIANCE PRIORS FOR BINOMIAL DATA:

b2 <- blme::bglmer(cbind(expected_y, n - expected_y) ~ 1 + trt + (1 | location) +
                     (1 | location:trt), data = binomial, family = "binomial",
                     control = glmerControl(optimizer = "Nelder_Mead", nAGQ0initStep = 0),
                     cov.prior = list(location ~ gamma(rate = 1 / sqrt(0.02)),
                                      `location:trt` ~ gamma(rate = 1 / sqrt(0.05))))
  summary(b2)

# R CODE FOR INCONSISTENCY WITH GAMMA COVARIANCE PRIORS FOR POISSON DATA:

p3 <- bglmer(exp_count ~ rate + trt * rate + (1 | block:trt) + (1 | block),
              data = poisson_ex, family = "poisson",
              control = glmerControl(nAGQ0initStep = 0),
              cov.prior = list(block ~ gamma(1 / sqrt(0.25)),
                               `block:trt` ~ gamma(1 / sqrt(0.15))))

  summary(p3)
