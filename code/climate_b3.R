## [[file:~/git/allo/code/allo.org::*model%20R%20code][model R code:1]]
library(dplyr)
  library(brms)

  genus <- "no"
  species <- "no"
  cities <- "no"
  climate <- "b3"
  hetero <- "no"
  family <- "Gamma"

  data_form <- formula(DBH ~ b0 + 100 * b1 * (1 - exp(-(b2/100) * AGE^(b3))))
  b0_form <- formula(b0 ~ 1)
  b1_form <- formula(b1 ~ 1)
  b2_form <- formula(b2 ~ 1)
  b3_form <- formula(b3 ~ gdd* precip)

  form <- bf(data_form, b0_form, b1_form, b2_form, b3_form, nl = T)

  nlprior <- c(prior(gamma(4, 1.33), nlpar = "b0",lb = 0),
               prior(gamma(34, 19.4), nlpar = "b1",lb = 0),
               prior(gamma(69.4, 55.5), nlpar = "b2", lb = 0),
               prior(gamma(16, 26), nlpar = "b3",lb = 0),  # I reduce this value because it becomes the intercept (then gdd and precip add to it)
               prior(gamma(20, 1), class = "shape"),
               prior(normal(0.01, 0.01), nlpar = "b3", coef = "gdd"),
               prior(normal(0.03, 0.01), nlpar = "b3", coef = "precip"),
               prior(normal(0.025, 0.01), nlpar = "b3", coef = "gdd:precip"))

d <- readRDS("../data/age_dbh_testing_noWARO.rds")

   ## prior_mod <-  brm(form,
   ##                   data = d,
   ##                   prior = nlprior,
   ##                   family = Gamma("identity"),
   ##                   sample_prior = "only",
   ##                   chains = 2, cores = 2, init_r = .3, iter = 300, control = list(adapt_delta = .8))


  ##  pred <- predict(prior_mod, newdata = d)

   mod <- brm(form,
             data = d,
             prior = nlprior,
             family = Gamma("identity"),
             chains = 4, cores = 2, init_r = .3, iter = 2000)

  saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, ".rds"))
## model R code:1 ends here
