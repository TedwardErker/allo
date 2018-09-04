## [[file:~/git/allo/code/allo.org::*libraries%20and%20functions][libraries and functions:1]]
library(dplyr)
library(brms)
source("allo_functions.R")
## libraries and functions:1 ends here

## [[file:~/git/allo/code/allo.org::*set%20values][set values:1]]
genus <- "none"
species <- "many"
cities <- "single"
climate <- "none"
hetero <- "no"
family <- "Gamma"
## set values:1 ends here

## [[file:~/git/allo/code/allo.org::*generate%20formula%20and%20priors][generate formula and priors:1]]
form <- generate_formula(genus, species, cities, climate, hetero, family)
form
nlprior <- generate_prior(genus, species, cities, climate, family)
nlprior
## generate formula and priors:1 ends here

## [[file:~/git/allo/code/allo.org::*fit%20model%20to%20real%20data][fit model to real data:1]]
d <- readRDS("../data/age_dbh_testing.rds")

if(family == "Gamma") fam <- Gamma("identity")
if(family == "gaussian") fam <- gaussian()

  mod <- brm(form, chains = 6, cores = 6, data = d, init_r = .3, prior = nlprior, iter = 2000, family = fam)
  saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, ".rds"))
## fit model to real data:1 ends here
