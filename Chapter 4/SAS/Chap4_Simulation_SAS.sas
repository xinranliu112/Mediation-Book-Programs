* The following code conducts a simulation study of the 
single mediator model and computes various estimates 
 presented in Chapter 4 of the book, MacKinnon, D.P. (2007). 
Introduction to Statistical Mediation Analysis, Mahwah, NJ: Erlbaum.
The original version of this program was written in 1987;

TITLE 'SIMULATION OF MEDIATION SIMME';
title 'Chapter 4 Analysis Example- Single Mediator Model Simulation';

OPTIONS PS=59 LS=80 REPLACE NONOTES;

*The following two lines of code stop the SAS log 
from being saved over iterations of the macro program;

FILENAME NULLOG DUMMY 'C:\NULL';
PROC PRINTTO LOG=NULLOG;

*This code defines variables involved in the macro, and
generates the appropriate data based on the single
mediator model regression equations;

*NSIM defines the number of simulation replications desired;
*NOBS defines the number of observations for a replication;
*BMX defines the population a regression coefficient;
*BYX defines the population c prime regression coefficient;
*BYM defines the population b regression coefficient;
*ERROR is the population error standard deviation;

%MACRO SIMULATE(NSIM,NOBS,BMX,BYX,BYM,FILE,TYPE,ERROR);

DATA SUMMARY; SET _NULL_;
%DO I=1 %TO &NSIM;
TITLE 'SIMULATION OF MEDIATION';
DATA SIM;
DO I=1 TO &NOBS;
X=(&error)*RANNOR(0);
M=&BMX*X+(&error)*RANNOR(0);
Y=&BYX*X+&BYM*M+(&error)*RANNOR(0);
X2=X*X;
OUTPUT;
END;

*This code obtains estimates of the mediation regression
equations for the sample generated in the macro program;

*Estimating the (Y=X) regression and saving the value of bm1 or c in the text;
PROC REG OUTEST=FILE COVOUT noprint; MODEL Y=X/;
DATA B; SET FILE;
IF _TYPE_='PARMS'; BM1=X;MSE1=_RMSE_*_RMSE_;
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X Y;
KEEP BM1 MSE1;
DATA C; SET FILE;IF _NAME_='X'; SEBM1=SQRT(X);
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X Y;
KEEP SEBM1;
DATA MODEL1; MERGE B C;

*Estimating the (Y=X M) regression and saving the values of
c prime and b;
PROC REG DATA=SIM OUTEST=FILE COVOUT NOPRINT;
MODEL Y=X M/;
DATA B; SET FILE;
IF _TYPE_='PARMS'; C=X;
BM2=X; MSE2=_RMSE_*_RMSE_;
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X Y M;
KEEP MSE2 BM2 C;
DATA C; SET FILE;
IF _NAME_='X'; SEBM2=SQRT(X); SEC=SQRT(X);
KEEP SEBM2 SEC;
DATA D; SET FILE; IF _NAME_= 'M'; SEB=SQRT(M);
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X Y M;
KEEP SEB;
DATA E; SET FILE; B=M; IF _TYPE_='PARMS';
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X Y M;
KEEP B;
DATA F; SET FILE; IF _NAME_='M'; CBC=X;
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X Y M;
KEEP CBC;
DATA MODEL2; MERGE B C D E F;

*Estimating the (M=X) regression and saving the value of a;
PROC REG DATA=SIM OUTEST=FILE COVOUT NOPRINT;
MODEL M=X;
DATA BB; SET FILE;
IF _TYPE_='PARMS'; M=X;
BM2=X; MSE3=_RMSE_*_RMSE_;
KEEP MSE3;

DATA B; SET FILE; A=X; IF _TYPE_='PARMS';
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X M;
KEEP A;
DATA C; SET FILE; IF _NAME_='X'; SEA=SQRT(X);
DROP _MODEL_ _NAME_ _TYPE_ _DEPVAR_ _RMSE_ INTERCEP X M;
KEEP SEA;
DATA MODEL3; MERGE BB B C;

*This code saves  value of X squared in the sample;
PROC MEANS DATA=SIM SUM NOPRINT; VAR X2;
OUTPUT OUT=OUT SUM=SUMX;

*This code saves the variance of X in the sample;
PROC MEANS DATA=SIM STD NOPRINT; VAR X;
OUPUT OUT=OUTA STD=VARX;
DATA VARS; SET OUTA;
VARXX=VARX*VARX;
KEEP VARXX;

