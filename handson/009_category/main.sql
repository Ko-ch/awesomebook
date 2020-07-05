-- 009_01
select
    case when sex = 'man' then true else false end as sex_is_man
from
    awesomebook.customer

-- 009_01
with sex_mst as(
    select
        sex,
        row_number() over() as sex_mst_id
    from
        awesomebook.customer
    group by
        sex
)
select
    base.*,
    s_mst.sex_mst_id
from
    awesomebook.customer base
inner join
    sex_mst s_mst
on
    base.sex = s_mst.sex

-- 009_02
select
    case when sex = 'man' then true else false end as sex_is_man,
    case when sex = 'woman' then true else false end as sex_is_woman,
from
    awesomebook.customer

-- 009_03
with customer_tb_with_age_rank as (
    select
        *,
        cast(floor(age / 10) * 10 as string) as age_rank
    from
        awesomebook.customer
)
select
    customer_id,
    age,
    sex,
    home_latitude,
    home_longitude,
    case when age_rank = '60' or age_rank = '70' or age_rank = '80' then '60歳以上' else age_rank end as age_rank
from
    customer_tb_with_age_rank

-- 009_04
select
    *,
    sex || '_' || cast(floor(age / 10) * 10 as string) as sex_and_age
from
    awesomebook.customer

-- 009_05
with type_mst as (
    select
        type,
        count(*) as record_cnt,
        sum(case when fault_flg then 1 else 0 end) as fault_cnt
    from
        awesomebook.production
    group by
        type
)
select
    base.*,
    cast(t_mst.fault_cnt - (case when fault_flg then 1 else 0 end) as float64) / (t_mst.record_cnt - 1) as type_fault_rate
from
    awesomebook.production base
inner join
    type_mst t_mst
on
    base.type = t_mst.type