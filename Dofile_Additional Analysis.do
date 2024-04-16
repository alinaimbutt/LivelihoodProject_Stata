***********************************************************
*******************SETUP**************************************

global directory "C:\Users\Ali\Desktop\ProjectA data analysis"
global file "Livelihood Survey.dta"

cd "$directory"
use "$file", clear

drop if survey_status == "Partially Completed"
drop if survey_status == "Refused"
rename surveyid HHid 
destring HHid, replace
label var HHid "Household id"

**************************************************************
****************Dummy for multigenerational HHs

gen multi = 0
forvalues i = 1/18 {
 replace multi = multi + 1 if inlist(sec_1_a_q_2_`i', 6, 9, 11, 12)
 }
replace multi = (multi > 0)
tabout multi using multihh.xls, c(freq col) replace

***************************************************************
****************Female Labor Force Particiaption****************

gen fem_15_plus = 0
gen fem_15_plus_working = 0
forvalues i = 1/18 {
 replace fem_15_plus = fem_15_plus + 1 if sec_1_a_q_3_`i'==2 & sec_1_a_q_6_`i'>=15
 replace fem_15_plus_working = fem_15_plus_working + 1 if sec_1_a_q_3_`i'==2 & sec_1_a_q_6_`i'>=15 & sec_1_a_q_7_`i'<=15
 }
tab fem_15_plus
tab fem_15_plus_working
gen fem_lab_rate_hh = 100*fem_15_plus_working/fem_15_plus

preserve

collapse (sum) fem_15_plus*, by(multi)
gen fem_lab_rate = 100*fem_15_plus_working/fem_15_plus

export excel multi_fem_lab_participate, firstrow(var) replace

restore
******************************************************************
*****************Type of Jobs multi vs not

capture erase "temp.dta"

forvalues i = 1/8 {
preserve
keep sec_1c3_q_1b_`i' multi
rename sec_1c3_q_1b_`i' womenwork
capture append using temp
save temp, replace
restore
}

preserve

use temp, clear
drop if missing(womenwork)
tabout multi womenwork using multi_fem_jobs.xls, c(freq col) replace

*******************************************************************
*******************Dependency Ratio********************************
restore

*Age Varaiable
*creating age categories for HHs 
gen total_under5 = 0
forvalues i = 1/18 {
replace total_under5 = total_under5 + 1 if ~missing(sec_1_a_q_6_`i') & sec_1_a_q_6_`i'<=5 
}

gen total_6_15years =0
forvalues i = 1/18 {
replace total_6_15 = total_6_15 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 6, 15) 
}

gen total_16_20years =0
forvalues i = 1/18 {
replace total_16_20 = total_16_20 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 16, 20) 
}

gen total_21_25years =0
forvalues i = 1/18 {
replace total_21_25 = total_21_25 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 21, 25) 
}

gen total_26_30years =0
forvalues i = 1/18 {
replace total_26_30 = total_26_30 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 26, 30) 
}

gen total_31_35years =0
forvalues i = 1/18 {
replace total_31_35 = total_31_35 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 31, 35) 
}

gen total_36_40years =0
forvalues i = 1/18 {
replace total_36_40 = total_36_40 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 36, 40) 
}

gen total_41_45years =0
forvalues i = 1/18 {
replace total_41_45 = total_41_45 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 41, 45) 
}

gen total_46_50years =0
forvalues i = 1/18 {
replace total_46_50 = total_46_50 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 46, 50) 
}

gen total_51_55years =0
forvalues i = 1/18 {
replace total_51_55 = total_51_55 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 51, 55) 
}

gen total_56_60years =0
forvalues i = 1/18 {
replace total_56_60 = total_56_60 + 1 if ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 56, 60) 
}

