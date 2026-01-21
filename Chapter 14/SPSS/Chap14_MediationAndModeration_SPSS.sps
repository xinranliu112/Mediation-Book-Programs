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

 1    70    4    3
 2    71    4    3
 3    69    1    3
 4    70    1    3
 5    71    3    3
 6    70    4    2
 7    69    3    3
 8    70    5    5
 9    70    4    4
10    72    5    4
11    71    2    2
12    71    3    4
13    70    5    5
14    71    4    5
15    71    4    5
16    70    2    2
17    70    4    4
18    69    3    5
19    72    3    4
20    71    3    3
21    71    2    4
22    72    3    5
23    67    1    2
24    71    4    4
25    71    3    2
26    70    3    4
27    70    2    3
28    69    3    4
29    69    4    3
30    70    3    3
31    71    2    1
32    70    1    3
33    70    2    5
34    70    2    1
35    71    4    3
36    68    2    1
37    72    4    3
38    69    3    2
39    70    3    3
40    68    3    2
41    68    3    3
42    70    4    3
43    71    4    4
44    69    2    2
45    69    3    3
46    71    3    4
47    71    4    4
48    71    3    2
49    72    4    5
50    70    2    2
51    69    2    3
52    70    2    4
53    69    1    2
54    70    3    2
55    69    1    1
56    70    2    3
57    69    4    3
58    70    2    3
59    70    3    2
60    69    3    2
61    69    4    2
62    71    3    5
63    71    4    1
64    71    4    3
65    69    3    4
66    70    2    2
67    70    3    3
68    71    2    2
69    70    3    3
70    71    3    2
71    69    2    4
72    71    5    1
73    69    1    2
74    70    2    1
75    70    3    2
76    71    5    4
77    73    5    3
78    68    1    3
79    70    4    4
80    70    5    4
81    69    4    3
82    70    5    4
83    70    5    5
84    70    2    3
85    71    5    5
86    70    3    5
87    70    4    3
88    69    2    2
89    71    4    4
90    70    5    3
91    70    2    3
92    70    3    4
93    71    4    3
94    69    2    1
95    71    5    4
96    71    3    4
97    71    4    4
98    71    4    5
99    70    3    3
100   71    4    3
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






