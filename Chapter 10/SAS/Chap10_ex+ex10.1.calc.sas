/* SAS program to compute quantities in Chapter 5 (text example and 
exercise 5.1: MacKinnon, D. P. (2007) Introduction to Statistical 
Mediation Analysis. Mahwah, NJ: Erlbaum.). The first set of data is
from Exercise 5.1. Other data is from the book example. There are fiver 
different sets of values for the book example,, mreg4 with 4 decimal
places, mreg6 with 6 decimal places, EQS output, LISREL output,
and Mplus output.  So there are two sets of coefficients for the 
expectancy example; one set has four decimal places and the other set
of coefficients uses all 6 decimal places in the SAS output. With
more decimal places c-c' is equal to ab to more than four decimal 
places. Note also that in the output there are some missing data
because covariance between a1 and a2 is not included in SAS or SPSS
output and the c (direct effect) coefficient and mse are not specified
in the EQS, LISREL, and Mplus output.
*/
options ls=80;
Data a;
Input c sc cp scp b1 sb1 b2 sb2 #2 a1 sa1 a2 sa2 mse varx sb1b2 sa1a2 N label $;
*Compute t-values for coefficients;
ta1=a1/sa1;ta2=a2/sa2;tb1=b1/sb1;tb2=b2/sb2;tc=c/sc;tcp=cp/scp;
*Computes mediated effects and variances of coefficients;
a1b1=a1*b1; a2b2=a2*b2; ccp=c-cp;totab=a1b1+a2b2;
vara1=sa1*sa1;vara2=sa2*sa2;varb1=sb1*sb1; varb2=sb2*sb2;
*Equation 5.5;
vara1b1=vara1*b1*b1+varb1*a1*a1;vara2b2=vara2*b2*b2+varb2*a2*a2;
sa1b1=sqrt(vara1b1);sa2b2=sqrt(vara2b2);ta1b1=a1b1/sa1b1;ta2b2=a2b2/sa2b2;
*Equation 5.6;
sa1b1t=(a1b1*sqrt(ta1*ta1+tb1*tb1))/(ta1*tb1);
sa2b2t=(a2b2*sqrt(ta2*ta2+tb2*tb2))/(ta2*tb2);
*Equation 5.7;
Stot57=sqrt(vara1*b1*b1+varb1*a1*a1+vara2*b2*b2+varb2*a2*a2+2*a1*a2*sb1b2);
Stot57b=sqrt(vara1*b1*b1+varb1*a1*a1+vara2*b2*b2+varb2*a2*a2+2*a1*a2*sb1b2+2*b1*b2*sa1a2);
*Equation 5.8;
Stot58=sqrt(vara1b1+vara2b2+2*a1*a2*sb1b2);ttot=totab/stot58;
Stot58b=sqrt(vara1b1+vara2b2+2*a1*a2*sb1b2+2*b1*b2*sa1a2);ttot=totab/stot58b;
/*General formula for standard error of the total mediated that uses
covariances. Most of these covariances are zero with real data. For
the multiple regression analysis in chapter 5, only sb1b2 is
nonzero as in EQuation 5.7 and 5.8;
Stotcov=sqrt(vara1b1+vara2b2+2*a1*a2*sb1b2+2*b1*b2*sa1a2+
2*b1*a1*sa1b1+2*b1*a2*sa1b2+2*a1*b2*sa2b1+2*a2*b2*sb2a2);
ttotcov=totab/stotcov;
*/
*Equation 5.9;
covccp=mse**2/(N*varx);rccp=covccp/(sc*scp);
Stot59c=sqrt(sc*sc+scp*scp-2*covccp);
Stot59r=sqrt(sc*sc+scp*scp-2*rccp*sc*scp); tdiff=(c-cp)/stot59c;
*Equation 5.10;
Stot510=sqrt(vara1*b1*b1+varb1*a1*a1+vara2*b2*b2+varb2*a2*a2-2*a1*a2*sb1b2);
Stot510b=sqrt(vara1*b1*b1+varb1*a1*a1+vara2*b2*b2+varb2*a2*a2-2*a1*a2*sb1b2-2*b1*b2*sa1a2);
*Equation 5.11;
Stot511=sqrt(vara1b1+vara2b2-2*a1*a2*sb1b2);tequal=(a1b1-a2b2)/stot511;
Stot511b=sqrt(vara1b1+vara2b2-2*a1*a2*sb1b2-2*b1*b2*sa1a2);tequalb=(a1b1-a2b2)/stot511b;
/*General formula for standard error of the difference between two 
mediated effects. Most of these covariances are zero with real data.
For the multiple regression analysis in chapter 5, only sb1b2 is
nonzero as in Equations 5.10 and 5.11;
Stotcov=sqrt(vara1b1+vara2b2-2*a1*a2*sb1b2-2*b1*b2*sa1a2+
2*b1*a1*sa1b1-2*b1*a2*sa1b2-2*a1*b2*sa2b1+2*a2*b2*sb2a2);
ttotcov=totab/stotcov;
*/
*Confidence Limits;
lcla1b1=a1b1-1.96*sa1b1;ucla1b1=a1b1+1.96*sa1b1;
lcla2b2=a2b2-1.96*sa2b2;ucla2b2=a2b2+1.96*sa2b2;

*c sc cp scp b1 sb1 b2 sb2 #2 a1 sa1 a2 sa2  mse varx sb1b2 sa1a2 N;
Cards;
-.0014 .0603 .0044 .0635 -.4830 .0647 .3365 .0562 
.3441 .0471 .0542 .0129 10.1913 125.5615 .004 . 300 ex51
.7078 .1734 .1122 .2073 .5690 .1568 .5297 .1696
.8401 .1580 .2219 .1460 8.3879 84.87 .0079 . 40 mreg4
.707760 .17342970 .112152 .20731147 .569029 .15681205 .529720 .16963747 
.840138 .15795758 .221903 .14601522 8.3879 84.87 .0079 . 40 mreg6
. . .112 .199 .5690 .151 .530 .163 
.8401 .156 .222 .144 . 84.87 .0075 -.0068 40 EQS
. . .112 .2018 .5690 .1526 .5297 .1651 
.8401 .1580 .2219 .1460 . 84.87 .0075 -.0068 40 LISREL
. . .112 .197 .5690 .149 .530 .161 
.840 .1540 .222 .1420 . 84.87 .007 -.0068 40 MPLUS
;
Proc print;
*var label sa1b1 sa2b2 ta1b1 ta2b2 ttot;
Run;

