-- 1. Фамилия сотрудника с самой высокой зарплатой

SELECT lastname
FROM staff_new
WHERE salary = (SELECT MAX(salary) FROM staff_new);


--2. Фамилии сотрудников в алфавитном порядке

SELECT lastname
FROM staff_new
ORDER BY lastname ;


-- 3. Средний стаж для каждого уровня сотрудников

SELECT ROUND(AVG(DATE(NOW()) - DATE(startday))) AS AVG_DAYS_experience,
       plevel
FROM staff_new
GROUP BY plevel;


-- 4. Фамилию сотрудника и название отдела, в котором он работает

SELECT  s.lastname,
		d.departmentname
FROM staff_new s JOIN department d
ON d.id = s.department_id;


-- 5. Название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.

WITH t_2 AS(
	
	WITH t_1 AS (
		SELECT MAX(salary) AS max_salary,
			   department_id
		FROM staff_new 
		GROUP BY department_id
		)

	SELECT  t_1.department_id,
			d.departmentname,
			t_1.max_salary
			--s.lastname,
			--s.salary
	FROM department d JOIN t_1
	ON d.id = t_1.department_id
	)

SELECT s.lastname, 
	   t_2.departmentname,
	   s.salary
FROM staff s JOIN t_2
ON t_2.department_id = s.department_id
WHERE s.salary = (t_2.max_salary);


-- 6. *Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года.

SELECT t_1.departmentname
FROM 
(
	SELECT d.departmentname,
			ROUND (AVG(s.coefficient), 3) AS bonus
	FROM staff_new s JOIN department d
	ON d.id = s.department_id
	GROUP BY d.departmentname
	ORDER BY bonus DESC
	LIMIT 1
	) t_1;
	

-- 7. *Проиндексируйте зарплаты сотрудников с учетом коэффициента премии. 
--Для сотрудников с коэффициентом премии больше 1.2 – размер индексации составит 20%, для сотрудников с коэффициентом премии от 1 до 1.2 размер индексации составит 10%. 
--Для всех остальных сотрудников индексация не предусмотрена.

SELECT  id,
        lastname,
		firstname,
		coefficient,
		salary AS before_indexation,
		CASE WHEN coefficient > 1.2 THEN salary*1.2
         WHEN (coefficient >= 1) AND  (coefficient<= 1.2) THEN salary*1.1
		 ELSE salary END AS after_indexation
FROM staff_new	;	


/* 8. ***По итогам индексации отдел финансов хочет получить следующий отчет: вам необходимо на уровень каждого отдела вывести следующую информацию:

                                                    i.     Название отдела

                                                  ii.     Фамилию руководителя

                                                iii.     Количество сотрудников

                                                iv.     Средний стаж

                                                  v.     Средний уровень зарплаты

                                                vi.     Количество сотрудников уровня junior

                                              vii.     Количество сотрудников уровня middle

                                            viii.     Количество сотрудников уровня senior

                                                ix.     Количество сотрудников уровня lead

                                                  x.     Общий размер оплаты труда всех сотрудников до индексации

                                                xi.     Общий размер оплаты труда всех сотрудников после индексации

                                              xii.     Общее количество оценок А

                                            xiii.     Общее количество оценок B

                                            xiv.     Общее количество оценок C

                                              xv.     Общее количество оценок D

                                            xvi.     Общее количество оценок Е

                                          xvii.     Средний показатель коэффициента премии

                                        xviii.     Общий размер премии.

                                            xix.     Общую сумму зарплат(+ премии) до индексации

                                              xx.     Общую сумму зарплат(+ премии) после индексации(премии не индексируются)

                                            xxi.     Разницу в % между предыдущими двумя суммами(первая/вторая)

*/



-- по id отдела выводится сред стаж и сред зарплата, сумма зп до и после индексации, 
-- средний показатель коэффициента премии, общий размер премии, общую сумму зарплат(+ премии) до индексации,
-- общую сумму зарплат(+ премии) после индексации(премии не индексируются), разницу в % между предыдущими двумя суммами(первая/вторая)

