libname classdat '/folders/myfolders/EPI5143';

/***checking the contents of dataset NhrAbstracts***/
proc contents data=classdat.NhrAbstracts;
run;

/***keep only those admissions in 2003 and 2004***/
data Quiz5;
set classdat.NhrAbstracts;
where year(datepart(hraadmdtm)) = 2003 or year(datepart(hraadmdtm)) = 2004;
run;

/***Flat-filing Nhrdiagnosis dataset***/
data diabetes;
set classdat.nhrdiagnosis;
by hdghraencwid;
if first.hdghraencwid=1 then do;
diabetes=0; count=0; end;
if hdgcd in: ('250' 'E10' 'E11') then do;
diabetes=1;count=count+1; end;
if last.hdghraencwid=1 then output;
retain diabetes count; 
run;

proc freq data=diabetes;
tables diabetes count;
run;

/***merging two datasets***/
proc sort data=Quiz5;
by hraencwid;
run;

proc sort data=diabetes out=diabetes2 (rename=hdghraencwid=hraencwid);
by hdghraencwid;
run;

data final;
merge Quiz5 (in=a) diabetes2;
by hraencwid;
if a;
if diabetes=. then diabetes=0;
if count =. then count =0;
run;

/***getting proportions***/
proc freq data=final;
Tables diabetes count;
run;

/***ANSWER: 83/2230 or 3.72%***/

/***second approach using means***/
data diabetesmean;
set classdat.nhrdiagnosis;
diabetes=0;
if hdgcd in: ('250' 'E10' 'E11') then diabetes=1;
run;

proc means data=diabetesmean noprint;
class hdghraencwid;
types hdghraencwid;
var diabetes;
output out=diabetes3 max(diabetes)=diabetes n(diabetes)=count;
run;

proc freq data=diabetes3;
tables diabetes count;
run;

/***merge datasets using mean approach***/
proc sort data=Quiz5;
by hraencwid;
run;

proc sort data=diabetes3 out=diabetes4 (rename=hdghraencwid=hraencwid);
by hdghraencwid;
run;

data final2;
merge Quiz5 (in=a) diabetes4;
by hraencwid;
if a;
if diabetes=. then diabetes=0;
if count =. then count =0;
run;

proc freq data=final2;
Tables diabetes;
run;

/***ANSWER: 83/2230 or 3.72%***/

