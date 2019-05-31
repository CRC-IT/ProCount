CREATE TABLE [dbo].[tbl_MsgQueue] (
    [MsgQID]           INT              IDENTITY (1, 1) NOT NULL,
    [TransID]          INT              NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [SubIFace]         NVARCHAR (100)   NOT NULL,
    [PubID]            INT              NULL,
    [SubID]            INT              NULL,
    [SubStatus]        NVARCHAR (50)    NULL,
    [SubDate]          DATETIME         NULL,
    [SubMsg]           NVARCHAR (MAX)   NULL,
    [CreatedTime]      DATETIME         NULL,
    [CreatedBy]        NVARCHAR (200)   NULL,
    [LastModifiedTime] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (200)   NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NULL,
    [SubConnID]        INT              NULL,
    [PubConnID]        INT              NULL,
    CONSTRAINT [PK_tbl_MsgQueue] PRIMARY KEY CLUSTERED ([MsgQID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_SubIFace_MsgQID]
    ON [dbo].[tbl_MsgQueue]([SubIFace] ASC)
    INCLUDE([MsgQID]);


GO
CREATE NONCLUSTERED INDEX [IDX_SubIFace_SubStatus_IFaceBatchUID>]
    ON [dbo].[tbl_MsgQueue]([SubIFace] ASC, [SubStatus] ASC, [IFaceBatchUID] ASC)
    INCLUDE([MsgQID], [TransID], [TransSeq], [PubID], [SubID], [SubConnID], [PubConnID]);

