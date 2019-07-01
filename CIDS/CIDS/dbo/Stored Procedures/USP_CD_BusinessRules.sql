




CREATE PROCEDURE [dbo].[USP_CD_BusinessRules] 
	@Destination nvarchar(500),
	@ErrorLogId INT OUTPUT
AS
BEGIN TRY

	DECLARE @COUNT INT = 0
	DECLARE @RETURNVALUE INT = 1
	DECLARE @TBL_ERRORS TABLE ( ID INT identity(1,1), BusinessRule NVARCHAR(500), ErrorMsg NVARCHAR(500), RecordCount INT )
	DECLARE @XmlData XML;
       


	IF ( UPPER(@Destination) = 'PROCOUNT' ) 
	BEGIN

		-- START - BUSINESS RULE 2 - Last_Entity_Name must not be longer than 200 characters

			SELECT @COUNT = COUNT(*)
			FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD  on  TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
			WHERE TMQ.SubIFace = 'CompletionDaily' AND TSC.SubscriberName = 'ProCount'	AND TICD.RunHours NOT between 0 and 24 AND ((CONVERT(NUMERIC(38,0),cast(TICD.CasingPressure AS FLOAT))  > 5000 OR CONVERT(NUMERIC(38,0),cast(TICD.CasingPressure AS FLOAT))  < -10) OR	(TICD.TubingPressure >= 5000 OR TICD.TubingPressure < -10))


			IF @COUNT > 1
			BEGIN


				INSERT INTO [dbo].[tbl_ErrorQueue] ([IFaceBatchUID] ,[PubID] ,[SubID] ,[TransID] ,[TransSeq] ,[SubIFace], [ErrorTime] , [ErrorMsg] ,[IsResubmit],[IsBussRuleFail] ,[CreatedTime] ,[CreatedBy])
				SELECT 	TMQ.IFaceBatchUID AS IFaceBatchUID, TMQ.PubID, TMQ.SubID, TMQ.TransID, TMQ.TransSeq, TMQ.SubIFace, GETDATE() AS [ErrorTime],
				'Runhours value is not in between 0 and 24 OR Casing Pressure is less than -10 or greater than 5000' AS [ErrorMsg], 0 AS [IsResubmit], 1 AS [IsBussRuleFail], GETDATE() AS [CreatedTime], CURRENT_USER AS [CreatedBy]
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD	ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
				WHERE TMQ.SubIFace = 'CompletionDaily' AND TSC.SubscriberName = 'ProCount'	AND TICD.RunHours NOT between 0 and 24 AND ((CONVERT(NUMERIC(38,0),cast(TICD.CasingPressure AS FLOAT))  > 5000 OR CONVERT(NUMERIC(38,0),cast(TICD.CasingPressure AS FLOAT))  < -10))

				INSERT INTO [dbo].[tbl_ErrorQueue] ([IFaceBatchUID] ,[PubID] ,[SubID] ,[TransID] ,[TransSeq] ,[SubIFace], [ErrorTime] , [ErrorMsg] ,[IsResubmit] ,[IsBussRuleFail],[CreatedTime] ,[CreatedBy])
				SELECT 	TMQ.IFaceBatchUID AS IFaceBatchUID, TMQ.PubID, TMQ.SubID, TMQ.TransID, TMQ.TransSeq, TMQ.SubIFace, GETDATE() AS [ErrorTime],
				'Runhours value is not in between 0 and 24 OR Tubing Pressure is less than -10 or greater than 5000' AS [ErrorMsg], 0 AS [IsResubmit], 1 AS [IsBussRuleFail], GETDATE() AS [CreatedTime], CURRENT_USER AS [CreatedBy]
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD	ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
				WHERE TMQ.SubIFace = 'CompletionDaily' AND TSC.SubscriberName = 'ProCount'	AND TICD.RunHours NOT between 0 and 24 AND 	(TICD.TubingPressure >= 5000 OR TICD.TubingPressure < -10)


				INSERT INTO @TBL_ERRORS
				SELECT 'Runhours value is not in between 0 and 24 OR Casing Pressure is less than -10 or greater than 5000 OR Tubing Pressure is less than -10 or greater than 5000','Runhours value is not in between 0 and 24 OR Casing Pressure is less than -10 or greater than 5000 OR Tubing Pressure is less than -10 or greater than 5000',@COUNT


			END
			ELSE IF (@COUNT = 0)
			BEGIN


				SELECT @COUNT = COUNT(*)
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD	ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID 
				WHERE TMQ.SubIFace = 'CompletionDaily' AND TSC.SubscriberName = 'ProCount'	AND TICD.RunHours  between 0 and 24

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
			FOR XML PATH ('ErrorMessage'), ROOT('BR_CD_ERRORS')
		)

		INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg ,FormattedMsg, ErrorTime, MachineName, CreatedBy) 
		VALUES ( 'USP_CD_BusinessRules','StoredProcedure','CompletionDaily', @Destination + ' BusinessRule Validations','Error while executing the BusinessRules on CompletionDaily Data', @XmlData, GETDATE(),HOST_NAME(), CURRENT_USER)


	END

	--RETURN VALUE
	SELECT @RETURNVALUE

END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_CD_BusinessRules','StoredProcedure','CompletionDaily','Error while executing the BusinessRules on CompletionDaily Data',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH
