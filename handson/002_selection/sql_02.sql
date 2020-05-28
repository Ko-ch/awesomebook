-- a_sql_1_not_awesome.sql
select
    *
from
    awesomebook.reserve
where
    checkin_date between '2016-10-12' and '2016-10-13'


-- b_sql_2_awesome.sql
select
    *
from
    awesomebook.reserve
where
    checkin_date  between '2016-10-10' and '2016-10-13'
and
    checkout_date between '2016-10-13' and '2016-10-14'