CREATE TABLE [dbo].[tbl_IFace_MeterData] (
    [TransID]                   INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]                  INT              NOT NULL,
    [IFaceBatchUID]             UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]                INT              NULL,
    [TranDate]                  DATETIME         NULL,
    [TranMsg]                   NVARCHAR (MAX)   NULL,
    [PubID]                     INT              NOT NULL,
    [MeterID]                   NVARCHAR (16)    NULL,
    [RecordDate]                DATETIME         NULL,
    [MeterTemperature]          REAL             NULL,
    [MeterVolumePreviousDay]    REAL             NULL,
    [MeterFlowHours]            INT              NULL,
    [MeterPressureStatic]       REAL             NULL,
    [MeterPressureDifferential] REAL             NULL,
    [Energy]                    REAL             NULL,
    [CreatedTime]               DATETIME         NULL,
    [CreatedBy]                 NVARCHAR (100)   DEFAULT (user_name()) NULL,
    [PubConnID]                 INT              NULL,
    [LastModifiedTime]          DATETIME         NULL,
    [LastModifiedBy]            NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_MeterData] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

