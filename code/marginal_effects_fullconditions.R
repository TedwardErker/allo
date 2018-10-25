## [[file:~/git/allo/code/allo.org::*assess%20model][assess model:11]]
library(brms)
mod <- readRDS("~/git/allo/models/genus_many_species_many_cities_many_climate_b3linint_hetero_no_family_Gamma.rds")
  cond <- expand.grid(Species = unique(mod$data$Species),  City = unique(mod$data$City))
    cond <- left_join(cond, unique(select(mod$data, Species, Genus)))
    cond <- left_join(cond, unique(select(mod$data, City, precip, gdd)))

     me <- marginal_effects(mod, effects = "AGE", conditions = cond, re_formula = NULL, method = "predict")
saveRDS(me, "../models/genus_many_species_many_cities_many_climate_b3linint_hetero_no_family_Gamma_marginaleffects.rds")
## assess model:11 ends here
