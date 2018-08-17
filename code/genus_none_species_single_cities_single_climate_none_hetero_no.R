genus <- "none"
species <- "single"
cities <- "single"
climate <- "none"
hetero <- "no"

form <- generate_formula(model_table, genus, species, cities, climate, hetero)

nlprior <- generate_prior(genus, species, cities, climate)

m <- brm(form, chains = 1, cores = 1, data = dt, prior = nlprior, iter = 500)

summary(m)

plot(m)

marginal_effects(m, points = T)

pairs(m)

#standata(m)
#stancode(m)

d <- readRDS("../data/age_dbh_testing.rds")

form <- bf(DBH ~ (b0*100) * (1 - exp(-(b1/100) * AGE ^ b2)),
                       b0 ~ 1,
                       b1 ~ 1,
                       b2 ~ 1,
                       nl = T)

     nlprior <- c(prior(gamma(1, 2), nlpar = "b0", lb = 0),
                  prior(gamma(1, 2), nlpar = "b1", lb = 0),
                  prior(gamma(1, 2), nlpar = "b2", lb = 0))


     model_fram_ftcollins_homo <- brm(form, chains = 4, cores = 2, data = fram_ftcollins,
#                                     init_r = 1,
                                     prior = nlprior,  control = list(adapt_delta = 0.8))

pairs(model_fram_ftcollins_homo)

summary(model_fram_ftcollins_homo)

plot(model_fram_ftcollins_homo)

marginal_effects(model_fram_ftcollins_homo)

stancode(model_fram_ftcollins_homo)
