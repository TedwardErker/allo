## [[file:~/git/allo/code/allo.org::*assess%20model][assess model:13]]
library(dplyr)
library(brms)
mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData_ageless150 <- readRDS("../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData_ageless150.rds")
mod <- mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData_ageless150
precip.gdd <-   marginal_effects(mod, effects = "precip:gdd", surface = T, resolution = 100, nsamples = 10)
saveRDS(precip.gdd, "../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData_ageless150_precip.gdd.surface.rds")

cond <- expand.grid(Species = unique(mod$data$Species),  City = unique(mod$data$City))
cond <- left_join(cond, unique(select(mod$data, Species, Genus)))
cond <- left_join(cond, unique(select(mod$data, City, precip, gdd)))

me <- marginal_effects(mod, effects = "AGE", conditions = cond, re_formula = NULL, method = "predict", nsamples = 1000)
saveRDS(me, "../models/genus_many_species_many_cities_notB1_many_climate_b3linint_hetero_no_family_Gamma_FullData_ageless150_marginaleffects.rds")
## assess model:13 ends here
