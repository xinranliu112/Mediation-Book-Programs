title 'Chapter 12 SES Example specific indirect effects';
options ps=80 ls=80;
data a;
input 
b21 sb21 b31 sb31 b32 sb32
#2 g13 sg13 g23 sg23 g33 sg33 
#3 g11 sg11 g21 sg21 g31 sg31 
#4 g12 sg12 g22 sg22 g32 sg32
#5 sg11g21 sb31b32 rb31b32
;
*Effects of respedu on respocc on respinc;
b21b32=b21*b32;
sb21b32=sqrt(b21*b21*sb32*sb32+b32*b32*sb21*sb21);
tb21b32=b21b32/sb21b32;
zsb21b32=(b21*b32*sqrt((b21/sb21)**2+(b32/sb32)**2))/((b21/sb21)*(b32/sb32));

* Effect of fathocc on respeduc on respinc;
g11b31=g11*b31;
sg11b31=sqrt(b31*b31*sg11*sg11+g11*g11*sb31*sb31);
tg11b31=g11b31/sg11b31;

* Effect of fathocc on respedu on respocc on respinc;
x1n123=g11*b21*b32;
sx1n123=sqrt(g11*g11*b21*b21*sb32*sb32+g11*g11*sb21*sb21*b32*b32+
sg11*sg11*b21*b21*b32*b32);
tx1n123=x1n123/sx1n123;

* Effect of fathocc on respocc on respinc;
g21b32=g21*b32;
sg21b32=sqrt(b32*b32*sg21*sg21+g21*g21*sb32*sb32);
tg21b32=g21b32/sg21b32;

* Effect of fathocc on respedu on respocc;
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
*Test equality of two mediated effects;
dp165=g11b31-g21b32;
vdp165=sg11b31**2 + sg21b32**2+2*g11*g21*sb31b32+b31*b32*sg11g21;
vdrp165=sg11b31**2 + sg21b32**2+2*g11*g21*rb31b32*sb31*sb32+
b31*b32*sg11g21;
sdp165=sqrt(vdp165);sdrp165=sqrt(vdrp165);
cb31b32=rb31b32*sb31*sb32;
covdiff=cb31b32-sb31b32;
td165=dp165/sdp165;

cards;
4.3767 .1203 .1998 .0364 .0704 .0045
-.2281 .0176 -.4631 .1232 -.0373 .0314
.0385 .0025 .1352 .0175 .0114 .0045
.1707 .0156 .0490 .1082 .0712 .0275
0 -.0001 -.5404

;
;
proc print;
var 
g11b21 sg11b21 tg11b21
g21b32 sg21b32 tg21b32
g11b31 sg11b31 tg11b31
x1n123 sx1n123 tx1n123
g12b21 sg12b21 tg12b21
g22b32 sg22b32 tg22b32
g12b31 sg12b31 tg12b31
x2n123 sx2n123 tx2n123
g13b21 sg13b21 tg13b21
g13b31 sg13b31 tg13b31
g23b32 sg23b32 tg23b32
x3n123 sx3n123 tx3n123
b21b32 sb21b32 tb21b32
;
run;
