---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

```{r, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/README-",
  out.width = "100%"
)
```

# power_mm

Thus function allows for estimation of power approximations for generalized 
linear mixed models. Given an exemplary dataset, fixed and random effects,
variance components to be held constant in the model, and a significance level,
this formula can approximate power just like the GLIMMIX procedure in SAS.
Currently, this method is only available for Gaussian data.

## Archived Code

The archived files with the '.sas' extension contain the code that SAS uses to
approximate power. A description of the family type, whether it be binomial,
Poisson, or Gaussian is included in the file names. These can be used in
conjunction with '.R' files to compare results.

'Exemplary Datasets' contains the code to create exemplary data for the 
Gaussian, binomial, and Poisson examples used.

The file titled 'Errors with Steep Prior Method' shows what happens when 
'power_mm' is used on non-Gaussian data.

'Gamma Prior Failures' shows that variance components are not held constant
to the values specified in 'power_mm'.

'Optimization Results' shows that the variance components are held constant,
but values are inconsistent with SAS results.

## Installation

You can install the development version of power_mm from [GitHub](https://github.com/sydneykgeisler/power_mm.git) with:

``` r
# install.packages("devtools")
devtools::install_github("https://github.com/sydneykgeisler/power_mm.git")
```

## First Example

This is a basic example which shows you how to solve a common problem:

```{r example}
power_mm(Formula = estY ~ NSource*Thatch + (1 | Field) + (1|Field:NSource),
Varcomp = c(0.008, 0.07), Resid_var = 0.2, Data = ex_gaussian,
Family = "gaussian", Effect = "NSource*Thatch",
Alpha = 0.05)
```

## Second Example

Should you wish to use multiple fixed effects for power approximations, you can 
use concatenation as shown below:

```{r example}
power_mm(Formula = estY ~ NSource*Thatch + (1 | Field) + (1|Field:NSource), 
Varcomp = c(0.008, 0.07), Resid_var = 0.2, Data = ex_gaussian,
Family = "gaussian", Effect = c("NSource", "NSource:Thatch", "Thatch"),
Alpha = 0.05)
```
