power_mm <- function(Formula, Varcomp, Data, Family, Effect, Alpha,
                     Resid_var = NULL, tol = 1e-6) {

  if(Family == "gaussian") {
    b1 <- lme4::lmer(Formula, data = Data)
  } else {
    b1 <- lme4::glmer(Formula, data = Data, family = Family)
  }

  Resid_var_TEMP_notlikely <<- Resid_var

  random_effects <- names(lme4::ranef(b1))
  new_random_effects <- random_effects
  for (k in 1:length(random_effects)) {
    if(is.element(":", unlist(strsplit(random_effects[k], "")))) {
      new_random_effects[k] <- paste("`", random_effects[k], "`", sep = "")
    }
  }

  form_char <- vector("list", length(Varcomp - 1))

  if(is.null(Resid_var_TEMP_notlikely) == TRUE) {
    fn <- function(x, use.var) {
      dnorm(x, sqrt(use.var), tol, log = TRUE)
    }
  } else {
    fn <- function(x, use.var) {
      dnorm(x, sqrt(use.var / Resid_var_TEMP_notlikely), tol, log = TRUE)
    }
  }

  fn.list <- lapply(1:length(Varcomp),
                    function(y) functional::Curry(fn, use.var = Varcomp[y]))

  for (i in 1:length(Varcomp)) {

    x <- 1:i

    custom_list <- rep("custom_prior", times = i)
    var_list <- paste(custom_list, x, sep = "")

    assign(var_list[i], fn.list[[i]])

    form_char[[i]] <- paste(new_random_effects[i], " ~ custom(", var_list[i],
                            ", chol = TRUE", ", scale = 'log')", sep = "")

  }

  form_list <- lapply(form_char, noquote)

  if (Family == "gaussian") {
    if (length(new_random_effects > 1)) {
      b2 <- blme::blmer(Formula, data = Data,
                        resid.prior = point(sqrt(Resid_var_TEMP_notlikely)),
                        cov.prior = form_list)
    } else {
      b2 <- blme::blmer(Formula, data = Data,
                        resid.prior = point(sqrt(Resid_var_TEMP_notlikely)),
                        cov.prior = new_random_effects ~ custom(custom_prior1,
                                                                chol = TRUE,
                                                                scale = "log"))
    }
  } else {
    if (length(new_random_effects > 1)) {
      b2 <- blme::bglmer(Formula, data = Data, family = Family,
                         resid.prior = point(sqrt(Resid_var_TEMP_notlikely)),
                         cov.prior = form_list)
    } else {
      b2 <- blme::bglmer(Formula, data = Data, family = Family,
                         resid.prior = point(sqrt(Resid_var_TEMP_notlikely)),
                         cov.prior = new_random_effects ~ custom(custom_prior1,
                                                                 chol = TRUE,
                                                                 scale = "log"))
    }
  }

  b3 <- lmerTest::lmer(Formula, data = Data)
  aov_b3 <- anova(b3, ddf = "Kenward-Roger")

  Effect <- stringr::str_replace(Effect, "\\*", ":")

  aov <- anova(b2)
  reff_index <- vector("numeric", length(Effect))
  f <- vector("numeric", length(Effect))
  noncent_param <- vector("numeric", length(Effect))
  reff_index_b3 <- vector("numeric", length(Effect))
  ndf <- vector("numeric", length(Effect))
  ddf <- vector("numeric", length(Effect))
  FCrit <- vector("numeric", length(Effect))
  power <- matrix(NA, 1, length(Effect))

  for (i in 1:length(Effect)) {

    reff_index[i] <- which(rownames(aov) == Effect[i])
    f[i] <- aov$`F value`[reff_index[i]]
    noncent_param[i] <- aov$npar[reff_index[i]] * f[i]
    reff_index_b3[i] <- which(rownames(aov_b3) == Effect[i])
    ndf[i] <- aov$npar[reff_index_b3[i]]
    ddf[i] <- aov_b3$DenDF[reff_index_b3[i]]
    FCrit[i] <- qf(1 - Alpha, ndf[i], ddf[i], 0)
    power[, i] <- 1 - pf(FCrit[i], ndf[i], ddf[i], noncent_param[i])

  }

  colnames(power) <- Effect
  rownames(power) <- "Power Approximation"
  power

}

power_mm(Formula = estY ~ NSource*Thatch + (1 | Field) + (1|Field:NSource),
         Varcomp = c(0.008, 0.07), Resid_var = 0.2, Data = ex_gaussian,
         Family = "gaussian", Effect = "NSource*Thatch",
         Alpha = 0.05)
