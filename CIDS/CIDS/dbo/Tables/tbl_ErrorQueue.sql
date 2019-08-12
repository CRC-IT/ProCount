CREATE TABLE [dbo].[tbl_ErrorQueue] (
    [ErrorQID]         INT              IDENTITY (1, 1) NOT NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NOT NULL,
    [PubID]            INT              NOT NULL,
    [SubID]            INT              NOT NULL,
    [TransID]          INT              NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [SubIFace]         NVARCHAR (100)   NULL,
    [ErrorTime]        DATETIME         NULL,
    [ErrorSeverity]    NVARCHAR (50)    NULL,
    [ErrorMsg]         NVARCHAR (MAX)   NULL,
    [IsResubmit]       BIT              NULL,
    [CreatedTime]      DATETIME         NULL,
    [CreatedBy]        NVARCHAR (100)   NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [SubConnID]        INT              NULL,
    [PubConnID]        INT              NULL,
    [ErrorCode]        INT              NULL,
    [ErrorColumn]      INT              NULL,
    [LastResubmitTime] DATETIME         NULL,
    [LastResubmitBy]   NVARCHAR (100)   NULL,
    [IsBussRuleFail]   BIT              NULL,
    CONSTRAINT [PK_tbl_ErrorQueue] PRIMARY KEY CLUSTERED ([ErrorQID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_IFaceBatchUID_PubID_TransID_TransSeq]
    ON [dbo].[tbl_ErrorQueue]([IFaceBatchUID] ASC, [PubID] ASC, [TransID] ASC, [TransSeq] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_SubIFace_IsResubmit]
    ON [dbo].[tbl_ErrorQueue]([SubIFace] ASC, [IsResubmit] ASC)
    INCLUDE([IFaceBatchUID], [PubID], [SubID], [TransID], [TransSeq], [PubConnID]);


GO
CREATE NONCLUSTERED INDEX [IDX_IFaceBatchUID_SubIFace_IsResubmit]
    ON [dbo].[tbl_ErrorQueue]([IFaceBatchUID] ASC, [SubIFace] ASC, [IsResubmit] ASC)
    INCLUDE([PubID], [SubID], [TransID], [TransSeq], [PubConnID]);

