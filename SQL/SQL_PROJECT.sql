-- ==========================================
--        MODULE 3 – MYSQL PROJECT
-- ==========================================

-- Create Database
CREATE DATABASE module3_project;
USE module3_project;

-- ==========================================
-- 1. CREATE TABLES
-- ==========================================

-- EMP TABLE
CREATE TABLE EMP (
    Empno INT(4) PRIMARY KEY,
    Ename VARCHAR(10),
    Job VARCHAR(9),
    Mgr INT(4),
    Hiredate DATE,
    Sal DECIMAL(7,2),
    Comm DECIMAL(7,2),
    Deptno INT(2)
);

-- DEPT TABLE
CREATE TABLE DEPT (
    Deptno INT(2) PRIMARY KEY,
    Dname VARCHAR(14),
    Loc VARCHAR(13)
);

-- STUDENT TABLE
CREATE TABLE STUDENT (
    Rno INT(2) PRIMARY KEY,
    Sname VARCHAR(14),
    City VARCHAR(20),
    State VARCHAR(20)
);

-- EMP_LOG TABLE
CREATE TABLE EMP_LOG (
    Emp_id INT(5),
    Log_date DATE,
    New_salary INT(10),
    Action VARCHAR(20)
);

-- ==========================================
-- 2. INSERT DATA
-- ==========================================

-- DEPT DATA
INSERT INTO DEPT VALUES
(10,'ACCOUNTING','NEW YORK'),
(20,'RESEARCH','DALLAS'),
(30,'SALES','CHICAGO'),
(40,'OPERATIONS','BOSTON');

-- EMP DATA
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),
(7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30),
(7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30),
(7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),
(7782,'CLARK','MANAGER',7839,'1981-06-09',2450,NULL,10),
(7788,'SCOTT','ANALYST',7566,'1987-06-11',3000,NULL,20),
(7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10),
(7844,'TURNER','SALESMAN',7698,'1981-08-09',1500,0,30),
(7876,'ADAMS','CLERK',7788,'1987-07-13',1100,NULL,20),
(7900,'JAMES','CLERK',7698,'1981-03-12',950,NULL,30),
(7902,'FORD','ANALYST',7566,'1981-03-12',3000,NULL,20),
(7934,'MILLER','CLERK',7782,'1982-01-23',1300,NULL,10);

-- ==========================================
-- 3. QUERIES (1 – 23)
-- ==========================================

-- 1
SELECT DISTINCT Job FROM EMP;

-- 2
SELECT * FROM EMP ORDER BY Deptno ASC, Job DESC;

-- 3
SELECT DISTINCT Job FROM EMP ORDER BY Job DESC;

-- 4
SELECT * FROM EMP WHERE Hiredate < '1981-01-01';

-- 5
SELECT Empno, Ename, Sal,
       (Sal*12)/365 AS Daily_Sal
FROM EMP
ORDER BY (Sal*12) ASC;

-- 6
SELECT Empno, Ename, Sal,
       YEAR(CURDATE()) - YEAR(Hiredate) AS Experience
FROM EMP
WHERE Mgr = 7369;

-- 7
SELECT * FROM EMP WHERE Comm > Sal;

-- 8
SELECT * FROM EMP
WHERE Job IN ('CLERK','ANALYST')
ORDER BY Job DESC;

-- 9
SELECT * FROM EMP
WHERE (Sal*12) BETWEEN 22000 AND 45000;

-- 10
SELECT Ename FROM EMP
WHERE Ename LIKE 'S____';

-- 11
SELECT * FROM EMP
WHERE Empno NOT LIKE '78%';

-- 12
SELECT * FROM EMP
WHERE Job='CLERK' AND Deptno=20;

-- 13
SELECT E.*
FROM EMP E
JOIN EMP M ON E.Mgr = M.Empno
WHERE E.Hiredate < M.Hiredate;

-- 14
SELECT * FROM EMP
WHERE Deptno=20
AND Job IN (SELECT Job FROM EMP WHERE Deptno=10);

-- 15
SELECT * FROM EMP
WHERE Sal IN (
    SELECT Sal FROM EMP WHERE Ename IN ('FORD','SMITH')
)
ORDER BY Sal DESC;

-- 16
SELECT * FROM EMP
WHERE Job IN (
    SELECT Job FROM EMP WHERE Ename IN ('SMITH','ALLEN')
);

-- 17
SELECT DISTINCT Job
FROM EMP
WHERE Deptno=10
AND Job NOT IN (SELECT Job FROM EMP WHERE Deptno=20);

-- 18
SELECT MAX(Sal) AS Highest_Salary FROM EMP;

-- 19
SELECT * FROM EMP
WHERE Sal = (SELECT MAX(Sal) FROM EMP);

-- 20
SELECT SUM(Sal) AS Total_Manager_Salary
FROM EMP
WHERE Job='MANAGER';

-- 21
SELECT * FROM EMP
WHERE Ename LIKE '%A%';

-- 22
SELECT *
FROM EMP E
WHERE Sal = (
    SELECT MIN(Sal)
    FROM EMP
    WHERE Job = E.Job
)
ORDER BY Sal ASC;

-- 23
SELECT * FROM EMP
WHERE Sal > (SELECT Sal FROM EMP WHERE Ename='BLAKE');

-- ==========================================
-- 4. VIEW
-- ==========================================

CREATE VIEW v1 AS
SELECT E.Ename, E.Job, D.Dname, D.Loc
FROM EMP E
JOIN DEPT D
ON E.Deptno = D.Deptno;

-- ==========================================
-- 5. STORED PROCEDURE
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetEmpByDept(IN dno INT)
BEGIN
    SELECT E.Ename, D.Dname
    FROM EMP E
    JOIN DEPT D ON E.Deptno = D.Deptno
    WHERE E.Deptno = dno;
END //

DELIMITER ;

-- To Call:
-- CALL GetEmpByDept(10);

-- ==========================================
-- 6. ALTER TABLE
-- ==========================================

-- 26 Add column Pin
ALTER TABLE STUDENT
ADD Pin BIGINT;

-- 27 Modify sname length
ALTER TABLE STUDENT
MODIFY Sname VARCHAR(40);

-- ==========================================
-- 7. TRIGGER
-- ==========================================

DELIMITER //

CREATE TRIGGER trg_salary_update
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    IF OLD.Sal <> NEW.Sal THEN
        INSERT INTO EMP_LOG
        VALUES (NEW.Empno, CURDATE(), NEW.Sal, 'New Salary');
    END IF;
END //

DELIMITER ;

-- ==========================================
-- END OF PROJECT
-- ==========================================