WITH t_1 AS (
	SELECT  
			s.department_id AS dep_t_1,
			ROUND(AVG(DATE(NOW()) - DATE(s.startday))) AS AVG_DAYS_experience,
			ROUND(AVG(s.salary), 2) AS avg_salary,
			SUM(s.salary) AS salary_before_indexation,
			SUM(CASE WHEN s.coefficient > 1.2 THEN s.salary*1.2
			 WHEN (s.coefficient >= 1) AND  (s.coefficient<= 1.2) THEN s.salary*1.1
			 ELSE s.salary END) AS salary_after_indexation,
			 ROUND (AVG(s.coefficient),3) AS avg_coef_bonus,
			SUM(s.salary*(s.coefficient-1)) AS full_bonus,
			SUM(s.salary*s.coefficient) AS full_before_indexation,
			SUM(CASE WHEN s.coefficient > 1.2 THEN s.salary*1.2*s.coefficient
			 WHEN (s.coefficient >= 1) AND  (s.coefficient<= 1.2) THEN s.salary*1.1*s.coefficient
			 ELSE s.salary*s.coefficient END) AS full_after_indexation,
			 ROUND (SUM(s.salary*s.coefficient)/ (SUM(CASE WHEN s.coefficient > 1.2 THEN s.salary*1.2*s.coefficient
			 WHEN (s.coefficient >= 1) AND  (s.coefficient<= 1.2) THEN s.salary*1.1*s.coefficient
			 ELSE s.salary*s.coefficient END)), 2) *100 AS percentage_diff


	FROM staff_new s JOIN department d
	ON d.id = s.department_id
	GROUP BY s.department_id
	),


-- по id отдела выводятся количества сотрудников разных уровней

 t_mid AS (		
	SELECT COUNT(plevel) AS count_junior,
		   department_id
	FROM staff_new
	WHERE PLEVEL = 'junior'
	GROUP BY department_id
	),

 t_jun AS(
	SELECT COUNT(plevel) AS count_middle,
		   department_id
	FROM staff_new
	WHERE PLEVEL = 'middle'
	GROUP BY department_id
	),

 t_sen AS (
	SELECT COUNT(plevel) AS count_senior,
		   department_id
	FROM staff_new
	WHERE PLEVEL = 'senior'
	GROUP BY department_id
	),

 t_lead AS (
	SELECT COUNT(plevel) AS count_lead,
		   department_id
	FROM staff_new
	WHERE PLEVEL = 'lead'
	GROUP BY department_id
	),
	
-- по id отдела выводятся количества оценок	
 t_2 AS (

WITH t_A AS (
	SELECT  staff_id,
			COUNT(points) AS points_A
	FROM points
	WHERE points = 'A'	
	GROUP BY staff_id 
	),
	
	t_B AS (
	SELECT  staff_id,
			COUNT(points) AS points_B
	FROM points
	WHERE points = 'B'	
	GROUP BY staff_id 
	),
	
	t_C AS (
	SELECT  staff_id,
			COUNT(points) AS points_C
	FROM points
	WHERE points = 'C'	
	GROUP BY staff_id 
	),
	
	t_D AS (
	SELECT  staff_id,
			COUNT(points) AS points_D
	FROM points
	WHERE points = 'D'	
	GROUP BY staff_id 
	),
	
	t_E AS (
	SELECT  staff_id,
			COUNT(points) AS points_E
	FROM points
	WHERE points = 'E'	
	GROUP BY staff_id 
	),
	
 t_all AS (
	SELECT id,
			department_id
FROM staff_new
       )
SELECT  
		t_all.department_id dep_t_2,
		SUM(t_A.points_A) AS col_A, 
		SUM(t_b.points_b) AS col_b,
		SUM(t_c.points_c) AS col_c,
		SUM(t_d.points_d) AS col_d,
		SUM(t_e.points_e) AS col_e
FROM t_all FULL JOIN t_A 
ON t_all.id = t_A.staff_id
FULL JOIN t_B 
ON t_all.id = t_B.staff_id
FULL JOIN t_C 
ON t_all.id = t_C.staff_id
FULL JOIN t_D 
ON t_all.id = t_D.staff_id
FULL JOIN t_E 
ON t_all.id = t_E.staff_id
GROUP BY t_all.department_id

),

t_3 AS(

SELECT  id,
		departmentname,
		lastname_lead,
		count_staff
FROM department	
	)
 
SELECT t_1.dep_t_1 AS DEP_ID,
		departmentname,
		lastname_lead,
		count_staff,
		AVG_DAYS_experience, 
		avg_salary, 
		count_junior,
		count_middle,
		count_senior,
        count_lead, 
		salary_before_indexation, 
		salary_after_indexation, 
		col_A,
		col_B,
		col_C,
		col_D,
		col_E,		
		avg_coef_bonus, 
		full_bonus, 
		full_before_indexation, 
		full_after_indexation, 
		percentage_diff
		
FROM t_1 FULL JOIN t_2	
ON t_1.dep_t_1 = t_2.dep_t_2
FULL JOIN t_sen
ON t_1.dep_t_1 = t_sen.department_id
FULL JOIN t_mid 
ON t_1.dep_t_1 =t_mid.department_id
FULL JOIN t_jun 
ON t_1.dep_t_1 = t_jun.department_id
FULL JOIN t_lead 
ON t_1.dep_t_1 =t_lead.department_id
FULL JOIN t_3 
ON t_1.dep_t_1 =t_3.id
ORDER BY DEP_ID;










	
	   





