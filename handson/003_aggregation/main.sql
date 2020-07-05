-- 003_01
select
    hotel_id,
    count(reserve_id) as rsv_cnt,
    count(distinct customer_id) as cus_cnt
from
    awesomebook.reserve
group by
    hotel_id

-- 003_02
select
    hotel_id,
    people_num,
    sum(total_price) as price_sum
from
    awesomebook.reserve
group by
    hotel_id,
    people_num

-- 003_03 注意：下記コードはBig Queryで実行できていない
select
    hotel_id,
    MAX(total_price) as price_max,
    min(total_price) as price_min,
    avg(total_price) as price_avg,
    percentile_cont(total_price, 0.5) over(partition by hotel_id) as price_med,
    percentile_cont(total_price, 0.2) over(partition by hotel_id) as price_20per,
from
    awesomebook.reserve
group by
    hotel_id

-- 003_04
select
    hotel_id,
    coalesce(variance(total_price), 0) as price_var,
    coalesce(stddev(total_price), 0) as price_std
from
    awesomebook.reserve
group by
    hotel_id

-- 003_05
-- Big Query仕様に変更しました。どうもorder by 句内にはcount()は使用できない模様。
select
    round(total_price, -3) as total_price_round,
    count(*) as cnt
from
    awesomebook.reserve
group by
    total_price_round
order by
    cnt
limit
    1

--003_06_1
select
    *,
    row_number()
        over(partition by customer_id order by reserve_datetime) as log_no
from
    awesomebook.reserve

--003_06_2
select
    hotel_id,
    rank() over (order by count(*) desc) as rsv_cnt_rank
from
    awesomebook.reserve
group by
    hotel_id