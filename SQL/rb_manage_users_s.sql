CREATE OR REPLACE PACKAGE RB_MANAGE_USERS AS 
  --
  --
  -- ============================================================================================== +
  -- |                                                                                              |
  -- |                                                                                              |
  -- |                             Fujitsu Reachback User Mgmt Spec                                 |
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
  -- ============================================================================================== +
  --
  -- + ============================================================================================ + 
  -- |                                                                                              | 
  -- | Constants                                                                                    |
  -- |                                                                                              |
  -- + ============================================================================================ +
  --
  -- ============================================================================================== + 
  -- | Procedure       : process_user                                                               |
  -- | Description     : Standard procedure to manage the creation, update and deletion of users    |
  -- ============================================================================================== + 
  procedure process_user
	( p_action            in  varchar2,  -- valid values CREATE, UPDATE or DELETE
      p_username          in  varchar2,
	  p_first_name		  in varchar2,
	  p_last_name		  in varchar2,
	  p_email_address	  in varchar2,
      p_job_title         in  varchar2   default null,
      p_enabled_flag      in  varchar2   default 'Y',
      p_app_id            in  number,
      p_user_id           in out number );
	  
    /*( p_action            in  varchar2,  -- valid values CREATE, UPDATE or DELETE
      p_is_administrator  in  varchar2,  -- has to be set to 'Y' else it wont work for admin
      p_username          in  varchar2,
	  p_first_name		  in varchar2,
	  p_last_name		  in varchar2,
	  p_email_address	  in varchar2,
    --  p_address_book_id   in number,
      p_job_title         in  varchar2   default null,
      p_enabled_flag      in  varchar2   default 'Y',
      p_admin_flag        in  varchar2,
     -- p_project_manager   in  varchar2,
      p_app_id            in  number,
      p_user_id           in out number );  --- OLD*/ 
	  
  --
  --
  -- ============================================================================================== + 
  -- procedure to log any APEX specific errors
  -- ============================================================================================== + 
  procedure apex_add_error
    ( p_message          in varchar2 );
  --	
  --	
  -- ============================================================================================== + 
  -- | Procedure       : user_change_password                                                       |
  -- | Description     : Procedure used to change the users password                                |
  -- ============================================================================================== + 
  procedure user_change_password     
    ( p_id            IN  VARCHAR2,
      p_username      IN  VARCHAR2,
      p_old_pass      IN  VARCHAR2,
      p_new_pass      IN  VARCHAR2,
      p_app_id        IN  NUMBER);  
  -- 
 
 ---
 -- This is required as  we cannot reset password directly as we needto have admin priveleges
 -- which is set when the job is setup.
 --
  procedure run_reset_pwd_job     
   (    p_username in varchar2,  
		p_schema in varchar2,  
		p_random_password in varchar2,  
		p_user_email in varchar2,  
		p_app_id in number,  
		p_from_email in varchar2,  
		p_first_name in varchar2,  
		p_last_name in varchar2); 
 --
 procedure do_reset_pwd (  
		p_username in varchar2,  
		p_schema in varchar2,  
		p_random_password in varchar2,  
		p_user_email in varchar2,  
		p_app_id in number,  
		p_from_email in varchar2,  
		p_first_name in varchar2,  
		p_last_name in varchar2);


 
END RB_MANAGE_USERS;
/