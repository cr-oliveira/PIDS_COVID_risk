
/* 
Code to produce output in JPIDS article "Risk Factors for Pediatric Critical COVID-19: A Systematic Review and Meta-Analysis" https://doi.org/10.1093/jpids/piae052

Version: 5.8.2024
Authors: Camila Aparicio & Carlos Oliveira 
*/

************************************************

/* This dataset includes the following variables 

study = article
outcome = critical outcome (ICU, death, IMV, composite) for which data was extracted
outcomecode = outcome; (1) ICU (2) Death (3) IMV (4) composite
type_age = age group (<1 month, <1 year, ≥12 years) for which data was extracted
type_com = risk factor or comorbidity subgroup for which data was extracted (ie. any cardiac condition, CHD, hypertension)
type_risk_code = risk factor (age, comorbidity, complexity) subgroup code (ie. (1) <1 month (2) <1 year (3) ≥12 years)

sev_risk = count of cases with the risk factor that experienced a critical outcome
notsev_risk = count of cases with the risk factor that did not experience a critical outcome
total_risk = total count of cases with the risk factor
crit_noncrit_risk = count of critical outcome cases / count of cases without a critical outcome of the cases with the risk factor
sev_norisk = count of cases without the risk factor that experienced a critical outcome
notsev_norisk = count of cases without the risk factor that did not experience a critical outcome
total_norisk = total count of cases without the risk factor
crit_noncrit_norisk = count of critical outcome cases / count of cases without a critical outcome of the cases without the risk factor

or = odds ratio

in_outpatient = patient setting; (1) inpatient (2) inpatient and outpatient
countrycd = country where the study was conducted; (0) USA (1) Non-USA (2) Multinational study
race_black = proportion of black patients in the study
race_white = proportion of white patients in the study
race_hispanic = proportion of hispanic patients in the study
race_other = proportion of non-black, non-white, and non-hispanic patients in the study

rf = risk factor for which there is adjusted data
rf_code = code for risk factor for which there is adjusted data
ES = adjusted effect size extracted
ES_code = code for adjusted effect size extracted
aES = adjusted effect size
aLCI = adjustd lower confidence interval 
aUCI = adjusted upper confidence interval
lnaES = natural log of adjusted effect size
lnaLCI = natural log of adjustd lower confidence interval 
lnaUCI = natural log of adjusted upper confidence interval
*/


************************************************
*Step 1: Declare dataset a meta-analysis
************************************************

/* The first step is to prepare the dataset for conducting the meta-analysis. Using the meta commands we declare it a meta-analysis for a two-group comparison of binary outcomes using meta esize to compute and declare effect size from summary data. Here you specify a 2x2 table to compute the log odds-ratio as an effect size. It uses random effects models by default unless another model is indicated. */

meta esize sev_risk notsev_risk sev_norisk notsev_norisk, studylabel(study)


************************************************
*Step 2: Calculate effect size
************************************************

/* Here you generate OR, 95%CI, and weight for each study from log(OR). As well the pooled OR, 95%CI, heterogeneity and homogeneity tests are calculated. */

gen or2 = exp(_meta_es)
meta summarize, or


************************************************
*Step 3: Generate forest plots
************************************************

/* As part of the meta-analysis we generated forest plots for every risk factor. Here you will create a forest plot for the dataset being used, featuring studies, critical/non-critical cases for both the risk-factor and non-risk groups, the forest plot itself,  OR [95%CI], and weight for each study. Additionally, it will display the pooled OR [95%CI] and heterogeneity tests. You can modify the "Risk Factor" column title  to reflect the specific risk factor under analysis. */

*Forest plot for risk factors without multiple conditions (ie. sex, diabetes, obesity): 
meta forestplot _id crit_noncrit_risk crit_noncrit_norisk _plot _esci _weight, or  xlabel(0.01 0.1 1 10 100) xlabel(,format(%9.0g)) nullrefline omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(_meta_se, ascending) noohomtest noosigtest nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 100)  columnopts(crit_noncrit_risk, title ("{bf:Risk Factor}") supertitle ("Critical / Non-Critical")) columnopts(crit_noncrit_norisk, title ("No-risk group") supertitle ("Critical / Non-Critical")) columnopts (_weight, title ("%") supertitle ("Weight")) xtitle ("OR (95%CI)")

*Forest plot for risk factors with multiple conditions (ie. age groups, cardiac, pulm, neuro). Here you must specify which condition you are analysing after type_risk_code== (ie. age groups, CHD, asthma, seizure)
meta forestplot _id crit_noncrit_risk crit_noncrit_norisk _plot _esci  _weight if (type_risk_code==1), or xlabel(0.01 0.1 1 10 100) xlabel(,format(%9.0g)) nullrefline omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(_meta_se, ascending) noohomtest noosigtest nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 100) columnopts(crit_noncrit_risk, title ("{bf:Risk Factor}") supertitle ("Critical / Non-Critical")) columnopts(crit_noncrit_norisk, title ("No-risk group") supertitle ("Critical / Non-Critical")) columnopts (_weight, title ("%") supertitle ("Weight")) xtitle ("OR (95%CI)")


