/*med_plots.sas 2008 by Matthew Fritz, Dept. of Psychology, Virginia Tech
  and David MacKinnon, Dept. of Psychology, Arizona State University
  This program plots the mediated effect for a single mediator mediation 
  model and adds labels for the different effects.
  To use this SAS macro, either open the file in SAS or cut and paste the
  code into a SAS syntax window.
EDITED JAN 15, 2012 TO OVERLAY PLOTS AND FIX OTHER ISSUES PROBABLY RELATED TO 
THE NEW VERSION OF SAS DPM
  To run the macro, first open a data set in SAS.  Rename the variables of
  interest to X, M, and Y, respectively, then set data1 equal to this data
  set.  Next, go to the %med_plots(cont=, int=) line at the end of the file
  and specify values for cont (0=dichotomous X, 1=continuous X) and 
  int (0=no XM interaction, 1=XM interaction) and then run the macro.*/

*goptions reset=all;

data b;
input  id x m y;
if x le 69 then dichx=0;
if x gt 69 then dichx=1;
x=dichx;
 cards;
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
%macro med_plots(cont,int);
PROC SORT DATA=B;BY X;
PROC CORR DATA=B; VAR  M Y; BY X;
*Change 'b' to the name of your data set;
data data1; set b;
xm=x*m;
run;
proc print;
*Runs the regression analyses;
%if &int=0 %then %do;
proc reg data=data1 outest=out1 ;
model y=x;
model m=x;
model y=x m;
%end;

%else %do;
proc reg data=data1 outest=out1 ;
model y=x;
model m=x;
model y=x m xm;
%end;

*Captures the parameter estimates and makes the macro variables;
data out2; set out1;
if _model_="MODEL1" then i1=intercept;
if _model_="MODEL1" then c=x;
if c='.' then delete;
keep i1 c;

data out3; set out1;
if _model_="MODEL2" then i2=intercept;
if _model_="MODEL2" then a=x;
if a='.' then delete;
keep i2 a;

data out4; set out1;
if _model_="MODEL3" then i3=intercept;
if _model_="MODEL3" then cpr=x;
if _model_="MODEL3" then b=m;
if _model_="MODEL3" then g=xm;
if cpr='.' then delete;
keep i3 cpr b g;

data data2; merge out2 out3 out4;
call symput('i1',i1);
call symput('i2',i2);
call symput('i3',i3);
call symput('a',a);
call symput('b',b);
call symput('c',c);
call symput('cpr',cpr);
call symput('g',g);
run;
proc print data=data2;
*Syntax for the dichotomous, no interaction condition;
%if (&cont=0 and &int=0) %then %do;
data data1; set data1;
py=&i3+&cpr*x+&b*m;
%let vref1=&i1;
%let vref2=%sysevalf(&i1+&c);
%let href1=&i2;
%let href2=%sysevalf(&i2+&a);

proc gplot data=data1;
symbol1 value=none color=black i=rl line=1 width=3;
symbol2 value=none color=black i=rl line=3 width=3;
symbol3 value='0' color=black i=none;
symbol4 value='1' color=black i=none;
axis1 label=('Y') reflabel=(justify=left 'Y=i1' 'Y=i1+c') ;
axis2 label=('M') reflabel=(position=bottom 'M=i2' 'M=i2+a');
plot py*m=x/vref=&vref1 vref=&vref2 href=&href1 href=&href2
	vaxis=axis1 haxis=axis2 legend;
plot2 y*m=x/nolegend noaxis;
%end; 

*Syntax for the dichotomous, interaction condition;
%if (&cont=0 and &int=1) %then %do;
data data1; set data1;
py=&i3+&cpr*x+&b*m+&g*x*m;
%let vref1=&i1;
%let vref2=%sysevalf(&i1+&c);
%let href1=&i2;
%let href2=%sysevalf(&i2+&a);

