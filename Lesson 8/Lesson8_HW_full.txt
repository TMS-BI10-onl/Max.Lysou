/*
1.
Создайте вашу базу данных: таблицы, ограничения, ключи.
*/

-- создание БД [TMSGroup2]
CREATE DATABASE [TMSGroup2];





-- создание таблицы с турами [TMSGroup2].[DBO].[ToursDim]
DROP TABLE IF EXISTS [TMSGroup2].[DBO].[ToursDim];
CREATE TABLE [TMSGroup2].[DBO].[ToursDim]
	(
	[IDTour]			[int] IDENTITY(1,1) NOT NULL,
	[TourType]			[nvarchar](50) NULL,
	[HotelName]			[nvarchar](50) NOT NULL,
	[HotelRating]		[int] NULL,
	[Country]			[nvarchar](50) NOT NULL,
	[City]				[nvarchar](30) NOT NULL,
	[Address]			[nvarchar](50) NOT NULL,
	[CateringType]		[nvarchar](30) NULL,
	[Transfer]			[nvarchar](30) NOT NULL,
	[MaxQuantity]		[int] NOT NULL,
	[TransportType]		[nvarchar](30) NOT NULL,
	[TransportClass]	[nvarchar](30) NULL,

	CONSTRAINT [PK_ToursDim_IDTour] PRIMARY KEY ([IDTour]),
	CONSTRAINT [CK_HotelRating] CHECK ([HotelRating] >= 0 OR [HotelRating] IS NULL),
	CONSTRAINT [CK_MaxQuantity] CHECK ([MaxQuantity] > 0)
	);

-- тестовая проверка заполнения
INSERT INTO [TMSGroup2].[DBO].[ToursDim]
VALUES 
	('Test1','Test hotel',5,'Portugal','Porto','Lisbon str. 5-7',NULL,'Y',2,'avia','promo'),
	('Test2','Best hotel',NULL,'Spain','Barcelona','Gaudi str. 9','breakfast','Y',3,'bus','bussiness'),
	('Test3','Hotel hotel',1,'Sri Lanka','Unawatuna','First str. 1','AI','N',1,'avia','econom');

SELECT * FROM [TMSGroup2].[DBO].[ToursDim];
TRUNCATE TABLE [TMSGroup2].[DBO].[ToursDim]; 





-- создание таблицы с клиентами [TMSGroup2].[DBO].[ClientsDim]
DROP TABLE IF EXISTS [TMSGroup2].[DBO].[ClientsDim];
CREATE TABLE [TMSGroup2].[DBO].[ClientsDim]
	(
	[IDClient]				[int] IDENTITY(1,1) NOT NULL,
	[IdentificationNumber]	[nvarchar](30) NOT NULL,
	[FirstName]				[nvarchar](40) NOT NULL,
	[LastName]				[nvarchar](40) NOT NULL,
	[BirthDate]				[date] NOT NULL,
	[Gender]				[nvarchar](10) NOT NULL,
	[Phone]					[nvarchar](20) NOT NULL,
	[Email]					[nvarchar](30) NULL,

	CONSTRAINT [PK_ClientsDim_IDClient] PRIMARY KEY ([IDClient]),
	CONSTRAINT [UQ_IdentificationNumber] UNIQUE ([IdentificationNumber]),
	CONSTRAINT [CK_BirthDate] CHECK ([BirthDate] >= dateadd(year,-150,GETDATE()) AND [BirthDate] <= GETDATE())
	);

-- тестовая проверка заполнения
INSERT INTO [TMSGroup2].[DBO].[ClientsDim]
VALUES 
	('3010190C001PB5','Tony','Stark','1990-01-01','M','+33333333','tony.stark@avengers.com'),
	('3311295C001PB5','Piter','Parker','1995-12-31','M','+5(5)5-666','piter.parker@avengers.com'),
	('4010188C001PB5','Wanda','Maximoff','1888-12-31','F','+666',NULL);

SELECT * FROM [TMSGroup2].[DBO].[ClientsDim];
TRUNCATE TABLE [TMSGroup2].[DBO].[ClientsDim]; 





-- создание таблицы с менеджерами по продажам [TMSGroup2].[DBO].[ManagersDim]
DROP TABLE IF EXISTS [TMSGroup2].[DBO].[ManagersDim];
CREATE TABLE [TMSGroup2].[DBO].[ManagersDim]
	(
	[IDManager]		[int] IDENTITY(1,1) NOT NULL,
	[FirstName]		[nvarchar](40) NOT NULL,
	[LastName]		[nvarchar](40) NOT NULL,
	[Position]		[nvarchar](20) NOT NULL,
	[Phone]			[nvarchar](20) NOT NULL,
	[Email]			[nvarchar](30) NULL,

	CONSTRAINT [PK_ManagersDim_IDManager] PRIMARY KEY ([IDManager])
	);

-- тестовая проверка заполнения
INSERT INTO [TMSGroup2].[DBO].[ManagersDim]
VALUES 
	('Natasha','Romanoff','agent','+11111111','natasha.romanoff@avengers.com'),
	('Wade','Wilson','director','+2222222','wade.wilson@avengers.com');

