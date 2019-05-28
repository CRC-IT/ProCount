CREATE TABLE [dbo].[tbl_TranStatusDetails] (
    [StatusID]          INT            IDENTITY (1, 1) NOT NULL,
    [TranStatus]        INT            NULL,
    [StatusDescription] NVARCHAR (200) NULL,
    [Description]       NVARCHAR (MAX) NULL
);

