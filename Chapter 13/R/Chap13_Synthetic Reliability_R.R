#########################################
### Synthetic Reliability Estimation  ###
#########################################
# Read data
chap13Data <- read.table("Chap13_Exp1 Raw Data.txt",
                         quote = "\"", 
                         comment.char = "")
colnames(chap13Data) <- c("id", "coach1", "coach2", "coach3", 
                          "severe1", "severe2", "severe3", 
                           "intent1", "intent2", "intent3")
chap13Data$coachs <- chap13Data$coach1 + chap13Data$coach2 + chap13Data$coach3
chap13Data$severes <- chap13Data$severe1 + chap13Data$severe2 + chap13Data$severe3
chap13Data$intents <- chap13Data$intent1 + chap13Data$intent2 + chap13Data$intent3

# Load package
library(lavaan)

# Model syntax
syntheticReliabilityModel <- '
# Measurement model
severe =~ 1*severes
coach  =~ 1*coachs
intent =~ 1*intents

# Fix residual variances of indicators
severes ~~ 0.2828*severes
coachs ~~ 0.1784*coachs
intents ~~ 0.5629*intents

# Structural regressions
intent ~ severe + coach
severe ~ coach
'

syntheticReliabilityFit <- sem(model = syntheticReliabilityModel, 
                               data = chap13Data,
                               estimator = "ML")
summary(syntheticReliabilityFit, 
        ci = TRUE,
        standardized = TRUE)

notAdjustedforMeasurementErrorModel <- '
# Structural regressions
intents ~ severes + coachs
severes ~ coachs
'

notAdjustedforMeasurementErrorFit <- sem(model = notAdjustedforMeasurementErrorModel, 
                                         data = chap13Data,
                                         estimator = "ML")
summary(notAdjustedforMeasurementErrorFit, 
        ci = TRUE,
        standardized = TRUE)