*This code saves the variance of M in the sample;
PROC MEANS DATA=SIM STD NOPRINT; VAR M;
OUPUT OUT=OUTA STD=VARM;
DATA VARSM; SET OUTA;
VARMM=VARM*VARM;
KEEP VARMM;

*This code saves the correlation between X and M in the sample;
PROC CORR DATA=SIM OUTPUT=COV NOPRINT;
DATA FR; SET COV; IF _NAME_='M'; CORRXM=X;
KEEP CORRXM;

*This code merges the different datasets that contain 
estimates from the simulation replication;

DATA ALL; MERGE OUT MODEL1 MODEL2 MODEL3 VARS VARSM FR;
RUN;

*This code calculates the population values for empirical
values estimated in the simulation;
DATA TEST;SET ALL;
TYPE=&TYPE;
ERROR=&ERROR;
DOF=_FREQ_-2;
NOBS=&NOBS;
BMX=&BMX;BYX=&BYX;BYM=&BYM;

*This section computes true variances and covariances as in Section 4.10 based
on residual error variance equal to 1. Note that VX1X1, VX2X2, and VX3X3 are 
the residual variance in equations 3.1, 3.2, and 3.3, respectively; 
EMOD1=(&ERROR)**2;
EMOD2=(&ERROR)**2;
EMOD3=(&ERROR)**2;
VX1X1=EMOD1;
CY1X1=BMX*EMOD1;
CY2X1=BYM*BMX*VX1X1+BYX*EMOD1;
CY1Y1=BMX*BMX*VX1X1+EMOD2;
CY2Y1=BMX*BMX*BYM*VX1X1+BMX*BYX*EMOD1+BYM*EMOD2;
CY2Y2=BYM*BYM*(BMX*BMX*EMOD1+EMOD2)+2*BMX*BYM*BYX*VX1X1+BYX*BYX*EMOD1
+EMOD3;
*This section computes population correlations;
RY1X1=CY1X1/SQRT(VX1X1*CY1Y1);
RY2X1=CY2X1/SQRT(VX1X1*CY2Y2);
RY2Y1=CY2Y1/SQRT(CY1Y1*CY2Y2);
TRUEA=emod2/((NOBS-2)*(VX1X1));
TRUEB=(emod3/(NOBS-3))*(1/CY1Y1/(1-RY1X1*RY1X1));
TRUERAT=(BMX*BYM)/BYX;
TRUEPROP=(BMX*BYM)/((BMX*BYM)+BYX);

*These lines calculate the standard errors as in the computer output and in teh book where
sample values of quantities are put in the Equation;
HCSEAn=sqrt((MSE3)/((NOBS-1)*(VARXX)) );
HCSEcn=sqrt(((MSE2)/(NOBS-1))*(1/VARXX/(1-CORRXM*CORRXM)));
HCSEbn=sqrt(((MSE2)/(NOBS-1))*(1/VARMM/(1-CORRXM*CORRXM)));

*This section computes true or theoretical values as described in Section 4.11. 
Note that true variances of estimates of b and a are based on 
residual error variance in each equation equal to 1 which simplifies 
to 1/N-2 for the standard error of a and 1/N-3 for the standard errors of 
estimated b and c prime for the way the data are simulated with population variance 
of 1. Note that slightly better theoretical standard errors may be obtained using N-3 
and N-4, respectively;
TRUEAB=BMX*BYM;
VMED=CY1Y1;
TVARB=EMOD2/(NOBS-3);TVARB1=EMOD2/(NOBS-1);
tvarb4=emod2/(NOBS-4);STVARB4=SQRT(TVARB4);
TVARB2=EMOD2/((NOBS-3)*CY1Y1*(1-RY1X1**2));
TSEB=SQRT(TVARB);
TSEB2=SQRT(TVARB2);
TSEB1=SQRT(TVARB1);
TVARC=EMOD2/(NOBS-3);TVARC1=EMOD2/(NOBS-1);
TVARC2=EMOD2/((NOBS-3)*VX1X1*(1-RY1X1**2));
TSEC=SQRT(TVARC);
TSEC2=SQRT(TVARC2);
TSEC1=SQRT(TVARC1);
TVARC4=EMOD2/(NOBS-4);STVARC4=SQRT(TVARC4);
TVARA=EMOD3/(NOBS-2);TVAR1=EMOD3/(NOBS-1);
TVARA2=EMOD3/(NOBS-2)*VX1X1/VX1X1;
TVARA3=EMOD3/(NOBS-3);STVARA3=SQRT(TVARA3);
TSEA=SQRT(TVARA);
TSEA2=SQRT(TVARA2);
TSEA1=SQRT(TVAR1);
TRUESAB=SQRT(BMX*BMX*TVARB+BYM*BYM*TVARA+TVARB*TVARA);
*NOTE TRUESAB IS BASED ON EQUATION 3.9;

