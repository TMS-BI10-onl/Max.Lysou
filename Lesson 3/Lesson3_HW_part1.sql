/*
1. Решите на базе данных AdventureWorks2017 следующие задачи (для поиска ключей можно использовать схему БД ). 
	a) Вывести список цен в виде текстового комментария, основанного на диапазоне цен для продукта:
		a. StandardCost равен 0 или не определен – ‘Not for sale’  
		b. StandardCost больше 0, но меньше 100 – ‘<$100’ 
		c. StandardCost больше или равно 100, но меньше 500 - ‘ <$500' 
		d. Иначе - ‘ >= $500'
		Вывести имя продукта и новое поле PriceRange.
*/
SELECT Name,
		CASE
			WHEN StandardCost IS NULL OR StandardCost = 0 THEN 'Not for sale'
			WHEN StandardCost < 100 THEN '<$100'
			WHEN StandardCost < 500 THEN '<$500'
			ELSE '>= $500'
		END AS PriceRange
FROM AdventureWorks2017.Production.Product
ORDER BY Name;


/*
1. Решите на базе данных AdventureWorks2017 следующие задачи (для поиска ключей можно использовать схему БД ). 
	b) Найти ProductID, BusinessEntityID и имя поставщика продукции из Purchasing.ProductVendor и Purchasing.Vendor, где StandardPrice больше $10. 
	Также в имени вендора должна присутствовать (вне зависимости от положения) буква X или имя должно начинаться на букву N.
*/
SELECT T1.ProductID,
		T1.BusinessEntityID,
		T2.Name
FROM AdventureWorks2017.Purchasing.ProductVendor T1 
		LEFT JOIN AdventureWorks2017.Purchasing.Vendor T2 
		ON T1.BusinessEntityID = T2.BusinessEntityID
WHERE T1.StandardPrice > 10 
		AND (T2.Name LIKE '%X%' OR T2.Name LIKE 'N%');


/*
1. Решите на базе данных AdventureWorks2017 следующие задачи (для поиска ключей можно использовать схему БД ).
	c) Найти имена всех вендоров, продукция которых не продавалась за всё время. 
	Необходимо использовать следующую схему соединения таблиц Purchasing.ProductVendor и Purchasing.Vendor:
*/
--Решение через LEFT JOIN
SELECT T1.Name,
		T1.BusinessEntityID
FROM AdventureWorks2017.Purchasing.Vendor T1
		LEFT JOIN AdventureWorks2017.Purchasing.ProductVendor T2
		ON T1.BusinessEntityID = T2.BusinessEntityID
WHERE T2.BusinessEntityID IS NULL
ORDER BY T1.Name;

--Решение через подзапрос
SELECT Name,
		BusinessEntityID
FROM AdventureWorks2017.Purchasing.Vendor
WHERE BusinessEntityID NOT IN (SELECT DISTINCT BusinessEntityID
								FROM AdventureWorks2017.Purchasing.ProductVendor)
ORDER BY Name;





/*
2. Решить следующие задачи для тестовой базы данных (схема ниже):

	TableSales:		// Продажи
		ID				// ID, PK
		ID_Medicine		// ID фармпрепарата, FK
		Price			// цена
		Quantity		// количество
		Id_Bill			// ID чека, FK
		Id_Branch		// ID аптечного пункта, FK

	TableMedicine:		// Фармпрепараты
		ID				// ID, PK
		Name			// имя
		Packaging		// фасовка
		Price			// цена
		ID_Type			// ID типа, FK
		ID_Firm			// ID фирмы, FK

	TableMedicineType:	// Типы фармпрепаратов
		ID				// ID, PK
		Type			// тип

	TableFirms:		// Фирмы-производители
		ID				// ID, PK
		Name			// имя

	TableBills:		// Кассовые чеки
		ID				// ID, PK
		Date			// дата
		Offer			// скидка

	TableBranches:		// Аптечные пункты
		ID				// ID, PK
		Name			// имя
		Address			// адрес
		PhoneNumber		// телефон
*/

-- a) Найдите производителей, препараты которых не продавались в 2019 году (подсказка: для выделения года из даты надо использовать одну из функций для работы с датами).
SELECT DISTINCT Firms.ID,
				Firms.Name
FROM Scheme.TableFirms Firms 
		LEFT JOIN Scheme.TableMedicine Medicine
		ON Firms.ID = Medicine.ID_Firm
WHERE Medicine.ID IS NULL OR Medicine.ID NOT IN (SELECT DISTINCT Sales.ID_Medicine
												FROM Scheme.TableSales Sales
														LEFT JOIN Scheme.TableBills Bills
														ON Sales.ID_Bills = Bills.ID
												WHERE YEAR(Bills.Date) = 2019)
ORDER BY Firms.Name;


-- b) Выведите увеличенную в 2 раза цену препаратов типа А. 
SELECT Medicine.Name,
		2 * Medicine.Price AS Increased_Price
FROM Scheme.TableMedicine Medicine
		LEFT JOIN Scheme.TableMedicineType MedicineType
		ON Medicine.ID_Type = MedicineType.ID
WHERE MedicineType.Type = 'A'
ORDER BY Medicine.Name;


-- c) Найдите производителей и кол-во фармпрепаратов для кажого из них, где препарат не относится к типу А.
SELECT Firm.Name,
		COUNT(Medicine.Name) AS COUNT_Medicine
FROM Scheme.TableMedicine Medicine
		LEFT JOIN Scheme.TableMedicineType MedicineType
		ON Medicine.ID_Type = MedicineType.ID
				LEFT JOIN Scheme.TableFirm Firm
				ON Medicine.ID_Firm = Firm.ID
WHERE MedicineType.Type IS NOT NULL AND MedicineType.Type != 'A'
GROUP BY Firm.Name
ORDER BY Firm.Name;


-- d) Вывести название аптеки и названия фармпрепаратов, которые в ней продавались по субботам.
SELECT Branches.Name,
		Medicine.Name
FROM Scheme.TableSales Sales
		LEFT JOIN Scheme.TableMedicine Medicine
		ON Sales.ID_Medicine = Medicine.ID
				LEFT JOIN Scheme.TableBills Bills
				ON Sales.ID_Bills = Bills.ID
						LEFT JOIN Scheme.TableBranches Branches
						ON Sales.ID_Branches = Branches.ID
WHERE DATEPART(weekday, Bills.Date) = 'Saturday'
ORDER BY Branches.Name, Medicine.Name;