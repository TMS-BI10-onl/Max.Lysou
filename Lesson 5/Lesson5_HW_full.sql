/*
6.
В базе данных AdventureWorks2017 создать таблицу Patients для ведения наблюдений за температурой пациентов больницы. Таблица должна содержать поля:
	- ID – числовое поле. Авто заполняется.
	- FirstName – имя пациента.
	- LastName – фамилия пациента.
	- SSN – уникальный идентификатор пациента.
	- Email – электронная почта пациента. Формируется по следующему правилу: первая большая буква FirstName + маленькие 3 буквы LastName + @mail.com (например, Akli@mail.com). Полезная ссылка здесь. 
	- Temp – температура пациента.
	- CreatedDate — дата измерений. 
*/

-- создание таблицы [AdventureWorks2017].[dbo].[Patiens]
CREATE TABLE 
	[AdventureWorks2017].[dbo].[Patiens]
	(
		[ID]			INT IDENTITY(1,1),
		[FirstName]		NVARCHAR(100),
		[LastName]		NVARCHAR(100),
		[SSN]			UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
		[Email]			AS CONCAT(UPPER(LEFT(FirstName,1)),LOWER(LEFT(LastName,3)),'@gmail.com'),
		[Temp]			NUMERIC(10,2),
		[CreatedDate]	DATE
	);

-- просмотр структуры созданной таблицы
SELECT *
FROM [AdventureWorks2017].[DBO].[PATIENS];




/*
7.
Добавить в таблицу несколько произвольных записей. 
*/

-- заполнение таблицы данными
INSERT INTO 
	[AdventureWorks2017].[dbo].[Patiens]
	([FirstName],[LastName],[Temp],[CreatedDate])
VALUES
	('Piter','Parker',36.6,'2022-02-01'),
	('Steve','Rogers',36.9,'2022-01-31'),
	('Natasha','Romanoff',35.9,'2022-02-14'),
	('Tony','Stark',37.5,'2022-02-01'),
	('Wade','Wilson',35.9,'2022-02-14'),
	('Clint','Barton',36.5,'2022-02-14'),
	('Bruce','Banner',50.0,'2022-02-10'),
	('Caitlin','Snow',-99,'2022-01-15');

-- просмотр заполнения таблицы данными
SELECT *
FROM [AdventureWorks2017].[dbo].[Patiens];




/*
8.
Добавить поле TempType со следующими значениями ‘< 0°C’,  ‘> 0°C’ на основе значений из поля Temp ( используйте ALTER TABLE ADD column AS ). 
Посмотрите на данные, которые получились.
*/

-- создание нового стоблца в таблице
ALTER TABLE 
	[AdventureWorks2017].[dbo].[Patiens]
ADD [TempType] AS CASE
	WHEN [Temp] > 0 THEN '> 0°C'
	WHEN [Temp] < 0 THEN '< 0°C'
	ELSE '= 0°C'
END;

-- просмотр заполнения таблицы данными
SELECT *
FROM [AdventureWorks2017].[DBO].[PATIENS];




/*
9.
Создать представление Patients_v, показывающее температуру в градусах Фаренгейта (°F = °Cx9/5 + 32)
*/

-- создание нового представления / view [dbo].[Patients_v]
CREATE VIEW [dbo].[Patients_v]
AS   
SELECT
	*,
	Temp * 9 / 5 + 32 AS Temp_F
FROM [AdventureWorks2017].[dbo].[Patiens];
GO

-- просмотр заполнения таблицы данными
SELECT *
FROM [dbo].[Patients_v]




/*
10.
Создать функцию, которая возвращает температуру в градусах Фаренгейта, при подаче на вход градусы в Цельсиях.
*/

-- создание новой функции для перевода градусов по Цельсию в градусы по Фаренгейту
CREATE FUNCTION [dbo].[udfCtoF](
    @celsius DEC(10,2)
)
RETURNS DEC(10,2)
AS 
BEGIN
    RETURN @celsius * 9 / 5 + 32;
END;
GO

-- проверка работы функции на тестовых примерах
SELECT [dbo].[udfCtoF] (36.6) temp_F;
SELECT [dbo].[udfCtoF] (0) temp_F;
SELECT [dbo].[udfCtoF] (100) temp_F;




/*
11.
Перепишите решение задачи g из прошлого дз с использованием переменной, максимально упрощая select.
*/
-- ИСХОДНЫЙ КОД
---------------
SELECT  
	GETDATE() AS DATE,
	DATEADD(dd,1,EOMONTH(GETDATE(),-1)) AS FIRST_CALEND_DATE,
	CASE DATEPART(weekday,DATEADD(dd,1,EOMONTH(GETDATE(),-1)))
		WHEN  7 THEN DATEADD(dd,3,EOMONTH(GETDATE(),-1))
		WHEN  1 THEN DATEADD(dd,2,EOMONTH(GETDATE(),-1))
		ELSE DATEADD(dd,1,EOMONTH(GETDATE(),-1))
	END AS FIRST_WORK_DATE;

-- переписанный код с использованием переменной
-------------
DECLARE @DATE1 DATE;
SET @DATE1 = '2021-05-20';

SELECT  
	@DATE1 AS DATE,
	DATEADD(dd,1,EOMONTH(@DATE1,-1)) AS FIRST_CALEND_DATE,
	CASE DATEPART(weekday,DATEADD(dd,1,EOMONTH(@DATE1,-1)))
		WHEN  7 THEN DATEADD(dd,3,EOMONTH(@DATE1,-1))
		WHEN  1 THEN DATEADD(dd,2,EOMONTH(@DATE1,-1))
		ELSE DATEADD(dd,1,EOMONTH(@DATE1,-1))
	END AS FIRST_WORK_DATE;



-- переписанный код с использованием переменной и функции
-- создание новой функции для определения первого рабочего дня месяца
CREATE FUNCTION [udfFirstWDay] (@DATE2 DATE)
RETURNS TABLE
AS
RETURN (
SELECT  
	@DATE2 AS DATE,
	DATEADD(dd,1,EOMONTH(@DATE2,-1)) AS FIRST_CALEND_DATE,
	CASE DATEPART(weekday,DATEADD(dd,1,EOMONTH(@DATE2,-1)))
		WHEN  7 THEN DATEADD(dd,3,EOMONTH(@DATE2,-1))
		WHEN  1 THEN DATEADD(dd,2,EOMONTH(@DATE2,-1))
		ELSE DATEADD(dd,1,EOMONTH(@DATE2,-1))
	END AS FIRST_WORK_DATE
)
GO

-- проверка работы функции на тестовых примерах
DECLARE @DATE2 DATE;
SET @DATE2 = '2021-05-20';
SELECT * FROM [udfFirstWDay](@DATE2);

SET @DATE2 = '2021-12-20';
SELECT * FROM [udfFirstWDay](@DATE2);

DECLARE @DATE3 DATE;
SET @DATE3 = '2030-06-20';
SELECT * FROM [udfFirstWDay](@DATE3);

SELECT * FROM [udfFirstWDay](GETDATE());



-- удаление всех созданных объектов данных
DROP TABLE [AdventureWorks2017].[DBO].[PATIENS];
DROP VIEW [dbo].[Patients_v];
DROP FUNCTION [dbo].[udfCtoF];
DROP FUNCTION [udfFirstWDay];
