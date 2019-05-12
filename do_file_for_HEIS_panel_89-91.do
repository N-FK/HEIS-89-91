*-----------------------------------------*
* Impact of sanctions on FLFP in Iran
* .do file for HEIS panel 89-91.do
* 
* Maastricht Graduate School of Governance
* UNU-MERIT
*-----------------------------------------*


set more off

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<START

*Fresh dataset: use "dataset 2 updated.dta" from:
use ""
*<<<<<<<<<<<<<<<<<<<<<<<<<<<< PART ONE <<<<<<<<<<<<<<<<<<FIX DATA, ADD VARIABLES

*merging files brought back individuals who were previously dropped because /
*of inconsistencies along the years in age and sex*
*drop them using a variable which is only in the master file:*
drop if HHID == ""

*drop redundant variables that I created before merging:
drop DWHHID DWmembID DWyear DWur DWsanctions SEHHID SEmembID SEyear SEur SEsanctions CHHID CmembID Cyear Cur Csanctions

*generate dummy var to reflect different occupational statuses (for everyone)
tabulate occupstatus, generate(os)

*generate dummy var to reflect different DW sectors (for everyone)
tab DWsector, gen(sector)
rename sector1 DWpublicsector
lab var DWpublicsector "DW public sector"
rename sector2 DWcoopsector 
lab var DWcoopsector  "DW cooperative sector"
rename sector3 DWprivatesector
lab var DWprivatesector "DW private sector"

*isolate women working in private, public or cooperative sectors
tab DWpublicsector if sex==2
gen DWpublicsectorF = DWpublicsector if sex==2
lab var DWpublicsectorF "DW public sector female"
gen DWcoopsectorF = DWcoopsector if sex==2
lab var DWcoopsectorF "DW cooperative sector female"
gen DWprivatesectorF = DWprivatesector if sex==2
lab var DWprivatesectorF "DW private sector female"

*gen age2
gen age2=age*age

*destring degreecode
destring degreecode, replace ignore("-")

*create educational levels using var "degreecode":

*pre-primary is the max level of education:
gen preprimary=1 if inrange(degreecode,0,99)
replace preprimary = 0 if preprimary == .
*primary is the max level of education:
gen primary=1 if inrange(degreecode,100,199)
replace primary = 0 if primary == .
*lower-secondary is the max level of education:
gen lowsecondary=1 if inrange(degreecode,200,299)
replace lowsecondary = 0 if lowsecondary == .
*upper-secondary is the max level of education:
gen uppersecondary=1 if inrange(degreecode,300,399)
replace uppersecondary = 0 if uppersecondary == .
*first-stage of tertiary ed is the max level of education:
gen lowtertiary=1 if inrange(degreecode,500,599)
replace lowtertiary = 0 if lowtertiary == .
*second-stage of tertiary ed is the max level of education:
gen uppertertiary=1 if inrange(degreecode,600,699)
replace uppertertiary = 0 if uppertertiary == .
*other educational attainments are the max level of education:
gen othered=1 if inrange(degreecode,900,999)
replace othered = 0 if othered == .

*single out agricultural workers (men and women)
gen SEagriworkers=SEsector 
replace SEagriworkers = 0 if SEagriworkers==2
lab var SEagriworkers "SE agricultural workers"

*single out agricultural workers (women)
gen SEFagriworkers=SEagriworkers if sex==2
lab var SEFagriworker "SE female agriworkers"

*single out hpd (agricultural workers):
gen hpdSEagriW = SEhpd if SEsector==1
lab var hpdSEagriW "hpd agric workers"

*single out female work:
gen occupstatusfemale=occupstatus if sex==2
lab var occupstatusfemale "occupational status (women)"
*generate employment categories for women only:
tabulate occupstatusfemale, generate(osF)
lab var osF1 "employed women"
lab var osF2 "unemployed women"
lab var osF3 "rentier women"
lab var osF4 "studying women"
lab var osF5 "housekeeper women"
lab var osF6 "other"

