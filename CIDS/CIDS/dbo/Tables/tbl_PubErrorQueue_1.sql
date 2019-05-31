CREATE TABLE [dbo].[tbl_PubErrorQueue] (
    [PubErrorQID]   INT              IDENTITY (1, 1) NOT NULL,
    [PubID]         INT              NOT NULL,
    [PubConnID]     INT              NULL,
    [BatchTrackUID] UNIQUEIDENTIFIER NULL,
    [ProcessName]   NVARCHAR (500)   NULL,
    [ErrorTime]     DATETIME         NULL,
    [ErrorSeverity] NVARCHAR (50)    NULL,
    [ErrorMsg]      NVARCHAR (MAX)   NULL,
    [IsReprocess]   INT              NULL,
    [CreatedTime]   DATETIME         NULL,
    [CreatedBy]     NVARCHAR (100)   NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tbl_PubErrorQueue] PRIMARY KEY CLUSTERED ([PubErrorQID] ASC),
    CONSTRAINT [FK_tbl_PubErrorQueue_PubConnID] FOREIGN KEY ([PubConnID]) REFERENCES [dbo].[tbl_Publishers] ([PubConnID]),
    CONSTRAINT [FK_tbl_PubErrorQueue_PubID] FOREIGN KEY ([PubID]) REFERENCES [dbo].[tbl_PublisherController] ([PubID])
);

