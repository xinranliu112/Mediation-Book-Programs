title "Chapter 7 - Memory study data with M Continuous for RMPW Analysis";

data a;
input  id x m r y;
weight=1; xstar=x; xst=x;
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

*This code makes weights for treatment participants;
data dup10; set a;  if x=1; xstar=0; xst=x;
mm0=4.541666667;mm1=8.1;sd0=2.277; sd1= 2.277;
weight =sd1/sd0*exp(((m-mm1)**2)/(2*sd1**2) - ((m-mm0)**2)/(2*sd0**2)); 

*This section makes weights for control participants;
data dup01; set a; IF x=0; xstar=1; xst=x;
mm0=4.541666667;mm1=8.1;sd0=2.277; sd1= 2.277;
weight =sd0/sd1*exp(((m-mm0)**2)/(2*sd0**2) - ((m-mm1)**2)/(2*sd1**2));

*The next line combines all datasets;
data allin; set a dup10 dup01;
xxstar=xst*xstar;

*The next line prints out the new data set with weights for counterfactual conditions;
proc print data=allin; var weight x m y xst xstar xxstar ;run;
/*estimate for the intercept is the mean in the control group,  xst is the pure direct effect, xstar is the pure indirect effect and xxstar is the mediated interaction.*/

proc genmod data=allin;
 class id;
 model y=xst xstar xxstar/; 
 weight weight;
 repeated subject=id/ type=indep;
 run;
