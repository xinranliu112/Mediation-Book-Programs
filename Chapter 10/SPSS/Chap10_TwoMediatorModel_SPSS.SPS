* Encoding: UTF-8.
* This program reads in the dataset for the two mediator model in Chapter 10.

* Five variables are defined: (a) subject #, (b) teacher expectancy, i.e., X,
* (c) social climate, i.e., M1, (d) input, i.e., M2, and (e) test score at the 
* end of the semester, i.e., Y.

data  list free
   / s x m1 m2 y.
begin data
    1    51     41      54     59
    2    40     34      51     60
    3    55     42      53     60
    4    35     22      56     61
    5    47     34      45     47
    6    58     52      79     84
    7    56     57      55     69
    8    53     49      55     85
    9    38     42      46     75
  10    73     80      48     87
  11    57     42      65     85
  12    54     62      55     73
  13    68     54      55     77
  14    46     41      62     50
  15    48     44      43     58
  16    56     54      54     69
  17    67     73      61     99
  18    47     61      38     64
  19    60     59      42     65
  20    54     51      55     68
  21    53     69      44     84
  22    53     67      40     82
  23    40     49      45     74
  24    34     40      37     62
  25    32     40      49     54
  26    56     60      51     81
  27    55     46      65     89
  28    51     58      54     83
  29    50     53      56     75
  30    45     61      52     72
  31    63     42      40     63
  32    46     39      51     69
  33    60     62      53     66
  34    48     41      56     72
  35    46     40      46     68
  36    50     51      52     73
  37    49     51      55     69
  38    35     39      46     46
  39    50     44      46     70
  40    47     40      68     76
end data.

* The following commands run the four mediation regression equations
* outlined in Chapter 5 for the teacher expectancies two-mediator 
* model example.

* Note that running each regression equation in a separate step may yield
* slightly different N's for each equation. As indicated in the chapter,
* the researcher is advised to remove cases that do not have measures
* of all four variables prior to estimating the regression model to minimize
* this discrepancy.

* STEP 1:
	* Regress the outcome variable on the IV. That is, regress end of the
	* semester test score on teacher's expectancies.

regression
 /variables=x y m1 m2
 /dependent=y
 /enter=x.

* STEP 2:
	* Regress the outcome variable on the IV and all of the mediators.
	* That is, regress end of the semester test score on social
	* climate, M1, and input, M2. Note that the "bcov" option provides
	* the covariance of the regression coefficients relating each mediator
	* to the outcome variable. This estimate is needed for computing
	* standard errors for the model.

regression
 /variables=x y m1 m2
 /statistics=defaults bcov
 /dependent=y
 /enter= x m1 m2.

* STEP 3:
	* Regress the first mediator on the outcome. That is, regress end of
	* the semester test score on social climate.

regression
 /variables=x y m1
 /dependent=m1
 /enter=x.

* STEP 4:
	* Regress the second mediator on the outcome. That is, regress end 
	* of the semester test score on input.

regression
 /variables=x y m2
 /dependent=m2
 /enter=x.

