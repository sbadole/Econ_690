capture log close
log using figure1.log,replace


//figure1 : AVERAGE DIVORCE RATE: REFORM STATES AND CONTROLS
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
summarize lfdivlaw
generate chadiv =(lfdivlaw>=1968 & lfdivlaw<=1988)

foreach i of num 1956/1998  {
generate chadiv_year`i' =((year==`i')*chadiv)
}
generate chadiv2 = (chadiv==1)
regress div_rate Year* chadiv2 chadiv_year* [w=stpop]
predict divreform if reform==1
predict divcontrol if reform==0
gen friedberg_sample=0.2 if year>=1968 & year<=1988

twoway scatter divreform year || scatter divcontrol year || scatter friedberg_sample year || , ylabel(0(1)7, angle(horizontal)) xtitle("Year") xlabel(1956(2)1998, angle(forty_five)) xline(1969 1977, lcolor(black)) ytitle("Divorce Rate" "Divorces per thousand people per year") title("Average Divorce Rate: Reform States and Controls") legend(label( 1 "Reform States") label(2 "Control States") label(3 "Friedberg's Sample")) text(6.8 1973 "Reform period") text(6.3 1973 "28 states adopted" "unilateral divorce", size(small))

graph export figure1.png, replace

log close