title 'Kerckhoff Ambition and Attainment';
options ps=80 ls=80;
data a;
input 
b32 sb32 b31 sb31
#2 g12 sg12 g11 sg11 g21 sg21 
#3 sb31b32 sg11g21 rb31b32 rg11g21;
;
/*Effect of intelligence to educational expectations to occupatonal
aspirations;
*/
g21b32=g21*b32;
sg21b32=sqrt(g21*g21*sb32*sb32+b32*b32*sg21*sg21);
tg21b32=g21b32/sg21b32;
zsg21b32=(g21*b32*sqrt((g21/sg21)**2+(b32/sb32)**2))
/((g21/sg21)*(b32/sb32));
lcg21b32=g21b32-1.96*sg21b32;
ucg21b32=g21b32+1.96*sg21b32;
/*Effect of intelligence to grades to occupatonal
aspirations;
*/
g11b31=g11*b31;
sg11b31=sqrt(b31*b31*sg11*sg11+g11*g11*sb31*sb31);
tg11b31=g11b31/sg11b31;
lcg11b31=g11b31-1.96*sg11b31;
ucg11b31=g11b31+1.96*sg11b31;
/* Effect of fathocc on respedu on respocc on respinc;
x1n123=g11*b21*b32;
sx1n123=sqrt(g11*g11*b21*b21*sb32*sb32+g11*g11*sb21*sb21*b32*b32+
sg11*sg11*b21*b21*b32*b32);
tx1n123=x1n123/sx1n123;
*/

* Effect of fathocc on respocc on respinc;
g12b32=g12*b32;
sg12b32=sqrt(b32*b32*sg12*sg12+g12*g12*sb32*sb32);
tg12b32=g12b32/sg12b32;
lcg12b32=g12b32-1.96*sg12b32;
ucg12b32=g12b32+1.96*sg12b32;
/* Effect of fathocc on respedu on respocc;
g11b21=g11*b21;
sg11b21=sqrt(b21*b21*sg11*sg11+g11*g11*sb21*sb21);
tg11b21=g11b21/sg11b21;

* Effect of Fathedu on respeduc on respinc;
g12b31=g12*b31;
sg12b31=sqrt(b31*b31*sg12*sg12+g12*g12*sb31*sb31);
tg12b31=g12b31/sg12b31;

*Effect of fathedu on respedu on respocc on respinc;
x2n123=g12*b21*b32;
sx2n123=sqrt(g12*g12*b21*b21*sb32*sb32+g12*g12*sb21*sb21*b32*b32+
sg12*sg12*b21*b21*b32*b32);
tx2n123=x2n123/sx2n123;

*Effect of fathedu on respedu on respocc;
g12b21=g12*b21;
sg12b21=sqrt(b21*b21*sg12*sg12+g12*g12*sb21*sb21);
tg12b21=g12b21/sg12b21;

*Effect of fathedu on respocc on respinc;
g22b32=g22*b32;
sg22b32=sqrt(b32*b32*sg22*sg22+g22*g22*sb32*sb32);
tg22b32=g22b32/sg22b32;

*Effects of Siblings on respeduc on respinc;
g13b31=g13*b31;
sg13b31=sqrt(b31*b31*sg13*sg13+g13*g13*sb31*sb31);
tg13b31=g13b31/sg13b31;

*Effects of siblings on respedu on respocc on respinc;
x3n123=g13*b21*b32;
sx3n123=sqrt(g13*g13*b21*b21*sb32*sb32+g13*g13*sb21*sb21*b32*b32+
sg13*sg13*b21*b21*b32*b32);
tx3n123=x3n123/sx3n123;

*Effects of siblings on respedu on respocc;
g13b21=g13*b21;
sg13b21=sqrt(b21*b21*sg13*sg13+g13*g13*sb21*sb21);
tg13b21=g13b21/sg13b21;

*Effects of siblings on respocc on respinc;
g23b32=g23*b32;
sg23b32=sqrt(b32*b32*sg23*sg23+g23*g23*sb32*sb32);
tg23b32=g23b32/sg23b32;
*/
*Test equality of two mediated effects;
dp165=g11b31-g21b32;
vdp165=sg11b31**2 + sg21b32**2+2*g11*g21*sb31b32+b31*b32*sg11g21;
vdrp165=sg11b31**2 + sg21b32**2+2*g11*g21*rb31b32*sb31*sb32+
b31*b32*sg11g21;
sdp165=sqrt(vdp165);sdrp165=sqrt(vdrp165);
cb31b32=rb31b32*sb31*sb32;
covdiff=cb31b32-sb31b32;
td165=dp165/sdp165;
/*b32 sb32 b31 sb31
#2 g12 sg12 g11 sg11 g21 sg21
sb31b32 sg11g21 rb31b32 rg11g21sb31b32 sg11g21 rb31b32 rg11g21sb31b32 sg11g21 rb31b32 rg11g21
*/ 
cards;
.549593 .037601 .157912 .036799
-.111779 .026414 .525402 .030646 .160270 .032147
 -.000573 0 -.413983 0 
;
proc print; var g21b32 sg21b32 tg21b32 lcg21b32 ucg21b32; 
proc print; var g11b31 sg11b31 tg11b31 lcg11b31 ucg11b31;
proc print; var g12b32 sg12b32 tg12b32 lcg12b32 ucg12b32;
;
run;
