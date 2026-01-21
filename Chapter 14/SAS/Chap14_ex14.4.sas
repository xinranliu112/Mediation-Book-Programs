title 'Chapter 10 Analysis Example: Mediated-Moderation';

* This program reads in a dataset appropriate for the mediation and moderation
  example presented in Chapter 10;
* Note that this example uses the dataset presented in Chapter 3,;
* NOTE: subject fitness level acts as a moderating variable in this example;

* Creating a single mediator dataset with normal and fit groups;
data a;
input  id x m y;
fit=1;
record=0;
if _N_ <51 then fit=0;
if _N_ <26 then record=1;
if _N_ >50 then record=1;
if _N_ >75 then record=0;
recordc=1; fitc=1;
if fit=0 then fitc=-1;
if record=0 then recordc=-1;
fitrec=fitc*recordc;
group=record*10+fit;
cards;
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
          					   	1    69    2    3
                               	2    70    2    4
                               	3    69    1    2
                               	4    70    3    2
                                5    69    1    1
                                6    70    2    3
                                7    69    4    3
                                8    70    2    3
                                9    70    3    2
                               10    69    3    2
                               11    69    4    2
                               12    71    3    5
                               13    71    4    1
                               14    71    4    3
                               15    69    3    4
                               16    70    2    2
                               17    70    3    3
                               18    71    2    2
                               19    70    3    3
                               20    71    3    2
                               21    69    2    4
                               22    71    5    1
                               23    69    1    2
                               24    70    2    1
                               25    70    3    2
                               26    71    5    4
                               27    73    5    3
                               28    68    1    3
                               29    70    4    4
                               30    70    5    4
                               31    69    4    3
                               32    70    5    4
                               33    70    5    5
                               34    70    2    3
                               35    71    5    5
                               36    70    3    5
                               37    70    4    3
                               38    69    2    2
                               39    71    4    4
                               40    70    5    3
                               41    70    2    3
                               42    70    3    4
                               43    71    4    3
                               44    69    2    1
                               45    71    5    4
                               46    71    3    4
                               47    71    4    4
                               48    71    4    5
                               49    70    3    3
                               50    71    4    3
;
* THE FOLLOWING SECTIONS PROVIDE THE STEPS INVOLVED
  IN TWO METHODS FOR TESTING THE PRESENCE OF MODERATION 
  IN SINGLE MEDIATOR MODELS;
proc print;
proc sort; by record; by fit;
* Computing means for the overall sample and computing means by subgroup;
	proc glm; class record fit; model M = record fit record*fit;means record fit record*fit;
	proc glm; class record fit; model Y = record fit record*fit;means record fit record*fit;
	
*Running the overall mediation equations for the entire sample;
	proc reg;
		model y=x fitc recordc fitrec/pcorr1 pcorr2;
		model y= x m fitc recordc fitrec/pcorr1 pcorr2;
		model m=x fitc recordc fitrec/pcorr1 pcorr2;

* NOTE: The following regression equations correspond to Method 1
		for testing for the presence of moderation in a mediation 
		design. This method compares the equivalence of regression 
		coefficients across groups to test for moderation;
* Running the mediation equations separately for each group;
	proc sort; by group;
	proc reg; by group;
		model y=x/pcorr1 pcorr2;
		model y= x m/pcorr1 pcorr2;
		model m=x/pcorr1 pcorr2;
		proc reg; by record;
		model y=x/pcorr1 pcorr2;
		model y= x m/pcorr1 pcorr2;
		model m=x/pcorr1 pcorr2;

* NOTE: The following regression equations correspond to Method 2
		for testing the presence of moderation in a
		mediation design, where moderation is tested by determining
		the statistical significance of the interaction term in a
		single overall regression for the sample; 

* Centering predictor variables and creating interaction terms;
data all;
set a;
cx=x-70.13;
cm=m-3.13;
if fit=0 then mod1=-1;
if fit=1 then mod1=1;
xmod1=x*mod1;
cmmod1=cm*mod1;
cxmod1=cx*mod1;
mmod1=m*mod1;
if record=0 then mod2=-1;
if record=1 then mod2=1;
xmod2=cx*mod2;
cmmod2=cm*mod2;
cxmod2=cx*mod2;
mmod2=cm*mod2;
mod12=mod1*mod2;
mmod12=cm*mod1*mod2;
xmod12=cx*mod1*mod2;
xmmod12=cx*cm*mod1*mod2;
proc means data=all;

* Running the mediation regression equations for Method 2 of testing
  moderation in a mediation design (overall regression with interaction terms);
proc reg;

	model y=cx cm mod1 xmod1 mmod1 mod2 xmod2 mmod2 mmod12 xmod12 mod12 /pcorr1 pcorr2;
	model m=cx mod1 xmod1 mmod1 mod2 xmod2 mmod2 mmod12 xmod12 mod12 /pcorr1 pcorr2;

run;
run; 
		
