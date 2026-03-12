create or replace view fac_di_access_inclusions_v as
select c.id,
       c.user_name,
       c.entity_type,	   
       l.meaning access_level,
       c.entity_id,
       case
         when c.entity_type = 'CATEGORY' then
            (select category_name from fac_di_report_categories_v where id = c.entity_id)
         when c.entity_type = 'REPORT' then
            (select report_name from fac_di_reports_v where id = c.entity_id)  
         when c.entity_type = 'AREA' then
            (select report_area from fac_di_report_areas_v where id = c.entity_id)              
        else
        null
        end name,
       c.enabled_flag,
       c.start_date_active,
       c.end_date_active,
       c.created_by,
       c.created,
       c.updated_by,
       c.updated       
  from fac_di_access_control c,
       fac_di_lookups l
 where 1=1
   and c.entity_type = l.lookup_code
   and l.lookup_type = 'ACCESS_ENTITY_TYPES'
   and c.direction = 'INCLUSION'
 ;