gen total_above60 = 0
forvalues i = 1/18 {
replace total_above60 = total_above60 + 1 if ~missing(sec_1_a_q_6_`i') & sec_1_a_q_6_`i'>60
}

*Dependents 
gen dependents = total_under5 + total_above60
gen householdsize = sec_1_a_q_01
tab householdsize
egen grand_total = rowtotal( total_under5 total_6_15years total_16_20years total_21_25years total_26_30years total_31_35years total_36_40years total_41_45years total_46_50years total_51_55years total_56_60years total_above60)
*** The grand total is different for some values from variable size of HH recorded (could be error in data entry)

gen dependency_ratio = dependents/grand_total


********************************************************************************
********************************CORRELATIONS************************************
egen childcare = rowmin(sec_1c3_q_2*)
replace childcare = (childcare == 1)

pwcorr dependency* fem_lab*, sig
pwcorr childcare fem_lab*, sig


*******************************************************************************
****************************Household Characteristics**************************

****under 5, over 60

gen type = "Under5" if total_under5>0
replace type = "Over60" if total_above60>0
replace type = "None" if missing(type)
tabout type using age_hh.xls, c(freq col) replace


****under 5 or over 60

gen type2 = "Under5orOver60" if total_under5 | total_above60
replace type2 = "None" if missing(type2)
tabout type2 using age_hh.xls, c(freq col) append

****under 5 and over 60

gen type3 = "Under5andOver60" if total_under5 & total_above60
replace type3 = "None" if missing(type3)
tabout type3 using age_hh.xls, c(freq col) append

******Female Labor force participation
preserve
collapse fem_lab*, by(type)
export excel age_hh, sheet("Under5Over60") firstrow(var) replace
restore

preserve
collapse fem_lab*, by(type2)
export excel age_hh, sheet("Under5_or_Over60") firstrow(var)

restore

preserve
collapse fem_lab*, by(type3)
export excel age_hh, sheet("Under5_and_Over60") firstrow(var)
restore

*****Availability of childcare
preserve
collapse childcare, by(type)
export excel age_childcare, sheet("Under5Over60") firstrow(var) replace
restore

preserve
collapse childcare, by(type2)
export excel age_childcare, sheet("Under5_or_Over60") firstrow(var)
restore

preserve
collapse childcare, by(type3)
export excel age_childcare, sheet("Under5_and_Over60") firstrow(var)
restore

*****Type of Jobs women engage in

erase "temp.dta"

forvalues i = 1/8 {
preserve
keep sec_1c3_q_1b_`i' type*
rename sec_1c3_q_1b_`i' womenwork
capture append using temp
save temp, replace
restore
}

preserve

use temp, clear
drop if missing(womenwork)
tabout type womenwork using age_womenwork.xls, c(freq col) replace

use temp, clear
drop if missing(womenwork)
tabout type2 womenwork using age_womenwork.xls, c(freq col) append

use temp, clear
drop if missing(womenwork)
tabout type3 womenwork using age_womenwork.xls, c(freq col) append

restore

********************************************************************************
**************************Top 2 Nominees****************************************

******Gender Breakdown

gen male_top = 0
gen female_top = 0
forvalues i = 1/10 {
replace male_top = male_top + 1 if sec1c_1_`i'==1 & sec_1_a_q_3_`i'==1 & ~missing(sec_1_a_q_3_`i')
replace female_top = female_top + 1 if sec1c_1_`i'==1 & sec_1_a_q_3_`i'==2 & ~missing(sec_1_a_q_3_`i')
}

preserve
collapse (sum) *_top
export excel nominees, sheet("Gender Overall") firstrow(var) replace
restore

********Age Breakdown

gen nom_15_20 = 0
gen nom_21_25 = 0
gen nom_26_30 = 0
gen nom_31_35 = 0
gen nom_36_40 = 0
gen nom_41_45 = 0
gen nom_46_50 = 0
gen nom_50_plus = 0


