










CREATE PROCEDURE [dbo].[USP_GLT_BusinessRules] 
	@Destination nvarchar(500),
	@ErrorLogId INT OUTPUT
AS
BEGIN TRY

	DECLARE @COUNT INT = 0
	DECLARE @RETURNVALUE INT = 1
	DECLARE @TBL_ERRORS TABLE ( ID INT identity(1,1), BusinessRule NVARCHAR(500), ErrorMsg NVARCHAR(500), RecordCount INT )
	DECLARE @XmlData XML;
       


	IF ( UPPER(@Destination) = 'ONECALPS' ) 
	BEGIN

		-- START - BUSINESS RULE 2 - Last_Entity_Name must not be longer than 200 characters

			SELECT @COUNT = COUNT(*)
			FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD  on  TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
			WHERE TMQ.SubIFace = 'GasLoaderTrans' AND TSC.SubscriberName = 'ONECALPS'	
			AND ((TICD.Agr_Det_Sequence = ' ' OR TICD.Agr_Det_Sequence IS NULL) 
			OR (TICD.rc_user_key IS NULL OR TICD.rc_user_key = ' ') 
			OR (TICD.processing_party IS NULL OR TICD.processing_party = ' ')
			OR (TICD.Agreement_ID IS NULL OR TICD.Agreement_ID = ' '))


			IF @COUNT > 1
			BEGIN


				INSERT INTO [dbo].[tbl_ErrorQueue] ([IFaceBatchUID] ,[PubID] ,[SubID] ,[PubConnID], [SubConnID],[TransID] ,[TransSeq] ,[SubIFace], [ErrorTime] , [ErrorMsg] ,[IsResubmit],[IsBussRuleFail] ,[CreatedTime] ,[CreatedBy])
				SELECT 	TMQ.IFaceBatchUID AS IFaceBatchUID, TMQ.PubID, TMQ.SubID,tmq.PubConnID, TMQ.SubConnID, TMQ.TransID, TMQ.TransSeq, TMQ.SubIFace, GETDATE() AS [ErrorTime],
				'Agr_Det_Sequence OR rc_user_key OR processing_party OR Agreement_ID could be null or empty' AS [ErrorMsg], 0 AS [IsResubmit], 1 AS [IsBussRuleFail], GETDATE() AS [CreatedTime], CURRENT_USER AS [CreatedBy]
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD	ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
				WHERE TMQ.SubIFace = 'GasLoaderTrans' AND TSC.SubscriberName = 'ONECALPS'	
				AND ((TICD.Agr_Det_Sequence = ' ' OR TICD.Agr_Det_Sequence IS NULL) 
				OR (TICD.rc_user_key IS NULL OR TICD.rc_user_key = ' ') 
				OR (TICD.processing_party IS NULL OR TICD.processing_party = ' ')
				OR (TICD.Agreement_ID IS NULL OR TICD.Agreement_ID = ' '))

				
				INSERT INTO @TBL_ERRORS
				SELECT 'Agr_Det_Sequence OR rc_user_key OR processing_party OR Agreement_ID could be null or empty','Agr_Det_Sequence OR rc_user_key OR processing_party OR Agreement_ID could be null or empty',@COUNT


			END
			ELSE IF (@COUNT = 0)
			BEGIN


				SELECT @COUNT = COUNT(*)
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD	ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
				WHERE TMQ.SubIFace = 'GasLoaderTrans' AND TSC.SubscriberName = 'ONECALPS'	--AND TICD.RunHours  between 0 and 24

				IF @COUNT > 0
					SET @RETURNVALUE = @RETURNVALUE + 1
				ELSE
					SET @RETURNVALUE = 0	



			END

		-- END - BUSINESS RULE 2 - Comments must not be longer than 200 characters

	


		-- START - BUSINESS RULE 3 - Producing Status Check



		-- END - BUSINESS RULE 3 - Producing Status Check




	END


	--INSERT ERROR XML MESSAGE IN ERROR LOG TABLE WHEN ERROS FOUND IN BUSINESS RULES VALIDATIONS
	IF EXISTS ( SELECT * FROM @TBL_ERRORS )
	BEGIN

		SET @XmlData =
		(
			SELECT 
			BusinessRule AS 'BusinessRule',
			ErrorMsg AS 'ErrorMsg', 
			RecordCount AS 'RecordCount'
			FROM @TBL_ERRORS 
			FOR XML PATH ('ErrorMessage'), ROOT('BR_GLT_ERRORS')
		)

		INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg ,FormattedMsg, ErrorTime, MachineName, CreatedBy) 
		VALUES ( 'USP_GLT_BusinessRules','StoredProcedure','GasLoaderTrans', @Destination + ' BusinessRule Validations','Error while executing the BusinessRules on GasLoaderTrans Data', @XmlData, GETDATE(),HOST_NAME(), CURRENT_USER)


	END

	--RETURN VALUE
	SELECT @RETURNVALUE

END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_GLT_BusinessRules','StoredProcedure','GasLoaderTrans','Error while executing the BusinessRules on GasLoaderTrans Data',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH
