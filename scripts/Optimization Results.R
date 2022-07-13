# Optimization Method for Poisson Data

fixed_theta <- c(sqrt(.15),sqrt(.25))

dev_fun <- glmer(exp_count ~ rate + trt * rate + (1 | block:trt) + (1 | block),
                 data = poisson_ex, family = "poisson",
                 control = glmerControl(tolPwrss=1e-2, nAGQ0initStep = 0),
                 devFunOnly = TRUE)

wrapper <- function(beta) {
  pars <- c(fixed_theta, beta)
  dev_fun(pars)
}

pp <- environment(dev_fun)$pp

optim_fit <- optim(rep(0, times = ncol(pp$X)), wrapper, hessian = TRUE)

dummy_fit <- suppressWarnings(
  glmer(exp_count ~ rate + trt * rate + (1 | block:trt) + (1 | block),
        data = poisson_ex, family = "poisson",
        control = glmerControl(tolPwrss=1e-2, nAGQ0initStep = 0)))

rho <- environment(dev_fun)
rho$baseOffset
rho$pp <- dummy_fit@pp
rho$resp <- dummy_fit@resp

invisible(wrapper(optim_fit$par))

dummy_fit@beta <- optim_fit$par
dummy_fit@optinfo$Hessian <-
  as.matrix(Matrix::bdiag(diag(1e16, 1), optim_fit$hessian))

# Variance Components are Held Constant

suppressWarnings(summary(dummy_fit))

# ANOVA F-values Inconsistent with SAS

anova(dummy_fit)

car::Anova(dummy_fit, type = "II")

# Optimization Method for Binomial Data

fixed_theta <- c(sqrt(.05),sqrt(.02))

dev_fun <- glmer(cbind(expected_y, n - expected_y) ~ 1 + trt + (1 | location) + (1 | location:trt),
                 data = binomial, family = "binomial",
                 control = glmerControl(optimizer = "Nelder_Mead", nAGQ0initStep = 0),
                 devFunOnly = TRUE)
wrapper <- function(beta) {
  pars <- c(fixed_theta, beta)
  dev_fun(pars)
}

optim_fit <- optim(c(0, 0), wrapper, hessian = TRUE)
dummy_fit <- suppressWarnings(
  glmer(cbind(expected_y, n - expected_y) ~ 1 + trt + (1 | location) + (1 | location:trt),
        data = binomial, family = "binomial",
        control = glmerControl(optimizer = "Nelder_Mead", nAGQ0initStep = 0, optCtrl=list(maxfun=1L))))
rho <- environment(dev_fun)
rho$baseOffset
rho$pp <- dummy_fit@pp
rho$resp <- dummy_fit@resp

invisible(wrapper(optim_fit$par))
dummy_fit@beta <- optim_fit$par
dummy_fit@optinfo$Hessian <-
  as.matrix(Matrix::bdiag(diag(1e16, 1), optim_fit$hessian))

# Covariance Priors are Held Constant

suppressWarnings(summary(dummy_fit))

# ANOVA F-values are Inconsistent with SAS

anova(dummy_fit)







