##########################
### Two Mediator Model ###
##########################
# Read data
chap12TwoMed <- read.table("Chap12_twomed.txt", quote="\"", comment.char="")
colnames(chap12TwoMed) <- c("id", "x", "m1", "m2", "y")

# Load package
# install.packages("lavaan")
library(lavaan)

# Model syntax
twoMedModel <- "
m1 ~ lambda1*x
m2 ~ lambda2*x
y ~ lambda3*x + beta31*m1 + beta32*m2

specIndXM1Y := lambda1*beta31
specIndXM2Y := lambda2*beta32
totalInd := lambda1*beta31 + lambda2*beta32
total := lambda1*beta31 + lambda2*beta32 + lambda3
"

# Fit the model
twoMedFit <- sem(model = twoMedModel, data = chap12TwoMed, se = "bootstrap")
summary(twoMedFit)
fitted(twoMedFit)
lavInspect(twoMedFit, what = "est")