capture log close
log using figure5.log,replace

// FIGURE 5. CALIFORNIA’S DIVORCE RATE
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

regress div_rate state* Year* if year<1989 [w=stpop]
predict div_st_y_FE, residuals
generate div_st_y_FEnt=div_st_y_FE if year>1967 & year<1989
generate div_st_y_FEt=. if year<1968 | year>1988
replace div_st_y_FEt=-.072*time+0.447*(1988-1970)/(1988-1968)

regress div_st_y_FE time if year<1970 & st=="CA"
predict div_st_y_FE2r

foreach i of num 1(2)15{
generate years_uni_1_`i' = (years_unilateral==`i')
}
regress div_rate years_uni_* state* Year* if year<1989 [w=stpop]
foreach var of varlist years_uni_* {
replace `var' = 0 if `var' == 1
}
predict div_st_y_FEyu, residuals

foreach i of num 1/51  {
generate time_st`i' =((state==`i')*time)
}

generate new_unilateral=unilateral
regress div_rate new_unilateral state* time_st* Year* if year<1989 & year>1967 [w=stpop]
replace new_unilateral=0
predict div_unil, residuals
drop new_unilateral
replace div_unil=. if year<1968 | year>1989

twoway (scatter div_st_y_FEnt year,  connect(l) msymbol(i) sort clcolor(gray) clwidth(vvthick)) || (scatter div_st_y_FE year,  connect(l) msymbol(i)) || (scatter div_st_y_FEt year if year>1967,  connect(l) msymbol(i)) || (scatter div_st_y_FE2r year if year<1970,  connect(l) msymbol(i)) if st=="CA" & year>1949 & year<1989, name(Fig5_1, replace) title("Divorce rate relative to state and year fixed effects") ytitle("Divorce Rate, relative to the US" "Deviation from California's Long Run Average") legend(label(1 "Friedberg's short sample") label(2 "Divorces | state & year effects") label(3 "Friedberg's fitted trend") label(4 "Actual pre-existing trend")) xline(1969, lcolor(gray) lpat(dash))
graph export figure5A.png, replace

twoway (scatter div_st_y_FEyu year, connect(l) msymbol(i)) || (scatter div_unil year, connect(l) msymbol(i) clwidth(thick)) if st=="CA" & year>1949 & year<1989, name(Fig5_2, replace) legend(rows(2) label(1 "Divorce relative to pre-existing trend") label(2 "Divorce relative to Friedberg's fitted trend" )) title("Divorce rate relative to fitted trend") subtitle("(and state and year fixed effects)") ytitle("Divorce Rate, relative to the US" "Deviation from California's fitted trend") xline(1969, lcolor(gray) lpattern(dash)) yline(0, lcolor(gray))

graph export figure5B.png, replace

log close