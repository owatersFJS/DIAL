create or replace view fac_di_report_areas_sec_v as
select distinct c.user_name, a.* 
  from fac_di_report_areas_v a,
       fac_di_report_cat_sec_v c
 where 1=1
   and a.id = c.parent_category_id  --categories
   and a.enabled_flag = 'Y' and sysdate between a.start_date_active and nvl(a.end_date_active,sysdate)   
   and c.enabled_flag = 'Y' and sysdate between c.start_date_active and nvl(c.end_date_active,sysdate)      
  ;