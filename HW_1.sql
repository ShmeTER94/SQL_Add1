--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
create schema HW_1

SET search_path TO HW_1

show search_path

REVOKE CREATE ON SCHEMA HW_1 FROM PUBLIC

select * from lang l 

select * from people p 

select * from country

select * from lang_people lp 

select * from country c join people_country pc on c.country_id = pc.country_id 
join people p on p.people_id = pc.people_id 
join lang_people lp on lp.people_id = pc.people_id 
join lang l on l.lang_id = lp.lang_id 


-- select unnest (array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List'])

select * from film_new fn 
--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ
create table lang (
	lang_id serial primary key,
	lang_name varchar(50) unique not null
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert
	into
	lang(lang_name)
values 
	('Русский'),
	('Французский'),
	('Немецкий'),
	('Английский'),
	('Испанский')


--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table people (
	people_id serial primary key,
	people_name varchar(50) unique not null
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ
insert
	into
	people(people_name)
values 
	('Славяне'),
	('Англосаксы'),
	('Латиноамериканцы'),
	('Либерийцы'),
	('Кельты')


--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ
create table country (
	country_id serial primary key,
	country_name varchar(50) unique not null
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert
	into
	country (country_name)
values 
	('Россия'),
	('США'),
	('Франция'),
	('Либерия'),
	('Боливия')


--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table lang_people (
	lang_id integer references lang(lang_id),
	people_id integer references people(people_id),
	primary key 
	(lang_id,
	people_id)
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert
	into
	lang_people (lang_id,
	people_id)
values 
	(1,1),	(2,2),
	(3,2),	(4,4),
	(5,1),	(2,5),
	(4,1)
	

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table people_country (
	people_id integer references people(people_id),
	country_id integer references country(country_id),
	primary key 
	(people_id,
	country_id)
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert
	into
	people_country (people_id,
	country_id)
values 
(1,1),	(2,2),
(2,3),	(3,2),
(4,4),	(5,5),
(1,5)

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.
create table film_new (
	film_id serial primary key,
	film_name varchar(255) not null,
	film_year integer check(film_year > 0),
	film_rental_rate numeric(4,2) default 0.99,
	film_duration integer not null check(film_duration > 0)
)


--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]
insert
	into
	film_new (film_name,
	film_year,
	film_rental_rate,
	film_duration)
select
	unnest(array['The Shawshank Redemption',
	'The Green Mile',
	'Back to the Future',
	'Forrest Gump',
	'Schindlers List']),
	unnest (array[1994,
	1999,
	1985,
	1994,
	1993]),
	unnest (array[2.99,
	0.99,
	1.99,
	2.99,
	3.99]),
	unnest (array[142,
	189,
	116,
	142,
	195])


--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41
update
	film_new
set
	film_rental_rate = film_rental_rate + 1.41


--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new
delete
from
	film_new
where
	film_name = 'Back to the Future'


--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме
insert
	into
	film_new (film_name,
	film_year,
	film_rental_rate,
	film_duration)
values
('Godzilla',
1954,
2.54,
180)

--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых
select
	*,
	round(film_duration / 60::numeric,
	1) as "Продолжительность фильма в часах"
from
	film_new  


--ЗАДАНИЕ №7 
--Удалите таблицу film_new
drop table if exists film_new
