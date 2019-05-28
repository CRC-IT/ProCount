CREATE TABLE [dbo].[tbl_IFace_WellData] (
    [TransID]          INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]       INT              NULL,
    [TranDate]         DATETIME         NULL,
    [TranMsg]          NVARCHAR (MAX)   NULL,
    [PubID]            INT              NOT NULL,
    [NodeID]           NVARCHAR (50)    NOT NULL,
    [WellTestFacility] NVARCHAR (50)    NULL,
    [HeaderPosition]   INT              NULL,
    [PumperRoute]      NVARCHAR (10)    NULL,
    [CreatedTime]      DATETIME         NULL,
    [CreatedBy]        NVARCHAR (100)   DEFAULT (user_name()) NULL,
    [PubConnID]        INT              NULL,
    [LastModifiedTime] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_WellData] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

