## [[file:~/git/allo/code/allo.org::*libraries%20and%20functions][libraries and functions:1]]
library(dplyr)
library(brms)
source("allo_functions.R")
## libraries and functions:1 ends here

## [[file:~/git/allo/code/allo.org::*set%20values][set values:1]]
genus <- "many"
  species <- "many"
  cities <- "many"
  climate <- "b0linint"
  hetero <- "linear"
niter <- 10000
## set values:1 ends here

## [[file:~/git/allo/code/allo.org::*generate%20formula%20and%20priors][generate formula and priors:1]]
model_table <- read.csv("../data/model_table.csv", stringsAsFactors = F)

form <- generate_formula(model_table, genus, species, cities, climate, hetero)

nlprior <- generate_prior(genus, species, cities, climate)
## generate formula and priors:1 ends here

## [[file:~/git/allo/code/allo.org::*fit%20model%20to%20real%20data][fit model to real data:1]]
d <- readRDS("../data/age_dbh_testing.rds")

mod <- brm(form, chains = 6, cores = 6, data = d, init_r = .3, prior = nlprior, iter = niter)
saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_niter_",niter,".rds"))
## fit model to real data:1 ends here
