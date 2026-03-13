
--As ADMIN

GRANT DB_DEVELOPER_ROLE TO WKSP_OPAPPS;

GRANT create mining model TO WKSP_OPAPPS;

CREATE OR REPLACE DIRECTORY VECTOR_MODELS as 'VECTOR_MODELS';

GRANT READ ON DIRECTORY VECTOR_MODELS TO WKSP_OPAPPS;

GRANT WRITE ON DIRECTORY VECTOR_MODELS TO WKSP_OPAPPS;

grant execute on DBMS_CLOUD to WKSP_OPAPPS;




-- As APEX WKSP user: -


DECLARE 
    ONNX_MOD_FILE VARCHAR2(100) := 'all_MiniLM_L12_v2.onnx';
    MODNAME VARCHAR2(500);
    -- URI Hosted by Oracle for customer use
    LOCATION_URI VARCHAR2(200) := 'https://adwc4pm.objectstorage.us-ashburn-1.oci.customer-oci.com/p/iPX9W0MZeRkwJKWdFmdJCemmN-iKAl_bFvNGYLW7YqIrw4kKsukL24J2q93Beb9S/n/adwc4pm/b/OML-ai-models/o/';
BEGIN
    DBMS_OUTPUT.PUT_LINE('ONNX model file name in Object Storage is: '||ONNX_MOD_FILE); 
--------------------------------------------
-- Define a model name for the loaded model
--------------------------------------------
    SELECT UPPER(REGEXP_SUBSTR(ONNX_MOD_FILE, '[^.]+')) INTO MODNAME from dual;
    DBMS_OUTPUT.PUT_LINE('Model will be loaded and saved with name: '||MODNAME);
-----------------------------------------------------
-- Read the ONNX model file from Object Storage into 
-- the Autonomous Database data pump directory
-----------------------------------------------------
BEGIN DBMS_DATA_MINING.DROP_MODEL(model_name => MODNAME);
EXCEPTION WHEN OTHERS THEN NULL; END;
    DBMS_CLOUD.GET_OBJECT(                            
        credential_name => NULL,
        directory_name => 'VECTOR_MODELS',
        object_uri => LOCATION_URI||ONNX_MOD_FILE);
-----------------------------------------
-- Load the ONNX model to the database
-----------------------------------------                   
    DBMS_VECTOR.LOAD_ONNX_MODEL(
        directory => 'VECTOR_MODELS',
        file_name => ONNX_MOD_FILE,
        model_name => MODNAME);
    DBMS_OUTPUT.PUT_LINE('New model successfully loaded with name: '||MODNAME);
END;

