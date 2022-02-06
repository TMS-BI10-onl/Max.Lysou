/*
Посчитать минимальный, максимальный, средний возраст сотрудников.
Для работы использовать таблицу [HumanResources].[Employee]
*/
-- функции DATEDIFF(), GETDATE(), IIF(), DATEPART()
SELECT 
	MIN( DATEDIFF(year, BirthDate, GETDATE()) - IIF(DATEPART(DAYOFYEAR,BirthDate) - DATEPART(DAYOFYEAR,GETDATE()) > 0,1,0) ) AS MIN_AGE,
	MAX( DATEDIFF(year, BirthDate, GETDATE()) - IIF(DATEPART(DAYOFYEAR,BirthDate) - DATEPART(DAYOFYEAR,GETDATE()) > 0,1,0) ) AS MAX_AGE,
	AVG( DATEDIFF(year, BirthDate, GETDATE()) - IIF(DATEPART(DAYOFYEAR,BirthDate) - DATEPART(DAYOFYEAR,GETDATE()) > 0,1,0) ) AS AVG_AGE
FROM AdventureWorks2017.[HumanResources].[Employee];


/*
Вывести всех сотрудников, которым через полгода будет более 60 лет.
Для работы использовать таблицу [HumanResources].[Employee]
*/
-- функции DATEADD()
SELECT LoginID,
	DATEDIFF(year, BirthDate, DATEADD(month,6,GETDATE())) - IIF(DATEPART(DAYOFYEAR,BirthDate) - DATEPART(DAYOFYEAR,DATEADD(month,6,GETDATE())) > 0,1,0) AS NEW_AGE
FROM AdventureWorks2017.[HumanResources].[Employee]
WHERE DATEDIFF(year, BirthDate, DATEADD(month,6,GETDATE())) - IIF(DATEPART(DAYOFYEAR,BirthDate) - DATEPART(DAYOFYEAR,DATEADD(month,6,GETDATE())) > 0,1,0) > 60;


/*
Заменить сокращенное наименование семейного положения сотрудников на полное.
Для работы использовать таблицу [HumanResources].[Employee]
*/
-- функции REPLACE()
SELECT LoginID,
	CASE
		WHEN MaritalStatus = 'M' THEN REPLACE(MaritalStatus,'M','Married')
		WHEN MaritalStatus = 'S' THEN REPLACE(MaritalStatus,'S','Single')
	END AS MaritalStatus_FULL
FROM [HumanResources].[Employee];


/*
Посчитать количество совершенных транзакций для каждого дня недели.
Для работы использовать таблицу [Production].[TransactionHistory]
*/
-- функции DATENAME()
SELECT 	
	DATENAME(weekday, TransactionDate) AS WEEKDAY,
	COUNT(DATENAME(weekday, TransactionDate)) AS COUNT_TRANSACTIONS
FROM AdventureWorks2017.[Production].[TransactionHistory]
GROUP BY DATENAME(weekday, TransactionDate)
ORDER BY COUNT(DATENAME(weekday, TransactionDate)) DESC;


/*
Посчитать количество совершенных транзакций для каждого конкретного мясяца.
Для работы использовать таблицу [Production].[TransactionHistory]
*/
-- функции EOMONTH()
SELECT 
	EOMONTH(TransactionDate), 
	COUNT(1) 
FROM AdventureWorks2017.[Production].[TransactionHistory] 
GROUP BY EOMONTH(TransactionDate) 
ORDER BY COUNT(1)


/*
Вывести все доменные имена из e-mail адресов клиентов.
Для работы использовать таблицу [Person].[EmailAddress]
*/
-- функции SUBSTRING(), CHARINDEX(), LEN()
SELECT DISTINCT
		SUBSTRING(EmailAddress,CHARINDEX('@',EmailAddress)+1,LEN(EmailAddress)-CHARINDEX('@',EmailAddress)) AS domen_name,
		COUNT(SUBSTRING(EmailAddress,CHARINDEX('@',EmailAddress)+1,LEN(EmailAddress)-CHARINDEX('@',EmailAddress))) AS count_domen_name
FROM AdventureWorks2017.[Person].[EmailAddress]
GROUP BY SUBSTRING(EmailAddress,CHARINDEX('@',EmailAddress)+1,LEN(EmailAddress)-CHARINDEX('@',EmailAddress));


/*
Создать новые e-mail адреса клиентов, где '.com' заменить на '.ru'
Для работы использовать таблицу [Person].[EmailAddress]
*/
-- функции STUFF(), PATINDEX()
SELECT EmailAddress,
		STUFF(EmailAddress,PATINDEX('%.com%',EmailAddress),LEN(EmailAddress)+1-PATINDEX('%.com%',EmailAddress),'.ru') AS new_EmailAddress
FROM AdventureWorks2017.[Person].[EmailAddress];


/*
Создать полное имя клиентов по следующему образцу:
	- Title (если есть) заглавными буквами
	- FirstName и MiddleName (если есть) только первая буква
	- LastName в полном виде
Для работы использовать таблицу [Person].[Person]
*/
-- функции CONCAT_WS(), UPPER(), ISNULL()
SELECT 	
	CONCAT_WS(' ', UPPER(ISNULL(Title,NULL)), SUBSTRING(ISNULL(FirstName,NULL),1,1), ISNULL(MiddleName,NULL), ISNULL(LastName,NULL)) AS FULL_NAME
FROM AdventureWorks2017.[Person].[Person];


/*
Заменить в телефонных номерах клиентов все вхождения скобок на '-'
Для работы использовать таблицу [Person].[EmailAddress]
*/
-- функции TRANSLATE()
SELECT *,
	TRANSLATE(PhoneNumber,'()','--') AS NEW_PhoneNumber
FROM [Person].[PersonPhone]


/*
Округлить StandardCost до 2 знаков после запятой.
Округлить вес товара до целого значения в меньшую сторону.
Для работы использовать таблицу [Production].[Product]
*/
-- функции ROUND(), FLOOR()
SELECT
	ProductID,
	ROUND(StandardCost,2) AS ROUD_StandardCost,
	FLOOR(Weight) AS FLOOR_WEIGHT
FROM AdventureWorks2017.[Production].[Product]

/*
Преобразовать названия цветов товара к нижнему регистру, а пустые значения на знак пробела.
Для работы использовать таблицу [Production].[Product]
*/
-- функции Space(), Lower()
SELECT
	ProductID,
	Color,
	IIF(Color IS NULL, space(1),LOWER(Color)) AS NEW_COLOR
FROM AdventureWorks2017.[Production].[Product]