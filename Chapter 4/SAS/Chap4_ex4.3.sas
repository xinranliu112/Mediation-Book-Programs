/* This program analyzes the data in Exercise 4.3 with regression
and then computes quantities in the chapter including the 
coefficients and theoretical variance of the esimates;
*/

data a;
input x m y;
cards; 
4.83    5.75    5.23    
4.97    5.14    5.05    
4.94    5.19    5.01    
5.11    4.74    5.07    
5.05    4.95    5.11    
4.98    5.22    5.17    
4.86    5.43    5.00    
4.94    5.28    5.12    
4.97    5.17    5.06    
4.92    5.27    5.06    
5.00    4.72    4.73    
4.84    5.22    4.76    
5.07    4.76    4.99    
5.11    4.61    4.92    
5.14    4.65    5.09   
;
proc reg; model y=x/ stb pcorr1 pcorr2 scorr1 scorr2; model y= x m/ stb pcorr1 pcorr2 scorr1 scorr2;
model m=x/ stb pcorr1 pcorr2 scorr1 scorr2;
proc corr;
run; 

data a;
input c sec cp secp b seb a sea
#2 rxm rxy rmy sx sm sy N mseyx mseyxm msemx;
/* Here are a few definitions of variables:
rxm is the correlation between x and m, mseyx is the root mean
squared error in the equation relating x to y;
*/
seyx=mseyx;
seyxm=mseyxm;
semx=msemx;
ryxpm=(rxy-rmy*rxm)/sqrt((1-rmy*rmy)*(1-rxm*rxm));
rympx=(rmy-rxy*rxm)/sqrt((1-rxy*rxy)*(1-rxm*rxm));
cps=((rxy-rxm*rmy)/(1-rxm*rxm))*(1/1);
bs=((rmy-rxm*rxy)/(1-rxm*rxm))*(1/1);
cpcp=((rxy-rxm*rmy)/(1-rxm*rxm))*(sy/sx);
bb=((rmy-rxm*rxy)/(1-rxm*rxm))*(sy/sm);
big=(rxy*rxy+rmy*rmy-2*rmy*rxy*rxm)/(1-rxm*rxm);
cpcalc=(sm*sm*(rxy*sx*sy)-(rxm*sx*sm)*(rmy*sm*sy))/(sx*sx*sm*sm-(rxm*sx*sm)**2);
bcalc=(sx*sx*(rmy*sm*sy)-(rxm*sx*sm)*(rxy*sx*sy))/(sx*sx*sm*sm-(rxm*sx*sm)**2);
acalc=(rxm*sx*sm)/(sx*sx);
sacalc=sqrt(semx*semx/((N-1)*(sx*sx)));
ccalc=(rxy*sx*sy)/(sx*sx);
sccalc=sqrt(seyx*seyx/((N-1)*(sx*sx)));
scpcalc=sqrt(((seyxm*seyxm)/(N-1)) * (1/(sx*sx)/(1-rxm*rxm)));
sbpcalc=sqrt(((seyxm*seyxm)/(N-1)) * (1/(sm*sm)/(1-rxm*rxm)));
ab=a*b;diff=c-cp;
se36=sqrt(a*a*seb*seb+b*b*sea*sea);tab=ab/se36;
se38=sqrt( sec*sec+secp*secp- 2* ( (mseyxm*mseyxm)/(N*sx*sx) ));
prop=ab/c; ratio=ab/cp;
r21=rmy*rmy-(big-rxy*rxy);
r22=rxm*rxm*rympx*rympx;
r23=(rxm*rxm*rympx)/big;
cards;
.02173 .38234 2.93612 .10447 .97701 .03169 -2.98297 .38889
-.90500 .01576 .40843 .09865 .32515 .13601 15 .14112 .01640 .14354 
;
proc print;
run;