*The code in this section computes various mediated effect 
and standard error estimates for the sample data; 
*The following code computes standard errors for various
difference in coefficients methods;
DIFFB=BM1-BM2;
COVB1B2=MSE2/SUMX;
RCOVB1B2=MSE2/(VARXX*(NOBS));
R=COVB1B2/(SEBM1*SEBM2);
RR=RCOVB1B2/(SEBM1*SEBM2);
KIM=(SQRT(((SEBM1*SEBM1)+(SEBM2*SEBM2))-2*COVB1B2));
RKIM=(SQRT(((SEBM1*SEBM1)+(SEBM2*SEBM2))-2*RCOVB1B2));
FREED=(SQRT(((SEBM1*SEBM1)+(SEBM2*SEBM2))-2*SQRT(1-CORRXM*CORRXM)*SEBM1*SEBM2));
CLOGG=SEB*ABS(CORRXM);
*RKIM is Equation 3.8;
*The following code computes significance tests for various
difference in coefficients methods;
KIMZ=DIFFB/KIM;
RKIMZ=DIFFB/RKIM;
PKIMZ=1-PROBNORM(KIMZ);
PRKIMZ=1-PROBNORM(RKIMZ);
FREEDZ=DIFFB/FREED;
PFREEDZ=1-PROBNORM(FREEDZ);
CLOGGZ=DIFFB/CLOGG;
PCLOGGZ=1-PROBNORM(CLOGGZ);
*The following code computes standard errors for 
product of coefficients methods;
AB=A*B;
SOBEL=SQRT(A*A*SEB*SEB+B*B*SEA*SEA);
DERIVE=SQRT(B*B*SEA*SEA+A*A*SEB*SEB+SEA*SEA*SEB*SEB);
GDERIV=SQRT(B*B*SEA*SEA+A*A*SEB*SEB-SEA*SEA*SEB*SEB);
*SOBEL IS EQUATION 3.6, DERIVE IS EQUATION 3.9 AND GDERIVE IS EQUATION 3.11;
*The following code computes significance tests
for product of coefficients methods;
ZSOBEL=AB/SOBEL;
PSOBEL=1-PROBNORM(ZSOBEL);
ZDERIVE=AB/DERIVE;
PDERIVE=1-PROBNORM(ZDERIVE);

*The following code computes effect size 
measures for the mediated effect;

*The proportion mediated effect size measure;
PROP=AB/(AB+C);
*Partial derivatives of the proportion mediated;
AP=(B*C)/((C+A*B)*(C+A*B));
BP=(A*C)/((C+A*B)*(C+A*B));
CP=-(A*B)/((C+A*B)*(C+A*B));
CAC=0;CAB=0;
*Multivariate delta standard error for the proportion mediated,EQUATION 4.30;
SEPROPFI=SQRT(AP*AP*SEA*SEA+BP*BP*SEB*SEB+CP*CP*SEC*SEC+2*BP*CP*CBC);

*The ratio of the indirect to the direct effect effect size measure;
RATIO=AB/C;
*Partial derivatives of the indirect to direct effect ratio;
AR=B/C;
BR=A/C;
CR=-1*(A*B)/(C*C);
*Multivariate delta standard error for the indirect to direct effect ratio,EQUATION 4.29;
SERATFI=SQRT(AR*AR*SEA*SEA+BR*BR*SEB*SEB+CR*CR*SEC*SEC+2*BR*CR*CBC);

