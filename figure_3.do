capture log close
log using figure3.log,replace

//FIGURE 3. RESPONSE OF DIVORCE RATE TO UNILATERAL DIVORCE LAWS 
clear all
use Divorce-Wolfers-AER
encode st, gen(state)
tab state, nolabel
tab state, gen(state)

tostring year, replace
encode year, gen(Year)
tab Year, nolabel
tab Year, gen(Year)
drop Year
destring year, replace
keep if year>1955 & year<1989

//regression first, years unilateral, state and year fixed effects
foreach i of num 1(2)15{
generate years_uni_1_`i' = (years_unilateral==`i')
}
regress div_rate years_uni_* state* Year* [w=stpop]
generate years_uni_reg_coe = 0 
forvalues i = 1(2)15{
replace years_uni_reg_coe = _b[years_uni_1_`i'] if years_uni_1_`i'==1
}

generate functiona1 = . 
generate functiona2 = . 
forvalues i = 1(2)15{
replace functiona1 = _b[years_uni_1_`i']+ 1.96*_se[years_uni_1_`i'] if years_uni_1_`i'==1
}
forvalues i = 1(2)15{
replace functiona2 = _b[years_uni_1_`i']- 1.96*_se[years_uni_1_`i'] if years_uni_1_`i'==1
}

//regression secound, years unilateral, state, state_time and year fixed effects
foreach i of num 1/51  {
generate time_st`i' =((state==`i')*time)
}

foreach i of num 1(2)15{
generate years_uni_1_b`i' = (years_unilateral==`i')
}
regress div_rate time years_uni_1_b* state* time_st* Year* [w=stpop]
generate years_uni_reg_coeb = 0 
forvalues i = 1(2)15{
replace years_uni_reg_coeb = _b[years_uni_1_b`i'] if years_uni_1_b`i'==1
}

generate functionb1 = 0 if years_unilateral<0
generate functionb2 = 0 if years_unilateral<0
forvalues i = 1(2)15{
replace functionb1 = _b[years_uni_1_b`i']+ 1.96*_se[years_uni_1_b`i'] if years_uni_1_b`i'==1
}
forvalues i = 1(2)15{
replace functionb2 = _b[years_uni_1_b`i']- 1.96*_se[years_uni_1_b`i'] if years_uni_1_b`i'==1
}
      

//regression third, years unilateral, state, state_time state_time^2 and year fixed effects

foreach i of num 1/51  {
generate time_sqst`i' =((state==`i')*timesq)
}

foreach i of num 1(2)15{
generate years_uni_1_c`i' = (years_unilateral==`i')
}
regress div_rate time timesq years_uni_1_c* state* time_st* time_sqst* Year* [w=stpop]
generate years_uni_reg_coec = 0 
forvalues i = 1(2)15{
replace years_uni_reg_coec = _b[years_uni_1_c`i'] if years_uni_1_c`i'==1
}

generate functionc1 = 0 if years_unilateral<0
generate functionc2 = 0 if years_unilateral<0
forvalues i = 1(2)15{
replace functionc1 = _b[years_uni_1_c`i']+ 1.96*_se[years_uni_1_c`i'] if years_uni_1_c`i'==1
}
forvalues i = 1(2)15{
replace functionc2 = _b[years_uni_1_c`i']- 1.96*_se[years_uni_1_c`i'] if years_uni_1_c`i'==1
}

replace years_unilateral=-1 if years_unilateral<0
replace years_unilateral=-3 if years_unilateral==-1 & uniform()<.5


twoway rarea functionb1 functionb2 years_unilateral, sort color(gs14)|| scatter years_uni_reg_coe years_unilateral,connect(l) sort msymbol(triangle)|| scatter years_uni_reg_coeb years_unilateral, connect(l) sort msymbol(diamond) mcolor(brown)|| scatter years_uni_reg_coec years_unilateral, connect(l) sort msymbol(square)||, xlabel(-3 "(3-4)" -1 "(1-2)" 1 "1-2" 3 "3-4" 5 "5-6" 7 "7-8" 9 "9-10" 11 "11-12" 13 "13-14" 15 ">=15") ytitle("Regression coefficients: Effect on Divorce Rate" "Annual divorces per thousand people") xtitle("Years since (until) adoption of Unilateral Divorce Laws") title("Response of Divorce Rate to Unilateral Divorce Laws") subtitle("Sensitivity to controlling for pre-existing state trends") legend(label(1 "95% Confidence Interval - State Trends") label(2 "No State Trends") label(3 "State Trends") label(4 "Quadratic State Trends"))


graph export figure3.png, replace




log close




