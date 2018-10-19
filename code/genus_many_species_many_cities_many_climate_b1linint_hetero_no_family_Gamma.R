## [[file:~/git/allo/code/allo.org::*model%20R%20code][model R code:1]]
library(dplyr)
  library(brms)

## source("allo_functions.R")

  genus <- "many"
  species <- "many"
  cities <- "many"
  climate <- "b1linint"
  hetero <- "no"
  family <- "Gamma"


  data_form <- formula(DBH ~ b0 + 100 * b1 * (1 - exp(-(b2/100) * AGE^(b3))))
  b0_form <- formula(b0 ~ (1 | City) + (1 | Genus/Species))
  b1_form <- formula(b1 ~ precip * gdd +  (1 | City) + (1 | Genus / Species))
  b1_form <- formula(b1 ~ (1 | City) + (1 | Genus / Species))
  b2_form <- formula(b2 ~ (1 | City) + (1 | Genus/Species))
  b3_form <- formula(b3 ~ (1 | City) + (1 | Genus/Species))

  form <- bf(data_form, b0_form, b1_form, b2_form, b3_form, nl = T)

  nlprior <- c(prior(gamma(4, 1.33), nlpar = "b0",lb = 0),
               prior(gamma(25, 16.7), nlpar = "b1",lb = 0),
               prior(gamma(69.4, 55.5), nlpar = "b2", lb = 0),
               prior(gamma(44.4, 44.4), nlpar = "b3",lb = 0),
               prior(gamma(5, .3), class = "shape"),
               prior(gamma(10,5), class = "sd", nlpar = "b0"),
               prior(gamma(10,10), class = "sd", nlpar = "b1"),
               prior(gamma(5,10), class = "sd", nlpar = "b2"),
               prior(gamma(5,10), class = "sd", nlpar = "b3"))


   d <- readRDS("../data/age_dbh_testing.rds")


  ## mod <- brm(form,
  ##            data = d,
  ##            prior = nlprior,
  ##            family = Gamma("identity"),
  ##            chains = 1, cores = 1, init_r = .3, iter = 2000)

  ##    saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, ".rds"))
## model R code:1 ends here

## [[file:~/git/allo/code/allo.org::*prior%20mod][prior mod:1]]
prior_mod <-  brm(form,
             data = d,
             prior = nlprior,
             family = Gamma("identity"),
             sample_prior = "only",
             chains = 2, cores = 2, init_r = .3, iter = 600)
## prior mod:1 ends here

## [[file:~/git/allo/code/allo.org::*prior%20mod][prior mod:2]]
pairs(prior_mod)
## prior mod:2 ends here
