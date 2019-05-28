CREATE TABLE [dbo].[tbl_SubscriberController] (
    [SubID]               INT            IDENTITY (1, 1) NOT NULL,
    [SubscriberName]      NVARCHAR (100) NOT NULL,
    [SubIFace]            NVARCHAR (100) NOT NULL,
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
    [PickupIntervalInMin] INT            NULL,
    [SubConnID]           INT            NULL,
    CONSTRAINT [PK_tbl_SubscriberController] PRIMARY KEY CLUSTERED ([SubID] ASC),
    CONSTRAINT [FK_tbl_SubscriberController] FOREIGN KEY ([SubConnID]) REFERENCES [dbo].[tbl_Subscribers] ([SubConnID])
);

