SELECT *
  FROM (SELECT T1.*, MAX (CREATED) OVER (PARTITION BY OWNER) MAX_TIME FROM T1)
 WHERE CREATED = MAX_TIME;