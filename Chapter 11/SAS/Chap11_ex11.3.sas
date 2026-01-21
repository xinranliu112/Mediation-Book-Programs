Title "Program for Exercise 11.3";
/*Note the data use frequency input so that the values
for x, m, and y are given along with the frequency of persons
with that pattern for x, m, and y;
*/
data pancreas;
 input x m y freq;
 cards;
 0 1 1 26
 1 1 1 1
 2 1 1 1
 3 1 1 2
 0 2 1 12
 1 2 1 1
 2 2 1 3
 3 2 1 3
 0 3 1 4
 1 3 1 2
 2 3 1 5
 3 3 1 5
 0 4 1 1
 1 4 1 8
 2 4 1 10
 3 4 1 12
 0 1 0 42
 1 1 0 8
 2 1 0 12
 3 1 0 9
 0 2 0 25
 1 2 0 3
 2 2 0 4
 3 2 0 4
 0 3 0 8
 1 3 0 2
 2 3 0 2
 3 3 0 1
 0 4 0 10
 1 4 0 1
 2 4 0 1
 3 4 0 6
 ;
proc reg data=pancreas; weight freq;
model m=x/scorr1;
Proc logistic data=pancreas descending covout;
weight freq;
MODEL y=x ;
Proc logistic data=pancreas descending covout;
weight freq;
MODEL y=x m ;
run;
