  -- ============================================================================================== +
  -- |                                                                                              |
  -- |                                                                                              |
  -- |                             Fujitsu Reachback User Mgmt Body                                 |
  -- |                                                                                              |
  -- ============================================================================================== +
  -- | Name:         rb_manage_users - Package to create and manage users in the rb_users table     |
  -- |               and in the backend of apex to allow the user to log in and change passwords    |
  -- ============================================================================================== +
  -- |                                                                                              |
  -- | Change Record:                                                                               |
  -- | ==============                                                                               |
  -- | Version   Date         Author           Remarks                                              |
  -- | =======   ===========  =============    =====================================================|
  -- | 1.0       27/09/2022   Rashmi Mishra    Initial Version                                      |  
  -- | 2.0       10/10/2022   Rashmi Mishra    Added procedure run_reset_pwd_job                    |
  -- |                                                                                              |
  -- ============================================================================================== +
  --
--=================================================================================================
--- ****                  Package Body                               ****
--=================================================================================================


CREATE OR REPLACE PACKAGE BODY RB_MANAGE_USERS AS
    
	
  -- ============================================================================================== + 
  -- procedure to log any APEX specific errors
  -- ============================================================================================== + 
  procedure apex_add_error
    ( p_message          in varchar2 )
  is 
    --
  begin
    -- Check if we are being called from an APEX application
    if APEX_UTIL.GET_DEFAULT_SCHEMA is not null then 
      apex_error.add_error
        ( p_message          => p_message,
          p_display_location => apex_error.c_inline_in_notification );
    else
      dbms_output.put_line(p_message);
    end if;
    --
  end apex_add_error;
  --
  
  -- ============================================================================================== + 
  -- procedure to generate password
  -- ============================================================================================== + 
  function gen_password
    ( p_length   in number )
  return varchar2
  is
    l_password   varchar2(20);
  begin
    --
    select dbms_random.string('p', p_length) 
    into   l_password
    from   dual;
    return l_password;
    --
  end;
  --
  
  -- ============================================================================================== + 
  -- | Procedure       : process_user                                                               |
  -- | Description     : Standard procedure to manage the creation, update and deletion of users    |
  -- ============================================================================================== + 
  -- Process user returns the user_id
  
  procedure process_user
    ( p_action            in  varchar2,  -- valid values CREATE, UPDATE or DELETE
      p_username          in  varchar2,
	  p_first_name		  in varchar2,
	  p_last_name		  in varchar2,
	  p_email_address	  in varchar2,
      p_job_title         in  varchar2   default null,
      p_enabled_flag      in  varchar2   default 'Y',
      p_app_id            in  number,
      p_user_id           in out number )
  is
    --
    l_password         varchar2(20);
	l_apex_privs       varchar2(100);
    l_account_locked   varchar2(1);
    l_email            varchar2(100);
    l_first_name       varchar2(50);
    l_last_name        varchar2(50);
    l_workspace_id     number;
    --
  begin
   
    --
    apex_debug.message ( p_message => 'Privileges set' );      
    --
	-- set the priveleges for the apex user
		  l_apex_privs := NULL;
		  --l_apex_privs := 
	--	  
    if p_action = 'CREATE' then
      --
      apex_debug.message ( p_message => 'CREATE Action' );      
      --
      --
      apex_debug.message ( p_message => 'Inserting into users table' );      
      --
	  -- ================================================================
	  -- **** Create the new user in rb_users table ***
	  -- ================================================================
	  --
      insert into rb_users
	   ( username,
        first_name ,        
		last_name ,         
		email, 
		job_title,
		enabled_flag)             
     values
       ( p_username       ,
		p_first_name	  ,
		p_last_name		  ,
		p_email_address	  , 
		p_job_title,
		p_enabled_flag)
      returning id into p_user_id;

		-- ================================================================
		-- *** Generate password  ***
		-- ================================================================


      l_password  := gen_password(p_length=>9);
	  
      apex_debug.message ( p_message => 'Initial password generated' );      
      --
      l_workspace_id := apex_util.find_security_group_id (p_workspace => 'XXFACES_EBS');
	  
      apex_util.set_security_group_id ( p_security_group_id  => l_workspace_id );
      --
		-- ================================================================
		-- *** Create a new APEX user  ***
		-- ================================================================
	  apex_util.create_user
        ( p_user_id                       => p_user_id,
          p_user_name                     => p_username,
          p_first_name                    => p_first_name,
          p_last_name                     => p_last_name,
          p_email_address                 => p_email_address,
          p_web_password                  => l_password,
          p_developer_privs               => l_apex_privs,
          p_change_password_on_first_use  => 'Y');
      --
      apex_debug.message ( p_message => 'APEX User created' );      
     --
 	  
		  
		-- ================================================================
		-- *** Send an email to the user with the login credentials  ***
		-- ================================================================
		apex_mail.send ( 
			p_to                 => p_email_address,
			p_template_static_id => 'NEW_USER_ACCOUNT_NOTIFICATION',  --- @@@ do we need to create these templates
			p_placeholders       => '{' ||
			'    "FIRST_NAME":' || apex_json.stringify( p_first_name ) ||
			'   ,"LAST_NAME":' || apex_json.stringify( p_last_name ) ||
			'   ,"USERNAME":'   || apex_json.stringify( p_username ) || 
			'   ,"EXP_DATE":'   || apex_json.stringify( TO_CHAR(SYSDATE + 2, 'dd/mm/yyyy') ) ||
			'}' ,
			p_from                      =>    'Reachback - Do not reply <no_reply@fujitsu.com>', 
			p_application_id =>  TO_NUMBER( p_app_id ));
			
  
		apex_mail.push_queue;  
	
      --
		apex_debug.message ( p_message => 'Notification sent for login credentials' ); 
      --
		-- ================================================================
		-- *** Send an email to the user with password details  ***
		-- ================================================================
	
	  
	   --
        apex_mail.send (
			p_to                 => p_email_address,
			p_template_static_id => 'NEW_USER_ACCOUNT_PASSWORD_NOTIFICATION',
			p_placeholders       => '{' ||
			'    "FIRST_NAME":' || apex_json.stringify( p_first_name ) ||
			'   ,"LAST_NAME":' || apex_json.stringify( p_last_name ) ||
			'   ,"PASSWORD":'   || apex_json.stringify( l_password ) ||
			'   ,"EXP_DATE":'   || apex_json.stringify( TO_CHAR(SYSDATE + 2, 'dd/mm/yyyy') ) ||
			'}' ,
			p_from                      =>    'Reachback - Do not reply <no_reply@fujitsu.com>', 
			p_application_id => TO_NUMBER( p_app_id ) );
			
		apex_mail.push_queue;
	
	   --
		apex_debug.message ( p_message => 'Notification for password sent' ); 
      --
  
    
	elsif p_action = 'UPDATE' then
      --
      apex_debug.message ( p_message => 'UPDATE Action' );      
      --
      apex_debug.message ( p_message => 'Updating Reachback Users' );      
	  
	  --- ** Setting the apex users privs **
      l_apex_privs := APEX_UTIL.GET_USER_ROLES(p_username => p_username);
	  
	    
      update RB_users
         set first_name = p_first_name,        
			 last_name = p_last_name,
		     email = p_email_address,
		     job_title = p_job_title,
             enabled_flag = p_enabled_flag
      where id = apex_util.get_user_id(p_username); --p_user_id
      --
      if p_enabled_flag = 'Y' then
        l_account_locked := 'N';
      else
        l_account_locked := 'Y';
      end if;
      --
        --
        apex_util.edit_user
          ( p_user_id                => apex_util.get_user_id(p_username), --p_user_id,
            p_user_name              => p_username,
            p_first_name             => p_first_name,
            p_last_name              => p_last_name,
			p_email_address          => p_email_address,
            p_account_locked         => l_account_locked,
            p_developer_roles        => l_apex_privs,
            p_change_password_on_first_use => 'N' );
        --
      --
    elsif p_action = 'DELETE' then
      --
      -- Delete not allowed.  Can only change enabled flag
      null;
      --
    end if;

    --
  end process_user;
  -- 
  -- ============================================================================================== + 
  -- | Procedure       : user_change_password                                                       |
  -- | Description     : Standard procedure to manage the change user password                      |
  -- ============================================================================================== + 
  --
  procedure user_change_password     
    ( p_id            IN  VARCHAR2,
      p_username      IN  VARCHAR2,
      p_old_pass      IN  VARCHAR2,
      p_new_pass      IN  VARCHAR2,
      p_app_id        in  number)
    is
    --
    begin
    --change users password
       apex_util.reset_password (  
        p_user_name => upper(p_username),  
        p_old_password => p_old_pass,  
        p_new_password => p_new_pass,  
        p_change_password_on_first_use => FALSE);   

    end;
  -- 
  -- ============================================================================================== + 
  -- | Procedure       : run_reset_pwd_job                                                          |
  -- | Description     : Standard procedure to run the reset user password job                      |
  -- ============================================================================================== + 
  --
     
   procedure run_reset_pwd_job (  
		p_username in varchar2,  
		p_schema in varchar2,  
		p_random_password in varchar2,  
		p_user_email in varchar2,  
		p_app_id in number,  
		p_from_email in varchar2,  
		p_first_name in varchar2,  
		p_last_name in varchar2)  
	is  
	begin  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 1,  argument_value => p_username);  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 2,  argument_value => p_schema);   
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 3,  argument_value => p_random_password);  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 4,  argument_value => p_user_email);  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 5,  argument_value => p_app_id);  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 6,  argument_value => p_from_email);  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 7,  argument_value => p_first_name);  
		dbms_scheduler.set_job_argument_value (job_name => 'RB_PWD_RESET', argument_position => 8,  argument_value => p_last_name);  
  
	dbms_scheduler.run_job (  
	job_name => 'RB_PWD_RESET',    --- @@@@ Need to find this job and do something similar
	use_current_session => false );  
