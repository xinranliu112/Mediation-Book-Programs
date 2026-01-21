###################################
###     Autoregressive Model    ###
###################################
# Read data
data <- read.csv("Chap16_ATLASBtoE.csv", na.strings = "*")
colnames(data) <- c("group", "intent", "nutrit", "sever", "media",
                    "cintent", "cnutrit", "csever", "cmedia", "dintent", 
                    "dnutrit","dsever", "dmedia", "eintent", "enutrit", 
                    "esever", "emedia")
# Load package
# install.packages("lavaan")
library(lavaan)

# Define the model
model <- '
  cintent ~ group + intent + sever
  dintent ~ group + cintent + csever
  eintent ~ group + dintent + dsever

  csever ~ group + sever
  dsever ~ group + csever
  esever ~ group + dsever

  group ~~ intent + sever
  intent ~~ sever
  cintent ~~ csever
  dintent ~~ dsever
  eintent ~~ esever
'

# Fit the model
fit <- sem(model, data = data, missing = "fiml")
summary(fit, fit.measures = TRUE, standardized = TRUE)
