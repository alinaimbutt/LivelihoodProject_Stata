clear
clear matrix
clear mata
set mem 500000
set maxvar 32000
set more off

global directory "C:\Users\Ali\Desktop\ProjectA data analysis"
global file "Livelihood Survey.dta"

cd "$directory"
use "$file", clear

ssc install tabout

*Drop partially completed or refused survey
tab checkpoint_1, missing
tab checkpoint_2, missing
tab checkpoint_3, missing
tab checkpoint_4, missing
tab checkpoint_5, missing
tab checkpoint_6, missing
tab survey_status,nolab
drop if survey_status == "Partially Completed"
drop if survey_status == "Refused"
sum surveyid
rename surveyid HHid 
destring HHid, replace
label var HHid "Household id"
tab HHid
tostring HHid, format("%09.0f") replace

********FINAL ANALYSIS BEING RUN ON 561/577 SURVEYS*********

*******************SECTION 0******************
*marital status & gender of HH head 
numlabel sec0_9, add
numlabel sec0_10, add
tab sec0_9 sec0_10, missing 
histogram sec0_9, freq by(sec0_10, legend (off)) title("Marital Status of Head of HH by Gender") xlabel(1 "Married" 2 "Divorced" 3 "Widowed" 4 "Unmarried")addlabels

*primary language Head of HH
tab sec_0_q_1 , missing
numlabel sec_0_q_1 ,add
graph pie sec_0_q_1, over(sec_0_q_1) title(Language Spoken in Household)

*ethnicity of HH head 
numlabel sec_0_q_2, add
tab sec_0_q_2 , missing
graph pie sec_0_q_2, over(sec_0_q_2) title(Ethnicity of Household)

*In which sector HH head work in
numlabel sec_0_q_4, add
tab sec_0_q_4, missing
tab sec_0_q_4_desc, missing
graph bar (count) if sec_0_q_4==1 | sec_0_q_4==3 | sec_0_q_4==4 | sec_0_q_4==5, over(sec_0_q_4, label(labcolor(black) angle(forty_five) labsize(small))) blabel(bar) ytitle(Frequency) title(Top Identified Occupations of Household Head, size(medium)) scheme(s2color)

*******************************************************

************** SECTION 1****************

*number of indivduals living in a household 
sum sec_1_a_q_01, detail
sum sec_1_a_q_02, detail
tab sec_1_a_q_02

*Name first were 97% male and household head
gen relationship_to_hh_head = sec_1_a_q_2_1
label variable relationship_to_hh_head "Relationship to head"
label define relationship_to_hh_head 1 "Head" 2 "Spouse/Married" 3 "Own Child" 4 "Grandchild" 5 "Adopted Child" 6 "Brother/Sister" 7 "Niece/Nephew" 8 "Brother/Sister in law" 9 "Son/Daughter in law" 10 "Uncle/Aunt" 11 "Parent" 12 "Parent in law" 13 "Not related" 14 "Servant" 15 "Grandparents" 16 "Cousin" 17 "Stepson/StepDaughter" 88 "Other"
label values relationship_to_hh_head relationship_to_hh_head

gen cresidence_status_firstname = sec_1_a_q_1b_1
label variable cresidence_status_firstname "Current Residence Status of First Name"
label define cresidence_status_firstname 1 "Present in the household" 2 "Shifted out of the hosehold but contribute to HH income" 3 "Recently moved to the household" 4 "Have been living in the household but were not captured in the village census roster"
label values cresidence_status_firstname cresidence_status_firstname

gen maritalstatus_of_firstname = sec_1_a_q_1c_1
label variable maritalstatus_of_firstname "Marital Status of First Name"
label define maritalstatus_of_firstname 1 "Single" 2 "Married" 3 "Divorced/Separated" 4 "Widowed"
label values maritalstatus_of_firstname maritalstatus_of_firstname

gen gender_firstname = sec_1_a_q_3_1
label variable gender_firstname "Gender"
label define gender_firstname 1 "Male" 2 "Female"
label values gender_firstname gender_firstname

gen educationcompleted_firstname = sec_1_a_q_4_1
label variable educationcompleted_firstname "Number years of education completed"
label define educationcompleted_firstname 0 "Less than class 1" 1 "Class 1" 2 "Class 2" 3 "Class 3" 4 "Class 4" 5 "Class 5" 6 "Class 6" 7 "Class 7" 8 "Class 8" 9 "Class 9" 10 "SSC/Matric/Olevel" 11 "HSC/FSC/Alevel" 12 "Graduate/MBBS/BDS/LLB" 13 "MA/MPhil/MS" 14 "Diploma/vocational" 15 "Hafiz" 16 "No formal education but have basic literacy/numeracy" 17 "Have never been to school"
label values educationcompleted_firstname educationcompleted_firstname

gen firstname_presentin_hh_lastyear = sec_1_a_q_5_3
label variable firstname_presentin_hh_lastyear "First Name physically present in HH last year"
label define firstname_presentin_hh_lastyear 1 "Less than 3 months" 2 "3-6 Months" 3 "6-9 Months" 4 "More than 9 months"
label values firstname_presentin_hh_lastyear firstname_presentin_hh_lastyear

gen firstname_age = sec_1_a_q_6_2
label variable firstname_age "Age of First Name"

gen firstname_sector = sec_1_a_q_7_1
label variable firstname_sector "Sector in which First Name works"
label define firstname_sector 1 "Agriculture" 2 "Manufacturing" 3 "Construction" 4 "Personal Services" 5 "Retail or wholesale" 6 "Transportation and Storage" 7 "Accomodation and food services" 8 "Information and communication" 9 "Law Enforcement" 10 "Financial Activities" 11 "Education" 12 "Health" 13 "Commerical Services" 14 "Government" 15 "NGO or non-profit" 16 "Housewife/Homemaker" 17 "Student" 18 "Unemployed" 19 "Retired/Too old to work" 98 "Don't Know" 88 "Other"
label values firstname_sector firstname_sector

gen if_firstname_agriculture = sec_1_a_q_7a_4
label variable if_firstname_agriculture "If first name worked in agriculture, please specify"
label define if_firstname_agriculture 1 "Market gardeners and crop growers" 2 "Animal Producers" 3 "Mixed Crop and Animal Producers" 4 "Subsistence crop farmers" 5 "Subsistence livestock farmers" 6 "Subsistence mixed crop and livestock farmers" 7 "Crop farm laborers" 8 "Livestock/Poultry/Dairy farm laborers" 9 "Mixed crop and livestock/poulty/dairy farm laborers"
label values if_firstname_agriculture if_firstname_agriculture

gen if_firstname_commericalservices = sec_1_a_q_7b_1
label variable if_firstname_commericalservices "If first name worked in commercial services, please specifiy"
label define if_firstname_commericalservices 1 "Mechanic" 2 "Carpenters" 3 "Plumbers electricians" 4 "Tailors, dressmakers, furriers and hatters" 5 "Sewing, embroidery, knitting and related workers" 6 "Shoemakers" 7 "Fur and leather preparing machine operators" 8 "Handicraft workers in wood, basketry, textile and related materials" 9 "Salon worker"
label values if_firstname_commericalservices if_firstname_commericalservices

gen firstname_current_skillset = sec_1_a_q_8_1
label variable firstname_current_skillset "With current skillset what occupation can first name do best"
label define firstname_current_skillset 1 "Agriculture" 2 "Manufacturing" 3 "Construction" 4 "Personal Services" 5 "Retail or wholesale" 6 "Transportation and Storage" 7 "Accomodation and food services" 8 "Information and communication" 9 "Law Enforcement" 10 "Financial Activities" 11 "Education" 12 "Health" 13 "Commerical Services" 14 "Government" 15 "NGO or non-profit" 16 "Housewife/Homemaker" 17 "Student" 18 "Unemployed" 19 "Retired/Too old to work" 98 "Don't Know" 88 "Other"
label values firstname_current_skillset firstname_current_skillset

