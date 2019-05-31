﻿CREATE TABLE [dbo].[tbl_IFace_CompletionDaily] (
    [TransID]               INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]              INT              NOT NULL,
    [IFaceBatchUID]         UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]            INT              NULL,
    [TranDate]              DATETIME         NULL,
    [TranMsg]               NVARCHAR (MAX)   NULL,
    [PubID]                 INT              NOT NULL,
    [PubConnID]             INT              NULL,
    [LastScaneDate]         DATE             NOT NULL,
    [API14]                 VARCHAR (14)     NOT NULL,
    [RunHours]              REAL             NULL,
    [IdleTime]              REAL             NULL,
    [CasingPressure]        REAL             NULL,
    [TubingPressure]        REAL             NULL,
    [TubingTemperature]     REAL             NULL,
    [FlowlineTemperature]   REAL             NULL,
    [MinLoad]               REAL             NULL,
    [MaxLoad]               REAL             NULL,
    [StrokesPerMinute]      REAL             NULL,
    [Cycles]                REAL             NULL,
    [StrokeLength]          REAL             NULL,
    [PlungerDiam]           REAL             NULL,
    [PumpDepth]             SMALLINT         NULL,
    [ZoneType]              NVARCHAR (50)    NULL,
    [YesterdaysFluidVolume] REAL             NULL,
    [CreatedTime]           DATETIME         NULL,
    [CreatedBy]             NVARCHAR (100)   CONSTRAINT [DF__tbl_IFace__Creat__7BE56230] DEFAULT (user_name()) NULL,
    [LastModifiedTime]      DATETIME         NULL,
    [LastModifiedBy]        NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_CompletionDaily] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

