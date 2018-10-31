## [[file:~/git/allo/code/allo.org::*model%20R%20code][model R code:1]]
library(dplyr)
library(brms)


genus <- "many"
species <- "many"
cities <- "many_notB1"
climate <- "b3linint"
hetero <- "no"
family <- "Gamma"

data_form <- formula(DBH ~ b0 + 100 * b1 * (1 - exp(-(b2/100) * AGE^(b3))))
b0_form <- formula(b0 ~ (1 | City) + (1 | Genus/Species))
b1_form <- formula(b1 ~ (1 | Genus/Species))
b2_form <- formula(b2 ~ (1 | City) + (1 | Genus/Species))
b3_form <- formula(b3 ~ precip * gdd +  (1 | City) + (1 | Genus / Species))


form <- bf(data_form, b0_form, b1_form, b2_form, b3_form, nl = T)


nlprior <- c(prior(gamma(9, 3), nlpar = "b0",lb = 0),
             prior(gamma(34, 19.4), nlpar = "b1",lb = 0),
             prior(gamma(69.4, 55.5), nlpar = "b2", lb = 0),
             prior(gamma(16, 26), nlpar = "b3", lb = 0),
             prior(normal(0.01, 0.015), nlpar = "b3", coef = "gdd"),
             prior(normal(0.01, 0.01), nlpar = "b3", coef = "precip"),
             prior(normal(0.005, 0.005), nlpar = "b3", coef = "precip:gdd"),
             prior(gamma(20, 1), class = "shape"),
             prior(normal(0, .3), class = "sd", nlpar = "b0", group = "City"),
             prior(normal(0, .1), class = "sd", nlpar = "b2", group = "City"),
             prior(normal(0, .1), class = "sd", nlpar = "b3", group = "City"),
             prior(normal(0, .4), class = "sd", nlpar = "b0", group = "Genus"),
             prior(normal(0, .1), class = "sd", nlpar = "b0", group = "Genus:Species"),
             prior(normal(.1, .4), class = "sd", nlpar = "b1", group = "Genus"),
             prior(normal(0, .1), class = "sd", nlpar = "b1", group = "Genus:Species"),
             prior(normal(0, .1), class = "sd", nlpar = "b2", group = "Genus"),
             prior(normal(0, .05), class = "sd", nlpar = "b2", group = "Genus:Species"),
             prior(normal(0, .1), class = "sd", nlpar = "b3", group = "Genus"),
             prior(normal(0, .05), class = "sd", nlpar = "b3", group = "Genus:Species"))


d <- readRDS("../data/age_dbh_full_noPalms.rds")

mod <- brm(form,
           data = d,
           prior = nlprior,
           family = Gamma("identity"),
           chains = 12, cores = 12, init_r = .3, iter = 6000, control = list(adapt_delta = .9))

saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, "_family_", family, "_FullData.rds"))
## model R code:1 ends here
