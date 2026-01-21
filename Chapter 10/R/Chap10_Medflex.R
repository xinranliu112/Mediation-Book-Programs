library(medflex)
memory <- read.table("Chap10_memory.txt", header = T)

### imputation
set.seed(8292019)
#Creating the extended dataset
impword<-neImpute(Y~factor(X)*M*R,nMed=2, data=memory)
#Use the neModel instruction using X0 and X1 as predictors of Y
modcov<-neModel(Y~X0*X1,expData=impword, se="bootstrap",type="perc", nboot=1000)
summary(modcov)

### weighting
set.seed(8292019)
fitM1 <- glm(M ~ X, family = gaussian("identity"), data = memory)
fitM2 <- glm(R ~ X * M, family = gaussian("identity"), data = memory)
fitY <- glm(Y ~ X * M * R, family = gaussian("identity"), data = memory)
summary(fitM1)
summary(fitY)
extdat <- data.frame(replicate = rep(1:4, times = nrow(memory)), 
                     X = rep(memory$X, each = 4),
                     R = rep(memory$R, each = 4),
                     Y = rep(memory$Y, each = 4),
                     M = rep(memory$M, each = 4),
                     XM = rep(memory$XM, each = 4),
                     a0 = NA, a1 = NA, a2 = NA)
extdat2 <- within(extdat, {
  # let a0 take on counterfactual exposure level 1-X
  # for the 2nd and 4th duplicate
  a0 <- ifelse(replicate %in% c(2, 4), 1 - X, X)
  # let a1 take on the observed exposure level X
  a1 <- X
  # let a2 take on counterfactual exposure level 1-X
  # for the 3rd and 4th duplicate
  a2 <- ifelse(replicate %in% c(3, 4), 1 - X, X)
})
# calculate W2
num2 <- with(extdat2, dnorm(M, mean = predict(fitM1, newdata = within(extdat2, X <- a2), type = "response"), sd = sqrt(summary(fitM1)$dispersion)))
denom2 <- with(extdat2, dnorm(M, mean = predict(fitM1, newdata = within(extdat2, X <- a1), type = "response"), sd = sqrt(summary(fitM1)$dispersion)))
W2 <- num2/denom2
extdat2$Y <- predict(fitY, newdata = within(extdat2, X <- a0), type = "response")
fitNEM2 <- glm(Y ~ a0 * a1 * a2 , family = gaussian("identity"), data = extdat2, weights = W2)
summary(fitNEM2)

