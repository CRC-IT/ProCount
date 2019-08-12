﻿CREATE TABLE [dbo].[tbl_IFace_DownTime] (
    [TransID]          INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]       INT              NULL,
    [TranDate]         DATETIME         NULL,
    [TranMsg]          NVARCHAR (MAX)   NULL,
    [PubID]            INT              NOT NULL,
    [PubConnID]        INT              NULL,
    [DowntimeDate]     DATE             NOT NULL,
    [API14]            VARCHAR (50)     NOT NULL,
    [DisableCode]      NCHAR (10)       NULL,
    [DowntimeHours]    SMALLINT         NULL,
    [OutOfServiceDate] DATETIME         NULL,
    [InServiceDate]    DATETIME         NULL,
    [OutOfServiceTime] DATETIME         NULL,
    [InServiceTime]    DATETIME         NULL,
    [Note]             NVARCHAR (255)   NULL,
    [ResponseType]     NCHAR (30)       NULL,
    [RigStatus]        NCHAR (30)       NULL,
    [RigType]          NCHAR (30)       NULL,
    [CreatedTime]      DATETIME         NULL,
    [CreatedBy]        NVARCHAR (100)   CONSTRAINT [DF__tbl_IFace__Creat__7EC1CEDB] DEFAULT (user_name()) NULL,
    [LastModifiedTime] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_DownTime] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_IFaceBatchUID]
    ON [dbo].[tbl_IFace_DownTime]([IFaceBatchUID] ASC)
    INCLUDE([TransID], [TransSeq], [DowntimeDate], [API14], [DisableCode], [DowntimeHours], [OutOfServiceDate], [InServiceDate], [OutOfServiceTime], [InServiceTime], [Note], [ResponseType], [RigStatus], [RigType]);


GO
CREATE NONCLUSTERED INDEX [IDX_TranStatus]
    ON [dbo].[tbl_IFace_DownTime]([TranStatus] ASC)
    INCLUDE([PubID], [PubConnID], [TransID], [TransSeq], [IFaceBatchUID]);


GO
CREATE NONCLUSTERED INDEX [IDX_DowntimeHours]
    ON [dbo].[tbl_IFace_DownTime]([DowntimeHours] ASC)
    INCLUDE([TransID], [TransSeq], [IFaceBatchUID]);

