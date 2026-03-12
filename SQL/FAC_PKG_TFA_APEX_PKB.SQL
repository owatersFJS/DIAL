create or replace package body fac_pkg_tfa_apex as
  -- ============================================================================================== +
  -- |                                                                                              |
  -- |                                                                                              |
  -- |                             Fujitsu Reachback User Management for TFA                        |
  -- |                                                                                              |
  -- ============================================================================================== +
  -- | Name:         FAC_PKG_TFA_APEX - Package to create and manage users in the rb_users table    |
  -- |               to allow the user to log in and change passwords and use TFA    .              |
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
  -- ============================================================================================== + 
  -- | Function        : f_hash_password                                                            |
  -- | Description     : Used to hash the users entered password using the oos_util_crypto package. |
  -- ============================================================================================== + 
  function f_hash_password(
    p_password varchar2
  ) return varchar2
  as
  begin
    return
      oos_util_crypto.hash_str(
        p_src => p_password
        , p_typ => oos_util_crypto.gc_hash_sh256
      )
    ;
  end f_hash_password;
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
    )
  as
    l_shared_secret VARCHAR2(255);
    l_password_hash VARCHAR2(255);
    l_num_results pls_integer := -1;

    illegal_arguments_error exception;
  begin
    if
        p_username is null
        or p_password is null
        or p_password != p_confirm_password
    then
      raise illegal_arguments_error;
    end if;

    l_password_hash := f_hash_password(p_password => p_password);

    while l_num_results != 0
    loop
      l_shared_secret := oos_util_totp.generate_secret;

      select count(1)
      into l_num_results
      from RB_USERS
      where shared_secret = l_shared_secret;
    end loop;

    insert into RB_USERS
    (
      username
      , password_hash
      , shared_secret
      , email
      , first_name
      , last_name
      , ENABLED_FLAG
      , JOB_TITLE
      , PASSWORD_EXPIRED
    )
    values
    (
      p_username
      , l_password_hash
      , l_shared_secret
      , p_email
      , p_first_name
      , p_second_name
      , p_enabled
      , p_job_title 
      ,'Y'
    );
  exception
    when others then
      -- error handling
      raise;
  end p_register_user;
  -- ============================================================================================== + 
  -- | Procedure       : p_authenticate_user                                                        |
  -- | Description     : Used to authenticate the user when they log in.                            |
  -- ============================================================================================== + 
  procedure p_authenticate_user(
    p_username in varchar2
    , p_password in varchar2
  )
  as
    l_password_hash VARCHAR2(255);
    l_tfa_enabled NUMBER(1,0);

    login_failed exception;
  begin
    begin
      select password_hash, tfa_enabled
      into l_password_hash, l_tfa_enabled
      from RB_USERS
      where 1 = 1
        and lower(username) = lower(p_username)
        and coalesce(expiry_date, sysdate) >= sysdate
        and tfa_active = 1
      ;
    exception
      when no_data_found then
        raise login_failed;
    end;

    if l_password_hash = f_hash_password(p_password => p_password) then
      if l_tfa_enabled = 0 then
        /*apex_authentication.post_login(
          p_username => p_username
          , p_password => null
        );
        apex_util.clear_page_cache();*/
        null;
      end if;
    else
      raise login_failed;
    end if;
  exception
    when login_failed then
      apex_authentication.login(
        p_username => p_username
        , p_password => null
      );
  end p_authenticate_user;

  -- ============================================================================================== + 
  -- | Function        : f_authenticate_user                                                        |
  -- | Description     : Used to hash the users entered password using the oos_util_crypto package. |
  -- ============================================================================================== + 
  function f_authenticate_user(
    p_username in varchar2
    , p_password in varchar2
  ) return boolean
  as
    l_password_hash VARCHAR2(255);
  begin
    select password_hash
    into l_password_hash
    from RB_USERS
    where 1 = 1
      and lower(username) = lower(p_username)
      and coalesce(expiry_date, sysdate) >= sysdate
      and tfa_active = 1
    ;

    return l_password_hash = f_hash_password(p_password => p_password);
  exception
    when no_data_found then
      return false;
  end f_authenticate_user;

  -- ============================================================================================== + 
  -- | Function        : f_validate_otp                                                             |
  -- | Description     : Used to validate the OTP that the user has entered                         |
  -- ============================================================================================== + 
  function f_validate_otp(
    p_id in NUMBER
    , p_otp in number
  ) return boolean
  as
    l_shared_secret VARCHAR2(255);
  begin
    select shared_secret
    into l_shared_secret
    from RB_USERS
    where 1 = 1
      and id = p_id
      and coalesce(expiry_date, sysdate) >= sysdate
      and tfa_active = 1
    ;

    return
      oos_util_totp.validate_otp(
        p_secret => l_shared_secret
        , p_otp => p_otp
      ) = 1
    ;
  exception
    when no_data_found then
      return false;
  end f_validate_otp;

  -- ============================================================================================== + 
  -- | Function        : f_validate_otp                                                             |
  -- | Description     : Used to validate the OTP that the user has entered                         |
  -- ============================================================================================== + 
  function f_validate_otp(
    p_username in varchar2
    , p_otp in number
  ) return boolean
  as
    l_id NUMBER;
  begin
    select id
    into l_id
    from RB_USERS
    where lower(username) = lower(p_username);

    return f_validate_otp(p_id => l_id, p_otp => p_otp);
  exception
    when no_data_found then
      return false;
  end f_validate_otp;

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
      )
      as
        l_password_hash VARCHAR2(255);
      begin
      
        l_password_hash := f_hash_password(p_password => p_password);
      
        UPDATE rb_users
        SET password_hash = l_password_hash, password_expired = p_expire_pass, tfa_enabled = p_tfa_enabled
        WHERE id = p_id;

/*
        apex_util.reset_password (
          p_user_name => p_username
        , p_old_password => p_old_password
        , p_new_password => p_password );*/

      end p_reset_password;




end fac_pkg_tfa_apex;
