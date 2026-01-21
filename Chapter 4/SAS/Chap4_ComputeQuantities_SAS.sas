title 'Chapter 4 Analysis Example- Computing Chapter Quantities';

* The following program code computes quantities 
presented in Chapter 4 of the book. These 
estimates include, true values of parameters in the model and 
several effect size measures for the mediated effect;
* Note that the data used are from the water consumption example in Chapter 3;

* Recall four variables are defined: (a) subject ID#, (b) room
  temperature, or subject score on X, (c) reported thirst,
  or subject score on M, and (d) water consumption, or subject
  score on Y;

data a;
input  id x m y;
datalines;
 1    70    4    3
 2    71    4    3
 3    69    1    3
 4    70    1    3
 5    71    3    3
 6    70    4    2
 7    69    3    3
 8    70    5    5
 9    70    4    4
10    72    5    4
11    71    2    2
12    71    3    4
13    70    5    5
14    71    4    5
15    71    4    5
16    70    2    2
17    70    4    4
18    69    3    5
19    72    3    4
20    71    3    3
21    71    2    4
22    72    3    5
23    67    1    2
24    71    4    4
25    71    3    2
26    70    3    4
27    70    2    3
28    69    3    4
29    69    4    3
30    70    3    3
31    71    2    1
32    70    1    3
33    70    2    5
34    70    2    1
35    71    4    3
36    68    2    1
37    72    4    3
38    69    3    2
39    70    3    3
40    68    3    2
41    68    3    3
42    70    4    3
43    71    4    4
44    69    2    2
45    69    3    3
46    71    3    4
47    71    4    4
48    71    3    2
49    72    4    5
50    70    2    2  
;

*This code computes raw and partial correlations, as well as
regression coefficients for the three variables in the model. 
All estimates are named and saved out to datasets for use 
in the computations that follow;

proc corr data=a outp=rawcorrs noprint; 
	var m x y;
run;
proc means data=a noprint;
output out=out1 std(x)=stdx std(y)=stdy std(m)=stdm;
run;
proc reg data=a outest=cpath noprint;
model y=x;
run;
proc reg data=a outest=cpbpaths;
model y= x m;
run;
proc reg data=a outest=apath;
model m=x; 
run; 
quit;
data b; set cpath;
call symput("c",x);

data c; set cpbpaths;
call symput("cprime",x);
call symput("b",m);

data d; set apath;
call symput("a",x); 

data e; set rawcorrs;
if _name_ eq "m" then call symput("rxm",x);
if _name_ eq "m" then call symput("rmy",y);
if _name_ eq "x" then call symput("rxy",y);
run;

*The following code calculates various quantities presented in Chapter 4;
*All examples are computed for the water consumption example; 

data compute; set out1;
drop _TYPE_ _FREQ_;
rxm=&rxm;
rmy=&rmy;
rxy=&rxy;
c=&c;
cprime=&cprime;
a=&a;
b=&b;

*EQUATION 4.1, or the partial correlation for c';
pcorrcp= (rxy-rmy*rxm) / (sqrt( (1-rmy**2) * (1-rxm**2) ));

*EQUATION 4.2, or the partial correlation for b;
pcorrb= (rmy-rxy*rxm) / (sqrt( (1-rxy**2) * (1-rxm**2) ));

* EQUATION 4.3, or the regression coefficient for c';
betacp= ( (rxy-rxm*rmy) / (1-rxm**2) ) * (stdy/stdx);

* EQUATION 4.4, or the regression coefficient for b;
betab= ((rmy-rxm*rxy) / (1-rxm**2)) * (stdy/stdm);

* The proportion mediated effect size measure;
propmed= (a*b) / c;

* The ratio of the mediated effect to the direct effect;
ratio1= (a*b) / cprime;

* The ratio of the effect of X on Y to the effect of X on M;
ratio2= c / a; 

*The multiple correlation of Y, M, and X;
rsqrmult= ( ( (rxy**2) + (rmy**2) )-(2*rxy*rmy*rxm) ) / ( 1- (rxm**2) );

* EQUATION 4.5, or the amount of variance in Y explained 
by the mediated effect;
rsquare1 = (rmy**2) - (rsqrmult - (rxy**2) );

*EQUATION 4.6, or the squared correlation of X & M
times the squared partial correlation of M & Y, partialed for X; 
rsquare2 = (rxm**2) * (pcorrb**2);

*EQUATION 4.7, or the Rsquare2 measure divided by the
total variance in Y explained by both X and M;
rsquare3 = ( (rxm**2) * (pcorrb**2) ) / rsqrmult;

* EQUATION 4.8, or the ratio of the mediated effect
to the standard deviation of Y;
dmeasure = ( a * b ) / stdy;

run;

proc print data=compute noobs;

run;
quit;



