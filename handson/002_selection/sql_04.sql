with reserve_tb_random as (
    select
        *,
        FIRST_VALUE(rand()) OVER ( PARTITION BY customer_id order by checkout_date) as random_num
    from
        awesomebook.reserve
)
select
    *
from
    reserve_tb_random
where
    random_num <= 0.5