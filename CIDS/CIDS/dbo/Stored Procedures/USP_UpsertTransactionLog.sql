CREATE PROCEDURE [dbo].[USP_UpsertTransactionLog] 
@Action int, -- 1 = Insert , 2 = Update
@TrackID nvarchar(max) = NULL,
@IFaceBatchUIDxml xml = NULL,
@MsgType nvarchar(50) NULL,
@PubID int = NULL,
@SubID int = NULL,
@LogStatus nvarchar(max) = NULL,
@StartMsg nvarchar(max) = NULL,
@EndMsg nvarchar(max) = NULL,
@ArchiveXMLPath nvarchar(max) = NULL,
@RecordCount int = NULL,
@StageName nvarchar(500) = NULL,
@ProcessName nvarchar(500) = NULL,
@ProcessType nvarchar(500) = NULL,
@ErrorLogID int = NULL,
@StartTime datetime = NULL,
@EndTime datetime = NULL,
@CreatedBy nvarchar(100) = NULL,
@IsResubmitted bit = NULL,
@Description nvarchar(max) = NULL,
@SubConnID int = NULL,
@PubConnID int = NULL,
@IsArchive int = null,
@ArchMsgLength INT OUTPUT,
@TransformedMessage NVARCHAR(MAX) = NULL
AS

BEGIN TRY

	DECLARE @XmlData XML;

	IF ( @Action = 1 )
	BEGIN

		INSERT INTO [dbo].[tbl_TransactionLog]
				   (
						[TrackID]
					   ,[IFaceBatchUIDXml]
					   ,[MsgType]
					   ,[PubID]
					   ,[SubID]
					   ,[LogStatus]
					   ,[StartMsg]
					   ,[EndMsg]
					   ,[ArchiveXMLPath]
					   ,[RecordCount]
					   ,[StageName]
					   ,[ProcessName]
					   ,[ProcessType]
					   ,[StartTime]
					   ,[EndTime]
					   ,[CreatedBy]
					   ,[IsResubmitted]
					   ,[Description]
					   ,[SubConnID]
					   ,[PubConnID]
				   )
			 VALUES
				   (
					   CAST(@TrackID AS uniqueidentifier)
					   ,@IFaceBatchUIDxml
					   ,@MsgType
					   ,@PubID
					   ,@SubID
					   ,@LogStatus
					   ,@StartMsg
					   ,@EndMsg
					   ,@ArchiveXMLPath
					   ,@RecordCount
					   ,@StageName
					   ,@ProcessName
					   ,@ProcessType
					   ,GETDATE()
					   ,NULL
					   ,CURRENT_USER
					   ,@IsResubmitted
					   ,@Description
					   ,@SubConnID
					   ,@PubConnID
				   )

	END
	ELSE IF( @Action = 2 )
	BEGIN



		 IF (LEN(@TransformedMessage) > 0)
		 BEGIN
				IF ( @IsArchive = 1 AND LEN(@TransformedMessage) < 2000000)
				BEGIN

	 				UPDATE [dbo].tbl_TransactionLog
					SET  [TransformedMessage] = CAST( @TransformedMessage AS XML)
					WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

				END
				ELSE IF ( @IsArchive = 1 AND LEN(@TransformedMessage) > 2000000)
				BEGIN
					SET @ArchMsgLength =  LEN(@TransformedMessage)
				END

		 END
		 ELSE
		 BEGIN
		 			
				
				IF ( UPPER(RIGHT(@ArchiveXMLPath,3)) = 'XML' )
				BEGIN
					
					UPDATE [dbo].tbl_TransactionLog
					SET  ArchiveXMLPath = @ArchiveXMLPath
					WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

				END
				
				UPDATE [dbo].tbl_TransactionLog
				SET  EndTime = GETDATE(),
					 IFaceBatchUIDXml = cast(@IFaceBatchUIDxml as xml),
					 RecordCount = @RecordCount,
					 PubID = @PubID,
					 SubID = @SubID,
					 ErrorLogID = @ErrorLogID,
					 LogStatus = @LogStatus,
					 EndMsg = @EndMsg
				WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

		  END


	END


END TRY  
BEGIN CATCH 

	DECLARE @MSG NVARCHAR(500)
	SET @MSG = CASE WHEN @Action = 1 THEN  'inserting into' ELSE 'updating' END
	 
	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (PubID, SubID, PubConnID, SubConnID, IFaceBatchUID , ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( @PubID, @SubID, @PubConnID, @SubConnID, cast(@IFaceBatchUIDxml as nvarchar(max)) , 'USP_UpsertTransactionLog','StoredProcedure',@MsgType,'Error while '+@MSG+' tbl_TransactionLog table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH





