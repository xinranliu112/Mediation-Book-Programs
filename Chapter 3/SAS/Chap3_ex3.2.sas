*Program to compute Chapter 3 quantities for Exercise 3.2 and the water consumption
*example;
data a;
input c sec cp secp b seb a sea mse ssx N;
ta=a/sea;tb=b/seb;tc=c/sec;tcp=cp/secp;
varab=a*a*seb*seb+b*b*sea*sea;
se36=sqrt(varab);
se37=(a*b*(sqrt(ta*ta+ tb*tb)))/(ta*tb);
se38=sqrt(sec*sec+secp*secp-2*(mse/(N*ssx)));
se39=sqrt(varab+sea*sea*seb*seb);
se310=(a*b*(sqrt(ta*ta+tb*tb+1)))/(ta*tb);
se311=sqrt(varab-sea*sea*seb*seb);
se312=(a*b*(sqrt(ta*ta+tb*tb-1)))/(ta*tb);
ccp=c-cp;ab=a*b;
*Normal theory confidence limits with first order standard error;
ucl=ab+1.96*se36; lcl=ab-1.96*se36;
*Causal Steps are the same as the t-tests for regression estimates, c a, b, and cp;
*Note the first line of data is for question 3.2, second line of data is from the water consumption example 
*to four decimal places and the last line is the water consumption data to more decimal places. With 
*more decimal places ab equals c - cp more closely for the water consumption example so that ab may not be 
*exactly equal to c - cp because of rounding error;
cards;
.3552 .0631 .1856 .0642 .1711 .0195 .9912 .0896 1.1289 .2459 1227
.3604 .1343 .2076 .1333 .4510 .1460 .3386 .1224 .9852 1.293   50
.360366 .13432191 .207648 .13325967 .451039 .14597405 .338593 .12236736 .98523 1.293 50
;
proc print; var ccp ab;
proc print;var se36 se37 se38 se39 se310 se311 se312;
proc print;var ab se36 lcl ucl;
proc print; var tc ta tb tcp ccp;
run;
