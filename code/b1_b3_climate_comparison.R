## [[file:~/git/allo/code/allo.org::*compare%20climate%20beta%201%20to%20climate%20beta%203][compare climate beta 1 to climate beta 3:2]]
library(brms)
mod_genus_no_species_no_cities_no_climate_b1_hetero_no_family_Gamma <- readRDS("../models/genus_no_species_no_cities_no_climate_b1_hetero_no_family_Gamma.rds")
mod_genus_no_species_no_cities_no_climate_b3_hetero_no_family_Gamma <- readRDS("../models/genus_no_species_no_cities_no_climate_b3_hetero_no_family_Gamma.rds")
comparison <- loo(mod_genus_no_species_no_cities_no_climate_b1_hetero_no_family_Gamma, mod_genus_no_species_no_cities_no_climate_b3_hetero_no_family_Gamma)
saveRDS(comparison, "../models/b1_b3_climate_comparison.rds")
## compare climate beta 1 to climate beta 3:2 ends here
