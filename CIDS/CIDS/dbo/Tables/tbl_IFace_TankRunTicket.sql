﻿CREATE TABLE [dbo].[tbl_IFace_TankRunTicket] (
    [TransID]                       INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]                      INT              NOT NULL,
    [IFaceBatchUID]                 UNIQUEIDENTIFIER NULL,
    [TranStatus]                    INT              NULL,
    [TransDate]                     DATETIME         NULL,
    [PubID]                         INT              NULL,
    [PubConnID]                     INT              NULL,
    [ProductionDate]                DATETIME         NULL,
    [MerrickID]                     INT              NULL,
    [RecordDate]                    DATETIME         NULL,
    [RunTicketDate]                 DATETIME         NULL,
    [RunTicketNumber]               VARCHAR (22)     NULL,
    [eurc]                          INT              NULL,
    [SourceType]                    INT              NULL,
    [Purchaser]                     INT              NULL,
    [ProductType]                   VARCHAR (50)     NULL,
    [convertedgravity]              FLOAT (53)       NULL,
    [GrossBarrels]                  FLOAT (53)       NULL,
    [AllocActGravity]               FLOAT (53)       NULL,
    [LocationID]                    VARCHAR (20)     NULL,
    [LocAccountNumber1]             VARCHAR (14)     NULL,
    [LocAccountNumber2]             VARCHAR (14)     NULL,
    [AreaID]                        VARCHAR (15)     NULL,
    [AreaName]                      VARCHAR (50)     NULL,
    [COMPMID]                       INT              NULL,
    [UserName]                      VARCHAR (25)     NULL,
    [CreatedTime]                   DATETIME         NULL,
    [CreatedBy]                     VARCHAR (100)    DEFAULT (user_name()) NULL,
    [LastModifiedTime]              DATETIME         NULL,
    [LastModifiedBy]                VARCHAR (200)    NULL,
    [Vol]                           FLOAT (53)       NULL,
    [BusinessEnitity]               VARCHAR (75)     NULL,
    [AllocationDateStamp]           DATETIME         NULL,
    [completionID]                  INT              NULL,
    [decktype]                      INT              NULL,
    [DispositionCode]               INT              NULL,
    [DispositionCodeDescription]    VARCHAR (50)     NULL,
    [GatheringSystemAccountantName] VARCHAR (100)    NULL,
    [GatheringSystemLockDate]       DATETIME         NULL,
    [GatheringSystemLockName]       VARCHAR (100)    NULL,
    [GatheringSystemName]           VARCHAR (50)     NULL,
    [WellPlusCompletionName]        VARCHAR (120)    NULL,
    [AccountantPersonID]            INT              NULL,
    [GatheringSystemID]             VARCHAR (40)     NULL,
    CONSTRAINT [PK_tbl_IFace_TankRunTicket] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IDX_ranStatus]
    ON [dbo].[tbl_IFace_TankRunTicket]([TranStatus] ASC)
    INCLUDE([PubID], [PubConnID], [TransID], [TransSeq], [IFaceBatchUID]);