gen firstname_skillset_agriculture = sec_1_a_q_8a_1
label variable firstname_skillset_agriculture "If first name possess agriculture skill, please specify"
label define firstname_skillset_agriculture 1 "Market gardeners and crop growers" 2 "Animal Producers" 3 "Mixed Crop and Animal Producers" 4 "Subsistence crop farmers" 5 "Subsistence livestock farmers" 6 "Subsistence mixed crop and livestock farmers" 7 "Crop farm laborers" 8 "Livestock/Poultry/Dairy farm laborers" 9 "Mixed crop and livestock/poulty/dairy farm laborers"
label values firstname_skillset_agriculture firstname_skillset_agriculture

gen firstname_skillset_commercial = sec_1_a_q_8b_1
label variable firstname_skillset_commercial "If first name possess comercial skills, please specify"
label define firstname_skillset_commercial 1 "Mechanic" 2 "Carpenters" 3 "Plumbers electricians" 4 "Tailors, dressmakers, furriers and hatters" 5 "Sewing, embroidery, knitting and related workers" 6 "Shoemakers" 7 "Fur and leather preparing machine operators" 8 "Handicraft workers in wood, basketry, textile and related materials" 9 "Salon worker"
label values firstname_skillset_commercial firstname_skillset_commercial

gen firstname_additionaltraining = sec_1_a_q_9_1
label variable firstname_additionaltraining "If first name was provided additional training, which occupation would he/she likely to work in"
label define firstname_additionaltraining 1 "Agriculture" 2 "Manufacturing" 3 "Construction" 4 "Personal Services" 5 "Retail or wholesale" 6 "Transportation and Storage" 7 "Accomodation and food services" 8 "Information and communication" 9 "Law Enforcement" 10 "Financial Activities" 11 "Education" 12 "Health" 13 "Commerical Services" 14 "Government" 15 "NGO or non-profit" 16 "Housewife/Homemaker" 17 "Student" 18 "Unemployed" 19 "Retired/Too old to work" 98 "Don't Know" 88 "Other"
label values firstname_additionaltraining firstname_additionaltraining

gen firstname_atraining_agriculture = sec_1_a_q_9a_1 
label variable firstname_atraining_agriculture "If first name worked in agriculture, please specify"
label define firstname_atraining_agriculture 1 "Market gardeners and crop growers" 2 "Animal Producers" 3 "Mixed Crop and Animal Producers" 4 "Subsistence crop farmers" 5 "Subsistence livestock farmers" 6 "Subsistence mixed crop and livestock farmers" 7 "Crop farm laborers" 8 "Livestock/Poultry/Dairy farm laborers" 9 "Mixed crop and livestock/poulty/dairy farm laborers"
label values firstname_atraining_agriculture firstname_atraining_agriculture

gen firstname_atraining_commercial = sec_1_a_q_9b_1
label variable firstname_atraining_commercial "If first name possess comercial skills, please specify"
label define firstname_atraining_commercial 1 "Mechanic" 2 "Carpenters" 3 "Plumbers electricians" 4 "Tailors, dressmakers, furriers and hatters" 5 "Sewing, embroidery, knitting and related workers" 6 "Shoemakers" 7 "Fur and leather preparing machine operators" 8 "Handicraft workers in wood, basketry, textile and related materials" 9 "Salon worker"
label values firstname_atraining_commercial firstname_atraining_commercial

gen firstname_training_lastyear = sec_1_a_q_10_label_1
label variable firstname_training_lastyear "What kind of training first name received last year?"
label define firstname_training_lastyear 1 "Vocational Training" 2 "Apprenticeship" 3 "On the job training" 4 "No training received" 

gen firstname_willingness = sec_1_a_q_11_1
label variable firstname_willingness "First name willingness to work"
label define firstname_willingness 1 "extremely unwilling" 2 "unwilling" 3 "indifferent" 4 "willing" 5 "extremely willing"
label values firstname_willingness firstname_willingness

gen firstname_disability = sec_1_a_q_12_1
label variable firstname_disability "Does first name has any disability"
label define firstname_disability 1 "Yes" 0 "No"
label values firstname_disability firstname_disability

gen firstname_typeofdisability = sec_1_a_q_13_1
label variable firstname_typeofdisability "First name type of disability"
label define firstname_typeofdisability 1 "Physical Disability" 2 "Mental Disability" 98 " Dont Know"
label values firstname_typeofdisability firstname_typeofdisability

gen firstname_lr_job_lastyear = sec_1_a_q_14_2
label variable firstname_lr_job_lastyear "First name left or returned last year in pursue of job"
label define firstname_lr_job_lastyear 1 "left" 2 "Returned" 3 "Not applicable"
label values firstname_lr_job_lastyear firstname_lr_job_lastyear

tab relationship_to_hh_head 
tab relationship_to_hh_head gender_firstname
tab1 relationship_to_hh_head firstname_age
tab relationship_to_hh_head firstname_typeofdisability
tab1 relationship_to_hh_head firstname_additionaltraining
tab1 relationship_to_hh_head firstname_sector

tab sec_1_a_q_2_1 sec_1_a_q_3_1
tab2 sec_1_a_q_3_1 sec_1_a_q_4_1 sec_1_a_q_2_1
tab sec_1_a_q_3_1 sec_1_a_q_2_1
tab sec_1_a_q_6_1 sec_1_a_q_2_1
tab sec_1_a_q_7_1 sec_1_a_q_3_1
tab sec_1_a_q_10_1 sec_1_a_q_2_1
tab sec_1_a_q_11_1 sec_1_a_q_2_1
*Name 2 are 80% spouse: following are deductions for spouses (females)
tab name_first_2
tab sec_1_a_q_2_2
tab sec_1_a_q_2_2 sec_1_a_q_4_2
tab sec_1_a_q_3_2 sec_1_a_q_2_2
tab sec_1_a_q_6_2 sec_1_a_q_2_2
tab sec_1_a_q_7_2 sec_1_a_q_3_2
tab sec_1_a_q_10_2 sec_1_a_q_2_2
tab sec_1_a_q_11_2 sec_1_a_q_2_2

*discuss HH hire from anywhere else from village
tab sec_1_b_q_2a

*Lending and Borrowing in households 
tab sec_1_b_q_3
graph pie, over(sec_1_b_q_3) plabel(_all percent, color(white) size(vsmall) orientation(horizontal) format(%4.0g)) title(Does the Household Lend or Borrow Livestock (including Poultry) to other Households in the Village?, size(small))
tab sec_1_b_q_4
graph pie, over(sec_1_b_q_4) plabel(_all percent, color(white) size(tiny) orientation(horizontal) format(%4.0g)) title(Does the Household Lend or Borrow Produce Food Items to other Households in the Village?, size(small))

*discuss work oppertunities and budegting 
tab sec_1_b_q_5
tab sec_1_b_q_6
tab sec_1_b_q_7_1
tab sec_1_b_q_7_2
tab sec_1_b_q_7_3
tab sec_1_b_q_7_4
graph pie, over(sec_1_b_q_7_1) plabel(_all percent, color(white) size(vsmall) orientation(horizontal) format(%4.0g)) title(1st Priority, size(medsmall)) legend(on size(small) linegap(vsmall))
graph pie, over(sec_1_b_q_7_2) plabel(_all percent, color(white) size(vsmall) orientation(horizontal) format(%4.0g)) title(2nd Priority, size(medsmall)) legend(on size(small) linegap(vsmall))
graph pie, over(sec_1_b_q_7_3) plabel(_all percent, color(white) size(vsmall) orientation(horizontal) format(%4.0g)) title(3rd Priority, size(medsmall)) legend(on size(small) linegap(vsmall))

*WOMEN IN HOUSEHOLD 
*Number of individuals living in a HH
tab sec_1_a_q_01, missing 

*Number of women/girls over the age of 14 living in a households
tab sec_1_a_q_02, missing 
sum sec_1_a_q_02, detail

