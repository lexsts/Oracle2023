select   round(min(lh2.FIRST_TIME - lh1.FIRST_TIME) * 24 * 60,2) "Menor",
round(max(lh2.FIRST_TIME - lh1.FIRST_TIME) * 24 * 60,2) "Maior",
round(avg(lh2.FIRST_TIME - lh1.FIRST_TIME) * 24 * 60,2) "Media"
from     sys.v_$loghist lh1, sys.v_$loghist lh2
where    lh1.SEQUENCE# + 1 = lh2.SEQUENCE#
and      lh1.SEQUENCE# < (
select   max(SEQUENCE#)
from     sys.v_$loghist);