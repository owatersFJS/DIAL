create or replace view fac_di_report_cat_sec_v as
select distinct r.user_name, c.* 
  from fac_di_report_categories_v c,
       fac_di_reports_sec_v r
 where 1=1
   and c.parent_category_id is not null
   and c.id = r.category_id
   and c.enabled_flag = 'Y' and sysdate between c.start_date_active and nvl(c.end_date_active,sysdate)      
   and r.enabled_flag = 'Y' and sysdate between r.start_date_active and nvl(r.end_date_active,sysdate)         
  ; 