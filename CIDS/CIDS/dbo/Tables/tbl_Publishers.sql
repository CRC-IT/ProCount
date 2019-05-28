CREATE TABLE [dbo].[tbl_Publishers] (
    [PubConnID]        INT             IDENTITY (1, 1) NOT NULL,
    [ServerName]       NVARCHAR (200)  NULL,
    [DataBaseName]     NVARCHAR (200)  NULL,
    [SourceDirPath]    NVARCHAR (1000) NULL,
    [SrcFileName]      NVARCHAR (1000) NULL,
    [FileExtension]    NVARCHAR (10)   NULL,
    [DeleteSrcFile]    BIT             NULL,
    [DeleteSrcRecords] BIT             NULL,
    [UserID]           NVARCHAR (200)  NULL,
    [Password]         NVARCHAR (200)  NULL,
    [LastModifiedTime] DATETIME        NULL,
    [LastModifiedBy]   NVARCHAR (200)  NULL,
    [Description]      NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_tbl_Publishers] PRIMARY KEY CLUSTERED ([PubConnID] ASC)
);

