data a; input rxm rxy rmy nobs;
/*revised program from Appendix B, MacKinnon et al., 2002 Psychological Methods, 7, 83-104;
*note r corresponds to correlation;
*x, m, and y represent the independent, mediating, and dependent variables, respectively;
*variance of the correlations from Olkin & Siotani 1976 and Olkin & Finn (1995);*/
vrxy=((1-rxy*rxy)*(1-rxy*rxy))/nobs;
vrmy=((1-rmy*rmy)*(1-rmy*rmy))/nobs;
vrxm=((1-rxm*rxm)*(1-rxm*rxm))/nobs;

*covariances among the correlations from Olkin & Siotani 1976 and Olkin & Finn (1995)t;
crxyrmy=(.5*(2*rxm-rxy*rmy)*(1-rxm*rxm-rxy*rxy-rmy*rmy)+rxm*rxm*rxm)/nobs;
crxyrxm=(.5*(2*rmy-rxy*rxm)*(1-rxy*rxy-rmy*rmy-rxm*rxm)+rmy*rmy*rmy)/nobs;
crmyrxm=(.5*(2*rxy-rmy*rxm)*(1-rxm*rxm-rxy*rxy-rmy*rmy)+rxy*rxy*rxy)/nobs;

*olkin and finn (1995);
*partial correlation or correlation with mediating variable removed;
rxyi=(rxy-rmy*rxm)/sqrt((1-rmy*rmy)*(1-rxm*rxm));

*difference between simple and partial correlations;
diff=rxy-rxyi;

*partial derivatives of the difference between simple and partial correlations;
opd1=1-(1/(sqrt(1-rmy*rmy)*sqrt(1-rxm*rxm)));
opd2=(rxm-rxy*rmy)/((sqrt(1-rxm*rxm))*(1-rmy*rmy)**(1.5));
opd3=(rmy-rxm*rxy)/((sqrt(1-rmy*rmy))*(1-rxm*rxm)**(1.5));
			
ovar=opd1*opd1*vrxy+opd2*opd1*crxyrmy+opd3*opd1*crxyrxm+opd1*opd2*crxyrmy
   +opd2*opd2*vrmy+opd2*opd3*crmyrxm+opd1*opd3*crxyrxm+opd2*opd3*crmyrxm
   +opd3*opd3*vrxm;
ose=sqrt(ovar);
zolkin=diff/ose;
polkin=1-probnorm(zolkin);

*bobko & rieck (1980) product of standardized a and b;
bobko=rxm*(rmy-rxy*rxm)/(1-rxm**2);

*partial derivatives for product of standardized a and b;
bpd1=((rxm*rxm*rmy+rmy-2*rxm*rxy)/(1-rxm*rxm)**2);
bpd2=(-(rxm*rxm)/(1-rxm*rxm));
bpd3=(rxm/(1-rxm*rxm));

bobkovar=((bpd1**2)*vrxm)+((bpd2**2)*vrxy)+((bpd3**2)*vrmy)+
  (2*bpd1*bpd2*crxyrxm)+
  (2*bpd2*bpd3*crxyrmy)+(2*bpd1*bpd3*crmyrxm);
bobkose=sqrt(bobkovar);
zbobko=bobko/bobkose;
pbobko=1-probnorm(zbobko);
cards;
.371 .361 .490  50
;
proc print;
var diff ose zolkin polkin bobko bobkose zbobko pbobko;
run;