************************************************
*Step 4: Sensitivity analysis - Subgroup analysis
************************************************
/* For the sensitivity analysis we conducted subgroup analysis by critical outcome and by patient setting. Here you will create forest plots organized by these subgroups. */

*Forest plot for sensitivity analysis BY OUTCOME subgroup (ICU, death, composite) for risk factor without multiple conditions:
label define outcome 1 "ICU" 2 "Death" 3 "Invasive Ventilation" 4 "Composite"
label values outcomecode outcome
meta forestplot _id crit_noncrit_risk crit_noncrit_norisk _plot _esci _weight, or subgroup (outcomecode) xlabel(0.01 0.1 1 10 100) xlabel(,format(%9.0g)) nullrefline omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(_meta_se, ascending) noohomtest noosigtest nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 100)  columnopts(crit_noncrit_risk, title ("{bf:Risk Factor}") supertitle ("Critical / Non-Critical")) columnopts(crit_noncrit_norisk, title ("No-risk group") supertitle ("Critical / Non-Critical")) columnopts (_weight, title ("%") supertitle ("Weight")) xtitle ("OR (95%CI)")

*Forest plot for sensitivity analysis BY OUTCOME subgroup (ICU, death, composite) for risk factor with multiple conditions, modify if(type_risk_code==) accordingly:
label define outcome 1 "ICU" 2 "Death" 3 "Invasive Ventilation" 4 "Composite"
label values outcomecode outcome
meta forestplot _id crit_noncrit_risk crit_noncrit_norisk _plot _esci _weight if (type_risk_code==1), or subgroup (outcomecode) xlabel(0.01 0.1 1 10 100) xlabel(,format(%9.0g)) nullrefline omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(_meta_se, ascending) noohomtest noosigtest nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 100)  columnopts(crit_noncrit_risk, title ("{bf:Risk Factor}") supertitle ("Critical / Non-Critical")) columnopts(crit_noncrit_norisk, title ("No-risk group") supertitle ("Critical / Non-Critical")) columnopts (_weight, title ("%") supertitle ("Weight")) xtitle ("OR (95%CI)")

*Forest plot for sensitivity analysis BY PATIENT SETTING subgroup (inpatient, inpatient and outpatient) for risk factor without multiple conditions:
label define inout 1 "Inpatient" 2 "Inpatient and outpatient"
label values in_outpatient inout
meta forestplot _id crit_noncrit_risk crit_noncrit_norisk _plot _esci _weight, or subgroup (in_outpatient) xlabel(0.01 0.1 1 10 100) xlabel(,format(%9.0g)) nullrefline omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(_meta_se, ascending) noohomtest noosigtest nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 100)  columnopts(crit_noncrit_risk, title ("{bf:Risk Factor}") supertitle ("Critical / Non-Critical")) columnopts(crit_noncrit_norisk, title ("No-risk group") supertitle ("Critical / Non-Critical")) columnopts (_weight, title ("%") supertitle ("Weight")) xtitle ("OR (95%CI)")

*Forest plot for sensitivity analysis BY PATIENT SETTING subgroup (inpatient, inpatient and outpatient) for risk factor with multiple conditions, modify if(type_risk_code==) accordingly:
label define inout 1 "Inpatient" 2 "Inpatient and outpatient"
label values in_outpatient inout
meta forestplot _id crit_noncrit_risk crit_noncrit_norisk _plot _esci _weight if (type_risk_code==1), or subgroup (in_outpatient) xlabel(0.01 0.1 1 10 100) xlabel(,format(%9.0g)) nullrefline omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(_meta_se, ascending) noohomtest noosigtest nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 100)  columnopts(crit_noncrit_risk, title ("{bf:Risk Factor}") supertitle ("Critical / Non-Critical")) columnopts(crit_noncrit_norisk, title ("No-risk group") supertitle ("Critical / Non-Critical")) columnopts (_weight, title ("%") supertitle ("Weight")) xtitle ("OR (95%CI)")


*******************************************************************
*Step 5: Sensitivity analysis - Meta-regression
*******************************************************************
/* For the sensitivity analysis we conducted a meta-regression by date, country, patient setting, and race for the different risk factors. */

label define time 0 "Before vaccine" 1 "After vaccine (May 2021)"
label values incl_vaccine time

label define countrycd 0 "USA" 1 "Non-USA" 2 "Multinational"
label values countrycd countrycd

label define inout 1 "Inpatient" 2 "Inpatient and outpatient"
label values in_outpatient inout

*Meta-regression for risk factors without multiple conditions:
meta regress _cons, eform
meta regress incl_vaccine, eform
meta regress i.countrycd, eform
meta regress in_outpatient, eform
meta regress race_hispanic race_white race_hispanic, eform