*single out male work:
gen occupstatusmale=occupstatus if sex==1
lab var occupstatusmale "occupational status (men)"
gen employedmen=1 if occupstatusmale == 1
replace employedmen=0 if inrange(occupstatusmale,2,6)
gen RosM1 = employedmen if ur==2
lab var RosM1 "rural employed men"
gen UosM1 = employedmen if ur==1
lab var UosM1 "urban employed men"

*add rural/urban dimension
gen RosF1 = osF1 if ur==2
lab var RosF1 "rural employed women"
gen RosF2 = osF2 if ur==2
lab var RosF2 "rural unemployed women"

gen UosF1 = osF1 if ur==1
lab var UosF1 "urban employed women"
gen UosF2 = osF2 if ur==1 
lab var UosF2 "urban unemployed women"

gen RosF5 = osF5 if ur==2
lab var RosF5 "rural housekeepers"
gen UosF5 = osF5 if ur==1
lab var UosF5 "urban housekeepers"

*generate hours per day worked (Dependent workers) for women only:
gen DWhpdF=DWhpd if sex==2
lab var DWhpdF "DW hpd female"
*generate hours per day worked (Self-employed workers) for women only:
gen SEhpdF=SEhpd if sex==2
lab var SEhpdF "SE hpd female"

*[replaced by CPI] generate GDP (annual growth in percentage) from the WDI data
gen GDP = 0
replace GDP=5.79793830169434 if year==1389
replace GDP=2.64571791806429 if year==1390
replace GDP=-7.44455702975947 if year==1391
lab var GDP "annual GDP growth in % [WDI]"

*generate CPI from WDI website (data from IMF, 2010=100)
gen CPI = 0
replace CPI=100 if year==1389
replace CPI=120.869 if year==1390
replace CPI=151.977 if year==1391
lab var CPI "CPI"

*generate LFP: working + looking for work
gen LFP = 1 if inrange(occupstatus,1,2)
replace LFP = 0 if inrange(occupstatus,3,6)
lab var LFP "LFP"

*generate FLFP: women working + looking for work
gen FLFP = LFP if sex==2
lab var FLFP "FLFP"

*generate MLFP: men working + looking for work
gen MLFP = LFP if sex==1
lab var MLFP "MLFP"
gen RMLFP = MLFP if ur==2
lab var RMLFP "Rural MLFP"
gen UMLFP = MLFP if ur==1
lab var UMLFP "Urban MLFP"

*generate urban and rural FLFP
gen RFLFP = FLFP if ur==2
lab var RFLFP "Rural FLFP"
gen UFLFP = FLFP if ur==1
lab var UFLFP "Urban FLFP"


*married, unmarried women
gen marriedFLFP=FLFP if maritstatus == 1
replace marriedFLFP = 0 if marriedFLFP == .
gen widowedFLFP=FLFP if maritstatus == 2
replace widowedFLFP = 0 if widowedFLFP == .
gen unmarriedFLFP=FLFP if maritstatus == 4
replace unmarriedFLFP = 0 if unmarriedFLFP == .


*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

*set as panel data
destring ID, replace
xtset ID year, yearly
*panel is strongly balanced*

*Hausman test
xtreg FLFP sanctions, fe
estimates store fixed
xtreg FLFP sanctions, re
estimates store random
hausman fixed random

*test for time-fixed effects
xtreg FLFP sanctions i.year, fe
testparm i.year
*time-fixed effects are needed


*<<<<<<<<<<<<<<<<<<<<<<<< PART TWO <<<<<<<<<<<<<<<<<<<<<<<<<<<<DESCRIPTIVE STATS

summarize ID
*102,813 obs
tab sex
sort sex
by sex: tab occupstatus


tab occupstatus if sex==2
*MUCH less workers: 60% housekeepers
tab occupstatus if sex==1
*60% of men employed
sort sex
by sex: summarize occupstatus
*roughly same number of observations

