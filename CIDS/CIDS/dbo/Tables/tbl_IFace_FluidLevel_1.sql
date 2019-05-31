﻿CREATE TABLE [dbo].[tbl_IFace_FluidLevel] (
    [TransID]          INT              IDENTITY (1, 1) NOT NULL,
    [TransSeq]         INT              NOT NULL,
    [IFaceBatchUID]    UNIQUEIDENTIFIER NOT NULL,
    [TranStatus]       INT              NULL,
    [TranDate]         DATETIME         NULL,
    [TranMsg]          NVARCHAR (MAX)   NULL,
    [PubID]            INT              NOT NULL,
    [WELUWINTID]       VARCHAR (50)     NOT NULL,
    [FLDATE]           VARCHAR (8)      NULL,
    [FLCMNT]           VARCHAR (300)    NULL,
    [FLFAP]            FLOAT (53)       NULL,
    [FLFLVLFS]         FLOAT (53)       NULL,
    [FLVLCP]           FLOAT (53)       NULL,
    [FLVLTP]           FLOAT (53)       NULL,
    [GSFLIQ]           FLOAT (53)       NULL,
    [PDPTH]            FLOAT (53)       NULL,
    [CreatedTime]      DATETIME         NULL,
    [CreatedBy]        NVARCHAR (100)   DEFAULT (user_name()) NULL,
    [PubConnID]        INT              NULL,
    [LastModifiedTime] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (200)   NULL,
    CONSTRAINT [PK_tbl_IFace_FluidLevel] PRIMARY KEY CLUSTERED ([TransID] ASC, [TransSeq] ASC)
);

