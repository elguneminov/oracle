SELECT DBMS_RANDOM.NORMAL FROM DUAL;

BEGIN
    DBMS_RANDOM.SEED (VAL => 666);
END;

SELECT DBMS_RANDOM.STRING (OPT => 'p', LEN => 50) FROM DUAL;

SELECT DBMS_RANDOM.VALUE (LOW => 50, HIGH => 51) FROM DUAL;