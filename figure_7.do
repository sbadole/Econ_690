capture log close
log using figure7.log,replace

// FIGURE 7: U.S. DIVORCE RATE: EFFECT OF DIVORCE LAWS
clear all
use Divorce-Wolfers-AER

foreach i of num 1(2)25{
generate years_uni_long_`i' = (years_unilateral_long==`i')
}

encode st, gen(state)
tab state, nolabel
tab state, gen(state)

tostring year, replace
encode year, gen(Year)
tab Year, nolabel
tab Year, gen(Year)

generate histo_divo_trend = evdiv50*time

regress div_rate histo_divo_trend years_uni_long_* state* Year* if year < "1999" [w=stpop]
predict actualpredict
foreach var of varlist years_uni_long_* {
replace `var' = 0 if `var' == 1
}
predict counterfapredict

destring year, replace
generat popustotal = 0
forvalues i = 1956(1)1998{
egen popus`i' = total(stpop) if year==`i'
replace popustotal = popus`i' if year==`i'
drop popus`i'
}

generat actualdiv = 0
forvalues i = 1956(1)1998{
egen actualdiv`i' = total(stpop*actualpredict) if year==`i'
replace actualdiv = actualdiv`i' if year==`i'
drop actualdiv`i'
}
replace actualdiv = actualdiv/popustotal
generat counterfadiv = 0
forvalues i = 1956(1)1998{
egen counterfa`i' = total(stpop*counterfapredict) if year==`i'
replace counterfadiv = counterfa`i' if year==`i'
drop counterfa`i'
}
replace counterfadiv = counterfadiv/popustotal

twoway (scatter actualdiv year, connect(l) msymbol(i)) || (scatter counterfadiv year, connect(l) msymbol(i) lpattern(dash)) if st=="CA" & year>1955 & year<1999, ytitle("Divorce Rate (Annual Divorces per 1,000 People)") ylabel(0(1)6) xlabel(1955(5)2000) xtitle("Year") title("US Divorce Rate: Effect of Divorce Laws") legend(label(1 "Actual Divorce Rate") label(2 "Counterfactual: No reform"))
graph export figure7.png, replace	

log close