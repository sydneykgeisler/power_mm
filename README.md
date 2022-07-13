
<!-- README.md is generated from README.Rmd. Please edit that file -->

# power_mm

<!-- badges: start -->
<!-- badges: end -->

The goal of power_mm is to approximate the power of a generalized linear
mixed model. This is done by providing an exemplary dataset, which is a
dataset that mimics how a statistical experiment would look like in real
life. From here, a user can specify the fixed and random effects to be
used in the model. The user should have an idea beforehand of what the
variance components of the random effects are so these can be
essentially held constant within the model. Currently, power_mm is only
reliable for Gaussian data.

## Installation

You can install the development version of Final from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("https://github.com/sydneykgeisler/power_mm.git")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(Final)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