SELECT * FROM [TMSGroup2].[DBO].[ManagersDim];
TRUNCATE TABLE [TMSGroup2].[DBO].[ManagersDim];





-- создание таблицы с офисами [TMSGroup2].[DBO].[OfficesDim]
DROP TABLE IF EXISTS [TMSGroup2].[DBO].[OfficesDim];
CREATE TABLE [TMSGroup2].[DBO].[OfficesDim]
	(
	[IDOffice]		[int] IDENTITY(1,1) NOT NULL,
	[City]			[nvarchar](20) NOT NULL,
	[Address]		[nvarchar](90) NOT NULL,

	CONSTRAINT [PK_OfficesDim_IDOffice] PRIMARY KEY ([IDOffice]),
	);

-- тестовая проверка заполнения
INSERT INTO [TMSGroup2].[DBO].[OfficesDim]
VALUES 
	('Gotham-city','batman str. 7'),
	('Springfield','simpson str. 1');

SELECT * FROM [TMSGroup2].[DBO].[OfficesDim];
TRUNCATE TABLE [TMSGroup2].[DBO].[OfficesDim];





-- создание таблицы с продажами [TMSGroup2].[DBO].[SalesFct]
DROP TABLE IF EXISTS [TMSGroup2].[DBO].[SalesFct];
CREATE TABLE [TMSGroup2].[DBO].[SalesFct]
	(
	[IDSale]			[int] IDENTITY(1,1) NOT NULL,
	[ContractNumber]	[nvarchar](30) NOT NULL,
	[DataSales]			[date] NOT NULL,
	[IDManager]			[int] NOT NULL,
	[IDTour]			[int] NOT NULL,
	[IDClient]			[int] NOT NULL,
	[IDOffice]			[int] NOT NULL,
	[Costs]				[money] NOT NULL,
	[SellingPrice]		[money] NOT NULL,
	[DiscountRate]		[smallmoney] NULL,
	[TourCapacity]		[int]  NOT NULL,
	[TourStartDate]		[date] NOT NULL,
	[TourFinishDate]	[date] NOT NULL,

	CONSTRAINT [PK_SalesFct_IDSale] PRIMARY KEY ([IDSale]),
	CONSTRAINT [UQ_ContractNumber] UNIQUE ([ContractNumber]),
	CONSTRAINT [CK_DataSales] CHECK ([DataSales] <= GETDATE()),
	CONSTRAINT [CK_Costs] CHECK ([Costs] >= 0),
	CONSTRAINT [CK_SellingPrice] CHECK ([SellingPrice] >= 0),
	CONSTRAINT [CK_DiscountRate] CHECK ([DiscountRate] >= 0),
	CONSTRAINT [CK_TourCapacity] CHECK ([TourCapacity] > 0)
	);

-- тестовая проверка заполнения
INSERT INTO [TMSGroup2].[DBO].[SalesFct]
VALUES 
	('333A698BCV','2022-02-23',1,1,1,1,100,150,20,2,'2022-02-23','2022-02-25');

SELECT * FROM [TMSGroup2].[DBO].[SalesFct];
TRUNCATE TABLE [TMSGroup2].[DBO].[SalesFct];





-- добавление внешних ключей
ALTER TABLE [TMSGroup2].[DBO].[SalesFct] WITH CHECK
ADD CONSTRAINT FK_Sales_Managers FOREIGN KEY([IDManager])
REFERENCES [TMSGroup2].[DBO].[ManagersDim] ([IDManager])
ON UPDATE CASCADE
ON DELETE CASCADE
;

ALTER TABLE [TMSGroup2].[DBO].[SalesFct] WITH CHECK
ADD CONSTRAINT FK_Sales_Tours FOREIGN KEY([IDTour])
REFERENCES [TMSGroup2].[DBO].[ToursDim] ([IDTour])
ON UPDATE CASCADE
ON DELETE CASCADE
;

ALTER TABLE [TMSGroup2].[DBO].[SalesFct] WITH CHECK
ADD CONSTRAINT FK_Sales_Clients FOREIGN KEY([IDClient])
REFERENCES [TMSGroup2].[DBO].[ClientsDim] ([IDClient])
ON UPDATE CASCADE
ON DELETE CASCADE
;

ALTER TABLE [TMSGroup2].[DBO].[SalesFct] WITH CHECK
ADD CONSTRAINT FK_Sales_Offices FOREIGN KEY([IDOffice])
REFERENCES [TMSGroup2].[DBO].[OfficesDim] ([IDOffice])
ON UPDATE CASCADE
ON DELETE CASCADE
;






/*
2.
Напишите скрипт для получения 1 млн человек с различными именами и фамилиями. Полезная ссылка.
*/

SELECT *
FROM [TEST].[DBO].[RandomNames1];

SELECT *
FROM [TEST].[DBO].[RandomNames2];

SELECT
	T1.[First_Name],
	T2.[Last_Name]
FROM [TEST].[DBO].[RandomNames1] T1
	CROSS JOIN [TEST].[DBO].[RandomNames2] T2;