libname classdat '/folders/myfolders/EPI5143';

/***checking the contents of dataset NhrAbstracts***/
proc contents data=classdat.Nencounter;
run;

/***keep those encounters that started in 2003***/
data Quiz6;
set classdat.Nencounter;
where year(datepart(encStartDtm)) = 2003;
run;

/***Q1***/
proc sort data=Quiz6;
by EncPatWID;
run;

data Q1;
set Quiz6;
by EncPatWID;
if first.EncPatWID=1 then do;
inpatient=0; count=0; end;
if EncVisitTypeCd = "INPT" then do;
inpatient=1;count=count+1; end;
if last.EncPatWID=1 then output;
retain inpatient count;
run;

proc freq data=Q1;
tables inpatient count;
run;

/***ANSWER: 1074/2891 = 37.15%***/

/***Q2***/

data Q2;
set Quiz6;
by EncPatWID;
if first.EncPatWID=1 then do;
emergency=0; counte=0; end;
if EncVisitTypeCd = "EMERG" then do;
emergency=1;counte=counte+1; end;
if last.EncPatWID=1 then output;
retain emergency counte;
run;

proc freq data=Q2;
tables emergency counte;
run;

/***ANSWER: 1978/2891 = 68.42%***/

/***Q3***/
data Q3;
set Quiz6;
by EncPatWID;
if first.EncPatWID=1 then do;
both=0; countb=0; end;
if EncVisitTypeCd in ('INPT' 'EMERG') then do;
both=1;countb=countb+1; end;
if last.EncPatWID=1 then output;
retain both countb;
run;

proc freq data=Q3;
tables both countb;
run;

/***ANSWER: 2891/2891 = 100%***/

/***Q4 to confirm freqency table results for variable countb in previous question***/
/***make sure there is no missing value for encounter type in my dataset***/
proc freq data=Quiz6;
tables EncVisitTypeCd;
run;

/***there is no missing value which means every patient should have at least one encounter type that was inpatient or emergency***/
/***merge dataset from Q1 and Q2***/
proc sort data=Q1;
by EncPatWID;
run;

proc sort data=Q2;
by EncPatWID;
run;

/***make new variable to count total encounters***/
data Q4;
merge Q1 Q2;
by EncPatWID;
countt=count + counte;
run;

options formchar="|----|+|---+=|-/\<>*";
proc freq data=Q4;
tables countt;
run;

/***ANSWER: I got the same answer as the frequency table in Q3 for the variable countb***/
/***I am using SAS University and there is no non-HTML option to display the output as the SAS program***/
countt	Frequency	Percent	Cumulative
Frequency	Cumulative
Percent
1	2556	88.41	2556	88.41
2	270	9.34	2826	97.75
3	45	1.56	2871	99.31
4	14	0.48	2885	99.79
5	3	0.10	2888	99.90
6	1	0.03	2889	99.93
7	1	0.03	2890	99.97
12	1	0.03	2891	100.00





