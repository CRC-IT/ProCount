CREATE PROCEDURE [dbo].[USP_UpsertSubscriberLog] 
@Action INT = NULL -- 1 = Insert , 2 = Update
,@TrackID NVARCHAR(MAX) = NULL
,@ProcessName NVARCHAR(MAX) = NULL
,@SubIFace NVARCHAR(50) = NULL
,@QInStatus NVARCHAR(100) = NULL
,@StartMsg NVARCHAR(MAX) = NULL
,@EndMsg NVARCHAR(MAX) = NULL
,@RecordCount INT = NULL
,@Description NVARCHAR(MAX) = NULL
,@IFaceBatchUIDXml NVARCHAR(MAX) = NULL
,@SubID INT = NULL
AS

BEGIN TRY

   DECLARE @SUBCONNID AS INT 
	IF ( @Action = 1 )
	BEGIN

		SELECT @SUBCONNID = SubConnID FROM [dbo].[tbl_SubscriberController] WHERE SubID = @SubID


		INSERT INTO [dbo].[tbl_SubscriberLog]
		(
			[TrackID]
			,[SubID]
			,[ProcessName]
			,[MsgType]
			,[QInStartTime]
			,[StartMsg]
			,[SubConnID]
		)
		VALUES
		(
			 CAST(@TrackID AS uniqueidentifier)
			,@SubID
			,@ProcessName
			,@SubIFace
			,GETDATE()
			,@StartMsg 
			,@SUBCONNID
		)

	END
	ELSE IF( @Action = 2 )
	BEGIN
			UPDATE [dbo].[tbl_SubscriberLog]
			SET  [QInEndTime] = GETDATE()
				,[EndMsg] = @EndMsg
				,[QInStatus] = @QInStatus
				,[RecordCount] = @RecordCount
				,[IFaceBatchUIDS] = CAST(@IFaceBatchUIDXml AS xml)
			WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

	END
	ELSE IF( @Action = 3 )
	BEGIN
			DELETE FROM [dbo].[tbl_SubscriberLog]
			WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

	END


END TRY  
BEGIN CATCH 

	DECLARE @MSG NVARCHAR(500)
	SET @MSG = CASE WHEN @Action = 1 THEN  'inserting into' ELSE 'updating' END


	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (SubID, SubConnID, IFaceBatchUID , ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( @SubID, @SubConnID, @IFaceBatchUIDXml , 'USP_UpsertSubscriberLog','StoredProcedure',@SubIFace,'Error while '+@MSG+' tbl_SubscriberLog table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)


END CATCH