*All variables have 8 responses this means that xyz households had abc girls over the age of 14 years 
*last 3 jobs: 
tab1 sec_1c3_q_1a_1 sec_1c3_q_1a_2 sec_1c3_q_1a_3 sec_1c3_q_1a_4 sec_1c3_q_1a_5 sec_1c3_q_1a_6 sec_1c3_q_1a_7 sec_1c3_q_1a_8
*type of work:
tab1 sec_1c3_q_1b_1 sec_1c3_q_1b_2 sec_1c3_q_1b_3 sec_1c3_q_1b_4 sec_1c3_q_1b_5 sec_1c3_q_1b_6 sec_1c3_q_1b_7 sec_1c3_q_1b_8 , missing
*paid or unpaid: 
tab1 sec_1c3_q_1c_1 sec_1c3_q_1c_2 sec_1c3_q_1c_3 sec_1c3_q_1c_4 sec_1c3_q_1c_5 sec_1c3_q_1c_6 sec_1c3_q_1c_7 sec_1c3_q_1c_8 , missing

*CURRENT LEVEL OF SKILLS 
*BASIC STANDARD SKILS 
tab1 sec_1c3_q_3a_1 sec_1c3_q_3a_2 sec_1c3_q_3a_3 sec_1c3_q_3a_4 sec_1c3_q_3a_5 sec_1c3_q_3a_6 sec_1c3_q_3a_7 sec_1c3_q_3a_8 , missing
*ADVANCED STANDARD SKILLS
tab1 sec_1c3_q_3b_1 sec_1c3_q_3b_2 sec_1c3_q_3b_3 sec_1c3_q_3b_4 sec_1c3_q_3b_5 sec_1c3_q_3b_6 sec_1c3_q_3b_7 sec_1c3_q_3b_8 , missing
*BASIC SOFT SKILLS
tab1 sec_1c3_q_3c_1 sec_1c3_q_3c_2 sec_1c3_q_3c_3 sec_1c3_q_3c_4 sec_1c3_q_3c_5 sec_1c3_q_3c_6 sec_1c3_q_3c_7 sec_1c3_q_3c_8 , missing 
*ADVANCED SOFT SKILLS  
tab1 sec_1c3_q_3d_1 sec_1c3_q_3d_2 sec_1c3_q_3d_3 sec_1c3_q_3d_4 sec_1c3_q_3d_5 sec_1c3_q_3d_6 sec_1c3_q_3d_7 sec_1c3_q_3d_8 , missing

*WHAT SKILL NEED TO LEARN 
*BASIC STANDARD SKILS 
tab1 sec_1c3_q_4a_1 sec_1c3_q_4a_2 sec_1c3_q_4a_3 sec_1c3_q_4a_4 sec_1c3_q_4a_5 sec_1c3_q_4a_6 sec_1c3_q_4a_7 sec_1c3_q_4a_8 , missing
*ADVANCED STANDARD SKILLS
tab1 sec_1c3_q_4b_1 sec_1c3_q_4b_2 sec_1c3_q_4b_3 sec_1c3_q_4b_4 sec_1c3_q_4b_5 sec_1c3_q_4b_6 sec_1c3_q_4b_7 sec_1c3_q_4b_8 , missing
*BASIC SOFT SKILLS
tab1 sec_1c3_q_4c_1 sec_1c3_q_4c_2 sec_1c3_q_4c_3 sec_1c3_q_4c_4 sec_1c3_q_4c_5 sec_1c3_q_4c_6 sec_1c3_q_4c_7 sec_1c3_q_4c_8 , missing 
*ADVANCED SOFT SKILLS  
tab1 sec_1c3_q_4d_1 sec_1c3_q_4d_2 sec_1c3_q_4d_3 sec_1c3_q_4d_4 sec_1c3_q_4d_5 sec_1c3_q_4d_6 sec_1c3_q_4d_7 sec_1c3_q_4d_8 , missing

***********************************************************************

****************SECTION 2*****************

*In section 2,2A, 2B, 2C, 2D were asked for the people who identified with a particular current employment status 
* The total for these four sub-sections is different from the totals in mod2_q CURRENT EMPLOYMENT STATUS variable 
*the reason for the difference is human error. The difference in totals will be give or take 5 surveys: which does not impact the findings 
*while there is human error in data collection, it is miniscule and does not impact the analysis 

*Top 2 nominees data analysis from section 1 & 2

*Top 2 members basic information 
tab sec1c_1
tab sec1c_3, missing
graph pie, over(sec1c_3) title(Primary Reason for Selecting the top 2 members of the Household, size(medsmall)) legend(size(small)) scheme(s1color)
graph bar (count) if sec1c_3==1 | sec1c_3==4 | sec1c_3==2, over(sec1c_3) blabel(bar) ytitle(Percent) title(Top 3 Reasons for Selecting the Two Nominees)
tab sec1c_3_1, missing
graph pie, over(sec1c_3_1) title(Secondary Reason for Selecting the top 2 members of the Household, size(medsmall)) legend(size(small)) scheme(s1color)
tab sec1c_4, missing
*self reported health scale 
tab sec1c_6, missing
tab sec1c_6_1, missing

*what skills should top two people learn 
*person 1
tab sec_1c2_q_1_1, missing
tab sec_1c2_q_1a_1, missing
tab sec_1c2_q_1b_1, missing
*person 2
tab sec_1c2_q_1_2, missing
tab sec_1c2_q_1a_2, missing
tab sec_1c2_q_1b_2, missing
*Current level of skill 
*PERSON 1
*Basic Standard skill
tab sec_1c2_q_2a_1, missing
*advanced standard skill
tab sec_1c2_q_2b_1, missing
*basic soft skill 
tab sec_1c2_q_2c_1, missing
*advanced soft skill 
tab sec_1c2_q_2d_1, missing
*PERSON 2
*Basic Standard skill
tab sec_1c2_q_2a_2, missing
*advanced standard skill
tab sec_1c2_q_2b_2, missing
*basic soft skill 
tab sec_1c2_q_2c_2, missing
*advanced soft skill 
tab sec_1c2_q_2d_2, missing
*What level of skill training is needed? 
*PERSON 1
*Basic Standard skill
tab sec_1c2_q_3a_1, missing
*advanced standard skill
tab sec_1c2_q_3b_1, missing
*basic soft skill 
tab sec_1c2_q_3c_1, missing
*advanced soft skill 
tab sec_1c2_q_3d_1, missing
*PERSON 2
*Basic Standard skill
tab sec_1c2_q_3a_2, missing
*advanced standard skill
tab sec_1c2_q_3b_2, missing
*basic soft skill 
tab sec_1c2_q_3c_2, missing
*advanced soft skill 
tab sec_1c2_q_3d_2, missing
*Effect on Income if learn the identified skill (self reported)
tab sec_1c2_q_4_1, missing
sum sec_1c2_q_4_1, detail
tab sec_1c2_q_4_2, missing
sum sec_1c2_q_4_2, detail
*Potential risks for working in desired occupations
tab sec_1c2_q_5_1, missing
tab sec_1c2_q_5_desc_1
tab sec_1c2_q_5_2, missing

*Destringing top 2 nominees data to identify gender and relation to HH head for selected people
tab sec1c_1
gen first_nominee=substr( sec1c_1,1,1)
gen second_nominee=substr( sec1c_1,3,4)
destring first_nominee second_nominee,replace
tab first_nominee
tab second_nominee

*Gender & relation to HH head of top 2 nominees 
*1st nominee
tab sec_1_a_q_3_1 sec_1_a_q_2_1 if first_nominee ==1 
tab sec_1_a_q_3_2 sec_1_a_q_2_2 if first_nominee ==2
tab sec_1_a_q_3_3 sec_1_a_q_2_3 if first_nominee ==3
tab sec_1_a_q_3_4 sec_1_a_q_2_4 if first_nominee ==4
tab sec_1_a_q_3_5 sec_1_a_q_2_5 if first_nominee ==5
tab sec_1_a_q_3_6 sec_1_a_q_2_6 if first_nominee ==6
tab sec_1_a_q_3_7 sec_1_a_q_2_7 if first_nominee ==7
tab sec_1_a_q_3_8 sec_1_a_q_2_8 if first_nominee ==8
tab sec_1_a_q_3_9 sec_1_a_q_2_9 if first_nominee ==9

