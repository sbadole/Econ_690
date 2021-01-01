capture log close
log using figure4.log,replace

// FIGURE 4. RESPONSE OF DIVORCE RATE TO DIVORCE LAW REFORM
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

// figure4 a : Controlling for state and year fixed effects
// regression for gruber_yrs
foreach i of num 1(2)15{
generate gruber_yrs_`i' = (gruber_yrs==`i')
}
reg div_rate gruber_yrs_* state* Year* [w=stpop]
generate gruber_reg_coe = 0 if gruber_yrs<0
forvalues i = 1(2)15{
replace gruber_reg_coe = _b[gruber_yrs_`i'] if gruber_yrs_`i'==1
}

//friedberg_yrs 
foreach i of num 1(2)15{
generate friedberg_yrs_`i' = (friedberg_yrs==`i')
}
reg div_rate friedberg_yrs_* state* Year* [w=stpop]
generate friedberg_reg_coe = 0 if friedberg_yrs<0
forvalues i = 1(2)15{
replace friedberg_reg_coe = _b[friedberg_yrs_`i'] if friedberg_yrs_`i'==1
}

//johnson_yrs 
foreach i of num 1(2)15{
generate johnson_yrs_`i' = (johnson_yrs==`i')
}
reg div_rate johnson_yrs_* state* Year* [w=stpop]
generate johnson_reg_coe = 0 if johnson_yrs<0
forvalues i = 1(2)15{
replace johnson_reg_coe = _b[johnson_yrs_`i'] if johnson_yrs_`i'==1
}

//mechoulan_yrs
foreach i of num 1(2)15{
generate mechoulan_yrs_`i' = (mechoulan_yrs==`i')
}
reg div_rate mechoulan_yrs_* state* Year* [w=stpop]
generate mechoulan_reg_coe = 0 if mechoulan_yrs<0
forvalues i = 1(2)15{
replace mechoulan_reg_coe = _b[mechoulan_yrs_`i'] if mechoulan_yrs_`i'==1
}

//ellmanlohr1_yrs
foreach i of num 1(2)15{
generate ellmanlohr1_yrs_`i' = (ellmanlohr1_yrs==`i')
}
reg div_rate ellmanlohr1_yrs_* state* Year* [w=stpop]
generate ellmanlohr1_reg_coe = 0 if ellmanlohr1_yrs<0
forvalues i = 1(2)15{
replace ellmanlohr1_reg_coe = _b[ellmanlohr1_yrs_`i'] if ellmanlohr1_yrs_`i'==1
}

//ellmanlohr2_yrs
foreach i of num 1(2)15{
generate ellmanlohr2_yrs_`i' = (ellmanlohr2_yrs==`i')
}
reg div_rate ellmanlohr2_yrs_* state* Year* [w=stpop]
generate ellmanlohr2_reg_coe = 0 if ellmanlohr2_yrs<0
forvalues i = 1(2)15{
replace ellmanlohr2_reg_coe = _b[ellmanlohr2_yrs_`i'] if ellmanlohr2_yrs_`i'==1
}

//brinigbuckley_yrs
foreach i of num 1(2)15{
generate brinigbuckley_yrs_`i' = (brinigbuckley_yrs==`i')
}
reg div_rate brinigbuckley_yrs_* state* Year* [w=stpop]
generate brinigbuckley_reg_coe = 0 if brinigbuckley_yrs<0
forvalues i = 1(2)15{
replace brinigbuckley_reg_coe = _b[brinigbuckley_yrs_`i'] if brinigbuckley_yrs_`i'==1
}

//nakonezny_yrs
foreach i of num 1(2)15{
generate nakonezny_yrs_`i' = (nakonezny_yrs==`i')
}
reg div_rate nakonezny_yrs_* state* Year* [w=stpop]
generate nakonezny_reg_coe = 0 if nakonezny_yrs<0
forvalues i = 1(2)15{
replace nakonezny_reg_coe = _b[nakonezny_yrs_`i'] if nakonezny_yrs_`i'==1
}

foreach i of num 1(2)15{
generate years_uni_1_`i' = (years_unilateral==`i')
}
regress div_rate years_uni_* state* Year* [w=stpop]
generate years_uni_reg_coe = 0 
forvalues i = 1(2)15{
replace years_uni_reg_coe = _b[years_uni_1_`i'] if years_uni_1_`i'==1
}

generate function1 = 0 if years_unilateral<0
generate function2 = 0 if years_unilateral<0
forvalues i = 1(2)15{
replace function1 = _b[years_uni_1_`i']+ 1.96*_se[years_uni_1_`i'] if years_uni_1_`i'==1
}
forvalues i = 1(2)15{
replace function2 = _b[years_uni_1_`i']- 1.96*_se[years_uni_1_`i'] if years_uni_1_`i'==1
}

//figure4 b: Also controlling for pre-existing state trends
foreach i of num 1/51  {
generate time_st`i' =((state==`i')*time)
}

// regression for gruber_yrs

foreach i of num 1(2)15{
generate gruber_yrs_b`i' = (gruber_yrs==`i')
}
reg div_rate gruber_yrs_b* state* time_st* Year* [w=stpop]
generate gruber_reg_coeb = 0 if gruber_yrs<0
forvalues i = 1(2)15{
replace gruber_reg_coeb = _b[gruber_yrs_b`i'] if gruber_yrs_b`i'==1
}

//friedberg_yrs 
foreach i of num 1(2)15{
generate friedberg_yrs_b`i' = (friedberg_yrs==`i')
}
reg div_rate friedberg_yrs_b* state* time_st* Year* [w=stpop]
generate friedberg_reg_coeb = 0 if friedberg_yrs<0
forvalues i = 1(2)15{
replace friedberg_reg_coeb = _b[friedberg_yrs_b`i'] if friedberg_yrs_b`i'==1
}

//johnson_yrs 
foreach i of num 1(2)15{
generate johnson_yrs_b`i' = (johnson_yrs==`i')
}
reg div_rate johnson_yrs_b* state* time_st* Year* [w=stpop]
generate johnson_reg_coeb = 0 if johnson_yrs<0
forvalues i = 1(2)15{
replace johnson_reg_coeb = _b[johnson_yrs_b`i'] if johnson_yrs_b`i'==1
}

//mechoulan_yrs
foreach i of num 1(2)15{
generate mechoulan_yrs_b`i' = (mechoulan_yrs==`i')
}
reg div_rate mechoulan_yrs_b* state* time_st* Year* [w=stpop]
generate mechoulan_reg_coeb = 0 if mechoulan_yrs<0
forvalues i = 1(2)15{
replace mechoulan_reg_coeb = _b[mechoulan_yrs_b`i'] if mechoulan_yrs_b`i'==1
}

//ellmanlohr1_yrs
foreach i of num 1(2)15{
generate ellmanlohr1_yrs_b`i' = (ellmanlohr1_yrs==`i')
}
reg div_rate ellmanlohr1_yrs_b* state* time_st* Year* [w=stpop]
generate ellmanlohr1_reg_coeb = 0 if ellmanlohr1_yrs<0
forvalues i = 1(2)15{
replace ellmanlohr1_reg_coeb = _b[ellmanlohr1_yrs_b`i'] if ellmanlohr1_yrs_b`i'==1
}

//ellmanlohr2_yrs
foreach i of num 1(2)15{
generate ellmanlohr2_yrs_b`i' = (ellmanlohr2_yrs==`i')
}
reg div_rate ellmanlohr2_yrs_b* state* time_st* Year* [w=stpop]
generate ellmanlohr2_reg_coeb = 0 if ellmanlohr2_yrs<0
forvalues i = 1(2)15{
replace ellmanlohr2_reg_coeb = _b[ellmanlohr2_yrs_b`i'] if ellmanlohr2_yrs_b`i'==1
}

//brinigbuckley_yrs
foreach i of num 1(2)15{
generate brinigbuckley_yrs_b`i' = (brinigbuckley_yrs==`i')
}
reg div_rate brinigbuckley_yrs_b* state* time_st* Year* [w=stpop]
generate brinigbuckley_reg_coeb = 0 if brinigbuckley_yrs<0
forvalues i = 1(2)15{
replace brinigbuckley_reg_coeb = _b[brinigbuckley_yrs_b`i'] if brinigbuckley_yrs_b`i'==1
}

//nakonezny_yrs
foreach i of num 1(2)15{
generate nakonezny_yrs_b`i' = (nakonezny_yrs==`i')
}
reg div_rate nakonezny_yrs_b* state* time_st* Year* [w=stpop]
generate nakonezny_reg_coeb = 0 if nakonezny_yrs<0
forvalues i = 1(2)15{
replace nakonezny_reg_coeb = _b[nakonezny_yrs_b`i'] if nakonezny_yrs_b`i'==1
}

foreach i of num 1(2)15{
generate years_uni_1_b`i' = (years_unilateral==`i')
}
regress div_rate years_uni_1_b* state* time_st* Year* [w=stpop]
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

replace years_unilateral=-1 if years_unilateral<0
replace years_unilateral=-3 if years_unilateral==-1 & uniform()<.5

replace gruber_yrs=-1 if gruber_yrs<0
replace friedberg_yrs=-1 if friedberg_yrs<0
replace johnson_yrs=-1 if johnson_yrs<0
replace mechoulan_yrs=-1 if mechoulan_yrs<0
replace ellmanlohr1_yrs=-1 if ellmanlohr1_yrs<0
replace ellmanlohr2_yrs=-1 if ellmanlohr2_yrs<0
replace brinigbuckley_yrs=-1 if brinigbuckley_yrs<0
replace nakonezny_yrs=-1 if nakonezny_yrs<0

twoway rarea function1 function2 years_unilateral, sort color(gs14)|| scatter gruber_reg_coe gruber_yrs,connect(l) msymbol(i) sort clcolor(black) clpat(shortdash) || scatter johnson_reg_coe johnson_yrs, connect(l) msymbol(i) sort msymbol(triangle) clcolor(brown) mcolor(brown) clwidth(medium) || scatter mechoulan_reg_coe mechoulan_yrs, connect(l) msymbol(i) sort clcolor(blue) clpat(longdash) || scatter  ellmanlohr1_reg_coe ellmanlohr1_yrs, connect(l) msymbol(i) sort msymbol(circle) clcolor(green) || scatter  ellmanlohr2_reg_coe ellmanlohr2_yrs, connect(l) msymbol(i) sort msymbol(x) clcolor(pink) mcolor(pink) || scatter  brinigbuckley_reg_coe brinigbuckley_yrs, connect(l) msymbol(i) sort msymbol(plus) mcolor(purple) clcolor(purple) || scatter nakonezny_reg_coe nakonezny_yrs, connect(l) msymbol(i) sort clcolor(gray)||, xlabel(-3 "(3-4)" -1 "(1-2)" 1 "1-2" 3 "3-4" 5 "5-6" 7 "7-8" 9 "9-10" 11 "11-12" 13 "13-14" 15 ">=15") title(Controlling for state and year fixed effects, ring(0)) name(Figure4_A, replace) legend(off)  

twoway rarea functionb1 functionb2 years_unilateral, sort color(gs14) || scatter gruber_reg_coeb gruber_yrs,connect(l) msymbol(i) sort clcolor(black) clpat(shortdash) || scatter johnson_reg_coeb johnson_yrs, connect(l) msymbol(i) sort msymbol(triangle) clcolor(brown) mcolor(brown) clwidth(medium) || scatter mechoulan_reg_coeb mechoulan_yrs, connect(l) msymbol(i) sort clcolor(blue) clpat(longdash) || scatter  ellmanlohr1_reg_coeb ellmanlohr1_yrs, connect(l) msymbol(i) sort msymbol(circle) clcolor(green) || scatter  ellmanlohr2_reg_coeb ellmanlohr2_yrs, connect(l) msymbol(i) sort msymbol(x) clcolor(pink) mcolor(pink) || scatter  brinigbuckley_reg_coeb brinigbuckley_yrs, connect(l) msymbol(i) sort msymbol(plus) mcolor(purple) clcolor(purple) || scatter nakonezny_reg_coeb nakonezny_yrs, connect(l) msymbol(i) sort clcolor(gray)||, xlabel(-3 "(3-4)" -1 "(1-2)" 1 "1-2" 3 "3-4" 5 "5-6" 7 "7-8" 9 "9-10" 11 "11-12" 13 "13-14" 15 ">=15") title(Also controlling for pre-existing state trends, ring(0)) name(Figure4_B, replace) legend(label(1 "Friedberg (1998): 95% interval") label(2 "Gruber (2004)") label(3 "Johnson and Mazingo (2000)") label(4 "Mechoulan (2001)") label(5 "Ellman and Lohr (1998a)") label(6 "Ellman and Lohr (1998b)" ) label(7 "Brinig and Buckley (1998)") label(8 "Nakonezny & Shull (1995)"))

graph combine Figure4_A Figure4_B, ycommon colfirst rows(2) title("Response of Divorce Rate to Divorce Law Reform", size(medlarge)) subtitle("Sensitivity to different coding of family law regime") commonscheme ysize(10) xsize(7.5) l2title("Regression coefficients: Effect on divorce rate", size(medsmall)) l1title("(Annual divorces per thousand people)", size(small)) b1title("Years since (until) adoption of Unilateral or" "No-Fault Divorce Laws", size(medsmall))  


graph export figure4A-B.png, replace

log close