*The following code computes bias and relative bias for
mediation simulation outcome measures;
BAB=AB-TRUEAB;
B2AB=BAB*BAB;RBAB=BAB/TRUEAB;
BPROP=PROP-TRUEPROP;
B2PROP=BPROP*BPROP; RBPROP=BPROP/TRUEPROP;
BRATIO=RATIO-TRUERAT;
B2RATIO=BRATIO*BRATIO;RBRATIO=BRATIO/TRUERAT;
BSOBEL=(SOBEL-TRUESAB);
MSSOBEL=(SOBEL-TRUESAB)*(SOBEL*TRUESAB);
RBSOBEL=BSOBEL/TRUESAB;
BKIM=(KIM-TRUESAB);
MSKIM=(KIM-TRUESAB)*(KIM*TRUESAB);
RBKIM=BKIM/TRUESAB;
BRKIM=(RKIM-TRUESAB);
MSRKIM=(RKIM-TRUESAB)*(RKIM*TRUESAB);
RBKIM=BRKIM/TRUESAB;
BDERIVE=(DERIVE-TRUESAB);
MSDERIVE=(DERIVE-TRUESAB)*(DERIVE*TRUESAB);
RBDERIVE=BDERIVE/TRUESAB;
BGDERIV=GDERIV-TRUESAB; RBGDERIV=BGDERIV/TRUESAB;
MGDERIVE=BGDERIV*BGDERIV;
*The following code computes two simulation outcome measures (confidence
limits and cases where the true value is outside the confidence limits)
for methods to test mediation;
LSOBEL=AB-1.96*SOBEL; USOBEL=AB+1.96*SOBEL;
LDERIVE=AB-1.96*DERIVE; UDERIVE=AB+1.96*DERIVE;
LKIM=AB-1.96*KIM;    UKIM=AB+1.96*KIM;
LRKIM=AB-1.96*RKIM;    URKIM=AB+1.96*RKIM;
LGDERIV=AB-1.96*GDERIV; UGDERIV=AB+1.96*GDERIV;
LPROPFI=PROP-1.96*SEPROPFI; UPROPFI=PROP+1.96*SEPROPFI;
LRATIFI=RATIO-1.96*SERATFI; URATIFI=RATIO+1.96*SERATFI;
RGSOBEL=0; LFSOBEL=0; RGDERIVE=0;LFDERIVE=0;
RGKIM=0; LFKIM=0; RGPROPFI=0; LFPROPFI=0; RGRATIFI=0; LFRATIFI=0;
RGRKIM=0; LFRKIM=0;
IF TRUEAB GT USOBEL THEN RGSOBEL=1;
IF TRUEAB LT LSOBEL THEN LFSOBEL=1;
IF TRUEAB GT UDERIVE THEN RGDERIVE=1;
IF TRUEAB LT LDERIVE THEN LFDERIVE=1;
IF TRUEAB GT UKIM THEN RGKIM=1;
IF TRUEAB LT LKIM THEN LFKIM=1;
IF TRUEAB GT URKIM THEN RGRKIM=1;
IF TRUEAB LT LRKIM THEN LFRKIM=1;
*The following code appends simulation results across replications;
DATA NEW; SET SUMMARY;
DATA SUMMARY; SET NEW TEST;
*The following DROP statement drops variables that are not used for simulation results;
DROP _TYPE_ _FREQ_ SUMX BM2 SEBM2 DOF CAB CAC CY1X1
 LSOBEL USOBEL LDERIVE UDERIVE
LKIM UKIM LGDERIV UGDERIV LPROPFC UPROPFC LPROPSC UPROPSC LRATIFC URATIFC
LRATISC URATISC
AP BP CP AR BR CR  AP2 BP2 CP2 ABP BCP ACP AR2 BR2 CR2 AG2 BG2 CG2
ABG BCG ACG ABR BCR ACR AG BG CG EG VARP VARR AX BX AX2 BX2 VARRI VARPI;
%END;

*The following code prints results from the simulation after all
specified replications are completed;
PROC MEANS DATA=SUMMARY; run;

PROC MEANS DATA=SUMMARY; VAR NOBS A SEA TSEA TSEA2 STVARA3 TSEA1 HCSEAN 
B SEB TSEB TSEB2 STVARB4 TSEB1 HCSEBN 
C SEC TSEC TSEC2  stvarc4 HCSECN ;

PROC MEANS DATA=SUMMARY; VAR NOBS A B C AB SEA SEB SEC SOBEL DERIVE GDERIV RKIM;

;
RUN;
%MEND;

%SIMULATE(NSIM=200,NOBS=50,BMX=.4,BYX=.2,BYM=.7,
FILE=TEMP,TYPE='CCC',ERROR=1);
%SIMULATE(NSIM=200,NOBS=100,BMX=.4,BYX=.2,BYM=.7,
FILE=TEMP,TYPE='CCC',ERROR=1);
%SIMULATE(NSIM=200,NOBS=200,BMX=.4,BYX=.2,BYM=.7,
FILE=TEMP,TYPE='CCC',ERROR=1);
%SIMULATE(NSIM=200,NOBS=500,BMX=.4,BYX=.2,BYM=.7,
FILE=TEMP,TYPE='CCC',ERROR=1);

RUN;
quit;
