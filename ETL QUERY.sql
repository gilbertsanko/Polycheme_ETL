CREATE DATABASE DWW
CREATE TABLE [dbo].[DimensiBarangs](
	[BarangID] [int] IDENTITY(1,1) NOT NULL,
	[IDBarang] [nvarchar](11) NULL,
	[IDWarehouse] [nvarchar](11) NULL,
	[NamaBarang] [nvarchar](25) NULL,
	[Quantity] [int] NULL,
	[Satuan] [nvarchar](2) NULL,
	[Price] [int] NULL,
	[IDJenisBarang] [nvarchar](11) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BarangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

----------------------------------------
CREATE TABLE [dbo].[DimensiCustomer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[IDCustomer] [nvarchar] (7)NOT NULL,
	[CompanyName] [nvarchar](50) NULL,
	[Alamat] [nvarchar](100) NULL,
	[NoTelp] [nvarchar](18) NULL,
	[NoTelp2] [nvarchar](18) NULL,
	[Fax] [nvarchar](18) NULL,
	[ContactPerson] [nvarchar](30) NULL,
	[NPWPNumber] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-------------------------------------------------------------
CREATE TABLE [dbo].[DimensiJenisBarang](
	[JenisBarangID] [int] IDENTITY(1,1) NOT NULL,
	[IDJenisBarang] [nvarchar](11) NULL,
	[JenisBarang] [nvarchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[JenisBarangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-----------------------------------------------------------------
CREATE TABLE [dbo].[DimWaktu](
	[WaktuID] [int] IDENTITY(1,1) NOT NULL,
	[Tahun] [int] NOT NULL,
	[Bulan] [int] NOT NULL,
	[Hari] [int] NOT NULL,
	[Tanggal] [datetime] NOT NULL,
	[Status] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[WaktuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


---------------------------------------------
CREATE TABLE [dbo].[FaktaPenjualan](
	[WaktuID] [int] NOT NULL,
	[BarangID] [int] NOT NULL,
	[JenisBarangID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[JumlahBarangTerjual] [int] NOT NULL,
	[TotalPenjualan] [int] NOT NULL
) ON [PRIMARY]

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
--OLE DB dim waktu
SELECT DISTINCT CONVERT(int,CONVERT(varchar,date,112))
as DateKey,
CONVERT(date,date) as fulldate,
DATEPART(day,date) as Day,
DATENAME(WEEKDAY, date) AS DayName,
DATENAME(month,date) as MonthName,
Month(date) as MonthNumberOfYear,
year(date) as CalendarYear, keterangan as Status
from polychem_OLTP.dbo.TrHeaderSalesOrder

--------------------------------------------
--SELECT FACT TABLE BARU
SELECT
Tanggal.WaktuID,
Cust.CustomerID as IDCustomer,
Produk.BarangID as IDProduct,
PC.JenisBarangID as IDProductCategory,
SD.Quantity as SalesQty,
SH.TotalPrice as TotalDue
FROM
polychem_OLTP.dbo.TrHeaderSalesOrder SH LEFT JOIN polychem_OLTP.dbo.TrDetailSalesOrder SD
ON SH.NoSO = SD.NoSO
LEFT JOIN DWW.dbo.DimensiCustomer Cust ON Cust.IDCustomer collate SQL_Latin1_General_CP1_CI_AS  = SH.IDCustomer collate SQL_Latin1_General_CP1_CI_AS 
LEFT JOIN DWW.dbo.DimensiBarangs Produk ON Produk.IDBarang collate SQL_Latin1_General_CP1_CI_AS  = SD.IDBarang collate SQL_Latin1_General_CP1_CI_AS 
LEFT JOIN DWW.dbo.DimWaktu Tanggal ON Tanggal.Tanggal = SH.Date
LEFT JOIN DWW.dbo.DimensiJenisBarang PC ON
PC.IDJenisBarang = Produk.IDJenisBarang
