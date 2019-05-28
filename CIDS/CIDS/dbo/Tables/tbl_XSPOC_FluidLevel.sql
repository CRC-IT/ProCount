CREATE TABLE [dbo].[tbl_XSPOC_FluidLevel] (
    [FLID]        INT            IDENTITY (1, 1) NOT NULL,
    [FLDATE]      VARCHAR (8)    NULL,
    [FLCMNT]      VARCHAR (300)  NULL,
    [FLFAP]       FLOAT (53)     NULL,
    [FLFLVLFS]    FLOAT (53)     NULL,
    [FLVLCP]      FLOAT (53)     NULL,
    [FLVLTP]      FLOAT (53)     NULL,
    [GSFLIQ]      FLOAT (53)     NULL,
    [PDPTH]       FLOAT (53)     NULL,
    [CreatedTime] DATETIME       NULL,
    [CreatedBy]   NVARCHAR (100) NULL,
    [WELUWINTID]  VARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_tbl_XSPOC_FluidLevel] PRIMARY KEY CLUSTERED ([FLID] ASC)
);

