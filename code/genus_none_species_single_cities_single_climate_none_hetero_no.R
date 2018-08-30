## [[file:~/git/allo/code/allo.org::*set%20values][set values:1]]
genus <- "none"
species <- "single"
cities <- "single"
climate <- "none"
hetero <- "no"
family <- "Gamma"
## set values:1 ends here

## [[file:~/git/allo/code/allo.org::*generate%20formula%20and%20priors][generate formula and priors:1]]
#  model_table <- read.csv("../data/model_table.csv", stringsAsFactors = F)

  form <- generate_formula(genus, species, cities, climate, hetero, family)

  nlprior <- generate_prior(genus, species, cities, climate)
## generate formula and priors:1 ends here

## [[file:~/git/allo/code/allo.org::*fit%20model%20to%20real%20data][fit model to real data:1]]
d <- readRDS("../data/age_dbh_testing.rds")

  if(family == "Gaussian") {
    fam <- gaussian()
}
if(family == "Gamma") {
  fam <- Gamma('log')
}
    mod <- brm(form, chains = 4, cores = 4, data = d, init_r = .3, prior = nlprior, iter = 500, family = fam)
    saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, ".rds"))
## fit model to real data:1 ends here
