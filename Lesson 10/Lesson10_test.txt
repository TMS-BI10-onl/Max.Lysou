/*
1) Найдите людей и их номера телефонов, код города которых начинается на  4 и заканчивается на 5.
( таблицы Person.PersonPhone, Person.Person) 
*/

SELECT
	[P].[FirstName],
	[P].[MiddleName],
	[P].[LastName],
	[PP].[PhoneNumber]
FROM 
	[AdventureWorks2017].[Person].[Person] [P]
	LEFT JOIN [AdventureWorks2017].[Person].[PersonPhone] [PP]
	ON [P].[BusinessEntityID] = [PP].[BusinessEntityID]
WHERE 
	[PP].[PhoneNumber]  LIKE '4_5%'
	OR [PP].[PhoneNumber]  LIKE '1 (11) 4_5%';


/*
2) Отнести каждого человека из [HumanResources].[Employee] в свою возрастную категорию:
Adolescence: 17-20
Adults: 21-59
Elderly: 60-75
Senile: 76-90
*/

SELECT 
	[P].[FirstName],
	[P].[MiddleName],
	[P].[LastName],
	[EMP].[Age],
	CASE 
		WHEN [EMP].[AGE] BETWEEN 17 AND 20 THEN 'Adolescence'
		WHEN [EMP].[AGE] BETWEEN 21 AND 59 THEN 'Adults'
		WHEN [EMP].[AGE] BETWEEN 60 AND 75 THEN 'Elderly'
		WHEN [EMP].[AGE] BETWEEN 76 AND 90 THEN 'Senile'
	END AS [AgeRange]
FROM 
	(SELECT
		[BusinessEntityID],
		DATEDIFF(year, [BirthDate], GETDATE()) - IIF(DATEPART(DAYOFYEAR,[BirthDate]) - DATEPART(DAYOFYEAR,GETDATE()) > 0,1,0) AS [Age]
	FROM [AdventureWorks2017].[HumanResources].[Employee]
	) [EMP]
	LEFT JOIN [AdventureWorks2017].[Person].[Person] [P]
	ON [EMP].[BusinessEntityID] = [P].[BusinessEntityID];


/*
3) Вывести самый дорогой продукт для каждого цвета из [Production].[Product]
*/

SELECT
	[ProductId],
	[Name],
	[Color],
	[StandardCost],
	[MaxStandardCost]
FROM
	(SELECT
		*,
		MAX([StandardCost]) OVER(PARTITION BY [Color]) as [MaxStandardCost]
	FROM [AdventureWorks2017].[Production].[Product]
	) temp
WHERE [StandardCost] = [MaxStandardCost];