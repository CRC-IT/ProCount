﻿CREATE TABLE [CALNET\edwardsm].[Load Iface Runtime ticket] (
    [trans_copy]             VARCHAR (1)      NULL,
    [completionID]           INT              NULL,
    [WellPlusCompletionName] VARCHAR (120)    NULL,
    [areaname]               VARCHAR (50)     NULL,
    [activity_date]          DATETIME         NULL,
    [gravity]                FLOAT (53)       NULL,
    [BBL]                    FLOAT (53)       NULL,
    [GAL]                    FLOAT (53)       NULL,
    [MCF]                    FLOAT (53)       NULL,
    [BTU_content]            FLOAT (53)       NULL,
    [BTU_pressure_base]      FLOAT (53)       NULL,
    [BTU_wet_dry_ind]        INT              NULL,
    [processing_party]       VARCHAR (60)     NULL,
    [rc_user_key]            VARCHAR (20)     NULL,
    [Arg_Det_Sequence]       VARCHAR (14)     NULL,
    [Agreement_ID]           VARCHAR (14)     NULL,
    [decktype]               INT              NULL,
    [CreatedDate]            DATETIME         NULL,
    [TransDate]              DATETIME         NULL,
    [PubID]                  INT              NULL,
    [TransSeq]               INT              NULL,
    [BatchUID]               UNIQUEIDENTIFIER NULL,
    [TranStatus]             INT              NULL,
    [PubConnID]              INT              NULL
);

