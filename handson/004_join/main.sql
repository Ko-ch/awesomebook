-- 004_01
select
    rsv.reserve_id,
    rsv.hotel_id,
    rsv.customer_id,
    rsv.reserve_datetime,
    rsv.checkin_date,
    rsv.checkin_time,
    rsv.checkout_date,
    rsv.people_num,
    rsv.total_price,
    hotel.base_price,
    hotel.big_area_name,
    hotel.small_area_name,
    hotel.hotel_latitude,
    hotel.hotel_longitude,
    hotel.is_business
from
    awesomebook.reserve rsv
join
    awesomebook.hotel hotel
on
    rsv.hotel_id = hotel.hotel_id
where
    hotel.is_business is True
and
    rsv.people_num = 1

-- 004_02
with small_area_mst as(
    select
        small_area_name,
        case when count(hotel_id) - 1 >= 20
            then small_area_name else big_area_name end as join_area_id
    from
        awesomebook.hotel
    group by
        big_area_name,
        small_area_name
)
, recommend_hotel_mst as (

    select
        big_area_name as join_area_id,
        hotel_id as rec_hotel_id
    from
        awesomebook.hotel
    union all
    select
        small_area_name as join_area_id,
        hotel_id as rec_hotel_id
    from
        awesomebook.hotel
)
select
    hotels.hotel_id,
    r_hotel_mst.rec_hotel_id
from
    awesomebook.hotel hotels
inner join small_area_mst s_area_mst
    on hotels.small_area_name = s_area_mst.small_area_name
inner join recommend_hotel_mst r_hotel_mst
    on s_area_mst.join_area_id = r_hotel_mst.join_area_id
    and hotels.hotel_id != r_hotel_mst.rec_hotel_id

--004_03_a
select
    *,
    lag(total_price, 2) over (partition by customer_id order by reserve_datetime) as before_price
from
    awesomebook.reserve

-- 004_03_b
select
    *,
    case when count(total_price) over (partition by customer_id order by reserve_datetime rows between 2 preceding and current row) = 3
    then sum(total_price) over (partition by customer_id order by reserve_datetime rows between 2 preceding and current row)
    else null end as price_sum
from
    awesomebook.reserve

-- 004_03_c
select
    *,
    avg(total_price) over (partition by customer_id order by checkin_date rows between 3 preceding and 1 preceding) as price_avg
from
    awesomebook.reserve

-- 004_03_d
-- date_add,date_subの使用方法が異なるためエラー。解消せず。
select
    base.*,
    coalesce(sum(combine.total_price), 0) as price_sum
from
    awesomebook.reserve base
left join
    awesomebook.reserve combine
on
    base.customer_id = combine.customer_id
and
    base.reserve_datetime > combine.reserve_datetime
and
    date_sub(date base.reserve_datetime, interval 90 day) <= combine.reserve_datetime
group by
    base.reserve_id,
    base.hotel_id,
    base.customer_id,
    base.reserve_datetime,
    base.checkin_date,
    base.checkin_time,
    base.checkout_date,
    base.people_num,
    base.total_price

-- 004_04
select
    cus.customer_id,
    mst.year_num,
    mst.month_num,
    sum(coalesce(rsv.total_price, 0)) as total_price_month
from
    awesomebook.customer cus
cross join
    awesomebook.month_mst mst
left join
    awesomebook.reserve rsv
    on
    cus.customer_id = rsv.customer_id
    and
    mst.month_first_day <= rsv.checkin_date
    and
    mst.month_last_day >= rsv.checkin_date
where
    mst.month_first_day >= '2017-01-01'
    and
    mst.month_first_day < '2017-04-01'
group by
    cus.customer_id,
    mst.year_num,
    mst.month_num