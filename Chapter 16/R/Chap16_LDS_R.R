########################
###     LDS Model    ###
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

# Define the model
model <- '
  cintent ~ 1*intent
  dintent ~ 1*cintent
  eintent ~ 1*dintent
  csever ~ 1*sever
  dsever ~ 1*csever
  esever ~ 1*dsever

  ldint2 =~ 1*cintent
  ldint3 =~ 1*dintent
  ldint4 =~ 1*eintent
  ldsev2 =~ 1*csever
  ldsev3 =~ 1*dsever
  ldsev4 =~ 1*esever

  ldint2 ~ intent + sever + group + ldsev2
  ldint3 ~ cintent + csever + ldint2 + ldsev2 + ldsev3
  ldint4 ~ dintent + dsever + ldint3 + ldsev2 + ldsev3 + ldsev4
  ldsev2 ~ sever + intent + group
  ldsev3 ~ csever + cintent + ldsev2 + ldint2
  ldsev4 ~ dsever + dintent + ldsev3 + ldint2 + ldint3
  
  sever ~~ intent
  group ~~ intent
  sever ~~ group
  
  sever ~ 1 
  intent ~ 1 
  group ~ 1 

  sever ~~ sever
  intent ~~ intent

  cintent ~~ 0*cintent
  dintent ~~ 0*dintent
  eintent ~~ 0*eintent
  csever ~~ 0*csever
  dsever ~~ 0*dsever
  esever ~~ 0*esever

  ldint2 ~~ 0*ldint3
  ldint2 ~~ 0*ldint4
  ldint3 ~~ 0*ldint4
  ldsev2 ~~ 0*ldsev3
  ldsev2 ~~ 0*ldsev4
  ldsev3 ~~ 0*ldsev4
  intent ~~ 0*ldint2 + 0*ldint3 + 0*ldint4 + 0*ldsev2 + 0*ldsev3 + 0*ldsev4
  sever ~~ 0*ldint2 + 0*ldint3 + 0*ldint4 + 0*ldsev2 + 0*ldsev3 + 0*ldsev4
'

# Fit the model
fit <- sem(model, data = data, missing = "fiml")
summary(fit, fit.measures = TRUE, standardized = TRUE)