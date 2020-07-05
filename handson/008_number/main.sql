-- 008_02
select
    *,
    log(total_price / 1000 + 1) as total_price_log
from
    awesomebook.reserve

-- 008_03
select
    *,
    floor(age / 10) * 10 as age_rank
from
    awesomebook.customer

-- 008_07_a
select
    *
from
    awesomebook.production_missing_category
where
    thickness is not NULL

-- 008_07_b
select
    type,
    length,
    coalesce(thickness, 1) as thickness,
    fault_flg
from
    awesomebook.production_missing_category

-- 008_07_c
select
    type,
    length,
    coalesce(thickness,
            (select avg(thickness) from awesomebook.production_missing_category)) as thickness,
    fault_flg
from
    awesomebook.production_missing_category