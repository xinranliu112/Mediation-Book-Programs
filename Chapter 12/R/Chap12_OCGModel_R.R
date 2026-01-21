##########################
###     OCG Example    ###
##########################
# Read data
chap12OCGExample <- read.table("Chap12_ocgexample_R.txt", quote="\"", comment.char="")
sd <- as.matrix(chap12OCGExample[1,])
cor <- as.matrix(chap12OCGExample[-1,])
cov <- cor * matrix(outer(sd, sd), nrow = 6, byrow = TRUE)   
colnames(cov) <- rownames(cov) <- c("x1", "x2", "x3", "y1", "y2", "y3")

# Load package
# install.packages("lavaan")
library(lavaan)

# Model syntax
OCGModel <- "
y1 ~ lambda11*x1 + lambda12*x2 + lambda13*x3
y2 ~ lambda21*x1 + lambda22*x2 + lambda23*x3 + beta21*y1
y3 ~ lambda31*x1 + lambda32*x2 + lambda33*x3 + beta31*y1 + beta32*y2

specIndX1Y1Y2 := lambda11*beta21
specIndX1Y2Y3 := lambda21*beta32
specIndX1Y1Y3 := lambda11*beta31
specIndX1Y1Y2Y3 := lambda11*beta21*beta32
specIndX2Y1Y2 := lambda12*beta21
specIndX2Y2Y3 := lambda22*beta32
specIndX2Y1Y3 := lambda12*beta31
specIndX2Y1Y2Y3 := lambda12*beta21*beta32
specIndX3Y1Y2 := lambda13*beta21
specIndX3Y2Y3 := lambda23*beta32
specIndX3Y1Y3 := lambda13*beta31
specIndX3Y1Y2Y3 := lambda13*beta21*beta32
specIndY1Y2Y3 := beta21*beta32

totalIndX1Y3 := lambda11*beta31 + lambda21*beta32 + lambda11*beta21*beta32
totalIndX2Y3 := lambda12*beta31 + lambda22*beta32 + lambda12*beta21*beta32
totalIndX3Y3 := lambda13*beta31 + lambda23*beta32 + lambda13*beta21*beta32

totalX1Y2 := lambda11*beta21 + lambda21
totalX1Y3 := lambda11*beta31 + lambda21*beta32 + lambda11*beta21*beta32 + lambda31
totalX2Y2 := lambda12*beta21 + lambda22
totalX2Y3 := lambda12*beta31 + lambda22*beta32 + lambda12*beta21*beta32 + lambda32
totalX3Y2 := lambda13*beta21 + lambda23
totalX3Y3 := lambda13*beta31 + lambda23*beta32 + lambda13*beta21*beta32 + lambda33
totalY1Y3 := beta21*beta32 + beta31
"

# Fit the model
OCGFit <- sem(model = OCGModel, sample.cov = cov, sample.nobs = 3214)
summary(OCGFit)
fitted(OCGFit)
lavInspect(OCGFit, what = "est")