*2nd nominee
tab sec_1_a_q_3_2 sec_1_a_q_2_2 if second_nominee ==2
tab sec_1_a_q_3_3 sec_1_a_q_2_3 if second_nominee ==3
tab sec_1_a_q_3_4 sec_1_a_q_2_4 if second_nominee ==4
tab sec_1_a_q_3_5 sec_1_a_q_2_5 if second_nominee ==5
tab sec_1_a_q_3_6 sec_1_a_q_2_6 if second_nominee ==6
tab sec_1_a_q_3_7 sec_1_a_q_2_7 if second_nominee ==7
tab sec_1_a_q_3_8 sec_1_a_q_2_8 if second_nominee ==8
tab sec_1_a_q_3_9 sec_1_a_q_2_9 if second_nominee ==9
tab sec_1_a_q_3_10 sec_1_a_q_2_10 if second_nominee ==10 

*education of nominee 1 & 2
*1st nominee
tab sec_1_a_q_4_1 sec_1_a_q_3_1 if first_nominee ==1
tab sec_1_a_q_4_2 sec_1_a_q_3_2 if first_nominee ==2 
tab sec_1_a_q_4_3 sec_1_a_q_3_3 if first_nominee ==3
tab sec_1_a_q_4_4 sec_1_a_q_3_4 if first_nominee ==4
tab sec_1_a_q_4_5 sec_1_a_q_3_5 if first_nominee ==5
tab sec_1_a_q_4_6 sec_1_a_q_3_6 if first_nominee ==6
tab sec_1_a_q_4_7 sec_1_a_q_3_7 if first_nominee ==7
tab sec_1_a_q_4_8 sec_1_a_q_3_8 if first_nominee ==8
tab sec_1_a_q_4_9 sec_1_a_q_3_9 if first_nominee ==9

*2st nominee
tab sec_1_a_q_4_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_1_a_q_4_3 sec_1_a_q_3_3 if second_nominee ==3
tab sec_1_a_q_4_4 sec_1_a_q_3_4 if second_nominee ==4
tab sec_1_a_q_4_5 sec_1_a_q_3_5 if second_nominee ==5
tab sec_1_a_q_4_6 sec_1_a_q_3_6 if second_nominee ==6
tab sec_1_a_q_4_7 sec_1_a_q_3_7 if second_nominee ==7
tab sec_1_a_q_4_8 sec_1_a_q_3_8 if second_nominee ==8
tab sec_1_a_q_4_9 sec_1_a_q_3_9 if second_nominee ==9
tab sec_1_a_q_4_10 sec_1_a_q_3_10 if second_nominee ==10


*Empoyemnt status of person 1 
tab mod2_q0,missing
label var mod2_q0_1 "Unemployed(but looking/interested in working"
tab mod2_q0_1
label var mod2_q0_2 "Employed (Any work but NOT seasonal or self-employed"
tab mod2_q0_2
label var mod2_q0_3 "Self Employed"
tab mod2_q0_3
label var mod2_q0_4 "Seasonal Work"
tab mod2_q0_4
label var mod2_q0_5 "Currently Unemployed (never worked and not interested"
tab mod2_q0_5
label var mod2_q0_6 "Never worked but interested in working"
tab mod2_q0_6
label var mod2_q0_7 "Student"
tab mod2_q0_7
*Employment status of person 2
tab mod2_q1,missing
label var mod2_q1_1 "Unemployed(but looking/interested in working"
tab mod2_q1_1
label var mod2_q1_2 "Employed (Any work but NOT seasonal or self-employed"
tab mod2_q1_2
label var mod2_q1_3 "Self Employed"
tab mod2_q1_3
label var mod2_q1_4 "Seasonal Work"
tab mod2_q1_4
label var mod2_q1_5 "Currently Unemployed (never worked and not interested"
tab mod2_q1_5
label var mod2_q1_6 "Never worked but interested in working"
tab mod2_q1_6
label var mod2_q1_7 "Student"
tab mod2_q1_7

*2E FUTURE EMPLOYMENT 
recode sec2e_1_2 . = 0
tab sec2e_1_1, missing
tab sec2e_1_2, missing
* start which income generating activity by gender 
tab sec2e_1_1, missing
tab first_nominee
tab sec2e_2_1
tab sec2e_2_2
*first nominee 
tab sec2e_2_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2e_2_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_2_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_2_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_2_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_2_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_2_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_2_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_2_1 sec_1_a_q_3_9  if first_nominee ==9
*if commercial of agricultrure?
tab sec2e_2_1_1
tab sec2e_2_2_1

*Second nominee 
tab second_nominee
tab sec2e_1_2, missing
tab sec2e_2_2 
tab sec2e_2_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2e_2_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2e_2_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2e_2_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2e_2_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2e_2_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2e_2_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2e_2_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2e_2_2 sec_1_a_q_3_10 if second_nominee ==10
*if commercial of agricultrure?
tab sec2e_2_1_2
tab sec2e_2_2_2
*those who selected others 
tab sec2e_2_desc_1
tab sec2e_2_desc_2

*reason for starting new activity
tab sec2e_3_1, missing
tab sec2e_3_2, missing
tab2 sec2e_3_1 sec_1_a_q_3_1 if first_nominee ==1
tab sec2e_3_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_3_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_3_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_3_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_3_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_3_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_3_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_3_1 sec_1_a_q_3_9  if first_nominee ==9
tab sec2e_3_2 sec_1_a_q_3_2 if second_nominee ==2

*what kind of direct assistance would you need 
tab sec2e_4_1
tab sec2e_4_2
tab sec2e_4_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2e_4_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_4_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_4_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_4_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_4_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_4_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_4_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_4_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2e_4_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2e_4_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2e_4_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2e_4_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2e_4_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2e_4_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2e_4_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2e_4_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2e_4_2 sec_1_a_q_3_10 if second_nominee ==10

*what skill required
*shows same pattern as where want to start new occupation so not really alot of insights 
tab sec2e_5_1
tab sec2e_5_2
tab sec2e_5_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2e_5_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_5_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_5_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_5_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_5_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_5_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_5_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_5_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2e_5_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2e_5_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2e_5_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2e_5_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2e_5_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2e_5_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2e_5_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2e_5_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2e_5_2 sec_1_a_q_3_10 if second_nominee ==10

tab sec2e_5_1_1
tab sec2e_5_1_2
tab sec2e_5_2_1
tab sec2e_5_2_2

*confidence in pursuing occupation in next 5 years (self reported)
*majority people seemed fairly confident (score between 5-10)
*women more so then men but not by alot 
tab sec2e_6_1
tab sec2e_6_2

tab sec2e_6_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2e_6_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_6_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_6_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_6_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_6_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_6_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_6_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_6_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2e_6_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2e_6_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2e_6_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2e_6_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2e_6_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2e_6_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2e_6_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2e_6_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2e_6_2 sec_1_a_q_3_10 if second_nominee ==10

*barriers 
tab sec2e_7_1
tab sec2e_7_2

tab sec2e_7_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2e_7_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_7_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_7_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_7_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_7_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_7_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_7_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_7_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2e_7_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2e_7_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2e_7_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2e_7_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2e_7_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2e_7_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2e_7_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2e_7_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2e_7_2 sec_1_a_q_3_10 if second_nominee ==10

*current oppertunities
tab sec2e_8_1
tab sec2e_8_2
tab sec2e_8_desc_1
tab sec2e_8_desc_2

tab sec2e_8_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2e_8_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2e_8_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2e_8_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2e_8_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2e_8_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2e_8_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2e_8_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2e_8_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2e_8_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2e_8_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2e_8_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2e_8_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2e_8_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2e_8_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2e_8_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2e_8_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2e_8_2 sec_1_a_q_3_10 if second_nominee ==10

