/*Chapter 12 IML Example*/

options ps=60 ls=130 nocenter;
PROC IML;

***********PROGRAM INDIRECT********** ;
/*TWO MEDIATOR EXAMPLE IN CHAPTER 12;
MACKINNON, D.P. (2007) INTRODUCTION TO STATISTICAL
MEDIATION ANALYSIS, ERLBAUM: MAHWAH, NJ.; DATA ON PAGE 113.
THIS PROGRAM WAS ADAPATED FROM:
MacKinnon, D. P., & Wang, E. (1989). A SAS/IML matrix program to 
estimate indirect effects and their standard errors. 
In SUGI 14: Proceedings of the Statistical Analysis System Conference,
1151-1156.
*/
**** INPUT ****;

*INPUT THE NUMBER OF VARIABLES;

P=1;  IP=I(P);   *p is the number of y variables;                  
Q=1;  IQ=I(Q);   *q is the number of x variables;
M=3;  IM=I(M);   *m is the number of eta or endogenous variables;
N=1;  IN=I(N);   *n is the number of ksi or exogenous variables;

*INPUT PARAMETER MATRICES;

BETA = {0.000 0.000 0.000,
	 	0.000 0.000 0.000,
     	0.5690 0.5297 0.000 };
GAMMA= {0.8401,
        0.2219,
        0.1122}; 
LY = { 1 };


*COVARIANCE MATRIX AMONG THE BETA AND GAMMA ESTIMATES;
COV = {	0.0233     0.0075     0.000000    0.000000    -0.0212,
        0.0075     0.0273     0.000000    0.000000    -0.0123,
        0.000000     0.000000     0.0250    -0.0068    0.000000,
       	0.000000    0.000000    -0.0068     0.0213     0.000000,
       	-0.0212    -0.0123    -0.000000     0.000000     0.0407};

*If the covariance matrix of the estimates is not available, it can;
*by calculated using the standard errors of the parameters and the;
*correlation matrix of the estimates;
/*SE= { 0.1526 0.0000 0.0000 0.0000 0.0000,
		0.0000 0.1651 0.0000 0.0000 0.0000,
		0.0000 0.0000 0.1580 0.0000 0.0000,
		0.0000 0.0000 0.0000 0.1460 0.0000,
		0.0000 0.0000 0.0000 0.0000 0.2018};
CORR= {	1.0000 0.2967 0.0000 0.0000 -0.6894,
		0.2967 1.0000 0.0000 0.0000 -0.3702,
		0.0000 0.0000 1.0000 -0.2967 0.0000,
		0.0000 0.0000 -0.2967 1.0000 0.0000,
		-0.6894 -0.3702 0.0000 0.0000 1.0000};
COV2=SE`*CORR*SE;*/

*INPUT PARTIAL DERIVATIVE
  SELECTION MATRICES;
VB = { 0 0 0 0 0,
       0 0 0 0 0,
       1 0 0 0 0, 
       0 0 0 0 0,
       0 0 0 0 0, 
       0 1 0 0 0,
       0 0 0 0 0, 
       0 0 0 0 0,
       0 0 0 0 0};
      
VG = { 0 0 1 0 0,
       0 0 0 1 0,
       0 0 0 0 1};

VL = { 0 };

PRINT BETA;
PRINT GAMMA;
PRINT COV;
PRINT IM;
PRINT VB;
PRINT VG;

**************************************************************;

**** CALCULATIONS ****;
* SUFFICIENCY TEST FOR STABILITY;
START SUF;
BB = BETA`*BETA;
EVAL=EIGVAL(BB);
INVIB=INV(IM-BETA);
PRINT "STABILITY INDEX: SUFFICIENT CONDITION FOR CONVERGENCE";
PRINT "THE LARGEST EIGENVALUE SHOULD BE LESS THAN ONE"; 
PRINT "SEE BENTLER AND FREEMAN 1983";
PRINT EVAL;
FINISH;

*ETA ON ETA;
START NN;
DNN=VB` * ((INVIB@INVIB`  - (IM@IM)));  *Equation 6.14;
VDNN = DNN`  * COV * DNN;
INN = INV(IM-BETA) - IM - BETA; *Equation 6.10;
SENN = SHAPE (SQRT (vecdiag (VDNN)), M, M) ;
 *OUTPUT;
PRINT "INN PARTIAL DERIVATIVES";
PRINT DNN; 
PRINT "INN MATRIX OF INDIRECT EFFECTS";
PRINT INN;
PRINT "INN MATRIX STANDARD ERRORS";
PRINT SENN;
FINISH;


*ETA ON KSI;
START NE;
INE = INV(IM-BETA) *GAMMA-GAMMA;  *Equation 6.12;
DNE=VB` * ((INVIB * GAMMA)@ INVIB`) +
VG` *(IN@(INVIB-IM)` );  *Equation 6.15;
VDNE = DNE` * COV * DNE;
SENE = SHAPE(SQRT(vecdiag(VDNE)),N,M) ;
 *OUTPUT;
PRINT VDNE;
PRINT "INE PARTIAL DERIVATIVES";
PRINT DNE; 
PRINT "INE MATRIX OF INDIRECT EFFECTS";
PRINT INE;
PRINT "INE MATRIX STANDARD ERRORS";
PRINT SENE;
FINISH;

RUN SUF; RUN NE; RUN NN;
QUIT;
