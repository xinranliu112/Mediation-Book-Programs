Title "Chapter 12 Path Analysis SAS CAUSALGRAPH Examples";
proc causalgraph;
model "Confounding Covariate" X ==> Y, Z==>X, Z==>Y;
model "Mediating Covariate" X ==> Y, X ==> Z, Z ==>Y;
model "Collider Covariate" X ==> Y, X==> Z, Y ==> Z;
identify X ==> Y;
testid "No Adjustment";
testid "Covariate Adjustment" Z;
run;

proc causalgraph imap list;
model "One Mediator with two Confounders" X ==> Y, X ==> M, M ==>Y,
U1==>X, U1==> M, U2==>M, U2==>Y;
identify X ==> Y;
testid "No Adjustment";
testid "Covariate Adjustment" U1 U2;
run;

proc causalgraph imap list;
model "One Mediator with two Confounders" X ==> Y, X ==> M, M ==>Y,
U1==>X, U1==> M, U2==>M, U2==>Y;
identify X ==> M;
testid "No Adjustment";s
testid "Covariate Adjustment" U1 U2;
run;

proc causalgraph imap list;
model "One Mediator with two Confounders" X ==> Y, X ==> M, M ==>Y,
U1==>X, U1==> M, U2==>M, U2==>Y;
identify M ==> Y;
testid "No Adjustment";
testid "Covariate Adjustment" U1 U2;
run;