*2D SEASONAL EMPLOYMENT
tab mod2_q0_4, missing
tab mod2_q1_4, missing

*where does business normally operate 
*Total sample coming here for 35 observations
*total 4 females engaged in seasonal work, 31 men  
tab sec2d_2_1 sec_1_a_q_3_1  
tab sec2d_2_2 sec_1_a_q_3_2

tab sec2d_2_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2d_2_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2d_2_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2d_2_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2d_2_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2d_2_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2d_2_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2d_2_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2d_2_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2d_2_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2d_2_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2d_2_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2d_2_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2d_2_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2d_2_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2d_2_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2d_2_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2d_2_2 sec_1_a_q_3_10 if second_nominee ==10

*Household characteristics 
tab sec2d_5_1 
tab sec2d_5_2 
tab sec2d_5_1_1  
tab sec2d_5_1_2 
tab sec2d_6_1
sum sec2d_6_1, detail
tab sec2d_6_2
sum sec2d_6_2, detail
tab sec2d_7_1
sum sec2d_7_1, detail
tab sec2d_7_2
sum sec2d_7_2, detail
tab sec2d_8_1 
tab sec2d_8_2 
*Best and worst months for seasonal earning
tab sec2d_9_1 
tab sec2d_9_2 
tab sec2d_10_1 
tab sec2d_10_2 
*Barriers 
tab sec2d_11_1 
tab sec2d_11_2
tab sec2d_11_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2d_11_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2d_11_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2d_11_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2d_11_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2d_11_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2d_11_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2d_11_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2d_11_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2d_11_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2d_11_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2d_11_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2d_11_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2d_11_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2d_11_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2d_11_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2d_11_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2d_11_2 sec_1_a_q_3_10 if second_nominee ==10

*Household income effected 
tab sec2d_12_1 
tab sec2d_12_2
tab sec2d_12_1_1 
tab sec2d_12_1_2
tab sec2d_13_1 
tab sec2d_13_2
tab sec2d_13_1_1 
tab sec2d_13_1_2
tab sec2d_12_1_1
tab sec2d_12_1_2

*How has income been effected by reasons identified 
label var sec2D_12_1_1 "how have the reasons you identified affected your HH income"
label var sec2D_12_1_2 "how have the reasons you identified affected your HH income"
tab sec2D_12_1_1
tab sec2D_12_1_2

*2A: UNEMPLOYED
tab mod2_q0_1
tab mod2_q1_1
*Why not working anymore 
tab sec_2a_q_1_1
tab sec_2a_q_1_2 
tab sec_2a_q_1_desc_1
tab sec_2a_q_1_desc_2

tab sec_2a_q_1_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2a_q_1_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2a_q_1_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2a_q_1_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2a_q_1_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2a_q_1_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2a_q_1_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2a_q_1_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2a_q_1_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2a_q_1_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2a_q_1_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2a_q_1_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2a_q_1_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2a_q_1_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2a_q_1_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2a_q_1_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2a_q_1_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2a_q_1_2 sec_1_a_q_3_10 if second_nominee ==10

*How long unemployment
*unemployed for more than a year  
tab sec_2a_q_2_1
tab sec_2a_q_2_2

*Looking for new work 
*P1: out of 242, 98 (40.5%) look for new work 
*P2: out of 78, 21 (26.92%) look for new work 
tab sec_2a_q_3_1
tab sec_2a_q_3_2
*Methods of looking for work 
*first main method
tab sec_2a_q_5_1_1
tab sec_2a_q_5_1_2

tab sec_2a_q_5_1_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2a_q_5_1_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2a_q_5_1_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2a_q_5_1_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2a_q_5_1_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2a_q_5_1_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2a_q_5_1_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2a_q_5_1_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2a_q_5_1_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2a_q_5_1_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2a_q_5_1_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2a_q_5_1_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2a_q_5_1_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2a_q_5_1_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2a_q_5_1_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2a_q_5_1_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2a_q_5_1_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2a_q_5_1_2 sec_1_a_q_3_10 if second_nominee ==10

*second method 
tab sec_2a_q_5_2_1
tab sec_2a_q_5_2_2

tab sec_2a_q_5_2_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2a_q_5_2_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2a_q_5_2_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2a_q_5_2_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2a_q_5_2_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2a_q_5_2_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2a_q_5_2_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2a_q_5_2_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2a_q_5_2_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2a_q_5_2_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2a_q_5_2_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2a_q_5_2_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2a_q_5_2_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2a_q_5_2_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2a_q_5_2_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2a_q_5_2_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2a_q_5_2_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2a_q_5_2_2 sec_1_a_q_3_10 if second_nominee ==10

*Look for work in another city 
*only total of 5 out of 320 said yes:too little a sample to carry an analysis 
tab sec_2a_q_6_1
tab sec_2a_q_6_2
tab sec_2a_q_7_1
tab sec_2a_q_7_2
*willingness to travel for work 
*5 KM
tab sec_2a_q_8_1
tab sec_2a_q_8_2
*away from home for several days a week
*above question asked for only 5 respondents, this Q asked for all=error in coding survey
tab sec_2a_q_9_1
tab sec_2a_q_9_2

*Most helpful factor in getting work by gender
*voctaional traning and financial resources 
tab sec_2a_q_10_1
tab sec_2a_q_10_2

tab sec_2a_q_10_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2a_q_10_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2a_q_10_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2a_q_10_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2a_q_10_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2a_q_10_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2a_q_10_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2a_q_10_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2a_q_10_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2a_q_10_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2a_q_10_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2a_q_10_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2a_q_10_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2a_q_10_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2a_q_10_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2a_q_10_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2a_q_10_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2a_q_10_2 sec_1_a_q_3_10 if second_nominee ==10

*bariers by gedner
*family disapproval & lack of financial resources 
tab sec_2a_q_11_1
tab sec_2a_q_11_2

tab sec_2a_q_11_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2a_q_11_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2a_q_11_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2a_q_11_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2a_q_11_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2a_q_11_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2a_q_11_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2a_q_11_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2a_q_11_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2a_q_11_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2a_q_11_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2a_q_11_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2a_q_11_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2a_q_11_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2a_q_11_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2a_q_11_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2a_q_11_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2a_q_11_2 sec_1_a_q_3_10 if second_nominee ==10

*2B EMPLOYMENT DETAILS 
tab mod2_q0_2
tab mod2_q1_2

*Number of Hours spent on an activity 
recode sec_2b_q_4_1 (6000 = .)
tab sec_2b_q_4_1
sum sec_2b_q_4_1, detail
tab sec_2b_q_4_2
sum sec_2b_q_4_2, detail

*Recoded one observation as a missing value for nominee 1, 
*as the number of hours recorded were 6000 for one respondent, 
*thus skewing the results. Hence the total for nominee 1 is 128(instead of 129) 

*Number of hours by gender 
tab sec_2b_q_4_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2b_q_4_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2b_q_4_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2b_q_4_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2b_q_4_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2b_q_4_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2b_q_4_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2b_q_4_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2b_q_4_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2b_q_4_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2b_q_4_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2b_q_4_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2b_q_4_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2b_q_4_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2b_q_4_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2b_q_4_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2b_q_4_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2b_q_4_2 sec_1_a_q_3_10 if second_nominee ==10

*Average number of hours by gender
mean sec_2b_q_4_1 if first_nominee ==1, over(sec_1_a_q_3_1)
mean sec_2b_q_4_1 if first_nominee ==2, over(sec_1_a_q_3_2)
mean sec_2b_q_4_1 if first_nominee ==3, over(sec_1_a_q_3_3)
mean sec_2b_q_4_1 if first_nominee ==4, over(sec_1_a_q_3_4)
mean sec_2b_q_4_1 if first_nominee ==5, over(sec_1_a_q_3_5)
mean sec_2b_q_4_1 if first_nominee ==6, over(sec_1_a_q_3_6)
mean sec_2b_q_4_1 if first_nominee ==7, over(sec_1_a_q_3_7)
mean sec_2b_q_4_1 if first_nominee ==8, over(sec_1_a_q_3_8)
*mean sec_2b_q_4_1 if first_nominee ==9, over(sec_1_a_q_3_9)

