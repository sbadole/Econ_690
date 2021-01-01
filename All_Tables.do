capture log close
log using divorce_wolfers_aer.log,replace

clear all
use Divorce-Wolfers-AER

// TABLE 1—FRIEDBERG’S RESULTS, Panel B. Replication
keep if year>1967 & year<1989
encode st, gen(state)
tab state, nolabel
tab state, gen(state)

tostring year, replace
encode year, gen(Year)
tab Year, nolabel
tab Year, gen(Year)

*column 1
reg div_rate unilateral divx* state* Year* [w=stpop]
testparm state*
testparm Year*
outreg2 using table1.doc, replace ctitle(c1) keep(unilateral)

*column 2
foreach i of num 1/51  {
generate t_state`i' =((state==`i')*time)
}

reg div_rate unilateral divx* state* t_state* Year* [w=stpop]
outreg2 using table1.doc,append ctitle(c2) keep(unilateral)
testparm state*
testparm t_state*
testparm Year*

*column 3
foreach i of num 1/51  {
generate sqstate_t`i' =((state==`i')*timesq)
}

reg div_rate unilateral divx* state* t_state* sqstate_t* Year* [w=stpop]
outreg2 using table1.doc,append ctitle(c3) keep(unilateral)
testparm state*
testparm t_state*
testparm sqstate_t*
testparm Year*
********************************************************************************
*TABLE 2—DYNAMIC EFFECTS OF ADOPTING UNILATERAL DIVORCE LAWS
clear all
use Divorce-Wolfers-AER
keep if year>1955 & year<1989

foreach i of num 1(2)15{
generate years_uni_1_`i' = (years_unilateral==`i')
}

encode st, gen(state)
tab state, nolabel
tab state, gen(state)

tostring year, replace
encode year, gen(Year)
tab Year, nolabel
tab Year, gen(Year)

*column 1
regress div_rate years_uni_* state* Year* [w=stpop]
outreg2 using table2.doc, replace ctitle(c1) keep(years_uni_1_1 years_uni_1_3 years_uni_1_5 years_uni_1_7 years_uni_1_9 years_uni_1_11 years_uni_1_13 years_uni_1_15)
testparm state*
testparm Year*

*column 2
foreach i of num 1/51  {
generate t_state`i' =((state==`i')*time)
}

regress div_rate years_uni_* state* t_state* Year* [w=stpop]
outreg2 using table2.doc,append ctitle(c2) keep(years_uni_1_1 years_uni_1_3 years_uni_1_5 years_uni_1_7 years_uni_1_9 years_uni_1_11 years_uni_1_13 years_uni_1_15)
testparm state*
testparm t_state*
testparm Year*

*column 3
foreach i of num 1/51  {
generate sqstate_t`i' =((state==`i')*timesq)
}

regress div_rate years_uni_* state* t_state* sqstate_t* Year* [w=stpop]
outreg2 using table2.doc,append ctitle(c3) keep(years_uni_1_1 years_uni_1_3 years_uni_1_5 years_uni_1_7 years_uni_1_9 years_uni_1_11 years_uni_1_13 years_uni_1_15)
testparm state*
testparm t_state*
testparm sqstate_t*
testparm Year*

********************************************************************************
*Table 3: EFFECTS OF UNILATERAL DIVORCE LAWS ON THE STOCK OF DIVORCES—CENSUS DATA
clear all
use Census_stock_data.dta
encode st, gen(state)
tab state, nolabel
*tab state, gen(state)

*Panel A. Women
areg divorce unilat1 black white age year age##year if year > 1950 & year < 2000 & sex == 1 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table3a.doc, replace ctitle(c1) keep(unilat1)
generate coeffi_unilat1 = _b[unilat1]
summarize divorce if year >= 1960 & year <= 1990 &sex == 1 [w=nobs]
generate Mean_dependent_var1 = r(mean)
generate elasticity_1 = coeffi_unilat1/Mean_dependent_var1
summarize elasticity_1

