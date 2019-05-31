CREATE TABLE [dbo].[tbl_PublisherLog] (
    [PubLogID]         INT              IDENTITY (1, 1) NOT NULL,
    [TrackID]          UNIQUEIDENTIFIER NULL,
    [PubID]            INT              NOT NULL,
    [ProcessName]      NVARCHAR (MAX)   NULL,
    [MsgType]          NVARCHAR (50)    NULL,
    [PubStartTime]     DATETIME         NULL,
    [PubEndTime]       DATETIME         NULL,
    [PubStatus]        NVARCHAR (50)    NULL,
    [FormattedMessage] XML              NULL,
    [RecordCount]      INT              NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [PubConnID]        INT              NULL,
    [EndMsg]           NVARCHAR (MAX)   NULL,
    [StartMsg]         NVARCHAR (MAX)   NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NULL,
    [ArchiveXMLPath]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tbl_PublisherLog] PRIMARY KEY CLUSTERED ([PubLogID] ASC),
    CONSTRAINT [FK_tbl_PublisherLog] FOREIGN KEY ([PubID]) REFERENCES [dbo].[tbl_PublisherController] ([PubID]),
    CONSTRAINT [FK_tbl_PublisherLog_PubConnID] FOREIGN KEY ([PubConnID]) REFERENCES [dbo].[tbl_Publishers] ([PubConnID])
);

