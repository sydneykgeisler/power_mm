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

You can install the development version of power_mm from GitHub with:

```r
install.packages("devtools")
devtools::install_github("https://github.com/sydneykgeisler/power_mm.git")
library(powermm)
```

## First Example

Consider a study where researchers are interested in the effects of a nitrogen source, field, and years of thatch accumulation on the chlorophyll content (mg/g) of grass clippings (Kuehl 1994, example 14.1). The four sources of nitrogen that will be investigated are denoted as “Urea”, “AmmSulph”, “IBDU”, and “SCUrea”. The three levels of thatch accumulation that will be tested are 2, 5, and 8 years. Each field is divided into four parts, with each part randomly assigned a nitrogen source level.  Then each part is divided into three sub-regions, with each sub-region randomly assigned a level of thatch accumulation.  This is a split plot design. The estimated y-value, which comes from the Gaussian family distribution, is the anticipated average chlorophyll measurement that an experimenter would expect to see given the nitrogen source, thatch level, and field number. For two years of thatch accumulation, researchers expect the average chlorophyll content to be 6 mg/g for nitrogen sources of “AmmSulph”, “IBDU”, and “SCUrea” and 4 mg/g for “Urea”. For either five or eight years of thatch accumulation, the expected chlorophyll content for “AmmSulph”, “IBDU”, “SCUrea”, and “Urea” is 6, 7, 8, and 5 mg/g, respectively.  In other words, for this example, suppose that researchers hypothesize that the true interaction effect of nitrogen source and thatch is at least as large as represented in the following figure:

![Interaction Plot](/Users/sydneygeisler/Desktop/Screen Shot 2022-07-25 at 1.42.05 PM.png)

The ex_gaussian dataset is the exemplary dataset representing the data described above, with four fields.  Suppose that from a pilot study or prior literature, the researchers estimate the variance components for random effects Field and Field:NSource to be 0.008 and 0.07, respectively, and they estimate the error variance to be 0.2. Then the following code calls the power_mm function to approximate the power of the test for the interaction term given that this interaction between nitrogen source and thatch level exists:

```{r example}
power_mm(Formula = estY ~ NSource*Thatch + (1 | Field) + (1|Field:NSource),
Varcomp = c(0.008, 0.07), Resid_var = 0.2, Data = ex_gaussian,
Family = "gaussian", Effect = "NSource*Thatch",
Alpha = 0.05)
```

The returned messages about singular and unidentifiable model are only due to the variance components being effectively held constant, and are not a reason for concern.  The approximated power is about .9475.

## Second Example

Should you wish to use multiple fixed effects for power approximations, you can 
use concatenation as shown below:

```{r example}
power_mm(Formula = estY ~ NSource*Thatch + (1 | Field) + (1|Field:NSource), 
Varcomp = c(0.008, 0.07), Resid_var = 0.2, Data = ex_gaussian,
Family = "gaussian", Effect = c("NSource", "NSource:Thatch", "Thatch"),
Alpha = 0.05)
```