areg divorce unilat1 black white age year age##year if year>1950 & year<1990 & sex==1 [w=nobs],  absorb(state) vce(cluster state)
outreg2 using table3a.doc, append ctitle(c2) keep(unilat1)
generate coeffi_unilat2 = _b[unilat1]
summarize divorce if year >= 1960 & year <= 1980 &sex == 1 [w=nobs]
generate Mean_dependent_var2 = r(mean)
generate elasticity_2 = coeffi_unilat2/Mean_dependent_var2
summarize elasticity_2

areg evdiv unilat1 black white age year age##year if year>1950 & year<1990 & sex==1 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table3a.doc, append ctitle(c3) keep(unilat1)
generate coeffi_unilat3 = _b[unilat1]
summarize evdiv if year >= 1960 & year <= 1980 &sex == 1 [w=nobs]
generate Mean_dependent_var3 = r(mean)
generate elasticity_3 = coeffi_unilat3/Mean_dependent_var3
summarize elasticity_3

*Panel B. Men
areg divorce unilat1 black white age year age##year if year > 1950 & year < 2000 & sex == 0 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table3b.doc, replace ctitle(c1) keep(unilat1)
generate coeffi_unilat1m = _b[unilat1]
summarize divorce if year >= 1960 & year <= 1990 &sex == 0 [w=nobs]
generate Mean_dependent_var1m = r(mean)
generate elasticity_1m = coeffi_unilat1m/Mean_dependent_var1m
summarize elasticity_1m

areg divorce unilat1 black white age year age##year if year>1950 & year<1990 & sex==0 [w=nobs],  absorb(state) vce(cluster state)
outreg2 using table3b.doc, append ctitle(c2) keep(unilat1)
generate coeffi_unilat2m = _b[unilat1]
summarize divorce if year >= 1960 & year <= 1980 &sex == 0 [w=nobs]
generate Mean_dependent_var2m = r(mean)
generate elasticity_2m = coeffi_unilat2m/Mean_dependent_var2m
summarize elasticity_2m

areg evdiv unilat1 black white age year age##year if year>1950 & year<1990 & sex==0 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table3b.doc, append ctitle(c3) keep(unilat1)
generate coeffi_unilat3m = _b[unilat1]
summarize evdiv if year >= 1960 & year <= 1980 &sex == 0 [w=nobs]
generate Mean_dependent_var3m = r(mean)
generate elasticity_3m = coeffi_unilat3m/Mean_dependent_var3m
summarize elasticity_3m


*TABLE 4—LONG-RUN EFFECTS OF UNILATERAL DIVORCE LAWS

*Panel B. Dependent variable is share of women currently divorced (census data)
areg divorce unil1to10 unil11pl black white age year age##year if year>1950 & year<2000 & sex==1 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table4b.doc, replace ctitle(c1) keep(unil1to10 unil11pl)
summarize divorce if year >= 1960 & year <= 1990 &sex == 1 [w=nobs]


areg divorce unil1to10 unil11to20 unil20pl black white age year age##year if year>1950 & year<=2000 & sex==1 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table4b.doc, append ctitle(c2) keep(unil1to10 unil11to20 unil20pl)
summarize divorce if year >= 1960 & year <= 2000 &sex == 1 [w=nobs]

generate frac_currdiv_evermarri = ndivorce/(nmarsp+nmarab+nseparat+ndivorce+nwidow)

areg frac_currdiv_evermarri unil1to10 unil11pl black white age year age##year if year>1950 & year<2000 & sex==1 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table4b.doc, append ctitle(c3) keep(unil1to10 unil11pl)
summarize frac_currdiv_evermarri if year >= 1960 & year <= 1990 &sex == 1 [w=nobs]

