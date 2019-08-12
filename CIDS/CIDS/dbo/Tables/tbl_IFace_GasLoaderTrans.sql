CREATE TABLE [dbo].[tbl_IFace_GasLoaderTrans] (
    [TransID]                       INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]                      INT              NOT NULL,
    [IFaceBatchUID]                 UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]                    INT              NULL,
    [TranDate]                      DATETIME         NULL,
    [TranMsg]                       NVARCHAR (MAX)   NULL,
    [PubID]                         INT              NOT NULL,
    [PubConnID]                     INT              NULL,
    [trans_copy]                    VARCHAR (10)     NULL,
    [RecordDate]                    DATETIME         NULL,
    [AllocActGravity]               FLOAT (53)       NULL,
    [UserName]                      VARCHAR (25)     NULL,
    [CreatedTime]                   DATETIME         NULL,
    [CreatedBy]                     NVARCHAR (100)   NULL,
    [LastModifiedTime]              DATETIME         NULL,
    [LastModifiedBy]                NVARCHAR (200)   NULL,
    [ProductType]                   VARCHAR (50)     NULL,
    [DispositionCode]               INT              NULL,
    [DispositionCodeDescription]    VARCHAR (50)     NULL,
    [Sourcetype]                    INT              NULL,
    [CompletionID]                  INT              NULL,
    [GatheringSystemID]             FLOAT (53)       NULL,
    [AreaID]                        VARCHAR (15)     NULL,
    [AreaName]                      VARCHAR (50)     NULL,
    [GatheringSystemName]           VARCHAR (40)     NULL,
    [activity_date]                 DATETIME         NULL,
    [BBL]                           FLOAT (53)       NULL,
    [GAL]                           FLOAT (53)       NULL,
    [MCF]                           FLOAT (53)       NULL,
    [MMBTU]                         FLOAT (53)       NULL,
    [BTU_content]                   FLOAT (53)       NULL,
    [BTU_pressure_base]             FLOAT (53)       NULL,
    [BTU_wet_dry_ind]               INT              NULL,
    [WellPlusCompletionName]        VARCHAR (120)    NULL,
    [processing_party]              VARCHAR (60)     NULL,
    [rc_user_key]                   VARCHAR (20)     NULL,
    [Agr_Det_Sequence]              VARCHAR (15)     NULL,
    [Agreement_ID]                  VARCHAR (15)     NULL,
    [decktype]                      INT              NULL,
    [AllocationDateStamp]           DATETIME         NULL,
    [AccountantPersonID]            INT              NULL,
    [GatheringSystemLockDate]       DATETIME         NULL,
    [GatheringSystemLockName]       VARCHAR (100)    NULL,
    [GatheringSystemAccountantName] VARCHAR (100)    NULL,
    CONSTRAINT [PK_[tbl_IFace_GasLoaderTrans] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IDX_TranStatus]
    ON [dbo].[tbl_IFace_GasLoaderTrans]([TranStatus] ASC)
    INCLUDE([TransID], [TransSeq], [IFaceBatchUID], [PubID], [PubConnID]);


GO
CREATE NONCLUSTERED INDEX [IDX_IFaceBatchUID]
    ON [dbo].[tbl_IFace_GasLoaderTrans]([IFaceBatchUID] ASC)
    INCLUDE([TransID], [TransSeq], [trans_copy], [AllocActGravity], [CreatedTime], [ProductType], [DispositionCode], [DispositionCodeDescription], [Sourcetype], [CompletionID], [GatheringSystemID], [AreaID], [AreaName], [GatheringSystemName], [activity_date], [BBL], [GAL], [MCF], [MMBTU], [BTU_content], [BTU_pressure_base], [BTU_wet_dry_ind], [WellPlusCompletionName], [processing_party], [rc_user_key], [Agr_Det_Sequence], [Agreement_ID], [decktype], [AllocationDateStamp], [AccountantPersonID], [GatheringSystemLockDate], [GatheringSystemLockName], [GatheringSystemAccountantName]);

