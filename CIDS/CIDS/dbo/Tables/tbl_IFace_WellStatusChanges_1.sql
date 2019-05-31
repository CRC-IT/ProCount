CREATE TABLE [dbo].[tbl_IFace_WellStatusChanges] (
    [TransID]          INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]       INT              NULL,
    [TranDate]         DATETIME         NULL,
    [TranMsg]          NVARCHAR (MAX)   NULL,
    [PubID]            INT              NOT NULL,
    [API14]            VARCHAR (14)     NOT NULL,
    [NodeID]           NVARCHAR (50)    NOT NULL,
    [RecordDate]       DATETIME         NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL,
    [ChangeSetField]   NVARCHAR (50)    NOT NULL,
    [ChangeSetValue]   NVARCHAR (50)    NOT NULL,
    [Note]             NVARCHAR (255)   NULL,
    [CreatedTime]      DATETIME         NULL,
    [CreatedBy]        NVARCHAR (100)   CONSTRAINT [DF__tbl_IFace__Creat__473C8FC7] DEFAULT (user_name()) NULL,
    [PubConnID]        INT              NULL,
    [LastModifiedTime] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_WellStatusChanges] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC, [IFaceBatchUID] ASC)
);