proc gplot data=data1;
symbol1 value=none color=black i=rl line=1 width=3;
symbol2 value=none color=black i=rl line=3 width=3;
symbol3 value='0' color=black i=none;
symbol4 value='1' color=black i=none;
axis1 label=('Y') reflabel=(justify=left 'Y=i1' 'Y=i1+c') ;
axis2 label=('M') reflabel=(position=bottom 'M=i2' 'M=i2+a');
plot py*m=x/vref=&vref1 vref=&vref2 href=&href1 href=&href2
	vaxis=axis1 haxis=axis2 legend;
plot2 y*m=x/nolegend noaxis;
%end; 

*Syntax for the continuous, no interaction condition;
%if(&cont=1 and &int=0) %then %do;
proc means data=data1 noprint;
var x;
output out=out5 mean(x)=meanx std(x)=stdx;

data out5; set out5;
xminussd=meanx-stdx;
xplussd=meanx+stdx;
call symput('meanx',meanx);
call symput('xminussd',xminussd);
call symput('xplussd',xplussd);

data data1; set data1;
py1=&i3+&cpr*&xminussd+&b*m;
py2=&i3+&cpr*&meanx+&b*m;
py3=&i3+&cpr*&xplussd+&b*m;
label py1='MeanX-1SD' py2='MeanX' py3='MeanX+1SD';
%let vref1=%sysevalf(&i1+&c*&meanx);
%let vref2=%sysevalf(&i1+&c*(&meanx+1));
%let href1=%sysevalf(&i2+&a*&meanx);
%let href2=%sysevalf(&i2+&a*(&meanx+1));


proc gplot data=data1;
symbol1 value=none color=black i=rl line=2 width=3;
symbol2 value=none color=black i=rl line=1 width=3;
symbol3 value=none color=black i=rl line=3 width=3;
symbol4 value='0' color=black i=none;
axis1 label=('Y') reflabel=(justify=left 'Y=i1' 'Y=i1+c') ;
axis2 label=('M') reflabel=(position=bottom 'M=i2' 'M=i2+a');
plot py1*m py2*m py3*m/overlay vref=&vref1 vref=&vref2 href=&href1 href=&href2
	vaxis=axis1 haxis=axis2 legend;
plot2 y*m y*m y*m/overlay nolegend noaxis;

%end;

*Syntax for the continuous, interaction condition;
%if(&cont=1 and &int=1) %then %do;
proc means data=data1 noprint;
var x;
output out=out5 mean(x)=meanx std(x)=stdx;

data out5; set out5;
xminussd=meanx-stdx;
xplussd=meanx+stdx;
call symput('meanx',meanx);
call symput('xminussd',xminussd);
call symput('xplussd',xplussd);

data data1; set data1;
py1=&i3+&cpr*&xminussd+&b*m+&g*&xminussd*m;
py2=&i3+&cpr*&meanx+&b*m+&g*&meanx*m;
py3=&i3+&cpr*&xplussd+&b*m+&g*&xplussd*m;
label py1='MeanX-1SD' py2='MeanX' py3='MeanX+1SD';
%let vref1=%sysevalf(&i1+&c*&meanx);
%let vref2=%sysevalf(&i1+&c*(&meanx+1));
%let href1=%sysevalf(&i2+&a*&meanx);
%let href2=%sysevalf(&i2+&a*(&meanx+1));


proc gplot data=data1;
symbol1 value=none color=black i=rl line=2 width=3;
symbol2 value=none color=black i=rl line=1 width=3;
symbol3 value=none color=black i=rl line=3 width=3;
symbol4 value='0' color=black i=none;
axis1 label=('Y') reflabel=(justify=left 'Y=i1' 'Y=i1+c') ;
axis2 label=('M') reflabel=(position=bottom 'M=i2' 'M=i2+a');
plot py1*m py2*m py3*m/ OVERLAY vref=&vref1 vref=&vref2 href=&href1 href=&href2
	vaxis=axis1 haxis=axis2 legend;
plot2 y*m /OVERLAY  nolegend noaxis;
%end;

%mend;
%med_plots(cont=0,int=0);
run;
quit;
