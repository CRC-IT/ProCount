CREATE TABLE [dbo].[tbl_SubscriberLog] (
    [SubLogID]       INT              IDENTITY (1, 1) NOT NULL,
    [TrackID]        UNIQUEIDENTIFIER NULL,
    [SubID]          INT              NOT NULL,
    [ProcessName]    NVARCHAR (MAX)   NULL,
    [MsgType]        NVARCHAR (50)    NULL,
    [QInStartTime]   DATETIME         NULL,
    [QInEndTime]     DATETIME         NULL,
    [QInStatus]      NVARCHAR (100)   NULL,
    [RecordCount]    INT              NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [SubConnID]      INT              NULL,
    [StartMsg]       NVARCHAR (MAX)   NULL,
    [EndMsg]         NVARCHAR (MAX)   NULL,
    [IFaceBatchUIDS] XML              NULL,
    CONSTRAINT [PK_tbl_SubscriberLog] PRIMARY KEY CLUSTERED ([SubLogID] ASC),
    CONSTRAINT [FK_tbl_SubscriberLog] FOREIGN KEY ([SubID]) REFERENCES [dbo].[tbl_SubscriberController] ([SubID]),
    CONSTRAINT [FK_tbl_SubscriberLoge_SubConnID] FOREIGN KEY ([SubConnID]) REFERENCES [dbo].[tbl_Subscribers] ([SubConnID])
);

