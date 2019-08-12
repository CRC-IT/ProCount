﻿CREATE TABLE [dbo].[tbl_IFace_InjectionData] (
    [TransID]                   INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]                  INT              NOT NULL,
    [IFaceBatchUID]             UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]                INT              NULL,
    [TranDate]                  DATETIME         NULL,
    [TranMsg]                   NVARCHAR (MAX)   NULL,
    [PubID]                     INT              NOT NULL,
    [API14]                     VARCHAR (14)     NOT NULL,
    [NodeID]                    NVARCHAR (50)    NULL,
    [RecordDate]                DATETIME         NOT NULL,
    [LineTemperature]           REAL             NULL,
    [YesterdayInjectionWater]   REAL             NULL,
    [YesterdayInjectionCO2]     REAL             NULL,
    [YesterdayInjectionSteam]   REAL             NULL,
    [YesterdayInjectionGas]     REAL             NULL,
    [InjectionRateSetpoint]     REAL             NULL,
    [InjectionPressure]         REAL             NULL,
    [InjectionPressureSetpoint] REAL             NULL,
    [CasingPressure]            REAL             NULL,
    [CasingPressureDailyHigh]   REAL             NULL,
    [CasingPressureDailyLow]    REAL             NULL,
    [SupplyPressure]            REAL             NULL,
    [CreatedTime]               DATETIME         NULL,
    [CreatedBy]                 NVARCHAR (100)   DEFAULT (user_name()) NULL,
    [PubConnID]                 INT              NULL,
    [LastModifiedTime]          DATETIME         NULL,
    [LastModifiedBy]            NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_InjectionData] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_TranStatus]
    ON [dbo].[tbl_IFace_InjectionData]([TranStatus] ASC)
    INCLUDE([PubID], [PubConnID], [TransID], [TransSeq], [IFaceBatchUID]);


GO
CREATE NONCLUSTERED INDEX [IDX_LastModifiedTime]
    ON [dbo].[tbl_IFace_InjectionData]([LastModifiedTime] ASC)
    INCLUDE([IFaceBatchUID]);

