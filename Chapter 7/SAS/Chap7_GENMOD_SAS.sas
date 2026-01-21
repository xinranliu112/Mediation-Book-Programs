title 'Chapter 7 Analysis Example - Potential Outcomes Model';

* The following program code the SAS program for the memory data to 
estimate potential outcomes and then stack the data prior to regression 
analysis with generalized estimating equations (GENMOD);

data a;
input  id x m r y;
 cards;
1	0	3	9	13
2	0	7	9	11
3	0	2	8	13
4	0	1	9	15
5	0	7	8	19
6	0	4	9	13
7	0	1	8	9
8	0	1	8	9
9	0	5	9	10
10	0	1	9	16
11	0	6	8	9
12	0	2	9	6
13	0	1	9	11
14	0	3	9	12
15	0	7	8	15
16	0	9	6	18
17	0	7	7	10
18	0	5	8	4
19	0	3	8	8
20	0	9	7	18
21	0	6	6	14
22	0	2	9	10
23	0	8	9	15
24	0	9	3	12
25	1	9	1	10
26	1	9	7	15
27	1	7	8	17
28	1	9	5	19
29	1	8	4	16
30	1	9	8	14
31	1	8	6	14
32	1	8	4	16
33	1	6	3	12
34	1	8	4	16
35	1	9	6	18
36	1	9	6	9
37	1	6	5	10
38	1	9	6	19
39	1	9	4	19
40	1	8	7	13
41	1	5	5	10
42	1	9	1	17
43	1	8	3	11
44	1	9	9	17
;

data observed;
set a (keep=id x y);
xstar = x;

data counterfactual;
set a;
xstar=abs(x-1); 
predm=4.54167+3.55833*xstar;
ixstar=xstar*predm;
predy=3.8777+5.88848*xstar+1.32374*predm-.81354*ixstar;
y = predy;

data all;
set observed (keep=id x xstar y) counterfactual (keep=id x xstar y);
xxstar=x*xstar;

proc print data = all;
run;

proc genmod data=all; 
class id; 
model y = x xstar xxstar;
repeated subject=id/type=indep; 
run;