*Meta-regression for risk factors with multiple conditions:
meta regress _cons if (type_risk_code==1), eform
meta regress incl_vaccine if (type_risk_code==1), eform
meta regress i.countrycd if (type_risk_code==1), eform
meta regress in_outpatient if (type_risk_code==1), eform
meta regress race_black race_white race_hispanic if (type_risk_code==1), eform


************************************************
*Step 6: Calculate prevalence of critical disease
************************************************
/* To estimate the prevalence (single proportion) of critical disease within the risk-factor and no-risk group we used the Freeman-Turkey-transformed proportions. . */

*The meta-analysis has to be declared again.

*Here you calculate the prevalence of critical disease in those without the risk factor.
meta esize sev_norisk total_norisk, studylabel(study)
meta forestplot if (type_risk_code==1), proportion xlabel(,format(%9.0g)) omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) columnopts(_data, title ("Critical Total") supertitle ("{bf:No-risk group}"))

*Here you calculate the prevalence of critical disease by risk  group. Modify type_risk_code== to the analyzed risk-factor condition. If the risk factor has no multiple conditions, do not include if(type_risk_code==)
meta esize sev_risk total_risk, studylabel(study)
meta forestplot if (type_risk_code==1), proportion xlabel(,format(%9.0g)) omarkeropts (mcolor(emerald)) markeropts (mcolor(navy)) ciopts (lcolor(navy) mcolor(navy) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) columnopts(_data, title ("Critical Total") supertitle ("{bf:Risk Factor}"))


*******************************************************************
*Step 7: Sensitivity analysis - Study-level adjusted data analysis
*******************************************************************
/* For the sensitivity analysis we conducted analyzed the study-level adjusted by other comorbidities data provided. Here you will create forest plots by the adjusted effect size for the risk factor being analyzed. */

*Use study adjusted data

label variable rf_code "Risk Factor"
label variable es "Adjusted ES"
label variable outcomecode "Outcome"

label define aes 1 "aOR" 2 "aRR" 3 "aHR"
label values es_code aes

label define outcome 1 "ICU" 2 "Death" 4 "Composite"
label values outcomecode outcome

*Here you generate the relative difference between the confidence intervals to determine the civartolerance.
generate double relative_diffln = reldif(lnaes-lnalci, lnauci-lnaes)
summarize relative_diffln

*Here you declare the dataset as meta set because you are using precomputed (study-level) effect sizes
meta set lnaes lnalci lnauci, studylabel(study) civartolerance (0.27)
meta summarize, eform(odds ratios)

*Here you generate the forest plot with the adjusted effect sizes for each risk factor (if(rf_code==))
meta forestplot _id outcomecode _plot _esci _weight if (rf_code==1), eform(Adjusted ES [95%CI]) subgroup (es_code) xsize(11.5) xlabel(0.1 2 1 10) xlabel(,format(%9.0g)) nullrefline gmarkeropts (mcolor(khaki)) markeropts (mcolor(maroon)) omarkeropts (mcolor(khaki)) ciopts (lcolor(maroon) mcolor(maroon) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(aes, ascending)   noohomtest noosigtest  nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 15) columnopts (_id, title ("{bf:Study}")) columnopts (outcomecode, title ("Critical outcome")) columnopts (_weight, supertitle ("") title ("Weight %")) columnopts (_esci, supertitle ("") title ("Adjusted ES [95%CI]")) columnopts (_plot, title ("{bf:Risk Factor}")) xtitle ("Adjusted ES (95%CI)") 

note ("* With controller medication ** Without controller medication ^ Without other comorbidities ^^ With other comorbidities")

*Here you generate an overall forestplot with the adjusted effect size of all the risk factors
label define rfdef 1 "Cardiovascular disease" 13 "Congenital heart disease" 2 "1 underlying condition" 3 "≥ 2 underlying conditions" 4 "Diabetes" 5 "Chronic GI disease" 6 "Severe immunocompromise" 7 "Oncologic diagnosis" 8 "Neurodevelopmental disorders" 9 "Seizure disorders" 10 "Obesity" 11 "Pulmonary disease" 12 "Asthma" 14 "Neurologic disease" 15 "Chronic kidney disease" 15 "Prematurity"
label values rf_code rfdef
meta forestplot _id outcomecode _plot if (es_code==1), eform(Adjusted ES [95%CI]) subgroup (rf_code) xsize(11.5) xlabel(1 2 10) xlabel(,format(%9.0g)) nullrefline markeropts (mcolor(maroon)) omarkeropts (mcolor(khaki)) ciopts (lcolor(maroon) mcolor(maroon) barbsize(vtiny)) itemopts(justification(left)) bodyopts (justification(left)) sort(aes, ascending)  nogmarkers noohomtest noosigtest  nogwhomtests nogsigtests nogbhomtests nonote crop(0.005 15) columnopts (_id, title ("{bf:Study}")) columnopts (outcomecode, title ("Critical outcome")) columnopts (_plot, title ("{bf:Adjusted OR}")) xtitle ("Adjusted OR (95%CI)") 


