create or replace view fac_di_settings_v as
select 
s.ID,
s.ENTITY_TYPE,
s.ENTITY_ID,
s.SETTING_TYPE,
s.SETTING_VALUE,
s.DESCRIPTION,
s.DISPLAY_SEQ,
s.ICON,
s.ENABLED_FLAG,
s.SEEDED_FLAG,
s.START_DATE_ACTIVE,
s.END_DATE_ACTIVE,
s.deletion_date,
s.ATTRIBUTE_CONTEXT,
s.ATTRIBUTE_01,
s.ATTRIBUTE_02,
s.ATTRIBUTE_03,
s.ATTRIBUTE_04,
s.ATTRIBUTE_05,
s.N_ATTRIBUTE_01,
s.N_ATTRIBUTE_02,
s.D_ATTRIBUTE_01,
s.D_ATTRIBUTE_02,
s.CREATED,
s.CREATED_BY,
s.UPDATED,
s.UPDATED_BY
  from fac_settings s
     , fac_modules m
where s.module_id = m.id
  and m.module_code = 'DATA_INSIGHTS';  