forvalues i = 1/10 {

replace nom_15_20 = nom_15_20 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 15, 20)
replace nom_21_25 = nom_21_25 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 21, 25)
replace nom_26_30 = nom_26_30 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 26, 30)
replace nom_31_35 = nom_31_35 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 31, 35)
replace nom_36_40 = nom_36_40 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 36, 40)
replace nom_41_45 = nom_41_45 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 41, 45)
replace nom_46_50 = nom_46_50 + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 46, 50)
replace nom_50_plus = nom_50_plus + 1 if sec1c_1_`i'==1 & ~missing(sec_1_a_q_6_`i') & inrange(sec_1_a_q_6_`i', 51, 100)
}

preserve
collapse (sum) nom*
export excel nominees, sheet("Age Brkdown") firstrow(var)
restore

*********Nomination Gender Breakdown

gen nom_both = (male_top==1 & female_top==1)
gen nom_male_only = (male_top==2 & female_top==0)
gen nom_female_only = (female_top==2 & male_top==0)

preserve
collapse (sum) nom_both nom_male_only nom_female_only
export excel nominees, sheet("Gender Brkdown") firstrow(var)
restore

**********************Nomination Education Profile Breakdown

gen nom_no_ed = 0
gen nom_primary = 0
gen nom_secondary = 0
gen nom_high_secondary = 0
gen nom_informal = 0


