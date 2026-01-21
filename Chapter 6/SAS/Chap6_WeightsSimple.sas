/*Two group examples of Horovitz and Thompson (1952) weighting;*/
data al;
input p1 n1 p2 n2;
nn=n1+n2;
prop1=n1/NN;prop2=n2/NN;
weight1 = 1/prop1; weight2 = 1/prop2;
value1=p1/weight1; value2=p2/weight2;
popprop=value1 + value2;
cards;
.4 20 .6 180
.1 20 .2 180
.4 20  .6 180
.01 20  .002 180
.8 20  .6 180
.91 20  .2 180
.94 20  .2 180
.901 20  .002 180
.4 202 .6 180
.1 203  .2 1800
.4 201 .6 1800
.01 20 .002 180
.8 20000 .6 180
.91 2032  .2 180
.94 2022  .2 180
.901 203  .002 180
;

