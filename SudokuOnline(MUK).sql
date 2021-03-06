USE [master]
GO
/****** Object:  Database [SudokuOnline]    Script Date: 2019-01-15 오후 6:50:12 ******/
CREATE DATABASE [SudokuOnline]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Sudoku', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Sudoku.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Sudoku_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Sudoku_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [SudokuOnline] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SudokuOnline].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SudokuOnline] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SudokuOnline] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SudokuOnline] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SudokuOnline] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SudokuOnline] SET ARITHABORT OFF 
GO
ALTER DATABASE [SudokuOnline] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SudokuOnline] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SudokuOnline] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SudokuOnline] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SudokuOnline] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SudokuOnline] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SudokuOnline] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SudokuOnline] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SudokuOnline] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SudokuOnline] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SudokuOnline] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SudokuOnline] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SudokuOnline] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SudokuOnline] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SudokuOnline] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SudokuOnline] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SudokuOnline] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SudokuOnline] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SudokuOnline] SET  MULTI_USER 
GO
ALTER DATABASE [SudokuOnline] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SudokuOnline] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SudokuOnline] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SudokuOnline] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SudokuOnline] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SudokuOnline] SET QUERY_STORE = OFF
GO
USE [SudokuOnline]
GO
/****** Object:  Table [dbo].[Game]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Game](
	[GameNumber] [int] IDENTITY(1,1) NOT NULL,
	[StartedDatetime] [datetime] NOT NULL,
	[EndedDatetime] [datetime] NULL,
	[Player1] [int] NOT NULL,
	[Player2] [int] NOT NULL,
	[Winner] [int] NULL,
 CONSTRAINT [PK_게임] PRIMARY KEY CLUSTERED 
(
	[GameNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PlayingGames]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PlayingGames]
AS
SELECT  GameNumber, StartedDatetime, Player1, Player2
FROM     dbo.Game
WHERE  (EndedDatetime = NULL)
GO
/****** Object:  Table [dbo].[User]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Number] [int] NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[TierNumber] [int] NOT NULL,
	[MMR] [int] NOT NULL,
	[PlayedGames] [int] NOT NULL,
	[WonGames] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Birth] [date] NULL,
	[Address] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
 CONSTRAINT [PK_사용자] PRIMARY KEY CLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tier]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tier](
	[TierNumber] [int] NOT NULL,
	[TierName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_등급] PRIMARY KEY CLUSTERED 
(
	[TierNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[WeeklyTop100]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WeeklyTop100]
AS
SELECT  TOP (100) PERCENT dbo.[User].UserID, dbo.[User].MMR, dbo.Tier.TierName, dbo.[User].PlayedGames, dbo.[User].WonGames, CONVERT(numeric(4, 1), 
               1.0 * dbo.[User].WonGames / dbo.[User].PlayedGames * 100) AS WinRate
FROM     dbo.[User] INNER JOIN
               dbo.Tier ON dbo.[User].TierNumber = dbo.Tier.TierNumber
WHERE  (dbo.[User].PlayedGames > 0)
ORDER BY dbo.[User].TierNumber DESC, dbo.[User].MMR DESC, WinRate DESC, dbo.[User].PlayedGames DESC
GO
/****** Object:  Table [dbo].[Item]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[Number] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Price] [numeric](10, 2) NOT NULL,
 CONSTRAINT [PK_아이템] PRIMARY KEY CLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log](
	[LogNumber] [bigint] NOT NULL,
	[GameNumber] [int] NOT NULL,
	[UserNumber] [int] NOT NULL,
	[InputDatetime] [datetime] NOT NULL,
	[InputValue] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[LogNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserItem]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserItem](
	[UserNumber] [int] NOT NULL,
	[ItemNumber] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_아이템사용자] PRIMARY KEY CLUSTERED 
(
	[UserNumber] ASC,
	[ItemNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WeeklyRankingChart]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeeklyRankingChart](
	[RankingID] [int] NOT NULL,
	[Ranking] [int] NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[TierName] [nvarchar](50) NOT NULL,
	[MMR] [int] NOT NULL,
 CONSTRAINT [PK_WeeklyRankingChart] PRIMARY KEY CLUSTERED 
(
	[RankingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_사용자_MMR]  DEFAULT ((1000)) FOR [MMR]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_사용자_플레이게임수]  DEFAULT ((0)) FOR [PlayedGames]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_사용자_승리한게임수]  DEFAULT ((0)) FOR [WonGames]
GO
ALTER TABLE [dbo].[UserItem] ADD  CONSTRAINT [DF_아이템사용자_수량]  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[Game]  WITH CHECK ADD  CONSTRAINT [FK_게임_사용자] FOREIGN KEY([Player1])
REFERENCES [dbo].[User] ([Number])
GO
ALTER TABLE [dbo].[Game] CHECK CONSTRAINT [FK_게임_사용자]
GO
ALTER TABLE [dbo].[Game]  WITH CHECK ADD  CONSTRAINT [FK_게임_사용자1] FOREIGN KEY([Player2])
REFERENCES [dbo].[User] ([Number])
GO
ALTER TABLE [dbo].[Game] CHECK CONSTRAINT [FK_게임_사용자1]
GO
ALTER TABLE [dbo].[Log]  WITH CHECK ADD  CONSTRAINT [FK_로그_게임] FOREIGN KEY([GameNumber])
REFERENCES [dbo].[Game] ([GameNumber])
GO
ALTER TABLE [dbo].[Log] CHECK CONSTRAINT [FK_로그_게임]
GO
ALTER TABLE [dbo].[Log]  WITH CHECK ADD  CONSTRAINT [FK_로그_사용자] FOREIGN KEY([UserNumber])
REFERENCES [dbo].[User] ([Number])
GO
ALTER TABLE [dbo].[Log] CHECK CONSTRAINT [FK_로그_사용자]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_사용자_등급] FOREIGN KEY([TierNumber])
REFERENCES [dbo].[Tier] ([TierNumber])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_사용자_등급]
GO
ALTER TABLE [dbo].[UserItem]  WITH CHECK ADD  CONSTRAINT [FK_아이템사용자_사용자] FOREIGN KEY([UserNumber])
REFERENCES [dbo].[User] ([Number])
GO
ALTER TABLE [dbo].[UserItem] CHECK CONSTRAINT [FK_아이템사용자_사용자]
GO
ALTER TABLE [dbo].[UserItem]  WITH CHECK ADD  CONSTRAINT [FK_아이템사용자_아이템] FOREIGN KEY([ItemNumber])
REFERENCES [dbo].[Item] ([Number])
GO
ALTER TABLE [dbo].[UserItem] CHECK CONSTRAINT [FK_아이템사용자_아이템]
GO
/****** Object:  StoredProcedure [dbo].[Game_Delete]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Game_Delete]
	@GameNumber int

as

delete Game where GameNumber = @GameNumber
GO
/****** Object:  StoredProcedure [dbo].[Game_Get]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Game_Get]
	@GameNumber int,
	@Winner int
	 
as

select @GameNumber, @Winner from Game
where GameNumber = @GameNumber
GO
/****** Object:  StoredProcedure [dbo].[Game_GetAll]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Game_GetAll]

as

select * from Game
GO
/****** Object:  StoredProcedure [dbo].[Game_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Game_Insert]
	@StartedDatetime datetime,
	@Player1 int,
	@Player2 int

as

insert into Game values(@StartedDatetime, NULL, @Player1, @Player2, NULL)
GO
/****** Object:  StoredProcedure [dbo].[Game_Update]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Game_Update]
	@GameNumber int,
	@EndedDatetime datetime,
	@Winner int

as

update Game set EndedDatetime = @EndedDatetime,
				Winner = @Winner
where GameNumber = @GameNumber
GO
/****** Object:  StoredProcedure [dbo].[Item_Delete]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Item_Delete]
	@ItemNumber int

as

delete Item where Number = @ItemNumber
GO
/****** Object:  StoredProcedure [dbo].[Item_GetAll]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Item_GetAll]

as

select * from Item
GO
/****** Object:  StoredProcedure [dbo].[Item_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Item_Insert]
	@Number int,
	@Name nvarchar(50),
	@Price numeric(10, 2)

as

insert into Item values(@Number, @Name, @Price)
GO
/****** Object:  StoredProcedure [dbo].[Item_Update]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Item_Update]
	@Number int,
	@Name nvarchar(50),
	@Pirce numeric(10, 2)

as

update Item set Name = @Name, Price = @Pirce where Number = @Number
GO
/****** Object:  StoredProcedure [dbo].[Log_GetTimeAndValue]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Log_GetTimeAndValue]
	@UserID nvarchar(50),
	@InputDatetime datetime

as

Select Us.UserID, Lo.InputValue, Lo.InputDatetime from Log Lo 
join [User] Us on Lo.UserNumber = Us.Number
	where @UserID = Us.UserID and @InputDatetime < InputDatetime and @InputDatetime > DATEADD(hh, 1,InputDatetime)
GO
/****** Object:  StoredProcedure [dbo].[Log_GetTimelyInputValues]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Log_GetTimelyInputValues]
	@UserID nvarchar(50),
	@InputDatetime datetime

AS

Select Us.UserID, Lo.InputValue, Lo.InputDatetime from Log Lo 
join [User] Us on Lo.UserNumber = Us.Number
	where @UserID = Us.UserID and @InputDatetime like InputDatetime
GO
/****** Object:  StoredProcedure [dbo].[Log_GetValuesBetweenTime]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Log_GetValuesBetweenTime]
	@UserID nvarchar(50),
	@StartedDatetime datetime,
	@EndedDatetime datetime

AS

Select Us.UserID, Lo.InputValue, Lo.InputDatetime from Log Lo 
join [User] Us on Lo.UserNumber = Us.Number
	where @UserID = Us.UserID and @StartedDatetime <= lo.InputDatetime and Lo.InputDatetime >= @EndedDatetime
GO
/****** Object:  StoredProcedure [dbo].[Log_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Log_Insert]
	@GameNumber int,
	@UserNumber int,
	@InputDatetime datetime,
	@InputValue nvarchar(50)
AS
	INSERT INTO Log 
		( GameNumber, UserNumber, InputDatetime, InputValue ) 
		VALUES (@GameNumber, @UserNumber, @InputDatetime, @InputValue)
GO
/****** Object:  StoredProcedure [dbo].[Tier_Delete]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Tier_Delete]
	@TierNumber int

as

delete Tier where TierNumber = @TierNumber
GO
/****** Object:  StoredProcedure [dbo].[Tier_GetAll]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Tier_GetAll]

as

select * from Tier
GO
/****** Object:  StoredProcedure [dbo].[Tier_GetUser]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Tier_GetUser]
	@TierNumber int

as

select t.TierNumber, u.Number, u.MMR, u.PlayedGames, u.WonGames from Tier t
	join dbo.[User] u on u.TierNumber = @TierNumber order by u.MMR
GO
/****** Object:  StoredProcedure [dbo].[Tier_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Tier_Insert]
	@TierNumber int,
	@TierName nvarchar(50)

as

insert into Tier values(@TierNumber, @TierName)
GO
/****** Object:  StoredProcedure [dbo].[Tier_Update]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Tier_Update]
	@TierNumber int,
	@TierName nvarchar(50)

as

update Tier set TierName = @TierName where TierNumber = @TierNumber
GO
/****** Object:  StoredProcedure [dbo].[User_Delete]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_Delete]
	@UserNumber int
AS

	DELETE FROM [User] Where Number = @UserNumber
GO
/****** Object:  StoredProcedure [dbo].[User_Get]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_Get]
	@UserID nvarchar(50)

AS
	SELECT * FROM [User] WHERE UserID = @UserID;
GO
/****** Object:  StoredProcedure [dbo].[User_GetGamesPerUser]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_GetGamesPerUser]
	@UserID nvarchar(50)
AS

Select Ga.* from [User] Us 
join Game Ga on Us.UserID = @UserID
	where Ga.Player1 = Us.UserID or Ga.Player2 = Us.UserID
GO
/****** Object:  StoredProcedure [dbo].[User_GetItems]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_GetItems]
	@UserID nvarchar(50),
	@Total int
AS

select It.Name, IU.Quantity, It.Price from [User] Us
	join UserItem IU on Us.Number = IU.UserNumber 
	join Item It on IU.ItemNumber = It.Number
where Us.UserID = @UserID
order by IU.Quantity desc
GO
/****** Object:  StoredProcedure [dbo].[User_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_Insert]
	@UserID nvarchar(50),
	@Email nvarchar(50),
	@Password nvarchar(50),
	@TierNumber int,
	@MMR int,
	@PlayedGames int,
	@WonGames int

AS
	INSERT INTO [User] 
		( UserID, Email, Password, TierNumber, MMR, PlayedGames, WonGames ) 
		VALUES (@UserID, @Email, @Password, 1, 1000, 0, 0)
GO
/****** Object:  StoredProcedure [dbo].[User_Update]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[User_Update]
    @UserID nvarchar(50),
    @Name nvarchar(50),
    @Birth date,
    @Phone nvarchar(25)

AS

UPDATE [User] 
   SET UserID = @UserID, Birth = @Birth, Phone = @Phone
   WHERE UserID = @UserID
GO
/****** Object:  StoredProcedure [dbo].[User_UpdateWhenGameEnded]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_UpdateWhenGameEnded]
    @UserNumber int,
    @MMR int,
    @PlayedGames int,
    @WonGames int

AS

UPDATE [User]
   SET MMR = @MMR, PlayedGames = @PlayedGames, WonGames = @WonGames
   WHERE @UserNumber = @UserNumber
GO
/****** Object:  StoredProcedure [dbo].[UserItem_Delete]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[UserItem_Delete]
	@UserNumber int,
	@ItemNumber int

as

delete UserItem where UserNumber = @UserNumber and ItemNumber = @ItemNumber
GO
/****** Object:  StoredProcedure [dbo].[UserItem_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[UserItem_Insert]
	@UserNumber int,
	@ItemNumber int,
	@Quantity int

as

insert into UserItem values(@UserNumber, @ItemNumber, @Quantity)
GO
/****** Object:  StoredProcedure [dbo].[UserItem_UpdateAmount]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[UserItem_UpdateAmount]
	@UserNumber int,
	@ItemNumber int,
	@Quantity int

as

update UserItem set Quantity = Quantity + @Quantity 
	where UserNumber = @UserNumber and ItemNumber = @ItemNumber
GO
/****** Object:  StoredProcedure [dbo].[WeeklyRankingChart_Get]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[WeeklyRankingChart_Get]
	@RankingID int
	 
as

select * From WeeklyRankingChart
where RankingID = @RankingID
GO
/****** Object:  StoredProcedure [dbo].[WeeklyRankingChart_GetAll]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[WeeklyRankingChart_GetAll]

as

select * from WeeklyRankingChart
GO
/****** Object:  StoredProcedure [dbo].[WeeklyRankingChart_GetWeek]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[WeeklyRankingChart_GetWeek]
	@RankingID int

as

select * from WeeklyRankingChart
where RankingID = @RankingID + '%'
GO
/****** Object:  StoredProcedure [dbo].[WeeklyRankingChart_Insert]    Script Date: 2019-01-15 오후 6:50:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[WeeklyRankingChart_Insert]

as

select * into 주간순위뷰 from WeeklyRankingChart
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Game', @level2type=N'COLUMN',@level2name=N'Player1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Game', @level2type=N'COLUMN',@level2name=N'Player2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1개 게임이 생성될 때 마다 관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Game'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log', @level2type=N'COLUMN',@level2name=N'UserNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자가 키를 입력한 시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log', @level2type=N'COLUMN',@level2name=N'InputDatetime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자가 입력한 값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log', @level2type=N'COLUMN',@level2name=N'InputValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tier', @level2type=N'COLUMN',@level2name=N'TierName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제 플레이어가 참여한 게임 수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PlayedGames'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참여한 게임 중 승리한 횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'WonGames'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ex)190101 = 19년 1월 1주' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WeeklyRankingChart', @level2type=N'COLUMN',@level2name=N'RankingID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주간순위를 저장하기 위한 테이블' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WeeklyRankingChart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Game"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 223
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PlayingGames'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PlayingGames'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "User"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Tier"
            Begin Extent = 
               Top = 6
               Left = 334
               Bottom = 102
               Right = 486
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'WeeklyTop100'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'WeeklyTop100'
GO
USE [master]
GO
ALTER DATABASE [SudokuOnline] SET  READ_WRITE 
GO