mean sec_2b_q_4_2 if second_nominee ==2, over(sec_1_a_q_3_2)
*mean sec_2b_q_4_2 if second_nominee ==3, over(sec_1_a_q_3_3)
mean sec_2b_q_4_2 if second_nominee ==4, over(sec_1_a_q_3_4)
mean sec_2b_q_4_2 if second_nominee ==5, over(sec_1_a_q_3_5)
mean sec_2b_q_4_2 if second_nominee ==6, over(sec_1_a_q_3_6)
mean sec_2b_q_4_2 if second_nominee ==7, over(sec_1_a_q_3_7)
mean sec_2b_q_4_2 if second_nominee ==8, over(sec_1_a_q_3_8)
mean sec_2b_q_4_2 if second_nominee ==9, over(sec_1_a_q_3_9)
*mean sec_2b_q_4_2 if second_nominee ==10, over(sec_1_a_q_3_10)

*Number of hours by education 
tab sec_2b_q_4_1 sec_1_a_q_4_1  if first_nominee ==1
tab sec_2b_q_4_1 sec_1_a_q_4_2  if first_nominee ==2
tab sec_2b_q_4_1 sec_1_a_q_4_3  if first_nominee ==3
tab sec_2b_q_4_1 sec_1_a_q_4_4  if first_nominee ==4
tab sec_2b_q_4_1 sec_1_a_q_4_5  if first_nominee ==5
tab sec_2b_q_4_1 sec_1_a_q_4_6  if first_nominee ==6
tab sec_2b_q_4_1 sec_1_a_q_4_7  if first_nominee ==7
tab sec_2b_q_4_1 sec_1_a_q_4_8  if first_nominee ==8
tab sec_2b_q_4_1 sec_1_a_q_4_9  if first_nominee ==9

tab sec_2b_q_4_2 sec_1_a_q_4_2 if second_nominee ==2
tab sec_2b_q_4_2 sec_1_a_q_4_3 if second_nominee ==3
tab sec_2b_q_4_2 sec_1_a_q_4_4 if second_nominee ==4
tab sec_2b_q_4_2 sec_1_a_q_4_5 if second_nominee ==5
tab sec_2b_q_4_2 sec_1_a_q_4_6 if second_nominee ==6
tab sec_2b_q_4_2 sec_1_a_q_4_7 if second_nominee ==7
tab sec_2b_q_4_2 sec_1_a_q_4_8 if second_nominee ==8
tab sec_2b_q_4_2 sec_1_a_q_4_9 if second_nominee ==9
tab sec_2b_q_4_2 sec_1_a_q_4_10 if second_nominee ==10

*Average number of hours by education
mean sec_2b_q_4_1 if first_nominee ==1, over(sec_1_a_q_4_1)
mean sec_2b_q_4_1 if first_nominee ==2, over(sec_1_a_q_4_2)
mean sec_2b_q_4_1 if first_nominee ==3, over(sec_1_a_q_4_3)
mean sec_2b_q_4_1 if first_nominee ==4, over(sec_1_a_q_4_4)
mean sec_2b_q_4_1 if first_nominee ==5, over(sec_1_a_q_4_5)
mean sec_2b_q_4_1 if first_nominee ==6, over(sec_1_a_q_4_6)
mean sec_2b_q_4_1 if first_nominee ==7, over(sec_1_a_q_4_7)
mean sec_2b_q_4_1 if first_nominee ==8, over(sec_1_a_q_4_8)
*mean sec_2b_q_4_1 if first_nominee ==9, over(sec_1_a_q_4_9)

mean sec_2b_q_4_2 if second_nominee ==2, over(sec_1_a_q_4_2)
*mean sec_2b_q_4_2 if second_nominee ==3, over(sec_1_a_q_4_3)
mean sec_2b_q_4_2 if second_nominee ==4, over(sec_1_a_q_4_4)
mean sec_2b_q_4_2 if second_nominee ==5, over(sec_1_a_q_4_5)
mean sec_2b_q_4_2 if second_nominee ==6, over(sec_1_a_q_4_6)
mean sec_2b_q_4_2 if second_nominee ==7, over(sec_1_a_q_4_7)
mean sec_2b_q_4_2 if second_nominee ==8, over(sec_1_a_q_4_8)
mean sec_2b_q_4_2 if second_nominee ==9, over(sec_1_a_q_4_9)
*mean sec_2b_q_4_2 if second_nominee ==10, over(sec_1_a_q_4_10)

*Main employers
tab sec_2b_q_10_1
tab sec_2b_q_10_2
tab sec_2b_q_10_desc_1
tab sec_2b_q_10_desc_2
tab sec_2b_q_10_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec_2b_q_10_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec_2b_q_10_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec_2b_q_10_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec_2b_q_10_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec_2b_q_10_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec_2b_q_10_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec_2b_q_10_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec_2b_q_10_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec_2b_q_10_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec_2b_q_10_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec_2b_q_10_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec_2b_q_10_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec_2b_q_10_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec_2b_q_10_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec_2b_q_10_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec_2b_q_10_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec_2b_q_10_2 sec_1_a_q_3_10 if second_nominee ==10

*Loss of job due to COVID
tab sec_2b_q_22_1
tab sec_2b_q_22_2

*2C SELF_EMPLOYMENT 
tab mod2_q0_3
tab mod2_q1_3
*description of business 
tab sec2c_1_1
tab sec2c_1_2
tab sec2c_1_3
*type of business 
*Nominee 1
tab sec2c_2_1
tab sec2c_2_1_1
tab sec2c_2_2_1
*Nominee 2
label var sec2c_2_2 "What kind of business is this"
tab sec2c_2_2
label var sec2c_2_1_2 "if agriculture, then specify"
tab sec2c_2_1_2
label var sec2c_2_2_2 "if commercial, then specify"
tab sec2c_2_2_2
*Nominee 3
**Both retail/wholesale 
label var sec2c_2_3 "What kind of business is this"
tab sec2c_2_3
*How many HH and non HH members work in the business 
tab sec2c_4_1
tab sec2c_4_1_2
tab sec2c_4_3
tab sec2c_5_1
tab sec2c_5_2
tab sec2c_5_3
*How did HH obatin the resources needed
tab sec2c_18_1
tab sec2c_18_2
tab sec2c_18_3
*what skills use in business?
*Nominee 1
tab sec2c_22_1
tab sec2c_22_1_1
tab sec2c_22_2_1
*Nominee 2
label var sec2c_22_2 "What skills do you use in your business"
tab sec2c_22_2
label var sec2c_22_1_2 "If agriculture, please specify"
tab sec2c_22_1_2
label var sec2c_22_2_2 "If commercial, please specify"
tab sec2c_22_2_2
*Nominee 3
label var sec2c_22_3 "What skill do you use in your business"
tab sec2c_22_3
*Barriers in running/starting a business
tab sec2c_23_1
tab sec2c_23_2
tab sec2c_23_3
*by gender
tab sec2c_23_1 sec_1_a_q_3_1  if first_nominee ==1
tab sec2c_23_1 sec_1_a_q_3_2  if first_nominee ==2
tab sec2c_23_1 sec_1_a_q_3_3  if first_nominee ==3
tab sec2c_23_1 sec_1_a_q_3_4  if first_nominee ==4
tab sec2c_23_1 sec_1_a_q_3_5  if first_nominee ==5
tab sec2c_23_1 sec_1_a_q_3_6  if first_nominee ==6
tab sec2c_23_1 sec_1_a_q_3_7  if first_nominee ==7
tab sec2c_23_1 sec_1_a_q_3_8  if first_nominee ==8
tab sec2c_23_1 sec_1_a_q_3_9  if first_nominee ==9

tab sec2c_23_2 sec_1_a_q_3_2 if second_nominee ==2
tab sec2c_23_2 sec_1_a_q_3_3 if second_nominee ==3
tab sec2c_23_2 sec_1_a_q_3_4 if second_nominee ==4
tab sec2c_23_2 sec_1_a_q_3_5 if second_nominee ==5
tab sec2c_23_2 sec_1_a_q_3_6 if second_nominee ==6
tab sec2c_23_2 sec_1_a_q_3_7 if second_nominee ==7
tab sec2c_23_2 sec_1_a_q_3_8 if second_nominee ==8
tab sec2c_23_2 sec_1_a_q_3_9 if second_nominee ==9
tab sec2c_23_2 sec_1_a_q_3_10 if second_nominee ==10

tab sec2c_23_3 sec_1_a_q_3_1  if first_nominee ==1

*by type of business
tab sec2c_2_1
tab sec2c_2_2
tab sec2c_2_3

tab sec2c_23_1 sec2c_2_1 if first_nominee ==1
tab sec2c_23_1 sec2c_2_1 if first_nominee ==2
tab sec2c_23_1 sec2c_2_1 if first_nominee ==3
tab sec2c_23_1 sec2c_2_1 if first_nominee ==4
tab sec2c_23_1 sec2c_2_1 if first_nominee ==5
tab sec2c_23_1 sec2c_2_1 if first_nominee ==6
tab sec2c_23_1 sec2c_2_1 if first_nominee ==7
tab sec2c_23_1 sec2c_2_1 if first_nominee ==8
tab sec2c_23_1 sec2c_2_1 if first_nominee ==9

tab sec2c_23_2 sec2c_2_2 if second_nominee ==2
tab sec2c_23_2 sec2c_2_2 if second_nominee ==3
tab sec2c_23_2 sec2c_2_2 if second_nominee ==4
tab sec2c_23_2 sec2c_2_2 if second_nominee ==5
tab sec2c_23_2 sec2c_2_2 if second_nominee ==6
tab sec2c_23_2 sec2c_2_2 if second_nominee ==7
tab sec2c_23_2 sec2c_2_2 if second_nominee ==8
tab sec2c_23_2 sec2c_2_2 if second_nominee ==9
tab sec2c_23_2 sec2c_2_2 if second_nominee ==10

tab sec2c_23_3 sec2c_2_3 if first_nominee ==1

********************************************************


**************SECTION 3*****************
*land owned & tenancy
ssc install univar
tab sec3a_1
sum sec3a_1, detail
univar sec3a_1 if sec3a_1 != 0
sum sec3a_1 if sec3a_1 != 0
tab sec3a_1_1
sum sec3a_1_1, detail
sum sec3a_1_1 if sec3a_1_1 != 0
univar sec3a_1_1
univar sec3a_1_1 if sec3a_1_1 != 0
tab sec3a_2, missing

