/* Program to compute true correlation given true values of 
a, b, cp, c, vare1, vare2, and vare3, Section 4.19; 
*/
Data a;
input a b cp vare1 vare2 vare3 N; 
varx=vare1; 
vary=b*b*(a*a*varx+vare3)+2*b*cp*a*varx+
cp*cp*varx+vare2;
covxy=b*a*varx+cp*varx;
rxy=covxy/(sqrt(vary)*sqrt(varx));
serxy=sqrt (((1-rxy*rxy)**2)/N);
trxy=rxy/serxy;
cards;
.1 .1 0 1 1 1 1000
.3 .1 .2 1 1 1 1000
.5 .6 .3 1 1 1 1000 
;
proc print;
run; 