forvalues i = 1/10 {
replace nom_no_ed = nom_no_ed + 1 if sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 15, 17) & ~missing(sec_1_a_q_4_`i')
replace nom_primary = nom_primary + 1 if sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 0, 5) & ~missing(sec_1_a_q_4_`i')
replace nom_secondary = nom_secondary + 1 if sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 6, 9) & ~missing(sec_1_a_q_4_`i')
replace nom_high_secondary = nom_high_secondary + 1 if sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 10, 14) & ~missing(sec_1_a_q_4_`i')
replace nom_informal = nom_informal + 1  if sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 15, 16) & ~missing(sec_1_a_q_4_`i')

}

gen nom_formal = nom_primary + nom_secondary + nom_high_secondary

preserve
collapse (sum) nom_no_ed nom_primary nom_secondary nom_high_secondary nom_formal nom_informal

export excel nom_no_ed nom_primary nom_secondary nom_high_secondary using nominees, sheet("Edu Overall") firstrow(var)
export excel nom_formal nom_informal using nominees, sheet("Edu Formal") firstrow(var)
restore

*********GENDER DISAGGREGATED Edu Profile*******************************
***Male/Female

local gender "Male Female"
local value = 1
foreach sex of local gender {

di "`sex'"

gen nom_no_ed_`sex' = 0
gen nom_primary_`sex' = 0
gen nom_secondary_`sex' = 0
gen nom_high_secondary_`sex' = 0
gen nom_informal_`sex' = 0


forvalues i = 1/10 {
replace nom_no_ed_`sex' = nom_no_ed_`sex' + 1 if sec_1_a_q_3_`i'==`value' & sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 15, 17) & ~missing(sec_1_a_q_4_`i')
replace nom_primary_`sex' = nom_primary_`sex' + 1 if sec_1_a_q_3_`i'==`value' & sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 0, 5) & ~missing(sec_1_a_q_4_`i')
replace nom_secondary_`sex' = nom_secondary_`sex' + 1 if sec_1_a_q_3_`i'==`value' & sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 6, 9) & ~missing(sec_1_a_q_4_`i')
replace nom_high_secondary_`sex' = nom_high_secondary_`sex' + 1 if sec_1_a_q_3_`i'==`value' & sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 10, 14) & ~missing(sec_1_a_q_4_`i')
replace nom_informal_`sex' = nom_informal_`sex' + 1  if sec_1_a_q_3_`i'==`value' & sec1c_1_`i'==1 & inrange(sec_1_a_q_4_`i', 15, 16) & ~missing(sec_1_a_q_4_`i')

}

gen nom_formal_`sex' = nom_primary_`sex' + nom_secondary_`sex' + nom_high_secondary_`sex'

preserve
collapse (sum) nom_no_ed_`sex' nom_primary_`sex' nom_secondary_`sex' nom_high_secondary_`sex' nom_formal_`sex' nom_informal_`sex'
export excel nominees, sheet("`sex' Edu Profile") firstrow(var)
restore
local value = `value' + 1
}

*******EMPLOYMENT STATUS TOP 2 NOMINEES*************************

preserve
encode mod2_q0_label, g(emp)
collapse (count) emp, by(mod2_q0_label gender_individual_one)
rename gender_individual_one gender
save temp, replace
restore
preserve
encode mod2_q1_label, g(emp)
collapse (count) emp, by(mod2_q1_label gender_individual_two)
rename gender_individual_two gender
append using temp
replace mod2_q0_label = mod2_q1_label if missing(mod2_q0_label)
split mod2_q0_label, p(" &")
collapse (sum) emp, by(mod2_q0_label1 gender)
sort gender mod*
egen tot = total(emp), by(gender)
gen pct = 100*emp/tot
export excel nominees, sheet("Emp Status") firstrow(var)
restore

********************************************************************************
***********************EMPLOYMENT***********************************************
**********************TIME SPENT ON ACTIVITY-overall****************************
preserve
keep sec_2b_q_4_1
rename sec_2b_q_4_1 time
save temp, replace
restore
preserve
keep sec_2b_q_4_2
rename sec_2b_q_4_2 time
append using temp
drop if time>=100

outreg2 using timespent_overall.xls, replace sum(log) keep(time)

restore

*****TIME SPENT ON ACTIVITY-by gender
preserve
keep sec_2b_q_4_1 gender_individual_one
rename (sec_2b_q_4_1 gender_individual_one) (time gender)
save temp, replace
restore

preserve
keep sec_2b_q_4_2 gender_individual_two
rename (sec_2b_q_4_2 gender_individual_two) (time gender)
append using temp
drop if time>=100

bys gender: outreg2 using timespent_bygender.xls, replace sum(log) keep(time) 

restore

*****TIME SPENT ON ACTIVITY-by emp type

gen edu_one = .
gen edu_two = .
forvalues i = 1/561 {
local index1 = first_individual_number[`i']
local index2 = second_individual_number[`i']

replace edu_one = sec_1_a_q_4_`index1'[`i'] in `i'/561
replace edu_two = sec_1_a_q_4_`index2'[`i'] in `i'/561

}
label values edu_one edu_two sec_1_a_q_4_1


preserve
keep sec_2b_q_4_1 mod2_q0_label gender_individual_one edu_one
rename (sec_2b_q_4_1 mod2_q0_label gender_individual_one edu_one) (time emp gender edu)
save temp, replace
restore

preserve
keep sec_2b_q_4_2 mod2_q1_label gender_individual_two edu_two
rename (sec_2b_q_4_2 mod2_q1_label gender_individual_two edu_two) (time emp gender edu)
append using temp
drop if time>=100
split emp, p(" &")

gen edu1 = ""

replace edu1 = "No education" if inrange(edu, 15, 17) & ~missing(edu)
replace edu1 = "Primary" if inrange(edu, 0, 5) & ~missing(edu)
replace edu1 = "Secondary" if inrange(edu, 6, 9) & ~missing(edu)
replace edu1 = "Higher Sec & Above" if inrange(edu, 10, 14) & ~missing(edu)

save emp_gender, replace

collapse time, by(emp1)
export excel timespent_emptype, firstrow(var) replace

***************T Test***************************************
use emp_gender, clear
ttest time, by(gender)

collapse time, by(edu1)
export excel timespent_edutype, firstrow(var) replace

restore

******Type of business

gen business_cat = ""
replace business_cat = "Armed Forces" if sec2c_2_1==9
replace business_cat = "Craft and Related Trades Workers" if sec2c_2_1==3
replace business_cat = "Elementary Occupations" if sec2c_2_1==4
replace business_cat = "Not formally employed" if inlist(sec2c_2_1, 16, 17, 18, 98)
replace business_cat = "Plant and Machine Operators and Assemblers" if inlist(sec2c_2_1, 2, 6)
replace business_cat = "Professionals" if inlist(sec2c_2_1, 8, 11, 12, 14, 15)
replace business_cat = "Service workers and shop and market sales workers" if inlist(sec2c_2_1, 5, 7, 10, 13)
replace business_cat = "Skilled Agricultural and Fishery Workers" if sec2c_2_1==1

gen business_cat1 = ""
replace business_cat1 = "Armed Forces" if sec2c_2_2==9
replace business_cat1 = "Craft and Related Trades Workers" if sec2c_2_2==3
replace business_cat1 = "Elementary Occupations" if sec2c_2_2==4
replace business_cat1 = "Not formally employed" if inlist(sec2c_2_2, 16, 17, 18, 98)
replace business_cat1 = "Plant and Machine Operators and Assemblers" if inlist(sec2c_2_2, 2, 6)
replace business_cat1 = "Professionals" if inlist(sec2c_2_2, 8, 11, 12, 14, 15)
replace business_cat1 = "Service workers and shop and market sales workers" if inlist(sec2c_2_2, 5, 7, 10, 13)
replace business_cat1 = "Skilled Agricultural and Fishery Workers" if sec2c_2_2==1

***************************************
********Main Employer***************
*****************************************

preserve
keep mod2_q0_label gender_individual_one edu_one sec_2b_q_10_1 business_cat
rename (mod2_q0_label gender_individual_one edu_one sec_2b_q_10_1) (emp gender edu employer)
save temp, replace
restore

preserve
keep mod2_q1_label gender_individual_two edu_two sec_2b_q_10_2 business_cat1
rename (mod2_q1_label gender_individual_two edu_two sec_2b_q_10_2 business_cat1) (emp gender edu employer business_cat)
append using temp
label values employer sec_2b_q_10_1
split emp, p(" &")

gen edu1 = ""

replace edu1 = "No education" if inrange(edu, 15, 17) & ~missing(edu)
replace edu1 = "Primary" if inrange(edu, 0, 5) & ~missing(edu)
replace edu1 = "Secondary" if inrange(edu, 6, 9) & ~missing(edu)
replace edu1 = "Higher Sec & Above" if inrange(edu, 10, 14) & ~missing(edu)

label variable employer "Employer"

save emp_gender_edu, replace

************************************************************************
************************Main employer overall
tabout employer using mainemployer.xls, c(freq col) replace

******************************by gender & edu
tabout employer gender using mainemployer.xls, c(freq col) append

tabout employer edu1 using mainemployer.xls, c(freq col) append

tabout employer emp1 using mainemployer.xls, c(freq col) append


restore

***************************************
********Covid loss of emp***************
*****************************************

preserve
keep sec_2b_q_22_1 mod2_q0_label gender_individual_one edu_one sec_2b_q_10_1 business_cat
rename (sec_2b_q_22_1 mod2_q0_label gender_individual_one edu_one sec_2b_q_10_1) (covid emp gender edu employer)
save temp, replace
restore

preserve
label values sec_2b_q_22_2 sec_2b_q_22_1
keep sec_2b_q_22_2 mod2_q1_label gender_individual_two edu_two sec_2b_q_10_2 business_cat1
rename (sec_2b_q_22_2 mod2_q1_label gender_individual_two edu_two sec_2b_q_10_2 business_cat1) (covid emp gender edu employer business_cat)
append using temp
label values employer sec_2b_q_10_1
split emp, p(" &")

gen edu1 = ""

replace edu1 = "No education" if inrange(edu, 15, 17) & ~missing(edu)
replace edu1 = "Primary" if inrange(edu, 0, 5) & ~missing(edu)
replace edu1 = "Secondary" if inrange(edu, 6, 9) & ~missing(edu)
replace edu1 = "Higher Sec & Above" if inrange(edu, 10, 14) & ~missing(edu)

label variable covid "affected by Covid"
label variable employer "Employer"

save emp_gender_edu, replace

************************************************************************
************************loss of emp overall
tabout covid using covid.xls, c(freq col) replace

******************************by gender & edu
tabout covid gender using covid.xls, c(freq col) append

tabout covid edu1 using covid.xls, c(freq col) append


********ADDITIONAL STUFF - COVID******************
*********Added 31/8/21****************************

tabout covid emp1 using covid.xls, c(freq col) append
tabout covid employer using covid.xls, c(freq col) append


restore

***********************************************************
************************SELF EMPLOYMENT*******************
***********************************************************

tabout business_cat using self_emp.xls, c(freq col) replace


**************************************************
*************BARRIERS*****************************

preserve
keep sec2c_23_label_1 gender_individual_one edu_one business_cat
rename (sec2c_23_label_1 gender_individual_one edu_one) (reason gender edu)
save temp, replace

restore
*preserve
keep sec2c_23_label_2 gender_individual_two edu_two business_cat1
rename (sec2c_23_label_2 gender_individual_two edu_two business_cat1) (reason gender edu business_cat)
append using temp
save temp, replace

/*
restore
*preserve
keep sec2c_23_label_3
rename sec2c_23_label_3 reason
append using temp
*/

split reason, p(" &")
gen index = 1

gen edu1 = ""

replace edu1 = "No education" if inrange(edu, 15, 17) & ~missing(edu)
replace edu1 = "Primary" if inrange(edu, 0, 5) & ~missing(edu)
replace edu1 = "Secondary" if inrange(edu, 6, 9) & ~missing(edu)
replace edu1 = "Higher Sec & Above" if inrange(edu, 10, 14) & ~missing(edu)

save temp, replace

********Overall barriers
capture erase "tempreason.dta"
forvalues i = 1/3 {
use temp, clear
keep if ~missing(reason`i')
collapse (count) index, by(reason`i')
rename reason`i' reason
capture append using tempreason
save tempreason, replace
}

