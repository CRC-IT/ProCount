CREATE PROCEDURE [dbo].[USP_UpsertErrorLog]
@Action int,
@IFaceBatchUID nvarchar(max) NULL,
@PubID int NULL,
@SubID int NULL,
@ProcessName nvarchar(500) NULL,
@ComponentName nvarchar(500) NULL,
@ProcessType nvarchar(500) NULL,
@MsgType nvarchar(50) NULL,
@Title nvarchar(max) NULL,
@ErrorRecCount int NULL,
@ErrorType nvarchar(50) NULL,
@ErrorNumber int NULL,
@ErrorSeverity nvarchar(50) NULL,
@ErrorMsg nvarchar(max) NULL,
@IsReprocess bit NULL,
@ErrorStatus nvarchar(50) NULL,
@MachineName nvarchar(50) NULL,
@FormattedMsg xml NULL,
@ErrorTime datetime NULL,
@CreatedBy nvarchar(100) NULL,
@Description nvarchar(max) NULL,
@SubConnID int NULL,
@PubConnID int NULL,
@ConnType nvarchar(100) NULL
AS
BEGIN TRY


	INSERT INTO [dbo].[tbl_ErrorLog]
           (
			   [IFaceBatchUID]
			   ,[PubID]
			   ,[SubID]
			   ,[ProcessName]
			   ,[ComponentName]
			   ,[ProcessType]
			   ,[MsgType]
			   ,[Title]
			   ,[ErrorRecCount]
			   ,[ErrorType]
			   ,[ErrorNumber]
			   ,[ErrorSeverity]
			   ,[ErrorMsg]
			   ,[IsReprocess]
			   ,[ErrorStatus]
			   ,[MachineName]
			   ,[FormattedMsg]
			   ,[ErrorTime]
			   ,[CreatedBy]
			   ,[Description]
			   ,[SubConnID]
			   ,[PubConnID]
			   ,[ConnType]
		   )
     VALUES
           (
				@IFaceBatchUID,
				@PubID,
				@SubID,
				@ProcessName,
				@ComponentName,
				@ProcessType,
				@MsgType,
				@Title,
				@ErrorRecCount,
				@ErrorType,
				@ErrorNumber,
				@ErrorSeverity,
				@ErrorMsg,
				@IsReprocess,
				@ErrorStatus,
				@MachineName,
				@FormattedMsg,
				@ErrorTime,
				@CreatedBy,
				@Description,
				@SubConnID,
				@PubConnID,
				@ConnType
		   )



END TRY  
BEGIN CATCH 

	INSERT INTO [dbo].[tbl_ErrorLog]
           (
			   [IFaceBatchUID]
			   ,[PubID]
			   ,[SubID]
			   ,[ProcessName]
			   ,[ComponentName]
			   ,[ProcessType]
			   ,[MsgType]
			   ,[Title]
			   ,[ErrorRecCount]
			   ,[ErrorType]
			   ,[ErrorNumber]
			   ,[ErrorSeverity]
			   ,[ErrorMsg]
			   ,[IsReprocess]
			   ,[ErrorStatus]
			   ,[MachineName]
			   ,[FormattedMsg]
			   ,[ErrorTime]
			   ,[CreatedBy]
			   ,[Description]
			   ,[SubConnID]
			   ,[PubConnID]
			   ,[ConnType]
		   )
     VALUES
           (
				@IFaceBatchUID,
				@PubID,
				@SubID,
				'USP_UpsertErrorLog',
				@ComponentName,
				'StoredProcedure',
				@MsgType,
				'Error while insert records into tbl_ErrorLog table',
				@ErrorRecCount,
				@ErrorType,
				ERROR_NUMBER(),
				ERROR_SEVERITY(),
				ERROR_MESSAGE(),
				@IsReprocess,
				@ErrorStatus,
				HOST_NAME(),
				@FormattedMsg,
				GETDATE(),
				CURRENT_USER,
				@Description,
				@SubConnID,
				@PubConnID,
				@ConnType
		   )

END CATCH

