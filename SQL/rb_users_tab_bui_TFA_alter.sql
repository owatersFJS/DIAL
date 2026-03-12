-- +==============================================================================================+
-- |                                                                                              |
-- |                                                                                              |
-- |                                      Fujitsu FACES   - Reachback                             |
-- |                                                                                              |
-- +==============================================================================================+
-- |                                                                                              |  
-- | Change Record:                                                                               |
-- | ==============                                                                               |
-- | Version   Date         Author           Remarks                                              |
-- | =======   ===========  =============    =====================================================|
-- | 1.0       12/04/2023   Edward Davidson    rb_users Table alter to add columns for TFA login  |
-- |                                                                                              |
-- ============================================================================================== +
--


-- alter table

alter table rb_users 
add (TFA_ACTIVE NUMBER(1,0) DEFAULT '1' NOT NULL ENABLE,
     TFA_ENABLED NUMBER(1,0) DEFAULT '0' NOT NULL ENABLE,
     PASSWORD_HASH VARCHAR2(255) COLLATE USING_NLS_COMP, 
     SHARED_SECRET VARCHAR2(255) COLLATE USING_NLS_COMP, 
     EXPIRY_DATE DATE, 
     PASSWORD_EXPIRED VARCHAR2(1) COLLATE USING_NLS_COMP DEFAULT 'Y')
;

-- comments
comment on column rb_users.tfa_active is 'Indictates if TFA is enabled for this account.';
comment on column rb_users.tfa_enabled is 'Indicates whether the user has set up TFA.';
comment on column rb_users.password_hash is 'Used to store the hashed password for the user.';
comment on column rb_users.shared_secret is 'Used to store the users Shared Secret used for TFA.';
comment on column rb_users.expiry_date is 'Used to store the date when the account will/has exprired.';
comment on column rb_users.password_expired is 'Used to manage if the user has to change their password once they sign in.';
