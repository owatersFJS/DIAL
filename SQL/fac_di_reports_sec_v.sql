create or replace view fac_di_reports_sec_v as
select i.user_name, r.*
  from fac_di_reports_v r,
       fac_di_access_inclusions_v i
 where i.entity_type = 'AREA'
   and i.entity_id = r.report_area_id
   and i.enabled_flag = 'Y' and sysdate between i.start_date_active and nvl(i.end_date_active,sysdate)
   and not exists (select 1 
                     from fac_di_access_exclusions_v e 
                    where e.entity_type = 'REPORT' 
                      and e.entity_id = r.id
                      and i.user_name = e.user_name
                      and e.enabled_flag = 'Y' and sysdate between e.start_date_active and nvl(e.end_date_active,sysdate)
                      )
  ;  