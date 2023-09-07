# ID 2024 : Unique Users Per Client Per Month
select client_id,
       month,
       count(distinct (user_id)) as users_num
from facts_events
group by 1, 2
order by 1;
# -----------------------------------------------------------
# ID 2056 : Number of Shipments Per Month
with cte as
         (select *,
                 concat(shipment_id, " ", sub_id) as "key",
                 left(shipment_date, 7) as date_ym
          from amazon_shipment)
select count(*) as count,
       date_ym
from cte
group by date_ym
# ---------------------------------------------------------------
# ID 2119 Most Lucrative Products
with cte as
    (select
    *, quarter (date) as qt, (cost_in_dollars* units_sold) as revenue
    from
    online_orders)
select product_id,
       sum(revenue)
from cte
where qt <= 2
group by 1
order by 2 desc
limit 5;
#----------------------------------------------------------------
#ID 9622 Number Of Bathrooms And Bedrooms
select city,
       property_type,
       avg(bathrooms),
       avg(bedrooms)
from airbnb_search_details
group by 2, 1;
# -----------------------------------------------------------------
# ID 9653 Count the number of user events performed by MacBookPro users
select event_name,
       count(*)
from playbook_events
where device IN ("Macbook Pro")
group by 1;
#-------------------------------------------------------------------
# ID 9663 Find the most profitable company in the financial sector of the entire world along with its continent
select company,
       continent
from forbes_global_2010_2014
where sector
          Like ("Financ%")
order by assets desc
limit 1;
# ------------------------------------------------------------------
# ID 9688 Churro Activity Date
select activity_date,
       pe_description
from los_angeles_restaurant_health_inspections
WHERE facility_name
    like ("%STREET CHURROS%")
  and score < 95;
# --------------------------------------------------------------------
# ID 9845 Admin Department Employees Beginning in April or Later
select count(*)
from worker
where department
    like ("Admin%")
  and MONTH(joining_date) >= 4;
# ------------------------------------------------------------------
# ID 9847 Number of Workers by Department Starting in April or Later
select department,
       count(*)
from worker
where month(joining_date) >= 4
group by department;
# ------------------------------------------------------------------
# ID 9891 Customer Details
select first_name,
       last_name,
       city,
       order_details
from customers c
         left join
     orders o
     on
         c.id = o.cust_id
Order by 1, 4;
# ------------------------------------------------------------------
# ID 9913 Order Details
select order_date,
       order_details,
       total_order_cost,
       first_name
from customers c
         inner join
     orders o
     on
         c.id = o.cust_id
where first_name
          IN ("Jill", "Eva")
order by cust_id;
# ------------------------------------------------------------------
# ID 9917 Average Salaries
select department,
       first_name,
       salary,
       avg(salary) over (partition by department)
from employee;
# ------------------------------------------------------------------
# ID 9924 Find libraries who haven't provided the email address in circulation year 2016 but their notice preference definition is set to email
select distinct home_library_code
from library_usage
where circulation_active_year = 2016
  and notice_preference_definition
    IN
      (upper("email"))
  and provided_email_address = 0;
# ------------------------------------------------------------------
# ID 9972 Find the base pay for Police Captains
select employeename,
       basepay
from sf_public_salaries
where jobtitle
          like
      ("%Police%");
# ------------------------------------------------------------------
# ID 9992 Find how many times each artist appeared on the Spotify ranking list
select artist,
       count(*)
from spotify_worldwide_daily_song_ranking
group by 1
order by 2 desc;
# ------------------------------------------------------------------
# ID 9992 Find how many times each artist appeared on the Spotify ranking list
select *
from lyft_drivers
where yearly_salary <= 30000
   or yearly_salary >= 70000;
# ------------------------------------------------------------------
# ID 10003 Lyft Driver Wages
select location,
       avg(popularity)
from facebook_employees fe
         inner join
     facebook_hack_survey fc
     on
         fe.id = fc.employee_id
group by 1;
# ---------------------------------------------------------------
# ID 10087 Find all posts which were reacted to with a heart
select distinct fp.post_id,
                fp.poster,
                fp.post_text,
                fp.post_keywords,
                fp.post_date
from facebook_reactions fr
         inner join
     facebook_posts fp
     on
         fr.post_id = fp.post_id
where reaction
          like
      "%heart%";
# ---------------------------------------------------------------
# ID 10128 Count the number of movies that Abigail Breslin nominated for oscar
select count(*)
from oscar_nominees
where nominee
          like
      "Abigail%";
# ---------------------------------------------------------------
# ID 10166 Reviews of Hotel Arena
select hotel_name,
       reviewer_score,
       count(*)
from hotel_reviews
where hotel_name = 'Hotel Arena'
group by 2;

# ---------------------------------------------------------------
# ID 10176 Bikes Last Used
with cte as (select bike_number,
                    rider_type,
                    id,
                    start_time,
                    start_station,
                    start_terminal,
                    end_time,
                    end_station,
                    end_terminal,
                    duration,
                    duration_seconds
             from dc_bikeshare_q1_2012)
select bike_number,
       max(end_time)
from cte
group by 1
order by end_time desc

# ---------------------------------------------------------------
# ID 10299 Finding Updated Records
select id,
       first_name,
       last_name,
       department_id,
       max(salary)
from ms_employee_salary
group by 1, 2, 4
order by 1
# ---------------------------------------------------------------
# ID 10308 Salaries Differences
    with cte as
         (select
              e.id,
              e.first_name,
              e.last_name,
              e.salary,
              d.department
          from
              db_employee e
                  inner join
                  db_dept d
                      on
                          e.department_id = d.id)
select abs(max(a.salary) - max(b.salary))
from cte a,
     cte b
where a.department
    like
      "market%"
  and b.department
    like
      "engine%"