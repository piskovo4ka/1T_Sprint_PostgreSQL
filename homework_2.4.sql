-- При инициализации Postgres была создана база данных и схема с таблицами из заданий 1-3;

-- добавляем названия отделов (указываем id вручную, чтобы их потом корректно указать в следующих заданиях);
insert into de_scala.department(id, title, director, amount) VALUES
    ('a1ee06c2-dc18-4090-b076-e6360dd88ff0','Администрация', 'Иванов И.И.', 3),
    ('8bb7baab-ad91-43d1-85c4-16e5d457f1bc','Бухгалтерия', 'Сидорова С.С.', 2),
    ('8097e87f-5a3e-4f6c-954a-d10b10009029','IT отдел', 'Бородко Б.Б.', 3),
    ('65748d39-0d21-498e-b1f8-017932c2d9c4','PR отдел', 'Абазов А.А.', 2),
    ('41676736-08f3-41a8-b715-4de1d6558fd8','GR отдел', 'Волков В.В.', 2),
    ('21d66cf9-59d8-4cb3-a67d-0db708ab0d21','Отдел кадров', 'Глушко Г.Г.', 2),
    ('1da57ba8-aaed-49a6-b50e-a17785f0c24a','Отдел ДЗЗ', 'Дмитров Д.Д.', 20),
    ('14be5580-ed4c-4cc9-b441-d91e50c4a97e','АХО', 'Петров П.П.', 7);

-- добавляем данные работников;
insert into de_scala.staff(full_name, birthdate, start_date, position, level, salary, department) VALUES
('Иванов И.И.', '1970-01-01', '2022-02-24', 'Директор', 'lead', 350000, 'a1ee06c2-dc18-4090-b076-e6360dd88ff0'),
('Сидорова С.С.', '1975-03-08', '2022-02-28', 'Главный бухгалтер', 'lead', 250000, '8bb7baab-ad91-43d1-85c4-16e5d457f1bc'),
('Бородко Б.Б.', '1978-02-23', '2022-03-12', 'Начальник отдела', 'lead', 200000, '8097e87f-5a3e-4f6c-954a-d10b10009029'),
('Абазов А.А.', '1988-04-01', '2022-04-01', 'Пресс-секретарь', 'lead', 150000, '65748d39-0d21-498e-b1f8-017932c2d9c4'),
('Волков В.В.', '1962-05-09', '2022-06-12', 'Советник', 'lead', 220000, '41676736-08f3-41a8-b715-4de1d6558fd8'),
('Глушко Г.Г.', '1985-06-07', '2022-03-04', 'Начальник отдела', 'lead', 150000, '21d66cf9-59d8-4cb3-a67d-0db708ab0d21'),
('Дмитров Д.Д.', '1992-07-25', '2022-04-12', 'Начальник отдела', 'lead', 250000, '1da57ba8-aaed-49a6-b50e-a17785f0c24a'),
('Петров П.П.', '1981-08-19', '2022-04-14', 'Начальник отдела', 'lead', 230000, '14be5580-ed4c-4cc9-b441-d91e50c4a97e'),
('Яблоков Я.Я.', '1995-09-11', '2022-05-06', 'Заместитель начальника отдела', 'senior', 200000, '1da57ba8-aaed-49a6-b50e-a17785f0c24a'),
('Юшкина Ю.Ю.', '2000-10-27', '2022-05-07', 'Аналитик', 'middle', 150000, '1da57ba8-aaed-49a6-b50e-a17785f0c24a'),
('Энтин Э.Э.', '1997-11-30', '2022-05-07', 'DE инженер', 'middle', 180000, '1da57ba8-aaed-49a6-b50e-a17785f0c24a'),
('Хой Х.Х.', '1987-12-24', '2022-05-14', 'DS', 'jun', 130000, '1da57ba8-aaed-49a6-b50e-a17785f0c24a');

-- добавляем названия нового отдела (указываем id вручную, чтобы их потом корректно указать в следующих заданиях);
insert into de_scala.department(id, title, director, amount) VALUES
    ('a3ee06c2-dc18-4090-b036-e6360dd84ff0','Отдел Интеллектуального анализа данных', 'Баранов Д.А.', 3);

-- добавляем данные работников из нового отдела;
insert into de_scala.staff(full_name, birthdate, start_date, position, level, salary, department) VALUES
('Баранов Д.А.', '1999-11-03', '2022-10-16', 'Начальник отдела', 'middle', 115000, 'a3ee06c2-dc18-4090-b036-e6360dd84ff0'),
('Козлов Б.Э.', '1994-05-31', '2022-10-16', 'Аналитик', 'jun', 100000, 'a3ee06c2-dc18-4090-b036-e6360dd84ff0'),
('Кошкин Ф.Р.', '1984-07-15', '2022-10-16', 'Аналитик', 'jun', 100000, 'a3ee06c2-dc18-4090-b036-e6360dd84ff0');

-- 2.4.2.a.
select full_name
from de_scala.staff
where salary = (select max(salary) from de_scala.staff);

-- 2.4.2.b.
select full_name
from de_scala.staff
order by full_name asc;

-- 2.4.2.c.
select level, avg(salary)
from de_scala.staff
group by level;

-- 2.4.2.d.
select s.full_name, d.title
from de_scala.staff s
left join de_scala.department d on s.department= d.id
order by full_name asc;

-- 2.4.2.e.
select d.title, full_name, salary
           from de_scala.staff s
           left join de_scala.department d on d.id = s.department
           where (department, salary) in (select department, max(salary) m
                                          from de_scala.staff
                                          group by department)