tab ur
*57% rural, 42 urban
tab occupstatus if ur==1
tab occupstatus if ur==2
*same number of housewives

tab maritstatus
tab maritstatus if sex==2
*lots of married, unmarried

tab DWemployed if sex==2
*909 obs
tab SEemployed if sex==2
*1971 obs

sort sex
by sex: tab SEagriworkers
*hard to tell what it means (why fill out the SE part of the survey and then
*check "I'm not self-employed")

by sex: tab DWpublicsector
by sex: tab DWprivatesector

*number of hours work by sex
by sex: tab SEhpd
by sex: tab DWhpd
by sex: tab DWemployed
by sex: tab SEemployed


*check literacy
tab lit if ur==1
tab lit if ur==2
* 84% vs 71%

*check education rural and urban
tab lowtertiary if ur==1
tab lowtertiary if ur==2
*6,000 vs 2,000

tab uppersecondary if ur==1
tab uppersecondary if ur==2
*9,000 vs 7,000

tab primary if ur==1
tab primary if ur==2
*more rural people report primary as their highest degree
*same with lowsecondary, but closer: 7,000 (urban) vs 8,000 (rural)
*othered more common among 2

tab osF2 if year==1389
tab osF2 if year==1390
tab osF2 if year==1391
*the numer of women who reported themselves as unemployed and looking for work
*increased moderately: 2.54%, 2.67%, 3.02%. 

*women who reported themselves as employed:
tab osF1 if year==1389
*87.30
tab osF1 if year==1390
*88.49 
tab osF1 if year==1391
*87.95
*mirror pattern of housewives. Interruption of trend?

*housewives:
tab osF5 if year==1389
*41
tab osF5 if year==1390
*40
tab osF5 if year==1391
*41

*other:
tab osF6 if year==1389
*1.46
tab osF6 if year==1390
*1.39
tab osF6 if year==1391
*1.40
*decrease in 1390. Interruption of trend?

*sex differences in education:
sort sex
by sex: tab preprimary
by sex: tab primary
by sex: tab lowsecondary
by sex: tab uppersecondary
by sex: tab lowtertiary
by sex: tab uppertertiary

*gen head of household (by sex):
gen HHH=kin if kin == 1
replace HHH=0 if HHH == .
lab var HHH "Head of household"
tab sex if HHH==1


*<<<<<<<<<<<<<<<<<<<<< PART THREE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< REGRESSIONS


*LABOUR FORCE PARTICIPATION


*effect on FLFP:
xtreg FLFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions had a positive effect
outreg2 using LFPregression.doc, addstat(F test, e(p)) replace ctitle(FLFP) label

*effect on MLFP:
xtreg MLFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions are NOT significant. Age and education are.
outreg2 using LFPregression.doc, addstat(F test, e(p)) append ctitle(MLFP) label

*effect on LFP:
xtreg LFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions had a positive effect, high education has a negative effect on LFP
outreg2 using LFPregression.doc, addstat(F test, e(p)) append ctitle(LFP) label


*EMPLOYMENT

*sanctions on employment (women):
xtreg osF1 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sancitions, age, lowtertiary had a positive effect on employment. Coefficient larger for women than for os1.
outreg2 using EMPLOYMENTregression.doc, addstat (F test, e(p)) replace ctitle(Female employment) label

*sanctions on employment (men):
xtreg employedmen sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
outreg2 using EMPLOYMENTregression.doc, addstat(F test, e(p)) append ctitle(Male employment) label

*sanctions on employment (men and women):
xtreg os1 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sancitions, age, cpi, primary had a positive effect on employment. 
outreg2 using EMPLOYMENTregression.doc, addstat(F test, e(p)) append ctitle(Total employment) label



*sanctions on unemployment (men and women):
xtreg os2 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions are not significant. High education has a negative impact on unemployment. Age is significant.

