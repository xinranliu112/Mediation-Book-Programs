memory <- read.delim("memory.txt")
library(mediation)
set.seed(8292019)

datasets <- list(T1 = memory)
mediators <- c("M", "R")
outcome <- c("Y")
treatment <- ("X")
covariates <- c()


x.1 <- mediations(datasets, treatment, mediators, outcome, covariates, families=c("gaussian", "gaussian"), interaction=TRUE, conf.level=.95, sims=1000)

summary(x.1)


allmult <- multimed(outcome = "Y", med.main = "M", med.alt = "R", treat = "X", covariates = NULL, data = memory)
summary(allmult)

