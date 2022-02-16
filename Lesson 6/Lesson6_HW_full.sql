/*
3)
Создайте объект с параметрами для обновления значения NationalIDNumber в таблице HumanResources.Employee для указанного BusinessEntityID. 
Т.е. объекту будет подаваться 2 значения: BusinessEntityID (для кого изменяем данные) и NationalIDNumber (на какое значение изменяем).
С помощью данного объекта попробуйте заменить NationalIDNumber на 879341111 для BusinessEntityID= 15.
*/

-- создание объекта процедура
CREATE PROCEDURE [dbo].[uspUpdateNationalIDNumber]
	@BusinessEntityID int,
	@NationalIDNumber nvarchar(15)
AS
UPDATE [AdventureWorks2017].[HumanResources].[Employee]
SET [NationalIDNumber] = @NationalIDNumber
WHERE [BusinessEntityID] = @BusinessEntityID;

-- запуск процедуры 1
EXECUTE [dbo].[uspUpdateNationalIDNumber]
	@BusinessEntityID = 15, 
	@NationalIDNumber = 'klmn';

-- запуск процедуры 2
EXECUTE [dbo].[uspUpdateNationalIDNumber]
	@BusinessEntityID = 15, 
	@NationalIDNumber = 879341111;

--проверка результата работы процедуры
SELECT *
FROM [AdventureWorks2017].[HumanResources].[Employee]
WHERE BusinessEntityID = 15;

-- удаление объекта процедуры
DROP PROCEDURE [dbo].[uspUpdateNationalIDNumber];