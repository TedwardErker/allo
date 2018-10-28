## [[file:~/git/allo/code/allo.org::*compare%20models][compare models:1]]
library(brms)
library(loo)
  models <- c("../models/genus_none_species_single_cities_single_climate_none_hetero_no_family_Gamma.rds",
              "../models/genus_no_species_no_cities_yes_climate_no_hetero_no_family_Gamma.rds",
              "../models/genus_yes_species_yes_cities_yes_climate_no_hetero_no_family_Gamma.rds",
              "../models/genus_no_species_no_cities_no_climate_b1_hetero_no_family_Gamma.rds",
              "../models/genus_no_species_no_cities_no_climate_b3_hetero_no_family_Gamma.rds",
              "../models/genus_many_species_many_cities_many_climate_b3linint_hetero_no_family_Gamma.rds",
              "../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma.rds")

loo.list <- lapply(models, function(m) {
    model <- readRDS(m)
    loo.model <- loo(model)
    })

comparison <- compare(x = loo.list)

saveRDS(list(loo.list, comparison), "../models/model_comparison_loo.rds")
## compare models:1 ends here
