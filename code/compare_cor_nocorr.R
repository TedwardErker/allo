## [[file:~/git/allo/code/allo.org::*compare%20to%20not%20corellated][compare to not corellated:1]]
library(loo)
library(brms)
mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_correlated <- readRDS("../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_correlated.rds")
mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma <- readRDS("../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma.rds")

res <- loo(mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma, mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_correlated, cores = 20)
saveRDS(res, "../models/corr_nocorr_comparison.rds")
## compare to not corellated:1 ends here
