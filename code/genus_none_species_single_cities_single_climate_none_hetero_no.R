genus <- "none"
species <- "single"
cities <- "single"
climate <- "none"
hetero <- "no"

form <- generate_formula(model_table, genus, species, cities, climate, hetero)

nlprior <- generate_prior(genus, species, cities, climate)

d <- readRDS("../data/age_dbh_testing.rds")

mod <- brm(form, chains = 4, cores = 2, data = d, init_r = .3, prior = nlprior)
