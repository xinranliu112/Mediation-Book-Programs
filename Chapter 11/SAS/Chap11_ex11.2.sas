 data a;
 input c sec estimate $;
 LCLn= c - 1.96*(sec);
 UCLn= c + 1.96*(sec);
 LCLb= c - 1.96*(sec);
 UCLb= c + 1.96*(sec);
 lcoef=exp(c);
 lcl=exp(lclb); ucl=exp(uclb);
 cards;
 1.0065 .1918 c
 1.0499 .2287 cp
 1.7373 .2755 b 
 .21488 .07472 a
 ;
 proc print;
 proc print;
 var estimate lcoef lcl ucl;
 proc print;
 var estimate c lcln ucln;
 run;
