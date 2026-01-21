install.packages("medflex")
library(medflex)

memory <- read.table("Chap7_Memory.txt")
colnames(memory) <- c("id", "x", "m", "r", "y")

impData <- neImpute(y ~ factor(x) * m, data = memory)
neImpFit <- neModel(y ~ x0*x1,
                    expData = impData,
                    se = "bootstrap",
                    nBoot = 1000)
neImpEff <- neEffdecomp(neImpFit)
summary(neImpEff)
confint(neImpEff, level = 0.95, type = "perc")

weightData <- neWeight(m ~ factor(x), data = memory)
weightData$weights <- c(weights(weightData))
weightData$yW <- 1 / weightData$weights
neWeightFit <- neModel(yW ~ x0*x1,
                       expData = weightData,
                       se = "bootstrap",
                       nBoot = 1000)
neWeightEff <- neEffdecomp(neWeightFit)
summary(neWeightEff)
confint(neWeightEff, level = 0.95, type = "perc")
