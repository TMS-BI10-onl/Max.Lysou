/*
	5
	Вокзал
	Маршруты_dim (id маршрута, пункт отправления,пункт прибытия, дата отправления, дата прибытия, цена билета)
	Водители_dim (id водителя, имя, фамилия)
	Пассажиры_dim (id пассажира, имя, фамилия)
	Вокзал_dim (id вокзал, адрес, телефон)
	Автобусы_dim (id автобуса, марка, количество мест, год выпуска)
	Кассиры_dim (id кассира, имя, фамилия)
	Продажа билетов_fact (id чека, id маршрута, id автобуса, id водителя, id вокзал, id кассира, id пассажира, количество билетов, дата покупки)

	Необходимо узнать по каким маршрутам, отправляющимся в марте, остались свободные места и сколько этих мест. 
	Необходимо узнать выручку по каждому маршруту за каждый год суммарно. Результаты вывести в виде транспонированной таблицы.
*/

DROP TABLE IF EXISTS [Test].[dbo].[RoutesDim];
CREATE TABLE RoutesDim
	(
	[IdRoute]		int IDENTITY(1,1) NOT NULL, 
	[DeparturePoint]	nvarchar(50),
	[ArrivalPoint]		nvarchar(50), 
	[DepartureDate]		date, 
	[ArrivalDate]		date, 
	[Price]			money
	);

DROP TABLE IF EXISTS [Test].[dbo].[DriversDim];
CREATE TABLE [Test].[dbo].[DriversDim]
	(
	[IdDriver]		int IDENTITY(1,1) NOT NULL, 
	[FirstName]		nvarchar(50),
	[LastName]		nvarchar(50)
	);

DROP TABLE IF EXISTS [Test].[dbo].[PassengersDim];
CREATE TABLE [Test].[dbo].[PassengersDim]
	(
	[IdPassenger]	int IDENTITY(1,1) NOT NULL, 
	[FirstName]	nvarchar(50),
	[LastName]	nvarchar(50)
	);

DROP TABLE IF EXISTS [Test].[dbo].[StationsDim];
CREATE TABLE [Test].[dbo].[StationsDim]
	(
	[IdStation]	int IDENTITY(1,1) NOT NULL, 
	[Address]	nvarchar(50),
	[PhoneNumber]	nvarchar(50)
	);

DROP TABLE IF EXISTS [Test].[dbo].[BusesDim];
CREATE TABLE [Test].[dbo].[BusesDim]
	(
	[IdBus]			int IDENTITY(1,1) NOT NULL, 
	[Model]			nvarchar(50),
	[NumOfPlaces]		int,
	[YearOfManufacture]	int
	);

DROP TABLE IF EXISTS [Test].[dbo].[CashiersDim];
CREATE TABLE [Test].[dbo].[CashiersDim]
	(
	[IdCashier]	int IDENTITY(1,1) NOT NULL, 
	[FirstName]	nvarchar(50),
	[LastName]	nvarchar(50)
	);

DROP TABLE IF EXISTS [Test].[dbo].[SalesFct];
CREATE TABLE [Test].[dbo].[SalesFct]
	(
	[IdSale]		int IDENTITY(1,1) NOT NULL, 
	[IdRoute]		int, 
	[IdBus]			int, 
	[IdDriver]		int, 
	[IdStation]		int, 
	[IdCashier]		int, 
	[IdPassenger]		int, 
	[NumOfTickets]		int,
	[DateOfPurchase]	date
	);

/*
	Необходимо узнать по каким маршрутам, отправляющимся в марте, остались свободные места и сколько этих мест. 
*/

SELECT
	Routes.*,
	Sales.[SoldTickets],
	Buses.[NumOfPlaces],
	Buses.[NumOfPlaces] - Sales.[SoldTickets] AS RemainedTickets
FROM
	[Test].[dbo].[RoutesDim] Routes
	LEFT JOIN (
		SELECT
			[IdRoute],
			[IdBus],
			SUM([NumOfTickets]) AS SoldTickets
		FROM [Test].[dbo].[SalesFct]
		GROUP BY [IdRoute], [IdBus]
	) Sales
	ON Routes.[IdRoute] = Sales.[IdRoute]
	LEFT JOIN [Test].[dbo].[BusesDim] Buses
	ON Sales.[IdBus] = Buses.[IdBus]
WHERE 
	Month(Routes.[DepartureDate]) = 3 AND
	(Buses.[NumOfPlaces] - Sales.[SoldTickets] > 0 or Buses.[NumOfPlaces] - Sales.[SoldTickets] IS NULL);
/*
Для данной БД задача полностью не может быть решена, так как таблица [Bus] не связана с таблицей [Routes] напрямую, а только через таблицу фактов [Sales].
Это приводит к тому, что если на маршрут не продано ни одного билета, тогда нельзя однозначно сопоставить автобус, а соответственно и количество доступных мест, для конкретного маршрута.
В таком случае для данного маршрута будет отсутствовать информация о количестве свободных мест (NULL), но при этом логично предположить, что свободные места есть ;)
*/


/*
	Необходимо узнать выручку по каждому маршруту за каждый год суммарно. Результаты вывести в виде транспонированной таблицы.
*/

SELECT [IdRoute], 
	ISNULL([2018],0) AS [2018], 
	ISNULL([2019],0) AS [2019], 
	ISNULL([2020],0) AS [2020], 
	ISNULL([2021],0) AS [2021], 
	ISNULL([2022],0) AS [2022]
FROM
	(
	SELECT
		Routes.[IdRoute],
		Sales.[NumOfTickets] * Routes.[Price] AS [Revenue],
		YEAR([DateOfPurchase]) AS [Year]
	FROM 
		[Test].[dbo].[RoutesDim] Routes
		--LEFT JOIN для таблицы [Routes], так как интересно узнать информацию по маршрутам, по которым не было продаж в анализируемом периоде
		LEFT JOIN [Test].[dbo].[SalesFct] Sales
		ON Sales.[IdRoute] = Routes.[IdRoute]
	) AS SourceTable
PIVOT
	(
		SUM([Revenue])
		FOR [Year] IN ([2018], [2019], [2020], [2021], [2022])
	) AS PivotTable;
