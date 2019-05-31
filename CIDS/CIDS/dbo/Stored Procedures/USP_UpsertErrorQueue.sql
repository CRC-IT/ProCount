CREATE PROCEDURE [dbo].[USP_UpsertErrorQueue]
@IFaceBatchUID nvarchar(max) = NULL,
@PubID int = NULL,
@SubID int = NULL,
@TransID int = NULL,
@TransSeq int = NULL,
@SubIFace nvarchar(100) = NULL,
@ErrorTime datetime = NULL,
@ErrorSeverity nvarchar(50) = NULL,
@ErrorMsg nvarchar(1000) = NULL,
@IsResubmit int = NULL,
@Description nvarchar(max) = NULL,
@SubConnID int = NULL,
@PubConnID int = NULL,
@ErrorCode int = NULL,
@ErrorColumn int = NULL
AS
BEGIN TRY

	IF NOT EXISTS 
	(
		SELECT 1 FROM [dbo].[tbl_ErrorQueue] ERRQ
		WHERE ERRQ.IFaceBatchUID = @IFaceBatchUID AND ERRQ.TransID = @TransID
		AND ERRQ.TransSeq = @TransSeq AND ERRQ.PubID = @PubID
	)
	BEGIN

		INSERT INTO [dbo].[tbl_ErrorQueue]
			   ([IFaceBatchUID]
			   ,[PubID]
			   ,[SubID]
			   ,[TransID]
			   ,[TransSeq]
			   ,[SubIFace]
			   ,[ErrorTime]
			   ,[ErrorSeverity]
			   ,[ErrorMsg]
			   ,[IsResubmit]
			   ,[CreatedTime]
			   ,[CreatedBy]
			   ,[Description]
			   ,[SubConnID]
			   ,[PubConnID]
			   ,[ErrorCode]
			   ,[ErrorColumn]
				)
		 VALUES
			   (
					@IFaceBatchUID
				   ,@PubID
				   ,@SubID
				   ,@TransID
				   ,@TransSeq
				   ,@SubIFace
				   ,@ErrorTime
				   ,@ErrorSeverity
				   ,@ErrorMsg
				   ,@IsResubmit
				   ,GETDATE()
				   ,CURRENT_USER
				   ,@Description
				   ,@SubConnID
				   ,@PubConnID
				   ,@ErrorCode
				   ,@ErrorColumn
			   )

	END
	ELSE 
	BEGIN
		
		UPDATE ERRQ
		   SET [ErrorTime] = @ErrorTime
			  ,[ErrorMsg] = @ErrorMsg
			  ,[ErrorCode] = @ErrorCode
			  ,[ErrorColumn] = @ErrorColumn
			  ,[LastResubmitTime] = GETDATE()
			  ,[LastResubmitBy] = CURRENT_USER
			  ,[IsResubmit] = @IsResubmit
			   FROM [dbo].[tbl_ErrorQueue]  ERRQ
				WHERE ERRQ.IFaceBatchUID = @IFaceBatchUID AND ERRQ.TransID = @TransID
				AND ERRQ.TransSeq = @TransSeq AND ERRQ.PubID = @PubID
		
	END


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (PubID, SubID, PubConnID, SubConnID, IFaceBatchUID , ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( @PubID, @SubID, @PubConnID, @SubConnID, @IFaceBatchUID , 'USP_UpsertErrorQueue','StoredProcedure',@SubIFace,'Error while insert / updateing records into tbl_ErrorQueue table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH

