## [[file:~/git/allo/code/allo.org::*libraries%20and%20functions][libraries and functions:1]]
library(dplyr)
library(brms)
source("allo_functions.R")
## libraries and functions:1 ends here

## [[file:~/git/allo/code/allo.org::*set%20values][set values:1]]
genus <- "many"
species <- "many"
cities <- "many"
climate <- "b1linint"
hetero <- "no"
family <- "Gamma"
## set values:1 ends here

## [[file:~/git/allo/code/allo.org::*generate%20formula%20and%20priors][generate formula and priors:1]]
form <- generate_formula(genus, species, cities, climate, hetero, family)

nlprior <- generate_prior(genus, species, cities, climate, family)
## generate formula and priors:1 ends here

## [[file:~/git/allo/code/allo.org::*fit%20model%20to%20real%20data][fit model to real data:1]]
d <- readRDS("../data/age_dbh_testing.rds")

if(family == "Gamma") fam <- Gamma("identity")
if(family == "gaussian") fam <- gaussian()

mod <- brm(form, chains = 8, cores = 8, data = d, init_r = .3, prior = nlprior, iter = 2000, family = fam)

saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, ".rds"))
## fit model to real data:1 ends here

## [[file:~/git/allo/code/allo.org::*model%20R%20code][model R code:1]]
library(dplyr)
  library(brms)
  source("allo_functions.R")

  genus <- "many"
  species <- "many"
  cities <- "many"
  climate <- "b1linint"
  hetero <- "no"
  family <- "Gamma"


  data_form <- formula(DBH ~ b0 + 100 * b1 * (1 - exp(-(b2/100) * AGE^(b3))))
  b0_form <- formula(b0 ~ (1 | City) + (1 | Genus/Species))
  b1_form <- formula(b1 ~ Precip * GDD +  (1 | City) + (1 | Genus / Species))
  b2_form <- formula(b2 ~ (1 | City) + (1 | Genus/Species))
  b3_form <- formula(b3 ~ (1 | City) + (1 | Genus/Species))


  form <- bf(data_form, b0_form, b1_form, b2_form, b3_form, nl = T)

  nlprior <- c(prior(gamma(7.5, 3), nlpar = "b0",lb = 0),
               prior(gamma(8, 6), nlpar = "b1",lb = 0),
               prior(gamma(8, 8), nlpar = "b2", lb = 0),
               prior(gamma(8, 6), nlpar = "b3",lb = 0),
               prior(gamma(5, .3), class = "shape"),
               prior(gamma(1.3,1.3), class = "sd", nlpar = "b0"),
               prior(gamma(10,10), class = "sd", nlpar = "b1"),
               prior(gamma(1.3,1.3), class = "sd", nlpar = "b2"),
               prior(gamma(1.3,1.3), class = "sd", nlpar = "b3"))


  d <- readRDS("../data/age_dbh_testing.rds")



prior_mod <-  brm(form,
             data = d,
             prior = nlprior,
             family = Gamma("identity"),
           sample_prior = "only",
             chains = 8, cores = 8, init_r = .3, iter = 2000)

  mod <- brm(form,
             data = d,
             prior = nlprior,
             family = Gamma("identity"),
             chains = 8, cores = 8, init_r = .3, iter = 2000)

  saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, ".rds"))
## model R code:1 ends here
