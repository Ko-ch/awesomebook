-- 010_01
-- BigQueryが優秀なせいで、reserve_tbの値が自動でtimestamp型やdate型として読込
-- その結果、下記のsqlをためせず
select
--    timestamp(reserve_datetime) as reserve_datetime_timestamptz,
--    cast(reserve_datetime) as reserve_datetime_timestamp,
    timestamp(checkin_date || ' ' || checkin_time) as checkin_timestamptz,
    date(reserve_datetime) as reserve_date,
--    date(checkin_date) as checin_date
from
    awesomebook.reserve

-- 010_02
select
    extract(year from reserve_datetime) as reserve_datetime_year,
    extract(month from reserve_datetime) as reserve_datetime_month,
    extract(day from reserve_datetime) as reserve_datetime_day,
    extract(week from reserve_datetime) AS reserve_datetime_week,
    EXTRACT(hour FROM reserve_datetime) AS reserve_datetime_hour,
    EXTRACT(minute FROM reserve_datetime) AS reserve_datetime_minute,
    EXTRACT(second FROM reserve_datetime) AS reserve_datetime_second
from
    awesomebook.reserve

-- 010_03
with tmp_log as(
    select
        reserve_datetime as reserve_datetime,
        cast(date(reserve_datetime) as date) as reserve_datetime2,
        cast(timestamp(checkin_date || " " || checkin_time) as timestamp) as checkin_datetime,
        checkin_date as checkin_datetime2
    from
        awesomebook.reserve
)
select
    date_diff(checkin_datetime2, reserve_datetime2, year) as diff_year,
    date_diff(checkin_datetime2, reserve_datetime2, month) as diff_month,
    date_diff(checkin_datetime2, reserve_datetime2, day) as diff_day,
    timestamp_diff(checkin_datetime, reserve_datetime, hour) as diff_hour,
    timestamp_diff(checkin_datetime, reserve_datetime, minute) as diff_minute,
    cast(timestamp_diff(checkin_datetime, reserve_datetime, second) as float64) / (60 * 60 * 24) as diff_day2,
    cast(timestamp_diff(checkin_datetime, reserve_datetime, second) as float64) / (60 * 60) as diff_hour2,
    cast(timestamp_diff(checkin_datetime, reserve_datetime, second) as float64) / (60) as diff_minute2,
    timestamp_diff(checkin_datetime, reserve_datetime, second) as diff_second
from
    tmp_log

-- 010_04
with tmp_log as(
    select
        cast(datetime(reserve_datetime) as datetime) as reserve_datetime,
        cast(date(reserve_datetime) as date) as reserve_date,
    from
        awesomebook.reserve
)
select
    reserve_datetime as reserve_datetime,
    datetime_add(reserve_datetime, interval 1 day) as reserve_datetime_1d,
    date_add(reserve_date, interval 1 day) as reserve_date_1d,
    datetime_add(reserve_datetime, interval 1 hour) as reserve_datetime_1h,
    datetime_add(reserve_datetime, interval 1 minute) as reserve_datetime_1m,
    datetime_add(reserve_datetime, interval 1 second) as reserve_datetime_1s,
from
    tmp_log

-- 010_05
with tmp_log as(
select
    extract(month from reserve_datetime) as reserve_month
from
    awesomebook.reserve
)
select
    case
        when 3 <= reserve_month and reserve_month <= 5 then 'spring'
        when 6 <= reserve_month and reserve_month <= 8 then 'summer'
        when 9 <= reserve_month and reserve_month <= 11 then 'autumn'
        else 'winter' end
    as reserve_season
from
    tmp_log

-- 010_06
select
    base.*,
    mst.holidayday_flg,
    mst.nextday_is_holiday_flg
from
    awesomebook.reserve base
inner join
    awesomebook.holiday_mst mst
on
    base.checkin_date = mst.target_day