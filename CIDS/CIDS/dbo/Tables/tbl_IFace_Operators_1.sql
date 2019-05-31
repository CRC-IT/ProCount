CREATE TABLE [dbo].[tbl_IFace_Operators] (
    [TransID]          INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]       INT              NULL,
    [TranDate]         DATETIME         NULL,
    [TranMsg]          NVARCHAR (MAX)   NULL,
    [PubID]            INT              NOT NULL,
    [last_Entity_name] VARCHAR (60)     NULL,
    [Business_ASS_NO]  VARCHAR (16)     NULL,
    [MSTR_ORIGIN_DATE] DATETIME         NULL,
    [PubConnID]        INT              NULL,
    [LastModifiedTime] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_Operators] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

