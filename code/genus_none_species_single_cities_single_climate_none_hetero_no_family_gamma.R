## [[file:~/git/allo/code/allo.org::*libraries%20and%20functions][libraries and functions:1]]
library(dplyr)
library(brms)
source("allo_functions.R")
## libraries and functions:1 ends here

## [[file:~/git/allo/code/allo.org::*set%20values][set values:1]]
genus <- "none"
species <- "single"
cities <- "single"
climate <- "none"
hetero <- "no"
family <- "Gamma"
## set values:1 ends here

## [[file:~/git/allo/code/allo.org::*generate%20formula%20and%20priors][generate formula and priors:1]]
form <- generate_formula(genus, species, cities, climate, hetero, family)

nlprior <- generate_prior(genus, species, cities, climate, family)

        nlprior <- c(prior(gamma(7, 3.5), nlpar = "b0",lb = 0),
                     prior(gamma(7, 7), nlpar = "b1",lb = 0),
                     prior(gamma(8, 8), nlpar = "b2", lb = 0),
                     prior(gamma(8, 8), nlpar = "b3",lb = 0),
                     prior(gamma(20, 1), class = "shape"))
## generate formula and priors:1 ends here

## [[file:~/git/allo/code/allo.org::*fit%20model%20to%20real%20data][fit model to real data:1]]
d <- readRDS("../data/age_dbh_testing.rds")

if(family == "Gamma") fam <- Gamma("identity")
if(family == "gaussian") fam <- gaussian()

mod <- brm(form, chains = 6, cores = 6, data = d, init_r = .3, prior = nlprior, iter = 2000, family = fam)
saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_",family,".rds"))
## fit model to real data:1 ends here

## [[file:~/git/allo/code/allo.org::*model%20R%20code][model R code:1]]
library(dplyr)
  library(brms)
  source("allo_functions.R")

genus <- "none"
species <- "single"
cities <- "single"
climate <- "none"
hetero <- "no"
family <- "Gamma"


  data_form <- formula(DBH ~ b0 + 100 * b1 * (1 - exp(-(b2/100) * AGE^(b3))))
  b0_form <- formula(b0 ~ 1)
  b1_form <- formula(b1 ~ 1)
  b2_form <- formula(b2 ~ 1)
  b3_form <- formula(b3 ~ 1)

  form <- bf(data_form, b0_form, b1_form, b2_form, b3_form, nl = T)

  a <- seq(50,250,50)
 b <- c(.01, .0125, .015)
  c <- c(.9, 1, 1.2)


nlprior <- c(prior(gamma(1.33, 2), nlpar = "b0",lb = 0),
             prior(gamma(16.66, 5), nlpar = "b1",lb = 0),
             prior(gamma(125, 12.5), nlpar = "b2", lb = 0),
             prior(gamma(105, 10.5), nlpar = "b3",lb = 0),
             prior(gamma(20, 1), class = "shape"))


d <- readRDS("../data/age_dbh_testing.rds")



## prior_mod <-  brm(form,
##              data = d,
##              prior = nlprior,
##              family = Gamma("identity"),
##            sample_prior = "only",
##              chains = 2, cores = 2, init_r = .3, iter = 2000)


## pred <- predict(prior_mod, newdata = d)


   mod <- brm(form,
             data = d,
             prior = nlprior,
             family = Gamma("identity"),
             chains = 8, cores = 8, init_r = .3, iter = 2000)

  saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, ".rds"))
## model R code:1 ends here
