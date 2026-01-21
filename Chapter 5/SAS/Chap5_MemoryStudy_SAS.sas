title 'Chapter 5 Analysis Example- XM Interaction';

* The following program code reads in the dataset for the imagery 
  and memory for words study example in Chapter 5;

* Six variables are defined: (a) subject ID#, (b) X = intervention 
  (primary rehearsal = 0, secondary rehearsal = 1), (c) M = imagery, 
  (d) R = repetition, (e) Y = total word recall out of 20 words, and 
  (f) XM = X*M;

data a;
input id x m r y xm;
cards;
1	0	3	9	13	0
2	0	7	9	11	0
3	0	2	8	13	0
4	0	1	9	15	0
5	0	7	8	19	0
6	0	4	9	13	0
7	0	1	8	9	0
8	0	1	8	9	0
9	0	5	9	10	0
10	0	1	9	16	0
11	0	6	8	9	0
12	0	2	9	6	0
13	0	1	9	11	0
14	0	3	9	12	0
15	0	7	8	15	0
16	0	9	6	18	0
17	0	7	7	10	0
18	0	5	8	4	0
19	0	3	8	8	0
20	0	9	7	18	0
21	0	6	6	14	0
22	0	2	9	10	0
23	0	8	9	15	0
24	0	9	3	12	0
25	1	9	1	10	9
26	1	9	7	15	9
27	1	7	8	17	7
28	1	9	5	19	9
29	1	8	4	16	8
30	1	9	8	14	9
31	1	8	6	14	8
32	1	8	4	16	8
33	1	6	3	12	6
34	1	8	4	16	8
35	1	9	6	18	9
36	1	9	6	9	9
37	1	6	5	10	6
38	1	9	6	19	9
39	1	9	4	19	9
40	1	8	7	13	8
41	1	5	5	10	5
42	1	9	1	17	9
43	1	8	3	11	8
44	1	9	9	17	9
;

* The following commands run the code for the output in Table 5.3 
  Regression of Y on X (c is the same for both ways of coding of X);

* Regress the outcome variable on the IV. That is, regress
  total word recall on intervention.;
proc reg; 
model y=x;


* The following commands run the code for the output in Table 5.4 
  Regression of M on X (a is the same for both ways of coding X);

* Regress the mediator on the IV. That is, regress imagery
  on intervention.;
proc reg; 
model m=x;


* The following commands run the code for the output in Table 5.5
  Regression of Y on X, M, and XM with X set to 0 for the repetition/control group;

* Regress the outcome variable on the IV, the mediator, and
  the XM interaction. That is, regress total word recall on 
  intervention, imagery, and the interaction between intervention
  and imagery.;

* Regression of Y on X, M, and XM with X set to 0 for the repetition/control group;
proc reg; 
model y=x m xm;


* The following commands run the code for the output in Table 5.6
  Regression of Y on X, M, and XM with X set to 1 for the repetition/control group;
data a;
set a;
xnew = x-1; *set to -1 for the repetition/control group and 0 for the imagery/treatment group;
xnewm = xnew*m;
proc reg; 
model y=xnew m xnewm;


* The following commands run the code in Table 5.7 Direct Effect in the Control group;
data a;
set a;
mnewcontrol = m-4.5417; *m is set to mean-centered m for control group which was 4.5417;
xmnewcontrol = x*mnewcontrol; *the direct effects require centering at the value m for levels of x;
proc reg; 
model y = x mnewcontrol xmnewcontrol;


* The following commands run the code in Table 5.8 Direct Effect in the Treatment group;
data a;
set a;
mnewtreat = m-8.10; *m is set to mean-centered m for treatment group which was 8.10;
xmnewtreat = x*mnewtreat; *the direct effects require centering at the value m for levels of x; 
proc reg; 
model y = x mnewtreat xmnewtreat;
run;
quit;
