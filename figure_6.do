capture log close
log using figure6.log,replace

clear all
use Divorce-Wolfers-AER

// FIGURE 6. ESTIMATES OF STATE-SPECIFIC LINEAR TIME TRENDS

keep if year>1955 & year<1989

foreach i of num 1(2)15{
generate years_uni_1_`i' = (years_unilateral==`i')
}

encode st, gen(state)
tab state, nolabel
tab state, gen(state)
foreach i of num 1/51  {
generate state_t`i' =((state==`i')*time)
}

tostring year, replace
encode year, gen(Year)
tab Year, nolabel
tab Year, gen(Year)

regress div_rate years_uni_* state* state_t* Year* [w=stpop]
foreach var of varlist years_uni_* {
replace `var' = 0 if `var' == 1
}

foreach var of varlist Year* {
replace `var' = 0 if `var' == 1
}
predict pre_divratet2
sort st year
quietly by st: generate pre_divratet2new =pre_divratet2-pre_divratet2[_n-1] if year=="1979"

replace Year1 = 1 if year=="1956"
replace Year2 = 1 if year=="1957"
replace Year3 = 1 if year=="1958"
replace Year4 = 1 if year=="1959"
replace Year5 = 1 if year=="1960"
replace Year6 = 1 if year=="1961"
replace Year7 = 1 if year=="1962"
replace Year8 = 1 if year=="1963"
replace Year9 = 1 if year=="1964"
replace Year10 = 1 if year=="1965"
replace Year11 = 1 if year=="1966"
replace Year12 = 1 if year=="1967"
replace Year13 = 1 if year=="1968"
replace Year14 = 1 if year=="1969"
replace Year15 = 1 if year=="1970"
replace Year16 = 1 if year=="1971"
replace Year17 = 1 if year=="1972"
replace Year18 = 1 if year=="1973"
replace Year19 = 1 if year=="1974"
replace Year20 = 1 if year=="1975"
replace Year21 = 1 if year=="1976"
replace Year22 = 1 if year=="1977"
replace Year23 = 1 if year=="1978"
replace Year24 = 1 if year=="1979"
replace Year25 = 1 if year=="1980"
replace Year26 = 1 if year=="1981"
replace Year27 = 1 if year=="1982"
replace Year28 = 1 if year=="1983"
replace Year29 = 1 if year=="1984"
replace Year30 = 1 if year=="1985"
replace Year31 = 1 if year=="1986"
replace Year32 = 1 if year=="1987"
replace Year33 = 1 if year=="1988"
drop state

gen lfchtemp=unilateral
regress div_rate lfchtemp state* state_t* Year* [w=stpop]
replace lfchtemp=0
foreach var of varlist Year* {
replace `var' = 0 if `var' == 1
}
predict pre_divratenew
sort st year
quietly by st: generate pre_divratenew2 =pre_divratenew-pre_divratenew[_n-1] if year=="1979"

generate pre_divratenew2_reform = pre_divratenew2 if lfdivlaw > 1967 & lfdivlaw < 2000
generate pre_divratenew2_control = pre_divratenew2 if lfdivlaw < 1967 | lfdivlaw > 1999 

twoway (scatter pre_divratenew2_reform pre_divratet2new, mlabel(st) ) || (scatter pre_divratenew2_control pre_divratet2new,  mlabel(st)) || (line pre_divratet2new pre_divratet2new) if year =="1979" & st!="NV", xlabel(0(.05).2) title("Estimates of State-Specific Linear Time Trends") subtitle("Each point represents a regression-estimated state*time coefficient") ytitle("Estimated state time trends: Friedberg" "Table 1, Col. 2 specification", size(medium)) xtitle("Estimated state time trends: Wolfers" "Table 2, Col. 2 specification", size(medium)) legend(label(1 "States that reformed divorce laws") label(2 "Control states") label(3 "45-degree line"))

graph export figure6.png, replace

log close
