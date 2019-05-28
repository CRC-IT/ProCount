CREATE TABLE [dbo].[tbl_Subscribers] (
    [SubConnID]        INT             IDENTITY (1, 1) NOT NULL,
    [ServerName]       NVARCHAR (200)  NULL,
    [DataBaseName]     NVARCHAR (200)  NULL,
    [DstDirPath]       NVARCHAR (1000) NULL,
    [DstFileName]      NVARCHAR (1000) NULL,
    [FileExtension]    NVARCHAR (10)   NULL,
    [DelDstFile]       BIT             NULL,
    [DelDstRecords]    BIT             NULL,
    [UserID]           NVARCHAR (200)  NULL,
    [Password]         NVARCHAR (200)  NULL,
    [LastModifiedTime] DATETIME        NULL,
    [LastModifiedBy]   NVARCHAR (200)  NULL,
    [Description]      NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_tbl_Subscribers] PRIMARY KEY CLUSTERED ([SubConnID] ASC)
);

