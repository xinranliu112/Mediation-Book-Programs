/* SAS program to compute quantities in Chapter 5 Exercise 5.3.,
MacKinnon, D. P. (2007) Introduction to Statistical 
Mediation Analysis. Mahwah: NJ: Erlbuam.
*/
Data a;
Input c sc cp scp b1 sb1 b2 sb2 
#2 b3 sb3 b4 sb4 #3 a1 sa1 a2 sa2 a3 sa3 a4 sa4
#4 mse  sb1b2 N;
*Compute t-values for coefficients;
ta1=a1/sa1;ta2=a2/sa2;tb1=b1/sb1;tb2=b2/sb2;tc=c/sc;tcp=cp/scp;
ta3=a3/sa3;ta4=a4/sa4;tb3=b3/sb3;tb4=b4/sb4;
*Computes mediated effects and variances of coefficients;
a1b1=a1*b1; a2b2=a2*b2; a3b3=a3*b3; a4b4=a4*b4; ccp=c-cp;totab=a1b1+a2b2+a3b3+a4b4;
vara1=sa1*sa1;vara2=sa2*sa2;vara3=sa3*sa3;vara4=sa4*sa4;
varb1=sb1*sb1; varb2=sb2*sb2;varb3=sb3*sb3; varb4=sb4*sb4;
*Equation 5.5;
vara1b1=vara1*b1*b1+varb1*a1*a1;vara2b2=vara2*b2*b2+varb2*a2*a2;
vara3b3=vara3*b3*b3+varb3*a3*a3;vara4b4=vara4*b4*b4+varb4*a4*a4;
sa1b1=sqrt(vara1b1);sa2b2=sqrt(vara2b2);ta1b1=a1b1/sa1b1;ta2b2=a2b2/sa2b2;
sa3b3=sqrt(vara3b3);sa4b4=sqrt(vara4b4);ta3b3=a3b3/sa3b3;ta4b4=a4b4/sa4b4;
*Equation 5.6;
sa1b1t=(a1b1*sqrt(ta1*ta1+tb1*tb1))/(ta1*tb1);
sa2b2t=(a2b2*sqrt(ta2*ta2+tb2*tb2))/(ta2*tb2);
sa3b3t=(a3b3*sqrt(ta3*ta3+tb3*tb3))/(ta3*tb3);
sa4b4t=(a4b4*sqrt(ta4*ta4+tb4*tb4))/(ta4*tb4);
*Equation 5.7;
Stot57=sqrt(vara1*b1*b1+varb1*a1*a1+vara2*b2*b2+varb2*a2*a2+2*a1*a2*sb1b2);
*Equation 5.8;
Stot58=sqrt(vara1b1+vara2b2+2*a1*a2*sb1b2);ttot=totab/stot58;
*Equation 5.10;
da1b1a2b2=a1b1-a2b2;
Stot510=sqrt(vara1*b1*b1+varb1*a1*a1+vara2*b2*b2+varb2*a2*a2-2*a1*a2*sb1b2);
*Equation 5.11;
Stot511=sqrt(vara1b1+vara2b2-2*a1*a2*sb1b2);tequal=(a1b1-a2b2)/stot511;
*Confidence Limits;
lcla1b1=a1b1-1.96*sa1b1;ucla1b1=a1b1+1.96*sa1b1;
lcla2b2=a2b2-1.96*sa2b2;ucla2b2=a2b2+1.96*sa2b2;
lcla3b3=a3b3-1.96*sa3b3;ucla3b3=a3b3+1.96*sa3b3;
lcla4b4=a4b4-1.96*sa4b4;ucla4b4=a4b4+1.96*sa4b4;
* c sc cp scp b1 sb1 b2 sb2 #2
b3 sb3 b4 sb4 #3 a1 sa1 a2 sa2 a3 sa3 a4 sa4
#4 mse sb1b2 N;;
Cards;
-.095112 .05284463 -.279107 .05449605 .281868 .05323348 .059703 .05495897
.335794 .05427165 .114041 .05350677
.237149 .04621743 .131117 .04478027 .242897 .04526981 .243409 .04589909
1.03824 .004 400
;
Proc print;
Run;

