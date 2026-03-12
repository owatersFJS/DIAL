create or replace package FAC_PKG_TFA_APEX as
  --
  -- ============================================================================================== +
  -- |                                                                                              |
  -- |                                                                                              |
  -- |                             Fujitsu Reachback User Management for TFA                        |
  -- |                                                                                              |
  -- ============================================================================================== +
  -- | Name:         FAC_PKG_TFA_APEX- Package to create and manage users in the rb_users table     |
  -- |               to allow the user to log in and change passwords and use TFA                   |
  -- ============================================================================================== +
  -- |                                                                                              |
  -- | Change Record:                                                                               |
  -- | ==============                                                                               |
  -- | Version   Date         Author           Remarks                                              |
  -- | =======   ===========  =============    =====================================================|
  -- | 1.0       14/04/2023   Edward Davidson  Initial Version                                      |  
  -- ============================================================================================== +
  --
  -- + ============================================================================================ + 
  -- |                                                                                              | 
  -- | Constants                                                                                    |
  -- |                                                                                              |
  -- + ============================================================================================ +
  --
  -- ============================================================================================== + 
  -- | Procedure       : p_register_user                                                            |
  -- | Description     : Used to create the user within the rb_users table and set up TFA using the |
  -- |                   OOS_UTIL_* Packages.                                                       |
  -- ============================================================================================== + 
  procedure p_register_user(
    p_username in varchar2
    , p_password in varchar2
    , p_confirm_password in varchar2
    , p_email in varchar2
    , p_first_name in varchar2
    , p_second_name in varchar2
    , p_enabled in varchar2
    , p_job_title in varchar2
  );
 
  -- ============================================================================================== + 
  -- | Function        : f_validate_otp                                                             |
  -- | Description     : Used to validate the OTP that the user has entered using the username      |
  -- ============================================================================================== + 
  function f_validate_otp(
    p_username in varchar2
    , p_otp in number
  ) return boolean;
-- ============================================================================================== + 
  -- | Function        : f_validate_otp                                                             |
  -- | Description     : Used to validate the OTP that the user has entered using the user id       |
  -- ============================================================================================== + 
    function f_validate_otp(
    p_id in number
    , p_otp in number
  ) return boolean;

  -- ============================================================================================== + 
  -- | Procedure       : p_reset_password                                                           |
  -- | Description     : Used to reset the users password. This proceure is called when the user    |
  -- |                   first logs in or uses the password reset functionality.                    |
  -- ============================================================================================== +    
  procedure p_reset_password(
      p_id in NUMBER
      , p_username in varchar2
      , p_password in varchar2
      , p_expire_pass in varchar2
      , p_tfa_enabled in varchar2
  );
  -- ============================================================================================== + 
  -- | Procedure       : p_authenticate_user                                                        |
  -- | Description     : Used to authenticate the user when they log in.                            |
  -- ============================================================================================== + 
procedure p_authenticate_user(
    p_username in varchar2
    , p_password in varchar2
  );
end;
