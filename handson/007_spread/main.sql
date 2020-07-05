-- 007_01
--予約のカウントテーブル
with cnt_tb as(
select
    customer_id,
    people_num,
    count(reserve_id) as rsv_cnt
from
    awesomebook.reserve
group by
    customer_id,
    people_num
)
select
    customer_id,
    max(case people_num when 1 then rsv_cnt else 0 end) as people_num_1,
    max(case people_num when 2 then rsv_cnt else 0 end) as people_num_2,
    max(case people_num when 3 then rsv_cnt else 0 end) as people_num_3,
    max(case people_num when 4 then rsv_cnt else 0 end) as people_num_4,
from
    cnt_tb
group by
    customer_id
order by
    customer_id