Title "Chapter 11 Analysis Example: 2x2 Smoking Data Example";

* The following program code reads in the dataset and computes
  the analysis for the 2x2 smoking data example in Chapter 11;

* Three variables are defined: (a) outcome, i.e., whether
  the subject smoked in the last month or not, where 1
  defines tobacco use in the last month, and 0 defines 
  no tobacco use in the last month, (b) group, i.e., 
  smoking prevention program condition, where 1 defines 
  exposure to the treatment condition and 0 defines 
  exposure to the control condition, and (c) freq, i.e., 
  the frequency of observations in a given condition 
  (defined by the presence or absence of X and Y);

* NOTE: The regression coefficient estimated in the logistic 
  regression model is of the form of ln(odds). Given the difficult 
  interpretation of this metric, it is helpful to transform the 
  regression coefficient into one of three quantities: 
  (a) the logit, (b) the odds, and (c) the proportion;

* The following data commands define the logit, the odds, and the
  proportion of the outcome variable based on the intercept
  and the regression coefficient estimated in the logistic 
  regression model estimated below;

data a;
 input outcome group freq;
 logit=.3773+(-.5057)*group;
 odds=exp(logit);
 p=odds/(odds+1);

* The following cards statement reads in the data for the example;

cards;
 1 1 73 
 0 1 83
 1 0 420
 0 0 288
 ;

* The following commands run a logistic regression model for 
  the independent and dependent variables defined above: 
  (a) outcome and (b) group;

 * NOTE: The weight command in the proc logistic statement weights
  a given observation by the variable immediately following the 
  command. The following commands specify that each observation
  in the dataset be weighted by the frequency (i.e., freq) of
  that variable;

 * NOTE: The descending command tells proc logistic procedure
  to correctly analyze the dependent variable parameters as it is 
  in the dataset. Specifically, the default estimation in proc logistic 
  would have the parameter reversed such that 0 codes the presence
  of the outcome and 1 codes the absence of the outcome. The
  descending statement overrides this default;

 * NOTE: The clparm and clodds statements provide confidence limits
  for the model parameters and odds, respectively;

 proc logistic descending; weight freq;
 model outcome=group/clparm=both clodds=both;
 run;
 quit;