end run_reset_pwd_job;  
 --
   -- ============================================================================================== + 
  -- | Procedure       : do_reset_pwd                                                               |
  -- | Description     : Standard procedure to reset user password					                |
  -- ============================================================================================== + 
  --
 --
procedure do_reset_pwd (  
		p_username in varchar2,  
		p_schema in varchar2,  
		p_random_password in varchar2,  
		p_user_email in varchar2,  
		p_app_id in number,  
		p_from_email in varchar2,  
		p_first_name in varchar2,  
		p_last_name in varchar2)  
	is 
        l_rb_url varchar2(1000); -- Ver 1.1
	begin  
    -- ** Get the url from the config table***
	  begin
		select config_value into l_rb_url 
		from RB_configuration 
		where config_key = 'RB_url'; -- Ver 1.1 - @@@@@Determine login url from configuration table
	  exception
		when no_data_found then
		apex_add_error
       ( p_message  => 'No record in the rb_config table for the given config_key' );
      end;
	  
	apex_util.set_security_group_id(apex_util.find_security_group_id(p_schema));  
	
    apex_util.reset_password (  
		p_user_name => p_username,  
		p_old_password => '',  
		p_new_password => p_random_password,  
		p_change_password_on_first_use => TRUE);  
			
    apex_mail.send (   
        p_to                 => p_user_email,  
        p_template_static_id => 'JOB_PASSWORD_RESET',    --- @@@@ check where this job is defined
        p_placeholders       => '{' ||  
        '    "FIRST_NAME":' || apex_json.stringify( p_first_name ) ||
        '   ,"LAST_NAME":'  || apex_json.stringify( p_last_name ) ||
        '   ,"PASSWORD":'   || apex_json.stringify( p_random_password ) ||  
        '   ,"RB_URL":'    || apex_json.stringify( l_rb_url ) ||      -- Ver 1.1
        '}' ,  
        p_from           =>    p_from_email,  
        p_application_id => p_app_id);  
  
	apex_mail.push_queue;  
	
end do_reset_pwd;  

   
END RB_MANAGE_USERS;
/
