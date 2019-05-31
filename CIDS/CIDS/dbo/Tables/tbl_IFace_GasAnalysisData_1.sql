CREATE TABLE [dbo].[tbl_IFace_GasAnalysisData] (
    [TransID]               INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]              INT              NOT NULL,
    [IFaceBatchUID]         UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]            INT              NULL,
    [TranDate]              DATETIME         NULL,
    [TranMsg]               NVARCHAR (MAX)   NULL,
    [PubID]                 INT              NOT NULL,
    [PubConnID]             INT              NULL,
    [Mdbid]                 INT              NULL,
    [Meterid]               NVARCHAR (16)    NULL,
    [Location]              NVARCHAR (50)    NULL,
    [Description]           NVARCHAR (35)    NULL,
    [Value]                 NVARCHAR (18)    NULL,
    [LastModifiedTimeStamp] DATETIME         NULL,
    [CreatedTime]           DATETIME         NULL,
    [CreatedBy]             NVARCHAR (100)   NULL,
    [LastModifiedTime]      DATETIME         NULL,
    [LastModifiedBy]        NVARCHAR (200)   NULL,
    CONSTRAINT [PK_[tbl_IFace_GasAnalysisData] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

