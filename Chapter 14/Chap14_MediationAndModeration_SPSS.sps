* Encoding: UTF-8.
title 'Chapter 14 Analysis Example: Mediated-Moderation'.

* This program reads in a dataset appropriate for the mediation and moderation
* example presented in Chapter 14, using the dataset presented in Chapter 3.
* NOTE: subject fitness level acts as a moderating variable in this example, 
* where fit=1 and normal=0. The first 50 observations are normal, and the latter
* 50 are fit.

data list free
/fit x m y.
begin data
1	69	2	3
2	70	2	4
3	69	1	2
4	70	3	2
5	69	1	1
6	70	2	3
7	69	4	3
8	70	2	3
9	70	3	2
10	69	3	2
11	69	4	2
12	71	3	5
13	71	4	1
14	71	4	3
15	69	3	4
16	70	2	2
17	70	3	3
18	71	2	2
19	70	3	3
20	71	3	2
21	69	2	4
22	71	5	1
23	69	1	2
24	70	2	1
25	70	3	2
26	71	5	4
27	73	5	3
28	68	1	3
29	70	4	4
30	70	5	4
31	69	4	3
32	70	5	4
33	70	5	5
34	70	2	3
35	71	5	5
36	70	3	5
37	70	4	3
38	69	2	2
39	71	4	4
40	70	5	3
41	70	2	3
42	70	3	4
43	71	4	3
44	69	2	1
45	71	5	4
46	71	3	4
47	71	4	4
48	71	4	5
49	70	3	3
50	71	4	3
end data.

recode fit (1 thru 50=0)(51 thru 100=1).
execute.


regression
 /dependent=m
 /enter=x.
 execute.

* The following sections provide the steps involved in two methods for
   testing the presence of moderation in single mediator models.

* Computing means for the overall sample and computing means by subgroup.

means
tables=x m y by fit.

* Running the overall mediation equations for the entire sample.

regression
/statistics coeff zpp
/dependent y
/enter x.

regression
/statistics coeff zpp
/dependent y
/enter x m.

regression
/statistics coeff zpp
/dependent m
/enter x.


* NOTE: The following regression equations correspond to Method 1
	 for testing for the presence of moderation in a mediation 
	 design. This method compares the equivalence of regression 
	 coefficients across groups to test for moderation.

* Running the mediation equations separately for each group.

regression
/select=fit eq 0
/statistics coeff zpp
/dependent y
/enter x.

regression
/select=fit eq 0
/statistics coeff zpp
/dependent y
/enter x m.

regression
/select=fit eq 0
/statistics coeff zpp
/dependent m
/enter x.

regression
/select=fit eq 1
/statistics coeff zpp
/dependent y
/enter x.

regression
/select=fit eq 1
/statistics coeff zpp
/dependent y
/enter x m.

regression
/select=fit eq 1
/statistics coeff zpp
/dependent m
/enter x.

* NOTE: The following regression equations correspond to Method 2
	 for testing the presence of moderation in a
	 mediation design, where moderation is tested by determining
	 the statistical significance of the interaction term in a
	 single overall regression for the sample. 

* Centering predictor variables and creating interaction terms.

compute cx=x-70.13.
compute cm=m-3.13.
recode fit (0=-1) (1=1) into mod.
compute xmod=x*mod.
compute cmmod=cm*mod.
compute cxmod=cx*mod.
compute mmod=m*mod.
execute.

* Running the mediation regression equations for Method 2 of testing
  moderation in a mediation design (overall regression with interaction terms).

regression
/statistics coeff zpp
/dependent y
/enter x mod xmod.

regression
/statistics coeff zpp
/dependent y
/enter x m mod xmod mmod.

regression
/statistics coeff zpp
/dependent m
/enter x mod xmod.






