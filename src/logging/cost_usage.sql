USE "SNOWFLAKE"."ACCOUNT_USAGE";

SELECT 
date(start_time) date,
warehouse_name,
       SUM(credits_used) AS Total_Credits_Used,
       SUM(credits_used) * 3 Credits_Cost_in_Dollars
FROM   warehouse_metering_history
WHERE  start_time >= Date_trunc(month, current_date)
GROUP  BY warehouse_name,date(start_time)
ORDER  BY warehouse_name,total_credits_used;