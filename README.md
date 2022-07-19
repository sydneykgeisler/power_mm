<!-- README.md is generated from README.Rmd. Please edit that file -->

# Overview of power_mm

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

## Included Datasets

'Exemplary Datasets' contains the code to create exemplary data for the 
Gaussian, binomial, and Poisson examples used.

The binomial dataset, ex_binomial, is an exemplary dataset that mimics a real-
life plant experiment. Plants that are exposed to a disease are thought to have 
a 15% survival rate with a standard treatment. Scientists believe that this 
percentage will increase to 25% given a new experimental treatment.

The Gaussian dataset, ex_gaussian, describes an experiment in which thatch level 
accumulation, nitrogen source, and field number would effect the chloropyll 
content of certain grass clippings.

Lastly, the Poisson dataset, ex_poisson, is a dataset that mimics a split-plot 
design of a field experiment. This data represents several kinds of experimental 
setups that scientists might find useful in agronomic or land management 
practices.

## Archived Files That Contain Errors in Power Approximation

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
