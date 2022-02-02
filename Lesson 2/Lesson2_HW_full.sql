--1.Решите на базе данных AdventureWorks2017 следующие задачи:
--1a.Извлечь все столбцы из таблицы Sales.SalesTerritory.
USE AdventureWorks2017
SELECT *
FROM Sales.SalesTerritory;


--1b.Извлечь столбцы TerritoryID и Name из таблицы Sales.SalesTerritory.
SELECT TerritoryID, Name
FROM AdventureWorks2017.Sales.SalesTerritory;


--1c.Найдите все данные, которые существует для людей из Person.Person с LastName = ‘Norman’. 
SELECT *
FROM AdventureWorks2017.Person.Person
WHERE LastName = 'Norman';


--1d.Найдите все строки из Person.Person, где EmailPromotion не равен 2.
SELECT *
FROM AdventureWorks2017.Person.Person
WHERE EmailPromotion != 2;


/*
3a.На официальном сайте Microsoft ещё раз просмотрите синтаксис SUM, AVG, COUNT, MIN, MAX и примеры для каждой функции. 
Какие ещё агрегатные функции существуют в языке T-SQL? Приведите несколько примеров.

VAR - Возвращает статистическую дисперсию всех значений в указанном выражении. Функцию VAR можно использовать только для числовых столбцов. Значения NULL пропускаются.
STDEV - Возвращает статистическое стандартное отклонение всех значений в указанном выражении. Функцию STDEV можно использовать только для числовых столбцов. Значения NULL пропускаются.
Пример работы и синтаксиса функций VAR и STDEV на базе примера 4с. 
Найти статистические дисперсию и стандартное отклонение для веса продукта для каждой подкатегории ProductSubcategoryID из Production.Product. 
*/
SELECT ProductSubcategoryID,
		VAR(Weight) AS VAR_Weight, 
		STDEV(Weight) AS STDEV_Weight
FROM AdventureWorks2017.Production.Product
GROUP BY ProductSubcategoryID;


/*
3b.STRING_AGG - Сцепляет значения строковых выражений, помещая между ними значения-разделители. В конце строки разделитель не добавляется.
STRING_AGG — это агрегатная функция, которая принимает все выражения из строк и сцепляет их в одну строку. 
Значения выражений неявно преобразуются в строковые типы и затем сцепляются. 
Неявное преобразование в строки выполняется по существующим правилам преобразования типов данных. 
Значения NULL пропускаются, и соответствующий разделитель не добавляется.

Пример работы и синтаксиса функции STRING_AGG на базе примера 1с. 
Найдите и выведите одной строкой все FirstName, которые существует для людей из Person.Person с LastName = ‘Norman’
*/
SELECT STRING_AGG(FirstName,' ') AS 'Norman''s first names'
FROM AdventureWorks2017.Person.Person
WHERE LastName = 'Norman';


--4.Решите на базе данных AdventureWorks2017 следующие задачи:
--4a. Сколько уникальных PersonType существует для людей из Person.Person с LastName начинающиеся с буквы М или не содержащий 1 в EmailPromotion.
SELECT COUNT(DISTINCT PersonType) AS 'Unique PersonType'
FROM AdventureWorks2017.Person.Person
WHERE LastName LIKE 'M%'
		OR EmailPromotion != 1;


--4b.Вывести первых 3 специальных предложений из Sales.SpecialOffer с наибольшими DiscountPct, которые начинали действовать с 2013-01-01 по 2014-01-01.
SELECT TOP 3 WITH TIES *
FROM AdventureWorks2017.Sales.SpecialOffer
WHERE StartDate BETWEEN '2013-01-01' AND '2014-01-01'
ORDER BY DiscountPct DESC;


--4c.Найти самый минимальный вес и самый максимальный размер продукта из Production.Product.
SELECT 
		MIN(Weight) AS MIN_Weight, 
		MAX(Size) AS MAX_Size
FROM AdventureWorks2017.Production.Product;


--4d.Найти самый минимальный вес и самый максимальный размер продукта для каждой подкатегории ProductSubcategoryID из Production.Product. 
SELECT ProductSubcategoryID,
		MIN(Weight) AS MIN_Weight, 
		MAX(Size) AS MAX_Size
FROM AdventureWorks2017.Production.Product
GROUP BY ProductSubcategoryID;


--4e.Найти самый минимальный вес и самый максимальный размер продукта для каждой подкатегории ProductSubcategoryID из Production.Product, где цвет продукта определен(Color).
SELECT ProductSubcategoryID,
		MIN(Weight) AS MIN_Weight, 
		MAX(Size) AS MAX_Size
FROM AdventureWorks2017.Production.Product
WHERE Color IS NOT NULL
GROUP BY ProductSubcategoryID;
