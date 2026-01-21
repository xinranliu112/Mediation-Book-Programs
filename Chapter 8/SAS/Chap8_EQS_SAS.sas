/*Chapter 8 SAS Program to be used in conjuction with
  the Chap8_Bootstrap_EQS.eqs program*/
data a;
infile 'boot.rst';
input
#1
#2 e1 e2 e3 a b cp
#3 see1 see2 see3 sea seb secp;
ab=a*b;
seab=sqrt(a*a*seb*seb+b*b*sea*sea);
t=ab/seab;
;

proc means data=a;

proc univariate normal freq;
var ab;
run;
quit; 
