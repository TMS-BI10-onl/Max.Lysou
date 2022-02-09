/*
3. 
При каких значениях оконные функции Row Number, Rank и Dense Rank вернут одинаковый результат?

Ответ: Функции Row Number, Rank и Dense Rank вернут одинаковый результат, 
если ранжирование в таблице будет производиться по столбцу с уникальными значениями во всех строках 
*/


/*
4а)
Изучите данные в таблице Production.UnitMeasure. Проверьте, есть ли здесь UnitMeasureCode, 
начинающиеся на букву ‘Т’. Сколько всего различных кодов здесь есть? 
Вставьте следующий набор данных в таблицу:
	- TT1, Test 1, 9 сентября 2020
	- TT2, Test 2, getdate()

Проверьте теперь, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’. 
*/

-- Проверьте, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’.
SELECT *
FROM [AdventureWorks2017].[Production].[UnitMeasure]
WHERE [UnitMeasureCode] LIKE 'T%';
--таблица не содержит записей, начинающихся на букву 'T'

-- Сколько всего различных кодов здесь есть? 
SELECT 
	COUNT(DISTINCT UnitMeasureCode) AS COUNT_UnitMeasureCode
FROM [AdventureWorks2017].[Production].[UnitMeasure];
-- таблица содержит 38 записей уникальных по коду UnitMeasureCode

-- то же самое через 1 запрос с подзапросом, но по выполнению фактически это два запроса
SELECT
	(SELECT COUNT(1) FROM [AdventureWorks2017].[Production].[UnitMeasure] WHERE [UnitMeasureCode] LIKE 'T%') AS COUNT_CONTAINS_T,
	COUNT(DISTINCT [UnitMeasureCode]) AS COUNT_UnitMeasureCode
FROM [AdventureWorks2017].[Production].[UnitMeasure];

-- Вставьте следующий набор данных в таблицу
INSERT INTO [AdventureWorks2017].[Production].[UnitMeasure]
	([UnitMeasureCode], [Name], [ModifiedDate])
	VALUES('TT1','Test 1','2020-09-01'), ('TT2', 'Test 2', GETDATE());

-- Проверьте теперь, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’.
SELECT *
FROM [AdventureWorks2017].[Production].[UnitMeasure]
WHERE [UnitMeasureCode] LIKE 'T%';
--теперь таблица содержит 2 записи, начинающихся на букву 'T'

/*
4b)
Теперь загрузите вставленный набор в новую, не существующую таблицу Production.UnitMeasureTest. 
Догрузите сюда информацию из Production.UnitMeasure по UnitMeasureCode = ‘CAN’.  
Посмотрите результат в отсортированном виде по коду.
*/

-- Теперь загрузите вставленный набор в новую, не существующую таблицу Production.UnitMeasureTest. 
SELECT 
	[UnitMeasureCode],
	[Name],
	[ModifiedDate]
INTO [AdventureWorks2017].[Production].[UnitMeasureTest]
FROM [AdventureWorks2017].[Production].[UnitMeasure]
WHERE [UnitMeasureCode] LIKE 'T%';
-- SELECT * FROM [AdventureWorks2017].[Production].[UnitMeasureTest];

--Догрузите сюда информацию из Production.UnitMeasure по UnitMeasureCode = ‘CAN’.  
INSERT INTO [AdventureWorks2017].[Production].[UnitMeasureTest]
SELECT
	[UnitMeasureCode],
	[Name],
	[ModifiedDate]
FROM [AdventureWorks2017].[Production].[UnitMeasure]
WHERE UnitMeasureCode = 'CAN';
-- SELECT * FROM [AdventureWorks2017].[Production].[UnitMeasureTest];

-- Посмотрите результат в отсортированном виде по коду.
SELECT *
FROM [AdventureWorks2017].[Production].[UnitMeasureTest]
ORDER BY [UnitMeasureCode];


/*
4c)
Измените UnitMeasureCode для всего набора из Production.UnitMeasureTest на ‘TTT’.
*/

UPDATE [AdventureWorks2017].[Production].[UnitMeasureTest]
SET [UnitMeasureCode] = 'TTT';
-- SELECT * FROM [AdventureWorks2017].[Production].[UnitMeasureTest];


/*
4d)
Удалите все строки из Production.UnitMeasureTest.
*/
DELETE
FROM [AdventureWorks2017].[Production].[UnitMeasureTest];
-- SELECT * FROM [AdventureWorks2017].[Production].[UnitMeasureTest];


/*
4e) 
Найдите информацию из Sales.SalesOrderDetail по заказам 43659,43664.  
С помощью оконных функций MAX, MIN, AVG найдем агрегаты по LineTotal для каждого SalesOrderID.
*/
SELECT 
	*,
	AVG([LineTotal]) OVER(PARTITION BY [SalesOrderID]) AS AVG_LineTotal,
	MIN([LineTotal]) OVER(PARTITION BY [SalesOrderID]) AS MIN_LineTotal,
	MAX([LineTotal]) OVER(PARTITION BY [SalesOrderID]) AS MAX_LineTotal
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
WHERE [SalesOrderID] IN (43659, 43664);


/*
4f)
Изучите данные в объекте Sales.vSalesPerson. Создайте рейтинг cреди продавцов на основе годовых продаж SalesYTD, используя ранжирующую оконную функцию. 
Добавьте поле Login, состоящий из 3 первых букв фамилии в верхнем регистре + ‘login’ + TerritoryGroup (Null заменить на пустое значение). 
Кто возглавляет рейтинг? А кто возглавлял рейтинг в прошлом году (SalesLastYear). 
*/
SELECT 
	[BusinessEntityID],[LastName],[TerritoryGroup],[SalesYTD],[SalesLastYear],
	RANK() OVER(ORDER BY [SalesYTD] DESC) AS RANK_SalesYTD,
	CONCAT(UPPER(LEFT([LastName],3)),'login',[TerritoryGroup]) AS Login,
	--функция CONCAT преобразует значения NULL в пустые строки, поэтому использование ISNULL([TerritoryGroup],'') излишне
	FIRST_VALUE([BusinessEntityID]) OVER(ORDER BY [SalesYTD] DESC) AS ID_FIRST_SalesYTD,
	FIRST_VALUE([BusinessEntityID]) OVER(ORDER BY [SalesLastYear] DESC) AS ID_FIRST_SalesLastYear
FROM [AdventureWorks2017].[Sales].[vSalesPerson];

/*
4g)
Найдите первый будний день месяца (FROM не используем). Нужен стандартный код на все времена.
*/

SELECT  
	GETDATE() AS DATE,
	DATEADD(dd,1,EOMONTH(GETDATE(),-1)) AS FIRST_CALEND_DATE,
	CASE DATEPART(weekday,DATEADD(dd,1,EOMONTH(GETDATE(),-1)))
		WHEN  7 THEN DATEADD(dd,3,EOMONTH(GETDATE(),-1))
		WHEN  1 THEN DATEADD(dd,2,EOMONTH(GETDATE(),-1))
		ELSE DATEADD(dd,1,EOMONTH(GETDATE(),-1))
	END AS FIRST_WORK_DATE;
	
/*
5. 
Давайте еще раз остановимся и отточим понимание функции count. 
Найдите значения count(1), count(name), count(id), count(*) для следующей таблицы:

Id(PK)	Name	DepName
1		null	A
2		null	null
3		A		C
4		B		C

Ответ:
count(1)	= 4
count(name)	= 2
count(id)	= 4
count(*)	= 4
*/