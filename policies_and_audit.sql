CREATE OR REPLACE CONTEXT CARD_CONTEXT
    USING POLICIES;

CREATE OR REPLACE PACKAGE POLICIES
AS
    PROCEDURE SET_CARD_CONTEXT;

    FUNCTION CARD_POLICY (OBJECT_SCHEMA IN VARCHAR2, OBJECT_NAME IN VARCHAR2)
        RETURN VARCHAR2;
END;

CREATE OR REPLACE PACKAGE BODY POLICIES
AS
    PROCEDURE SET_CARD_CONTEXT
    IS
    BEGIN
        DBMS_SESSION.SET_CONTEXT (NAMESPACE   => 'CARD_CONTEXT',
                                  ATTRIBUTE   => 'CARD_EMBOSS_ID',
                                  VALUE       => '1');
    END;

    FUNCTION CARD_POLICY (OBJECT_SCHEMA IN VARCHAR2, OBJECT_NAME IN VARCHAR2)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN    'id = '
               || DBMS_ASSERT.ENQUOTE_LITERAL (
                      SYS_CONTEXT ('CARD_CONTEXT', 'CARD_EMBOSS_ID'));
    END;
END;

SELECT SYS_CONTEXT ('CARD_CONTEXT', 'CARD_EMBOSS_ID') FROM DUAL;

CREATE OR REPLACE TRIGGER SET_CONTEXT_ON_LOGON
    AFTER LOGON
    ON DATABASE
BEGIN
    POLICIES.SET_CARD_CONTEXT;
END;

BEGIN
    DBMS_RLS.ADD_POLICY (OBJECT_SCHEMA     => 'BDSM',
                         OBJECT_NAME       => 'CARDS',
                         POLICY_NAME       => 'CARDS_POLICY',
                         FUNCTION_SCHEMA   => 'BDSM',
                         POLICY_FUNCTION   => 'POLICIES.CARD_POLICY',
                         STATEMENT_TYPES   => 'SELECT');
END;

BEGIN
    DBMS_FGA.ADD_POLICY (OBJECT_SCHEMA     => 'BDSM',
                         OBJECT_NAME       => 'CARDS',
                         POLICY_NAME       => 'CARDS_AUDIT_POLICY',
                         AUDIT_COLUMN      => 'PAN',
                         AUDIT_CONDITION   => 'PAN = ''8565231''');
END;

  SELECT *
    FROM DBA_FGA_AUDIT_TRAIL
ORDER BY TIMESTAMP DESC;

SELECT * FROM UNIFIED_AUDIT_TRAIL;

SELECT * FROM DBA_AUDIT_OBJECT;

SELECT * FROM DBA_AUDIT_SESSION;

SELECT * FROM DBA_DATA_FILES;