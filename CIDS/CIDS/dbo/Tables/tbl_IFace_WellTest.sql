CREATE TABLE [dbo].[tbl_IFace_WellTest] (
    [TransID]             INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]            INT              NOT NULL,
    [IFaceBatchUID]       UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]          INT              NULL,
    [TranDate]            DATETIME         NULL,
    [TranMsg]             NVARCHAR (MAX)   NULL,
    [PubID]               INT              NOT NULL,
    [API_NO14]            VARCHAR (50)     NOT NULL,
    [WELLCOMP_NAME]       NVARCHAR (50)    NOT NULL,
    [WELL_TEST_DATE]      DATE             NOT NULL,
    [SOURCE]              VARCHAR (5)      NOT NULL,
    [OIL_RATE]            NUMERIC (12, 2)  NULL,
    [GAS_RATE]            NUMERIC (12, 2)  NULL,
    [WATER_RATE]          NUMERIC (12, 2)  NULL,
    [GAS_LIFT_RATE]       NUMERIC (12, 2)  NULL,
    [GAS_OIL_RATIO]       NUMERIC (12, 2)  NULL,
    [TUBING_PRESS]        NUMERIC (12, 2)  NULL,
    [CASING_PRESS]        NUMERIC (12, 2)  NULL,
    [LINE_PRESS]          NUMERIC (12, 2)  NULL,
    [WELLHEAD_TEMP]       NUMERIC (12, 2)  NULL,
    [ALLOCATABLE]         INT              NOT NULL,
    [OIL_GRAVITY]         NUMERIC (12, 2)  NULL,
    [CHOKE_SIZE]          NUMERIC (12, 2)  NULL,
    [PUMP_EFF]            NUMERIC (12, 2)  NULL,
    [WATER_CUT]           NUMERIC (12, 2)  NULL,
    [STROKE_LENGTH]       NUMERIC (12, 2)  NULL,
    [STROKES_MINUTE]      NUMERIC (12, 2)  NULL,
    [PUMP_BORE_SIZE]      NUMERIC (12, 2)  NULL,
    [PROD_HOURS]          NUMERIC (12, 2)  NULL,
    [TEST_HOURS]          NUMERIC (12, 2)  NULL,
    [LOW_PRESS_GAS_RATE]  NUMERIC (12, 2)  NULL,
    [HIGH_PRESS_GAS_RATE] NUMERIC (12, 2)  NULL,
    [CASING_GAS_RATE]     NUMERIC (12, 2)  NULL,
    [HERTZ]               NUMERIC (12, 2)  NULL,
    [AMPS]                NUMERIC (12, 2)  NULL,
    [SALINITY]            NUMERIC (12, 2)  NULL,
    [FLUID_LEVEL]         NUMERIC (12, 2)  NULL,
    [PUMP_INTAKE_PRESS]   NUMERIC (12, 2)  NULL,
    [COMMENTS]            NVARCHAR (255)   NULL,
    [PBH_PRESS]           NUMERIC (12, 2)  NULL,
    [BSW]                 NUMERIC (12, 2)  NULL,
    [GRAV_GAS]            NUMERIC (12, 2)  NULL,
    [SEP_PRESS]           NUMERIC (12, 2)  NULL,
    [TOTAL_GAS_PROD]      NUMERIC (12, 2)  NULL,
    [CreatedTime]         DATETIME         NULL,
    [CreatedBy]           NVARCHAR (100)   NULL,
    [PubConnID]           INT              NULL,
    [LastModifiedTime]    DATETIME         NULL,
    [LastModifiedBy]      NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_WellTest] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_TranStatus]
    ON [dbo].[tbl_IFace_WellTest]([TranStatus] ASC)
    INCLUDE([IFaceBatchUID]);


GO
CREATE NONCLUSTERED INDEX [IDX_IFaceBatchUID]
    ON [dbo].[tbl_IFace_WellTest]([IFaceBatchUID] ASC)
    INCLUDE([TransID], [TransSeq], [API_NO14], [WELL_TEST_DATE], [OIL_RATE], [GAS_RATE], [WATER_RATE], [GAS_LIFT_RATE], [GAS_OIL_RATIO], [TUBING_PRESS], [CASING_PRESS], [LINE_PRESS], [WELLHEAD_TEMP], [OIL_GRAVITY], [CHOKE_SIZE], [PUMP_EFF], [WATER_CUT], [STROKE_LENGTH], [STROKES_MINUTE], [PUMP_BORE_SIZE], [FLUID_LEVEL], [COMMENTS], [PBH_PRESS], [BSW], [GRAV_GAS], [SEP_PRESS], [TOTAL_GAS_PROD]);

