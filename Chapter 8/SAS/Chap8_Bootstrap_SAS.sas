/*Chapter 8 Bootstrapping Example*/

data a;
input s x m y;
cards;
1 1 2 -4
2 1 5 -6
3 2 8 -14
4 2 9 -16
5 -1 -7 12
6 0 0 -1
;
run;
proc reg data=a outest=out1 noprint;
model y = m x;
model m = x;
run;
quit;

data out1; set out1;
if _MODEL_='MODEL1' then call symput ("b", m);
if _MODEL_='MODEL2' then call symput ("a", x);
run;
quit;
/*Bootstrap*/
*This is where the bootstrap samples are made.;
*sampsize should be equal to the number of observations in the dataset;
*rep is the number of bootstrap samples you want;

%let nboot=10000;

proc surveyselect data=a noprint out=out2 method=urs sampsize=6 rep=&nboot outhits;
run;
quit;

proc reg data=out2 outest=out3 noprint;
by Replicate;
model y = m x;
model m = x;

data b; set out3;
if _MODEL_^='MODEL1' then delete;
b=m;
keep Replicate b;

data c; set out3;
if _MODEL_^='MODEL2' then delete;
a=x;
keep Replicate a;

data d; merge b c; by Replicate;
ab=a*b;
if ab<=&a*&b then z=1; else z=0;

proc means data=d noprint;
var z;
output out=out4 mean(z)=meanz;

data out4; set out4;
call symput("meanz", meanz);

proc sort data=d;
by ab;
proc univariate data=d;
var ab;
*Percentile Bootstrap and Bias-Corrected Bootstrap;
data e; set d;
z0=probit(&meanz);
if _N_=(ceil(.025*&nboot)) then call symput("LCL95", ab);
if _N_=(ceil(.975*&nboot)) then call symput("UCL95", ab);
if _N_=(ceil(&nboot*probnorm((2*z0)+probit(.025)))) then call symput("BCLCL95", ab);
if _N_=(ceil(&nboot*probnorm((2*z0)+probit(.975)))) then call symput("BCUCL95", ab);
run;
quit;

data f;
LCL95=&LCL95;
UCL95=&UCL95;
BCLCL95=&BCLCL95;
BCUCL95=&BCUCL95;

proc print data=f noobs;
var LCL95 UCL95 BCLCL95 BCUCL95;

run;
quit;
