data mydata;
input ID X M Y R gender verbal c3;
a=x; m1=m; m2=r; c1=gender; c2=verbal;
cards;
 1 1 9 10 1 1 5 2
 2 1 9 15 7 1 5 3
 3 0 3 13 9 1 5 3
 4 0 7 11 9 0 7 3
 5 0 2 13 8 0 6 3
 6 0 1 15 9 1 5 4
 7 0 7 19 8 1 7 2
 8 0 4 13 9 1 5 2
 9 0 1  9 8 1 7 2
10 1 7 17 8 1 7 3
11 1 9 19 5 1 7 4
12 1 8 16 4 1 7 2 
13 1 9 14 8 0 6 3
14 1 8 14 6 0 6 3
15 1 8 16 4 1 6 4
16 1 6 12 3 1 5 4 
17 1 8 16 4 1 5 3
18 1 9 18 6 1 6 3
19 1 9  9 6 1 6 2
20 1 6 10 5 1 6 4
21 1 9 19 6 1 6 3
22 1 9 19 4 1 6 4
23 1 8 13 7 0 7 2
24 1 5 10 5 1 6 4
25 1 9 17 1 1 6 3
26 1 8 11 3 1 7 3
27 1 9 17 9 0 5 3
28 0 1  9 8 0 7 2
29 0 5 10 9 1 6 4
30 0 1 16 9 1 7 3
31 0 6  9 8 1 6 4
32 0 2  6 9 0 5 3
33 0 1 11 9 1 6 4
34 0 3 12 9 1 7 5
35 0 7 15 8 0 7 5
36 0 9 18 6 1 5 4
37 0 7 10 7 1 5 3
38 0 5  4 8 1 5 3
39 0 3  8 8 0 5 5
40 0 9 18 7 1 6 5
41 0 6 14 6 0 6 4
42 0 2 10 9 1 6 3
43 0 8 15 9 1 7 4
44 0 9 12 3 1 7 3
;
proc means; run;
proc nlmixed data=mydata; /* specify dataset named “mydata” */ 
parms t0=0 t1=0 t2=0 t3=0 t4=0 t5=0 tc1=0 tc2=0 tc3=0 b0=0 b1=0 b2=0 b3=0 bc1=0 bc2=0 bc3=0 r0=0 r1=0 rc1=0 rc2=0 rc3=0 ss_m1=1 ss_m2=1 ss_y=1; 
/* parameter to be estimated*/ a1=1; a0=0; cc1=0.75; cc2=6.0227; cc3=3.294;/*note means for the three covariates)*/;
/* parameter to be intervened*/
/* regression model for mean of all variables */ 
mu_y=t0 + t1*A + t2*M1 + t3*M2 + t4*A*M1 + t5*A*M2 + tc1*C1 + tc2*C2 + tc3*C3; 
mu_m2 =b0 + b1*A + b2*M1 + b3*A*M1 + bc1*C1 + bc2*C2 + bc3*C3; 
mu_m1 =r0 + r1*A + rc1*C1 + rc2*C2 + rc3*C3;
/* score function for all variables*/ 
ll_y= -((y-mu_y)**2)/(2*ss_y)-0.5*log(ss_y);
ll_m2= -((m2-mu_m2)**2)/(2*ss_m2)-0.5*log(ss_m2);
ll_m1= -((m1-mu_m1)**2)/(2*ss_m1)-0.5*log(ss_m1); ll_o= ll_m1 + ll_m2 + ll_y;
model Y ~general(ll_o); /* estimate parameters */
/* calculate all estimate we want */ 
bcc = bc1*cc1 + bc2*cc2 + bc3*cc3; 
rcc = rc1*cc1 + rc2*cc2 + rc3*cc3; 
pse0 = ((t1+t5*(b0+b2*r0+b2*rcc+bcc)+t4*(r0+rcc))+(t4*r1+t5*(b1+b3*r0+b3*rcc+b2*r1))*a0+t5*b3*r1*a0*a0)*(a1-a0); 
pse1 =(t2*r1+t4*r1*a1)*(a1-a0); 
pse2 =(t3*(b1+b3*r0+b3*rcc)+t5*(b1+b3*r0+b3*rcc)*a1+t3*b3*r1*a0+t5*b3*r1*a1*a0)*(a1-a0); 
pse12 =(t3*b2*r1+((t5*b2*r1+t3*b3*r1))*a1+t5*b3*r1*a1*a1)*(a1-a0); ie1=pse1+pse12; ie2=pse2+pse12; 
ie = pse1+pse2+pse12; 
te = pse0+ie; 
estimate 'Direct Effect' pse0; 
estimate 'Path Specific Effect via M1 alone' pse1; 
estimate 'Path Specific Effect via M2 alone' pse2;
estimate 'Path Specific Effect via both M1 and M2' pse12; 
estimate 'Path Specific Effect via M1 (with/out M2)' ie1; 
estimate 'Path Specific Effect via M2 (with/out M1)' ie2; 
estimate 'Total Indirect Effect' ie; estimate 'Total Effect' te; 
estimate 'Proportion Direct Effect' pse0/te; 
estimate 'Proportion via M1' pse1/te; 
estimate 'Proportion via M2' pse2/te; 
estimate 'Proportion via both M1 and M2' pse12/te; 
estimate 'Total Proportion via M1' ie1/te; 
estimate 'Total Proportion via M2' ie2/te; 
estimate 'Proportion via M1 or M2' ie/te; run;
