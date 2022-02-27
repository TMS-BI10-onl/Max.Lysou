/*
2.
Решите следующую задачу. 
Дана таблица людей People. Поля: ID, FirstName, ParentName, LastName,  ID_Father, ID_Mother.
Для всех Дмитриев выведите их ФИО и ФИО их отцов.
*/

-- создание таблицы [Test].[dbo].[People]
DROP TABLE IF EXISTS [Test].[dbo].[People];
CREATE TABLE [Test].[dbo].[People]
	(
	[ID]			[int] IDENTITY(1,1) NOT NULL,
	[FirstName]		[nvarchar](50),
	[ParentName]	[nvarchar](50),
	[LastName]		[nvarchar](50),
	[ID_Father]		[int],
	[ID_Mother]		[int],

	CONSTRAINT [PK_People_ID] PRIMARY KEY ([ID])
	);

-- заполнение таблицы тестовыми данными
INSERT INTO [Test].[dbo].[People]
VALUES
(N'Дмитрий',N'Николаевич',N'Иванов',5,6),
(N'Игорь',N'Николаевич',N'Иванов',5,6),
(N'Татьяна',N'Николаевна',N'Петрова',5,6),
(N'Глеб',N'Дмитриевич',N'Воронин',7,8),
(N'Николай',N'Николаевич',N'Иванов',NULL,NULL),
(N'Инга',N'Дмитриевна',N'Иванова',7,8),
(N'Дмитрий',N'Дмитриевич',N'Воронин',9,10),
(N'Ольга',N'Викторовна',N'Воронина',NULL,NULL),
(N'Дмитрий',N'Максимович',N'Воронин',NULL,NULL),
(N'Алла',N'Глебовна',N'Воронина',NULL,NULL)
;
SELECT * FROM [Test].[dbo].[People];

-- запрос, который для всех Дмитриев выводит их ФИО и ФИО их отцов.
SELECT
	CONCAT(SON.[FirstName],' ',SON.[ParentName],' ',SON.[LastName]) AS FIO_SON,
	CONCAT(FATHER.[FirstName],' ',FATHER.[ParentName],' ',FATHER.[LastName]) AS FIO_FATHER
FROM [Test].[dbo].[People] SON
	LEFT JOIN [Test].[dbo].[People] FATHER
	ON SON.[ID_Father] = FATHER.[ID]
WHERE SON.[FirstName] = N'Дмитрий'
;