replace reason = strtrim(reason)
collapse (sum) index, by(reason)
gsort -index
ren index count
export excel barriers, sheet("Overall") firstrow(var) replace

********Gender barriers
capture erase "tempreason.dta"
forvalues i = 1/3 {
use temp, clear
keep if ~missing(reason`i')
collapse (count) index, by(reason`i' gender)
rename reason`i' reason
capture append using tempreason
save tempreason, replace
}

replace reason = strtrim(reason)
collapse (sum) index, by(reason gender)
gsort gender -index
ren index count
export excel barriers, sheet("Gender") firstrow(var)


********Edu barriers
capture erase "tempreason.dta"
forvalues i = 1/3 {
use temp, clear
keep if ~missing(reason`i')
collapse (count) index, by(reason`i' edu1)
rename reason`i' reason
capture append using tempreason
save tempreason, replace
}

replace reason = strtrim(reason)
collapse (sum) index, by(reason edu1)
gsort edu1 -index
ren index count
export excel barriers, sheet("Education") firstrow(var)

********Sector barriers
capture erase "tempreason.dta"
forvalues i = 1/3 {
use temp, clear
keep if ~missing(reason`i')
collapse (count) index, by(reason`i' business_cat)
rename reason`i' reason
capture append using tempreason
save tempreason, replace
}

replace reason = strtrim(reason)
collapse (sum) index, by(reason business_cat)
drop if missing(business_cat)
gsort business_cat -index
ren index count
export excel barriers, sheet("Sector") firstrow(var)

******Erase Remaining**********
erase "temp.dta"
erase "tempreason.dta"
erase "emp_gender.dta"
erase "emp_gender_edu.dta"
erase "timespent_bygender.txt"
erase "timespent_overall.txt"
capture erase "timespent.txt"
