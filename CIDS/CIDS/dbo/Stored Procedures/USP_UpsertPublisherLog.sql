CREATE PROCEDURE [dbo].[USP_UpsertPublisherLog] 
@Action INT = NULL -- 1 = Insert , 2 = Update
,@TrackID NVARCHAR(MAX) = NULL
,@PublisherName NVARCHAR(100)
,@ProcessName NVARCHAR(MAX) = NULL
,@MsgType NVARCHAR(50)
,@ConnType NVARCHAR(100) = NULL
,@PubStatus NVARCHAR(50) = NULL
,@StartMsg NVARCHAR(MAX) = NULL
,@EndMsg NVARCHAR(MAX) = NULL
,@FormattedMessage NVARCHAR(MAX) = NULL
,@RecordCount INT = NULL
,@Description NVARCHAR(MAX) = NULL
,@IFaceBatchUID NVARCHAR(MAX) = NULL
,@PubID INT OUTPUT
,@PubConnID INT OUTPUT
,@IsArchive INT = NULL
,@ArchMsgLength INT OUTPUT
,@ArchXMLPath  NVARCHAR(MAX) = NULL
AS

BEGIN TRY

	DECLARE @XmlData XML;


	IF ( @Action = 1 )
	BEGIN

		SELECT @PubID = PubID, @PubConnID = PubConnID FROM [dbo].[tbl_PublisherController] 
		WHERE PublisherName = @PublisherName AND MsgType = @MsgType AND ConnType = @ConnType


		INSERT INTO [dbo].[tbl_PublisherLog]
		(
			[TrackID]
			,[PubID]
			,[ProcessName]
			,[MsgType]
			,[PubStartTime]
			,[StartMsg]
			,[PubConnID]
		)
		VALUES
		(
			 CAST(@TrackID AS uniqueidentifier)
			,@PubID
			,@ProcessName
			,@MsgType
			,GETDATE()
			,@StartMsg 
			,@PubConnID
		)

	END
	ELSE IF( @Action = 2 )
	BEGIN

		 IF (LEN(@FormattedMessage) > 0)
		 BEGIN
				IF ( @IsArchive = 1 AND LEN(@FormattedMessage) < 2000000)
				BEGIN

	 				UPDATE [dbo].[tbl_PublisherLog]
					SET  FormattedMessage = CAST( @FormattedMessage AS XML)
					WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

				END
				ELSE IF ( @IsArchive = 1 AND LEN(@FormattedMessage) > 2000000)
				BEGIN
					SET @ArchMsgLength =  LEN(@FormattedMessage)
				END

		 END
		 ELSE
		 BEGIN
		 			
				
				IF ( UPPER(RIGHT(@ArchXMLPath,3)) = 'XML' )
				BEGIN
					
					UPDATE [dbo].[tbl_PublisherLog]
					SET  [ArchiveXMLPath] = @ArchXMLPath
					WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

				END
				
				UPDATE [dbo].[tbl_PublisherLog]
				SET  [PubEndTime] = GETDATE()
					,[EndMsg] = @EndMsg
					,[PubStatus] = @PubStatus
					,[RecordCount] = @RecordCount
					,[IFaceBatchUID] = CAST(@IFaceBatchUID AS uniqueidentifier)					
				WHERE [TrackID] = CAST(@TrackID AS uniqueidentifier)

		  END

	END


END TRY  
BEGIN CATCH 

	DECLARE @MSG NVARCHAR(500)
	SET @MSG = CASE WHEN @Action = 1 THEN  'inserting into' ELSE 'updating' END

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (PubID, PubConnID, IFaceBatchUID , ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( @PubID, @PubConnID, @IFaceBatchUID , 'USP_UpsertPublisherLog','StoredProcedure',@MsgType,'Error while '+@MSG+' tbl_PublisherLog table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)


END CATCH