areg frac_currdiv_evermarri unil1to10 unil11to20 unil20pl black white age year age##year if year>1950 & year<=2000 & sex==1 [w=nobs], absorb(state) vce(cluster state)
outreg2 using table4b.doc, append ctitle(c4) keep(unil1to10 unil11to20 unil20pl)
summarize frac_currdiv_evermarri if year >= 1960 & year <= 2000 &sex == 1 [w=nobs]


*Panel A. Dependent variable is divorce rate (administrative flow data)

clear all
use Divorce-Wolfers-AER

foreach i of num 1(2)15{
generate years_uni_1_`i' = (years_unilateral==`i')
}

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

generate frac_divrate_marranu = div_rate/married_annual

regress div_rate years_uni_1_* state* Year* if year < "1989" [w=stpop]
outreg2 using table4a.doc, replace ctitle(c1) keep(years_uni_1_*)
summarize div_rate if year < "1989" [w=stpop]

regress div_rate years_uni_long_* state* Year* if year < "1999" [w=stpop]
outreg2 using table4a.doc, append ctitle(c2) keep(years_uni_long_*)
summarize div_rate if year < "1999" [w=stpop]

regress frac_divrate_marranu years_uni_1_* state* Year* if year < "1989" [w=stpop]
outreg2 using table4a.doc, append ctitle(c3) keep(years_uni_1_*)
summarize frac_divrate_marranu if year < "1989" [w=stpop]

regress frac_divrate_marranu years_uni_long_* state* Year* if year < "1999" [w=stpop]
outreg2 using table4a.doc, append ctitle(c4) keep(years_uni_long_*)
summarize frac_divrate_marranu if year < "1999" [w=stpop]

**************************************************************************************
*TABLE 5—ROBUSTNESS TESTING
//(Dependent variable: Annual divorces per 1,000 persons)

regress div_rate years_uni_long_* state* Year* if year < "1999" [w=stpop]
outreg2 using table5.doc, replace ctitle(c1) keep(years_uni_long_*)

regress div_rate neighper years_uni_long_* state* Year* if year < "1999" [w=stpop]
outreg2 using table5.doc, append ctitle(c2) keep(years_uni_long_*)

generate histo_divo_trend = evdiv50*time

regress div_rate histo_divo_trend years_uni_long_* state* Year* if year < "1999" [w=stpop]
outreg2 using table5.doc, append ctitle(c3) keep(years_uni_long_*)

foreach i of num 1956/1998  {
generate interc_histo_year`i' =((year=="`i'")*histo_divo_trend)
}
regress div_rate years_uni_long_* Year* interc_histo_year* state* if year < "1999" [w=stpop]
outreg2 using table5.doc, append ctitle(c4) keep(years_uni_long_*)

regress div_rate years_uni_long_*  state* Year* if year < "1999" & reform==1 [w=stpop]
outreg2 using table5.doc, append ctitle(c5) keep(years_uni_long_*)

*********************************************************************************

* Appendix A

clear all
use Divorce-Wolfers-AER

keep if year>1955 & year<1989
encode st, gen(state)
tab state, nolabel
tab state, gen(state)

tostring year, replace
encode year, gen(Year)
tab Year, nolabel
tab Year, gen(Year)

*column 1
reg div_rate unilateral state* Year* [w=stpop]
testparm state*
testparm Year*
outreg2 using tableA1.doc, replace ctitle(c1) keep(unilateral)

*column 2
foreach i of num 1/51  {
generate t_state`i' =((state==`i')*time)
}

reg div_rate unilateral state* t_state* Year* [w=stpop]
outreg2 using tableA1.doc,append ctitle(c2) keep(unilateral)
testparm state*
testparm t_state*
testparm Year*

*column 3
foreach i of num 1/51  {
generate sqstate_t`i' =((state==`i')*timesq)
}

reg div_rate unilateral state* t_state* sqstate_t* Year* [w=stpop]
outreg2 using tableA1.doc,append ctitle(c3) keep(unilateral)
testparm state*
testparm t_state*
testparm sqstate_t*
testparm Year*


***************************************************************************


log close