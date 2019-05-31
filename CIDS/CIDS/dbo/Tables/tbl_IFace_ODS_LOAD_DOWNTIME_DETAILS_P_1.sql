CREATE TABLE [dbo].[tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P] (
    [TransID]               INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]              INT              NOT NULL,
    [IFaceBatchUID]         UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]            INT              NULL,
    [TranDate]              DATETIME         NULL,
    [TranMsg]               NVARCHAR (MAX)   NULL,
    [PubID]                 INT              NOT NULL,
    [PubConnID]             INT              NULL,
    [ObjectMerrickID]       INT              NULL,
    [OriginalDateEntered]   DATE             NULL,
    [DowntimeHours]         FLOAT (53)       NULL,
    [DowntimeCode]          INT              NULL,
    [LastModifiedTimeStamp] DATETIME         NULL,
    [UserName]              VARCHAR (25)     NULL,
    [CreatedTime]           DATETIME         NULL,
    [CreatedBy]             NVARCHAR (100)   NULL,
    [LastModifiedTime]      DATETIME         NULL,
    [LastModifiedBy]        NVARCHAR (200)   NULL,
    CONSTRAINT [PK_[tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