*Crops cultivated 
tab sec3a_3 
tab sec3a_3 if sec3a_3 != .
tab sec3a_crop_type
tab sec3a_crop_type, nolabel
tab sec3a_crop_type if sec3a_crop_type == "Cotton"
tab sec3a_crop_type_label
tab sec3a_crop_type_label if sec3a_crop_type_label == "Cotton" 
tab sec3a_crop_type_label if sec3a_crop_type_label == "Wheat" 
tab sec3a_crop_type_label if sec3a_crop_type_label == "Rice" 
tab sec3a_crop_type_label if sec3a_crop_type_label == "Sugar Cane"
*COTTON
tab sec3a_cotton_1
sum sec3a_cotton_2, detail
tab sec3a_cotton_2
tab sec3a_cotton_3_desc
graph pie, over(sec3a_cotton_3) plabel(_all percent, color(white) size(small)) plabel(4 percent, color(white)) title(What new Skills would households like to learn for cotton farming?, size(medsmall)) legend(on)
*RICE
tab sec3a_rice_1
sum sec3a_rice_2, detail
tab sec3a_cotton_2
tab sec3a_rice_3_desc
graph pie, over(sec3a_rice_3) plabel(_all percent, color(white) size(small)) plabel(4 percent, color(white)) title(What new Skills would households like to learn for Rice farming?, size(medsmall)) legend(on)
*SUGARCANE
tab sec3a_sugarcane_1
sum sec3a_sugarcane_2, detail
tab sec3a_sugarcane_2
tab sec3a_sugarcane_3_desc
graph pie, over(sec3a_sugarcane_3) plabel(_all percent, color(white) size(small)) plabel(4 percent, color(white)) title(What new Skills would households like to learn for Sugarcane farming?, size(medsmall)) legend(on)
*WHEAT
tab sec3a_wheat_1
sum sec3a_wheat_2, detail
tab sec3a_wheat_2
tab sec3a_wheat_3_desc
graph pie, over(sec3a_wheat_3) plabel(_all percent, color(white) size(small)) plabel(4 percent, color(white)) title(What new Skills would households like to learn for Wheat farming?, size(medsmall)) legend(on)
* BISP question
tab sec_3b_19, missing
graph pie, over(sec_3b_19) plabel(_all percent, color(white) size(vsmall)) title(Has your Household received a cash grant through BISP, size(medium)) legend(on size(small))
tab sec_3b_20
tab sec_3b_23
*Technology 
tab sec_3b_1
numlabel sec_3b_1, add 
graph pie, over(sec_3b_1) plabel(_all percent, color(white) size(small)) title(Access of Household to Internet/Wifi, size(medlarge))
tab sec_3b_2
tab sec_3b_2_1, missing
tab sec_3b_3
tab sec_3b_3_1
tab sec_3b_3_desc, missing
*Online Banking
tab sec_3b_4, missing
tab sec_3b_5, nolabel
*top most reason why no bank account
gen sec_3b_5_new = sec_3b_5
label var sec_3b_5_new "Top Most Reason for No Bank A/C"
tab sec_3b_5_new, missing
label define sec_3b_5_VAR 1 "Not enough money" 2 "Bank fee too high" 3 "Bank location not convenient" 4 "Interest rates too low" 5 "Do not Trust Bank" 6 "Bank staff rude/unhelpful" 7 "Not familiar with banks operations" 8 "No advantage of an account" 9 "Was not able to open A/C" 10 "Don't like interest"
label value sec_3b_5_new sec_3b_5_VAR 
numlabel sec_3b_5_VAR, add
tab sec_3b_5_new, missing
histogram sec_3b_5_new, frequency fcolor(maroon) lcolor(maroon) barwidth(0.5) addlabel addlabopts(mlabsize(small)) ytitle(Frequency) xtitle(Top Most Reason) xlabel(#10, labels labsize(tiny) labcolor(black) angle(forty_five) valuelabel ticks tlength(tiny) tposition(crossing)) title(Top Most Reason for Not Having a Bank Account) legend(off)
tab sec_3b_5_1, missing
gen sec_3b_51_new = sec_3b_5_1
label var sec_3b_51_new "Second Top Reason for No Bank A/C"
tab sec_3b_51_new, missing
label value sec_3b_51_new sec_3b_5_VAR 
numlabel sec_3b_5_VAR, add
tab sec_3b_51_new, missing
histogram sec_3b_51_new, frequency fcolor(maroon) lcolor(maroon) barwidth(0.5) addlabel addlabopts(mlabsize(small)) ytitle(Frequency) xtitle(2nd Imp. Reason) xlabel(#10, labels labsize(tiny) labcolor(black) angle(forty_five) valuelabel ticks tlength(tiny) tposition(crossing)) title(Second Top Reason for Not Having a Bank Account) legend(off)
tab sec_3b_6, missing
tab sec_3b_7, missing

tab sec_3b_8
tab sec_3b_2
tab sec_3b_8 if sec_3b_2 ==1
tab sec_3b_9, missing
tab sec_3b_10, missing
*borrowing and lending habits 
tab sec_3b_11, missing
tab sec_3b_12, missing
tab sec_3b_12_desc, missing
tab sec_3b_13, missing
tab sec_3b_13_desc, missing
tab sec_3b_14,missing
tab sec_3b_14_desc,missing
tab sec_3b_15, missing
sum sec_3b_15
*average amount of loan taken
sum sec_3b_15 if sec_3b_11==1 
list sec_3b_15 if sec_3b_11==1
*average amount of loan given
sum sec_3b_15 if sec_3b_11==2
list sec_3b_15 if sec_3b_11==2
*average amount of loan and payback period
tab sec_3b_16, missing
tab sec_3b_17, missing
*loan taken and returned how 
*taken/given in cash returned how?
sum sec_3b_17 if sec_3b_14==1 & sec_3b_17==1
sum sec_3b_17 if sec_3b_14==1 & sec_3b_17==2
sum sec_3b_17 if sec_3b_14==1 & sec_3b_17==3
sum sec_3b_17 if sec_3b_14==1 & sec_3b_17==4
*taken/given in grain returned how? 
sum sec_3b_17 if sec_3b_14==2 & sec_3b_17==1
sum sec_3b_17 if sec_3b_14==2 & sec_3b_17==2
sum sec_3b_17 if sec_3b_14==2 & sec_3b_17==3
sum sec_3b_17 if sec_3b_14==2 & sec_3b_17==4
*taken/given in food returned how? 
sum sec_3b_17 if sec_3b_14==3 & sec_3b_17==1
sum sec_3b_17 if sec_3b_14==3 & sec_3b_17==2
sum sec_3b_17 if sec_3b_14==3 & sec_3b_17==3
sum sec_3b_17 if sec_3b_14==3 & sec_3b_17==4
*taken/given in materia/good returned how? 
sum sec_3b_17 if sec_3b_14==4 & sec_3b_17==1
sum sec_3b_17 if sec_3b_14==4 & sec_3b_17==2
sum sec_3b_17 if sec_3b_14==4 & sec_3b_17==3
sum sec_3b_17 if sec_3b_14==4 & sec_3b_17==4
tab sec_3b_18
sum sec_3b_18

**********************************************************


*************SECTION 4**************
tab sec_4_1, missing
label define categories_PSDF_new 0 "N/A" 1 "least likely" 5 "most likely"

tab sec_4_a, missing
gen sec_4_a_new = sec_4_a
tab sec_4_a_new, missing
tab sec_4_a_new, missing
label values sec_4_a_new categories_PSDF_new
label var sec_4_a_new "Poultry Management and Production"
tab sec_4_a_new, missing
tab sec_4_a_new, nolabel

tab sec_4_b, missing
gen sec_4_b_new = sec_4_b
tab sec_4_b_new, missing
tab sec_4_b_new, missing
label values sec_4_b_new categories_PSDF_new
label var sec_4_b_new "Poultry Technician"
tab sec_4_b_new, missing
tab sec_4_b_new, nolabel

tab sec_4_c, missing
gen sec_4_c_new = sec_4_c
tab sec_4_c_new, missing
tab sec_4_c_new, missing
label values sec_4_c_new categories_PSDF_new
label var sec_4_c_new "Sheep/Goat husbandry"
tab sec_4_c_new, missing
tab sec_4_c_new, nolabel

tab sec_4_d, missing
gen sec_4_d_new = sec_4_d
tab sec_4_d_new, missing
tab sec_4_d_new, missing
label values sec_4_d_new categories_PSDF_new
label var sec_4_d_new "Animal breeding and Nutrition Management"
tab sec_4_d_new, missing
tab sec_4_d_new, nolabel

tab sec_4_e, missing
gen sec_4_e_new = sec_4_e
tab sec_4_e_new, missing
tab sec_4_e_new, missing
label values sec_4_e_new categories_PSDF_new
label var sec_4_e_new "Artificial Insemination"
tab sec_4_e_new, missing
tab sec_4_e_new, nolabel

tab sec_4_f, missing
gen sec_4_f_new = sec_4_f
tab sec_4_e_new, missing
tab sec_4_f_new, missing
label values sec_4_f_new categories_PSDF_new
label var sec_4_f_new "Livestock Management and Production"
tab sec_4_f_new, missing
tab sec_4_f_new, nolabel

tab sec_4_g, missing
gen sec_4_g_new = sec_4_g
tab sec_4_g_new, missing
tab sec_4_g_new, missing
label values sec_4_g_new categories_PSDF_new
label var sec_4_g_new "Livestock Workers and Assistants"
tab sec_4_g_new, missing
tab sec_4_g_new, nolabel

tab sec_4_h, missing
gen sec_4_h_new = sec_4_h
tab sec_4_h_new, missing
tab sec_4_h_new, missing
label values sec_4_h_new categories_PSDF_new
label var sec_4_h_new "Fodder Production Management"
tab sec_4_h_new, missing
tab sec_4_h_new, nolabel

tab sec_4_i, missing
gen sec_4_i_new = sec_4_i
tab sec_4_i_new, missing
tab sec_4_i_new, missing
label values sec_4_i_new categories_PSDF_new
label var sec_4_i_new "Meat Production and Processing"
tab sec_4_i_new, missing
tab sec_4_i_new, nolabel

tab sec_4_j, missing
gen sec_4_j_new = sec_4_j
tab sec_4_j_new, missing
tab sec_4_j_new, missing
label values sec_4_j_new categories_PSDF_new
label var sec_4_j_new "Dairy Production and Heard Management"
tab sec_4_j_new, missing
tab sec_4_j_new, nolabel

tab sec_4_k, missing
gen sec_4_k_new = sec_4_k
tab sec_4_k_new, missing
tab sec_4_k_new, missing
label values sec_4_k_new categories_PSDF_new
label var sec_4_k_new "Dairy Technician"
tab sec_4_k_new, missing
tab sec_4_k_new, nolabel

tab sec_4_l, missing
gen sec_4_l_new = sec_4_l
tab sec_4_l_new, missing
tab sec_4_l_new, missing
label values sec_4_l_new categories_PSDF_new
label var sec_4_l_new "Veterinary Assistant"
tab sec_4_l_new, missing
tab sec_4_l_new, nolabel

histogram sec_4_a_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Poultry Management and Production) legend(off) scheme(s2mono)
histogram sec_4_b_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Poultry Technician) legend(off) scheme(s2mono)
histogram sec_4_c_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Sheep/Goat Husbandry) legend(off) scheme(s2mono)
histogram sec_4_d_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Animal Breeding Nutrition Management) legend(off) scheme(s2mono)
histogram sec_4_e_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Artificial Insemination) legend(off) scheme(s2mono)
histogram sec_4_f_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Livestock Management and Production) legend(off) scheme(s2mono)
histogram sec_4_g_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Livestock Workers and Assistants) legend(off) scheme(s2mono)
histogram sec_4_h_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Fodder Production Management) legend(off) scheme(s2mono)
histogram sec_4_i_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Meat Production and Processing) legend(off) scheme(s2mono)
histogram sec_4_j_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Dairy Production and Herd Management) legend(off) scheme (s2mono)
histogram sec_4_k_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Dairy Technician) legend(off) scheme (s2mono)
histogram sec_4_l_new, discrete frequency fcolor(pink) barwidth(0.5) gap(6) addlabel addlabopts(mlabsize(small) mlabangle(horizontal)) ytitle(Frequency) yscale(range(0 200)) ylabel(#12) xtitle(Preferance scale) xlabel(0(1)5, labsize(small) angle(forty_five) labgap(small) valuelabel ticks tlength(vsmall) tposition(crossing)) xmtick(, valuelabel) title(Training in Veterinary Assistant) legend(off) scheme (s2mono)

*which skills you want your workers to be trained in
tab sec_4_3_label, missing
tab sec_4_4, missing
tab sec_4_4, nolabel
***************************************************************************
