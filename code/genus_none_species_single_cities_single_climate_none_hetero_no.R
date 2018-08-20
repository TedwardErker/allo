library(dplyr)
library(brms)
library(ggplot2)
library(gridExtra)


  generate_formula <- function(model_table, gen, sp, cit, clim, het) {
      f <- filter(model_table, genus == gen, species == sp, cities == cit, climate == clim, hetero == het)
      if(f$sigma == "") {
          bf(formula(f$data), formula(f$b0), formula(f$b1), formula(f$b2), nl = T)
      } else {
          bf(f$data, f$b0, f$b1, f$b2, f$sigma, nl = T)
      }
  }

  generate_prior <- function(gen, sp, cit, clim) {

      nlprior <- c(prior(gamma(4, 3), nlpar = "b0",lb = 0),
                   prior(gamma(5, 1), nlpar = "b1", lb = 0),
                   prior(gamma(4, 3), nlpar = "b2",lb = 0))

      if("many" %in% c(gen, sp, cit)) {

          nlprior <- c(nlprior,
                       prior(cauchy(0,.1), class = "sd", nlpar = "b0"),
                       prior(cauchy(0,.1), class = "sd", nlpar = "b1"),
                       prior(cauchy(0,.1), class = "sd", nlpar = "b2"))

      }

      if(clim == "b0") {
          nlprior <- c(nlprior,
                       prior(normal(.3,.25), class = "sds", nlpar = "b0"))
      }
      nlprior
  }

genus <- "none"
species <- "single"
cities <- "single"
climate <- "none"
hetero <- "no"

model_table <- read.csv("../data/model_table.csv", stringsAsFactors = F)

form <- generate_formula(model_table, genus, species, cities, climate, hetero)

nlprior <- generate_prior(genus, species, cities, climate)

d <- readRDS("../data/age_dbh_testing.rds")

  mod <- brm(form, chains = 4, cores = 4, data = d, init_r = .3, prior = nlprior, iter = 200)
saveRDS(mod, paste0("../models/genus_",genus,"_species_",species,"_cities_", cities, "_climate_", climate, "_hetero_", hetero, ".rds"))
