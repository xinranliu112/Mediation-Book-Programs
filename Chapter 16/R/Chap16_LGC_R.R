########################
###     LGC Model    ###
########################
# Read data
data <- read.csv("Chap16_ATLASBtoE.csv", na.strings = "*")
colnames(data) <- c("group", "intent", "nutrit", "sever", "media",
                    "cintent", "cnutrit", "csever", "cmedia", "dintent", 
                    "dnutrit","dsever", "dmedia", "eintent", "enutrit", 
                    "esever", "emedia")
# Load package
# install.packages("lavaan")
library(lavaan)

# lavaan model string
model <- '
  i1 =~ 1*media + 1*cmedia + 1*dmedia + 1*emedia
  s1 =~ 0*media + 0.3*cmedia + 1*dmedia + 1.3*emedia
  s3 =~ 0*media + 1*cmedia + 1*dmedia + 1*emedia

  i2 =~ 1*nutrit + 1*cnutrit + 1*dnutrit + 1*enutrit
  s2 =~ 0*nutrit + 0.3*cnutrit + 1*dnutrit + 1.3*enutrit
  s4 =~ 0*nutrit + 1*cnutrit + 1*dnutrit + 1*enutrit

  s1 ~ i2
  s2 ~ i1 + s3 + group
  s3 ~ i2 + group
  s4 ~ s3 + i1 + group

  media ~ 0*1
  cmedia ~ 0*1
  dmedia ~ 0*1
  emedia ~ 0*1

  nutrit ~ 0*1
  cnutrit ~ 0*1
  dnutrit ~ 0*1
  enutrit ~ 0*1

  i1 ~ 1 
  s1 ~ 1 
  s3 ~ 1 
  i2 ~ 1 
  s2 ~ 1 
  s4 ~ 1 
'

# Fit model
fit <- sem(model, data = data, missing = "fiml")
summary(fit, fit.measures = TRUE, standardized = TRUE)
