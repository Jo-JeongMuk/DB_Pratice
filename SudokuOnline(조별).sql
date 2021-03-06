USE [master]
GO
/****** Object:  Database [SudokuOnline]    Script Date: 2019-01-15 오후 5:32:09 ******/
CREATE DATABASE [SudokuOnline]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SudokuOnline', FILENAME = N'd:\MSSQL14.MSSQLSERVER\MSSQL\DATA\SudokuOnline.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SudokuOnline_log', FILENAME = N'd:\MSSQL14.MSSQLSERVER\MSSQL\DATA\SudokuOnline_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
/****** Object:  Table [dbo].[사용자]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[사용자](
	[사용자ID] [int] IDENTITY(1,1) NOT NULL,
	[닉네임] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[등급ID] [int] NOT NULL,
	[MMR] [int] NOT NULL,
	[플레이게임수] [int] NOT NULL,
	[승리한게임수] [int] NOT NULL,
	[성명] [nvarchar](50) NOT NULL,
	[생년월일] [date] NOT NULL,
	[주소] [nvarchar](50) NOT NULL,
	[연락처] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_사용자] PRIMARY KEY CLUSTERED 
(
	[사용자ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[주간순위뷰]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[주간순위뷰]
AS
SELECT  TOP (100) 닉네임, 등급ID, MMR, CONVERT(numeric(4, 1), 1.0 * 승리한게임수 / 플레이게임수 * 100) AS 승률
FROM     dbo.사용자 AS u
WHERE  (플레이게임수 > 0)
ORDER BY 등급ID DESC, MMR DESC, 승률 DESC, 플레이게임수 DESC
GO
/****** Object:  Table [dbo].[게임]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[게임](
	[게임ID] [int] IDENTITY(1,1) NOT NULL,
	[시작시간] [datetime] NOT NULL,
	[종료시간] [datetime] NULL,
	[승자] [int] NOT NULL,
	[패자] [int] NOT NULL,
 CONSTRAINT [PK_게임] PRIMARY KEY CLUSTERED 
(
	[게임ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[게임플레이현황]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[게임플레이현황]

as
	select g.게임ID, g.시작시간, g.승자 as 플레이어1, g.패자 as 플레이어2 from 게임 g where g.종료시간 = NULL
GO
/****** Object:  Table [dbo].[등급]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[등급](
	[등급ID] [int] NOT NULL,
	[등급] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_등급] PRIMARY KEY CLUSTERED 
(
	[등급ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[로그]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[로그](
	[게임ID] [int] NOT NULL,
	[사용자ID] [int] NOT NULL,
	[입력시각] [datetime] NOT NULL,
	[입력값] [nvarchar](50) NOT NULL,
	[로그ID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_로그] PRIMARY KEY CLUSTERED 
(
	[게임ID] ASC,
	[사용자ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[아이템]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[아이템](
	[아이템ID] [int] NOT NULL,
	[아이템명] [nvarchar](50) NOT NULL,
	[단가] [numeric](10, 2) NOT NULL,
 CONSTRAINT [PK_아이템] PRIMARY KEY CLUSTERED 
(
	[아이템ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[아이템사용자]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[아이템사용자](
	[사용자ID] [int] NOT NULL,
	[아이템ID] [int] NOT NULL,
	[수량] [int] NOT NULL,
 CONSTRAINT [PK_아이템사용자] PRIMARY KEY CLUSTERED 
(
	[사용자ID] ASC,
	[아이템ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[주간순위]    Script Date: 2019-01-15 오후 5:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[주간순위](
	[주차] [int] NOT NULL,
	[순위] [int] NOT NULL,
	[닉네임] [nvarchar](50) NOT NULL,
	[등급] [int] NOT NULL,
	[MMR] [int] NOT NULL,
 CONSTRAINT [PK_주간순위표] PRIMARY KEY CLUSTERED 
(
	[주차] ASC,
	[순위] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[게임] ON 

INSERT [dbo].[게임] ([게임ID], [시작시간], [종료시간], [승자], [패자]) VALUES (1, CAST(N'2019-01-10T09:57:00.000' AS DateTime), CAST(N'2019-01-10T11:49:00.000' AS DateTime), 2, 1)
INSERT [dbo].[게임] ([게임ID], [시작시간], [종료시간], [승자], [패자]) VALUES (2, CAST(N'2019-01-10T11:53:00.000' AS DateTime), CAST(N'2019-01-10T11:54:12.000' AS DateTime), 2, 1)
INSERT [dbo].[게임] ([게임ID], [시작시간], [종료시간], [승자], [패자]) VALUES (3, CAST(N'2019-01-10T11:55:00.000' AS DateTime), CAST(N'2019-01-10T11:56:00.000' AS DateTime), 1, 2)
SET IDENTITY_INSERT [dbo].[게임] OFF
INSERT [dbo].[등급] ([등급ID], [등급]) VALUES (1, N'브론즈')
SET IDENTITY_INSERT [dbo].[사용자] ON 

INSERT [dbo].[사용자] ([사용자ID], [닉네임], [Email], [Password], [등급ID], [MMR], [플레이게임수], [승리한게임수], [성명], [생년월일], [주소], [연락처]) VALUES (1, N'threego03', N'threego03@gmail.com', N'123456', 1, 1000, 2, 1, N'미입력', CAST(N'1900-01-01' AS Date), N'미입력', N'미입력')
INSERT [dbo].[사용자] ([사용자ID], [닉네임], [Email], [Password], [등급ID], [MMR], [플레이게임수], [승리한게임수], [성명], [생년월일], [주소], [연락처]) VALUES (2, N'yunjs0126', N'yunjs0126@naver.com', N'1q2w3e4r', 1, 1000, 2, 0, N'미입력', CAST(N'1900-01-01' AS Date), N'미입력', N'미입력')
SET IDENTITY_INSERT [dbo].[사용자] OFF
INSERT [dbo].[아이템] ([아이템ID], [아이템명], [단가]) VALUES (1, N'힌트', CAST(1000.00 AS Numeric(10, 2)))
INSERT [dbo].[아이템] ([아이템ID], [아이템명], [단가]) VALUES (2, N'물폭탄', CAST(10000.00 AS Numeric(10, 2)))
INSERT [dbo].[아이템] ([아이템ID], [아이템명], [단가]) VALUES (3, N'몇개만물폭탄', CAST(1500.00 AS Numeric(10, 2)))
INSERT [dbo].[아이템사용자] ([사용자ID], [아이템ID], [수량]) VALUES (1, 1, 5)
INSERT [dbo].[아이템사용자] ([사용자ID], [아이템ID], [수량]) VALUES (1, 3, 1)
INSERT [dbo].[아이템사용자] ([사용자ID], [아이템ID], [수량]) VALUES (2, 1, 10)
INSERT [dbo].[아이템사용자] ([사용자ID], [아이템ID], [수량]) VALUES (2, 2, 300)
ALTER TABLE [dbo].[로그] ADD  CONSTRAINT [DF_로그_로그ID]  DEFAULT (newid()) FOR [로그ID]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_MMR]  DEFAULT ((1000)) FOR [MMR]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_플레이게임수]  DEFAULT ((0)) FOR [플레이게임수]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_승리한게임수]  DEFAULT ((0)) FOR [승리한게임수]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_성명]  DEFAULT ('미입력') FOR [성명]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_성명1]  DEFAULT ('1900-01-01') FOR [생년월일]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_성명2]  DEFAULT ('미입력') FOR [주소]
GO
ALTER TABLE [dbo].[사용자] ADD  CONSTRAINT [DF_사용자_성명3]  DEFAULT ('미입력') FOR [연락처]
GO
ALTER TABLE [dbo].[아이템사용자] ADD  CONSTRAINT [DF_아이템사용자_수량]  DEFAULT ((0)) FOR [수량]
GO
ALTER TABLE [dbo].[게임]  WITH CHECK ADD  CONSTRAINT [FK_게임_사용자] FOREIGN KEY([승자])
REFERENCES [dbo].[사용자] ([사용자ID])
GO
ALTER TABLE [dbo].[게임] CHECK CONSTRAINT [FK_게임_사용자]
GO
ALTER TABLE [dbo].[게임]  WITH CHECK ADD  CONSTRAINT [FK_게임_사용자1] FOREIGN KEY([패자])
REFERENCES [dbo].[사용자] ([사용자ID])
GO
ALTER TABLE [dbo].[게임] CHECK CONSTRAINT [FK_게임_사용자1]
GO
ALTER TABLE [dbo].[로그]  WITH CHECK ADD  CONSTRAINT [FK_로그_게임] FOREIGN KEY([게임ID])
REFERENCES [dbo].[게임] ([게임ID])
GO
ALTER TABLE [dbo].[로그] CHECK CONSTRAINT [FK_로그_게임]
GO
ALTER TABLE [dbo].[로그]  WITH CHECK ADD  CONSTRAINT [FK_로그_사용자] FOREIGN KEY([사용자ID])
REFERENCES [dbo].[사용자] ([사용자ID])
GO
ALTER TABLE [dbo].[로그] CHECK CONSTRAINT [FK_로그_사용자]
GO
ALTER TABLE [dbo].[사용자]  WITH CHECK ADD  CONSTRAINT [FK_사용자_등급] FOREIGN KEY([등급ID])
REFERENCES [dbo].[등급] ([등급ID])
GO
ALTER TABLE [dbo].[사용자] CHECK CONSTRAINT [FK_사용자_등급]
GO
ALTER TABLE [dbo].[아이템사용자]  WITH CHECK ADD  CONSTRAINT [FK_아이템사용자_사용자] FOREIGN KEY([사용자ID])
REFERENCES [dbo].[사용자] ([사용자ID])
GO
ALTER TABLE [dbo].[아이템사용자] CHECK CONSTRAINT [FK_아이템사용자_사용자]
GO
ALTER TABLE [dbo].[아이템사용자]  WITH CHECK ADD  CONSTRAINT [FK_아이템사용자_아이템] FOREIGN KEY([아이템ID])
REFERENCES [dbo].[아이템] ([아이템ID])
GO
ALTER TABLE [dbo].[아이템사용자] CHECK CONSTRAINT [FK_아이템사용자_아이템]
GO
/****** Object:  StoredProcedure [dbo].[게임_Delete]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[게임_Delete]
	@게임ID int

as

delete 게임 where 게임ID = @게임ID
GO
/****** Object:  StoredProcedure [dbo].[게임_Get]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[게임_Get]
	@게임ID int,
	@승자 int,
	@패자 int
	 
as

select @게임ID, @승자, @패자 from 게임
where 게임ID = @게임ID
GO
/****** Object:  StoredProcedure [dbo].[게임_GetAll]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[게임_GetAll]

as

select * from 게임
GO
/****** Object:  StoredProcedure [dbo].[게임_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[게임_Insert]
	@시작시간 datetime,
	@승자 int,
	@패자 int

as

insert into 게임 values(@시작시간, NULL, @승자, @패자)
GO
/****** Object:  StoredProcedure [dbo].[게임_Update]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[게임_Update]
	@게임ID int,
	@종료시간 datetime,
	@승자 int,
	@패자 int

as

update 게임 set 종료시간 = @종료시간,
				승자 = @승자,
				패자 = @패자
where 게임ID = @게임ID
GO
/****** Object:  StoredProcedure [dbo].[등급_Delete]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[등급_Delete]
	@등급ID int

as

delete 등급 where 등급ID = @등급ID
GO
/****** Object:  StoredProcedure [dbo].[등급_GetAll]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[등급_GetAll]

as

select * from 등급
GO
/****** Object:  StoredProcedure [dbo].[등급_GetUser]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[등급_GetUser]
	@등급ID int

as

select t.등급, u.닉네임, u.MMR, u.플레이게임수, u.승리한게임수 from 등급 t
join 사용자 u on u.등급ID = @등급ID order by u.MMR
GO
/****** Object:  StoredProcedure [dbo].[등급_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[등급_Insert]
	@등급ID int,
	@등급 nvarchar(50)

as

insert into 등급 values(@등급ID, @등급)
GO
/****** Object:  StoredProcedure [dbo].[등급_Update]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[등급_Update]
	@등급ID int,
	@등급 nvarchar(50)

as

update 등급 set 등급 = @등급 where 등급ID = @등급ID
GO
/****** Object:  StoredProcedure [dbo].[로그_GetTimeAndValue]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[로그_GetTimeAndValue]
	@닉네임 nvarchar(50),
	@입력시간 datetime

as

Select Us.닉네임, Lo.입력값, Lo.입력시간 from 로그 Lo 
join 사용자 Us on Lo.사용자ID = Us.사용자ID
	where @닉네임 = Us.닉네임 and @입력시간 < 입력시간 and @입력시간 > DATEADD(hh, 1,입력시간)
GO
/****** Object:  StoredProcedure [dbo].[로그_GetValuesBetweenTime]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[로그_GetValuesBetweenTime]
	@닉네임 nvarchar(50),
	@시작시간 datetime,
	@종료시간 datetime

AS

Select Us.닉네임, Lo.입력값, Lo.입력시간 from 로그 Lo 
join 사용자 Us on Lo.사용자ID = Us.사용자ID
	where @닉네임 = Us.닉네임 and @시작시간 <= lo.입력시간 and Lo.입력시간 >= @종료시간	
GO
/****** Object:  StoredProcedure [dbo].[로그_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[로그_Insert]
	@게임ID int,
	@사용자ID int,
	@입력시간 datetime,
	@입력값 nvarchar(50)
AS
	INSERT INTO 로그 
		( 게임ID, 사용자ID, 입력시간, 입력값 ) 
		VALUES (@게임ID, @사용자ID, @입력시간, @입력값)	
GO
/****** Object:  StoredProcedure [dbo].[사용자_Delete]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_Delete]
	@사용자ID int
AS

	DELETE FROM 사용자 Where 사용자ID = @사용자ID	
GO
/****** Object:  StoredProcedure [dbo].[사용자_Get]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_Get]
	@닉네임 nvarchar(50)

AS
	SELECT * FROM 사용자 WHERE 닉네임 = @닉네임;
GO
/****** Object:  StoredProcedure [dbo].[사용자_GetGamesPerUser]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_GetGamesPerUser]
	@닉네임 nvarchar(50)
AS

Select Ga.* from 사용자 Us 
join 게임 Ga on Us.닉네임 = @닉네임
	where Ga.승자 = Us.사용자ID or Ga.패자 = Us.사용자ID
GO
/****** Object:  StoredProcedure [dbo].[사용자_GetItems]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_GetItems]
	@닉네임 nvarchar(50)
AS

select It.아이템명, IU.수량, It.단가, IU.수량 * It.단가 AS 총액 from 사용자 Us
	join 아이템사용자 IU on Us.사용자ID = IU.사용자ID 
	join 아이템 It on IU.아이템ID = It.아이템ID
where Us.닉네임 = @닉네임
order by IU.수량 desc
GO
/****** Object:  StoredProcedure [dbo].[사용자_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_Insert]
	@닉네임 nvarchar(50),
	@Email nvarchar(50),
	@Password nvarchar(50),
	@등급ID int,
	@MMR int,
	@플레이게임수 int,
	@승리한게임수 int

AS
	INSERT INTO 사용자 
		( 닉네임, Email, Password, 등급ID, MMR, 플레이게임수, 승리한게임수 ) 
		VALUES (@닉네임, @Email, @Password, 1, 1000, 0, 0)
GO
/****** Object:  StoredProcedure [dbo].[사용자_Update]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_Update]
    @닉네임 nvarchar(50),
    @성명 nvarchar(50),
    @생년월일 date,
    @연락처 nvarchar(25)

AS

UPDATE 사용자 
   SET 성명 = @성명, 생년월일 = @생년월일, 연락처 = @연락처
   WHERE 닉네임 = @닉네임
GO
/****** Object:  StoredProcedure [dbo].[사용자_UpdateWhenGameEnded]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[사용자_UpdateWhenGameEnded]
    @사용자ID int,
    @MMR int,
    @플레이게임수 int,
    @승리한게임수 int

AS

UPDATE 사용자
   SET MMR = @MMR, 플레이게임수 = @플레이게임수, 승리한게임수 = @승리한게임수
   WHERE 사용자ID = @사용자ID
GO
/****** Object:  StoredProcedure [dbo].[아이템_Delete]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템_Delete]
	@아이템ID int

as

delete 아이템 where 아이템ID = @아이템ID
GO
/****** Object:  StoredProcedure [dbo].[아이템_GetAll]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템_GetAll]

as

select * from 아이템
GO
/****** Object:  StoredProcedure [dbo].[아이템_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템_Insert]
	@아이템ID int,
	@아이템명 nvarchar(50),
	@단가 numeric(10, 2)

as

insert into 아이템 values(@아이템ID, @아이템명, @단가)
GO
/****** Object:  StoredProcedure [dbo].[아이템_Update]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템_Update]
	@아이템ID int,
	@아이템명 nvarchar(50),
	@단가 numeric(10, 2)

as

update 아이템 set 아이템명 = @아이템명, 단가 = @단가 where 아이템ID = @아이템ID
GO
/****** Object:  StoredProcedure [dbo].[아이템사용자_Delete]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템사용자_Delete]
	@아이템ID int,
	@사용자ID int

as

delete 아이템사용자 where 사용자ID = @사용자ID and 아이템ID = @아이템ID
GO
/****** Object:  StoredProcedure [dbo].[아이템사용자_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템사용자_Insert]
	@아이템ID int,
	@사용자ID int,
	@수량 int

as

insert into 아이템사용자 values(@사용자ID, @아이템ID, @수량)
GO
/****** Object:  StoredProcedure [dbo].[아이템사용자_UpdateAmount]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[아이템사용자_UpdateAmount]
	@아이템ID int,
	@사용자ID int,
	@수량 int

as

update 아이템사용자 set 수량 = @수량 where 아이템ID = @아이템ID and 사용자ID = @사용자ID
GO
/****** Object:  StoredProcedure [dbo].[주간순위표_Get]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[주간순위표_Get]
	@순위ID int
	 
as

select * From 주간순위표
where 순위ID = @순위ID
GO
/****** Object:  StoredProcedure [dbo].[주간순위표_GetAll]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[주간순위표_GetAll]

as

select * from 주간순위표
GO
/****** Object:  StoredProcedure [dbo].[주간순위표_GetWeek]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[주간순위표_GetWeek]
	@주차 int

as

select * from 주간순위표
where 순위ID = @주차 + '%'
GO
/****** Object:  StoredProcedure [dbo].[주간순위표_Insert]    Script Date: 2019-01-15 오후 5:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[주간순위표_Insert]

as

select * into 주간순위뷰 from 주간순위표
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게임 시작 시 상대적으로 MMR이 높은사람. 게임 종료 시 update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'게임', @level2type=N'COLUMN',@level2name=N'승자'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게임 시작 시 상대적으로 MMR이 낮은 사람. 게임 종료 시 update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'게임', @level2type=N'COLUMN',@level2name=N'패자'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1개 게임이 생성될 때 마다 관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'게임'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'언/브/실/골/플/다/마/챌' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'등급', @level2type=N'COLUMN',@level2name=N'등급'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'로그', @level2type=N'COLUMN',@level2name=N'사용자ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자가 키를 입력한 시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'로그', @level2type=N'COLUMN',@level2name=N'입력시각'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자가 입력한 값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'로그', @level2type=N'COLUMN',@level2name=N'입력값'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'사용자', @level2type=N'COLUMN',@level2name=N'사용자ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'사용자', @level2type=N'COLUMN',@level2name=N'닉네임'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Match Making Ranking' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'사용자', @level2type=N'COLUMN',@level2name=N'MMR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제 플레이어가 참여한 게임 수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'사용자', @level2type=N'COLUMN',@level2name=N'플레이게임수'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참여한 게임 중 승리한 횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'사용자', @level2type=N'COLUMN',@level2name=N'승리한게임수'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'190101 = 19년 1월 1주' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'주간순위', @level2type=N'COLUMN',@level2name=N'주차'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주간순위를 저장하기 위한 테이블' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'주간순위'
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
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 199
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'주간순위뷰'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'주간순위뷰'
GO
USE [master]
GO
ALTER DATABASE [SudokuOnline] SET  READ_WRITE 
GO