*sanctions on unemployment (women):
xtreg osF2 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*not significant

*Interesting: sanctions on housekeepers (female):
xtreg osF5 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions, higher education have a negative impact on becoming a housekeeper. Being married has positive impact. 
outreg2 using Appendix.doc, addstat(F test, e(p)) replace ctitle(Housekeeping) label


*WORKING HOURS

*effect on hours worked per day (female):
xtreg DWhpdF sanctions CPI preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered age age2 ib3.maritstatus, fe vce(robust)
xtreg SEhpdF sanctions CPI preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered age age2 ib3.maritstatus, fe vce(robust)
*nothing is significant, model is bad 

*effect on hours worked per day:
xtreg DWhpd sanctions CPI preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered age age2 ib3.maritstatus, fe vce(robust)
xtreg SEhpd sanctions CPI preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered age age2 ib3.maritstatus, fe vce(robust)
*nothing is significant, model is bad 

*effect on hours worked per day (agricultural workers):
xtreg hpdSEagriW sanctions CPI preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered age age2, fe vce(robust)
*not significant

*INCOME
*effect on annual self-employed earnings
xtreg SEnetincome sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered, fe vce(robust)
*CPI had a positive effect on income

*effect on annual dependent-worker earnings
xtreg DWtotalnet12 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered, fe vce(robust)
*CPI, high education had a positive effect on income


*RURAL-URBAN DIVIDE

*---------------------Rural------------------------------

*effect on rural FLFP:
xtreg RFLFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions had a positive effect
outreg2 using RU.doc, addstat(F test, e(p)) replace ctitle(Rural FLFP) label
*effect on rural MLFP:
xtreg RMLFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*not significant

*effect on rural employed women:
xtreg RosF1 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions are significant
outreg2 using RU.doc, addstat(F test, e(p)) append ctitle(Rural employment (female)) label
*effect on rural employed men:
xtreg RosM1 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanction significant, but smaller
outreg2 using RU.doc, addstat(F test, e(p)) append ctitle(Rural employment (male)) label

*effect on rural unemployed women:
xtreg RosF2 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions not significant

*--------------------Urban------------------------------

*effect on urban FLFP:
xtreg UFLFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*sanctions insignificant
*effect on urban MLFP:
xtreg UMLFP sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*not significant

*effect on urban employed women:
xtreg UosF1 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*nothing is significant

*effect on urban employed men:
xtreg UosM1 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*significant
outreg2 using RU.doc, addstat(F test, e(p)) append ctitle(Urban employment (male)) label

*effect on urban unemployed women:
xtreg UosF2 sanctions CPI age age2 preprimary primary lowsecondary uppersecondary lowtertiary uppertertiary othered ib3.maritstatus, fe vce(robust)
*nothing is significant

*rural, urban housekeepers
xtreg UosF5 sanctions age ib3.maritstatus, fe vce(robust)
xtreg RosF5 sanctions age ib3.maritstatus, fe vce(robust)

*married, unmarried
xtreg marriedFLFP sanctions CPI age age2 primary lowsecondary uppersecondary lowtertiary uppertertiary othered, fe vce(robust)
outreg2 using married.doc, addstat(F test, e(p)) replace ctitle(FLFP: married women) label
xtreg unmarriedFLFP sanctions CPI age age2 primary lowsecondary uppersecondary lowtertiary uppertertiary othered, fe vce(robust)
outreg2 using married.doc, addstat(F test, e(p)) append ctitle(FLFP: unmarried women) label
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ARTIFACTS

summarize artifacts, detail
*5,825 obs 
summarize artifacts if year==1389
summarize artifacts if year==1390
summarize artifacts if year==1391

plot artifacts year
*large outlier

xtreg artifacts sanctions CPI ib3.maritstatus i.occupstatus study lit primary lowsecondary uppersecondary lowtertiary uppertertiary othered, fe




