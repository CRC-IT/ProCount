CREATE TABLE [dbo].[tbl_PublisherController] (
    [PubID]               INT            IDENTITY (1, 1) NOT NULL,
    [PublisherName]       NVARCHAR (100) NOT NULL,
    [MsgType]             NVARCHAR (100) NOT NULL,
    [ConnType]            NVARCHAR (100) NOT NULL,
    [IsEnabled]           BIT            NOT NULL,
    [CriticalPickupTimes] NVARCHAR (100) NULL,
    [ExcludeDays]         NVARCHAR (100) NULL,
    [LastRunTime]         DATETIME       NULL,
    [LastRunStatus]       DATETIME       NULL,
    [ForceExecute]        BIT            NULL,
    [LastModifiedTime]    DATETIME       NULL,
    [LastModifiedBy]      NVARCHAR (100) NULL,
    [Description]         NVARCHAR (MAX) NULL,
    [PickupIntervalInMin] VARCHAR (50)   NULL,
    [PubConnID]           INT            NULL,
    CONSTRAINT [PK_tbl_PublisherController] PRIMARY KEY CLUSTERED ([PubID] ASC),
    CONSTRAINT [FK_tbl_PublisherController] FOREIGN KEY ([PubConnID]) REFERENCES [dbo].[tbl_Publishers] ([PubConnID])
);

