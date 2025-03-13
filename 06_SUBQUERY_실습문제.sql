-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_NAME != '전지연'
AND DEPT_ID = (SELECT DEPT_CODE
							 FROM EMPLOYEE SUB
							 WHERE EMP_NAME = '전지연');

-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MAX(SALARY)
								FROM EMPLOYEE
								WHERE EXTRACT(YEAR FROM HIRE_DATE) > '2000');

-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE EMP_NAME != '노옹철'
AND (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
															 FROM EMPLOYEE
															 WHERE EMP_NAME = '노옹철');

-- 4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
																FROM EMPLOYEE
																WHERE EXTRACT(YEAR FROM HIRE_DATE) = '2000');

-- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) IN (SELECT DEPT_CODE, MANAGER_ID
																  FROM EMPLOYEE
																  WHERE EMP_NO LIKE '77%'
																  AND SUBSTR(EMP_NO, 8, 1) = '2');

-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회..

SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE HIRE_DATE IN (SELECT MIN(HIRE_DATE)
										FROM EMPLOYEE
										WHERE ENT_YN = 'N'
										GROUP BY DEPT_CODE)
ORDER BY HIRE_DATE;

-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)

SELECT EMP_ID, EMP_NAME, JOB_NAME,
CEIL(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR('19' || EMP_NO, 1, 8), 'YYYYMMDD')) / 12) AS 나이,
TO_CHAR(SALARY * (1 + NVL(BONUS, 0)) * 12, 'L999,999,999') AS 보너스포함연봉
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 6) IN (SELECT MAX(SUBSTR(EMP_NO, 1, 6)) AS "최소 연령"
															FROM EMPLOYEE
															GROUP BY JOB_CODE)
ORDER BY 나이 DESC;

