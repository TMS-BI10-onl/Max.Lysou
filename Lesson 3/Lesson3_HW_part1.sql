/*
1. ������ �� ���� ������ AdventureWorks2017 ��������� ������ (��� ������ ������ ����� ������������ ����� �� ). 
	a) ������� ������ ��� � ���� ���������� �����������, ����������� �� ��������� ��� ��� ��������:
		a. StandardCost ����� 0 ��� �� ��������� � �Not for sale�  
		b. StandardCost ������ 0, �� ������ 100 � �<$100� 
		c. StandardCost ������ ��� ����� 100, �� ������ 500 - � <$500' 
		d. ����� - � >= $500'
		������� ��� �������� � ����� ���� PriceRange.
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
1. ������ �� ���� ������ AdventureWorks2017 ��������� ������ (��� ������ ������ ����� ������������ ����� �� ). 
	b) ����� ProductID, BusinessEntityID � ��� ���������� ��������� �� Purchasing.ProductVendor � Purchasing.Vendor, ��� StandardPrice ������ $10. 
	����� � ����� ������� ������ �������������� (��� ����������� �� ���������) ����� X ��� ��� ������ ���������� �� ����� N.
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
1. ������ �� ���� ������ AdventureWorks2017 ��������� ������ (��� ������ ������ ����� ������������ ����� �� ).
	c) ����� ����� ���� ��������, ��������� ������� �� ����������� �� �� �����. 
	���������� ������������ ��������� ����� ���������� ������ Purchasing.ProductVendor � Purchasing.Vendor:
*/
--������� ����� LEFT JOIN
SELECT T1.Name,
		T1.BusinessEntityID
FROM AdventureWorks2017.Purchasing.Vendor T1
		LEFT JOIN AdventureWorks2017.Purchasing.ProductVendor T2
		ON T1.BusinessEntityID = T2.BusinessEntityID
WHERE T2.BusinessEntityID IS NULL
ORDER BY T1.Name;

--������� ����� ���������
SELECT Name,
		BusinessEntityID
FROM AdventureWorks2017.Purchasing.Vendor
WHERE BusinessEntityID NOT IN (SELECT DISTINCT BusinessEntityID
								FROM AdventureWorks2017.Purchasing.ProductVendor)
ORDER BY Name;





/*
2. ������ ��������� ������ ��� �������� ���� ������ (����� ����):

	TableSales:		// �������
		ID				// ID, PK
		ID_Medicine		// ID �������������, FK
		Price			// ����
		Quantity		// ����������
		Id_Bill			// ID ����, FK
		Id_Branch		// ID ��������� ������, FK

	TableMedicine:		// �������������
		ID				// ID, PK
		Name			// ���
		Packaging		// �������
		Price			// ����
		ID_Type			// ID ����, FK
		ID_Firm			// ID �����, FK

	TableMedicineType:	// ���� ��������������
		ID				// ID, PK
		Type			// ���

	TableFirms:		// �����-�������������
		ID				// ID, PK
		Name			// ���

	TableBills:		// �������� ����
		ID				// ID, PK
		Date			// ����
		Offer			// ������

	TableBranches:		// �������� ������
		ID				// ID, PK
		Name			// ���
		Address			// �����
		PhoneNumber		// �������
*/

-- a) ������� ��������������, ��������� ������� �� ����������� � 2019 ���� (���������: ��� ��������� ���� �� ���� ���� ������������ ���� �� ������� ��� ������ � ������).
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


-- b) �������� ����������� � 2 ���� ���� ���������� ���� �. 
SELECT Medicine.Name,
		2 * Medicine.Price AS Increased_Price
FROM Scheme.TableMedicine Medicine
		LEFT JOIN Scheme.TableMedicineType MedicineType
		ON Medicine.ID_Type = MedicineType.ID
WHERE MedicineType.Type = 'A'
ORDER BY Medicine.Name;


-- c) ������� �������������� � ���-�� �������������� ��� ������ �� ���, ��� �������� �� ��������� � ���� �.
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


-- d) ������� �������� ������ � �������� ��������������, ������� � ��� ����������� �� ��������.
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