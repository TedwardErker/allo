## [[file:~/git/allo/code/allo.org::*assess%20model][assess model:14]]
library(dplyr)
 library(brms)
 mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData <- readRDS("../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData.rds")
 mod <- mod_genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData
 ## precip.gdd <-   marginal_effects(mod, effects = "precip:gdd", surface = T, resolution = 100, nsamples = 10000, cond = data.frame(AGE = 25))
 ## saveRDS(precip.gdd, "../models/genus_many_species_many_cities_many_notB1_climate_b3linint_hetero_no_family_Gamma_FullData_precip.gdd.surface.rds")


 cond <- expand.grid(Genus = unique(mod$data$Genus)) #City = unique(mod$data$City)) #Species = unique(mod$data$Species))#,  

#cond <- left_join(cond, unique(select(mod$data, Species, Genus)))
# cond <- left_join(cond, unique(select(mod$data, City, precip, gdd)))

 me <- marginal_effects(mod, effects = "AGE", conditions = cond, re_formula = NULL, method = "fitted", nsamples = 15000)
 saveRDS(me, "../models/genus_many_species_many_cities_notB1_many_climate_b3linint_hetero_no_family_Gamma_FullData_marginaleffects_Genus_methodfitted.rds")
## assess model:14 ends here
