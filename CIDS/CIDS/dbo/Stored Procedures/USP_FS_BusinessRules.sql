CREATE PROCEDURE [dbo].[USP_FS_BusinessRules] 
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

		-- START - BUSINESS RULE 2 - Comments must not be longer than 20 characters

			SELECT @COUNT = COUNT(*)
			FROM [dbo].[tbl_MsgQueue] TMQ	
			INNER JOIN [dbo].[tbl_IFace_Fluidshots] TIWT	ON TMQ.TransID = TIWT.TransID AND TMQ.TransSeq = TIWT.TransSeq AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID AND TMQ.SubConnID = TSC.SubConnID
			WHERE TMQ.SubIFace = 'Fluidshots' AND TSC.SubscriberName = 'ProCount'	AND convert(numeric(38,0),cast(TIWT.CasingPressure AS float))  > 50000


			IF @COUNT > 1
			BEGIN


				INSERT INTO [dbo].[tbl_ErrorQueue] ([IFaceBatchUID] ,[PubID] ,[SubID] ,[PubConnID], [SubConnID], [TransID] ,[TransSeq] ,[SubIFace], [ErrorTime] , [ErrorMsg] ,[IsResubmit] ,[IsBussRuleFail], [CreatedTime] ,[CreatedBy])
				SELECT 	TMQ.IFaceBatchUID AS IFaceBatchUID, TMQ.PubID, TMQ.SubID,tmq.PubConnID, TMQ.SubConnID, TMQ.TransID, TMQ.TransSeq, TMQ.SubIFace, GETDATE() AS [ErrorTime],
				'Casing pressure must not be greater than 50000' AS [ErrorMsg], 0 AS [IsResubmit], 1 AS [IsBussRuleFail], GETDATE() AS [CreatedTime], CURRENT_USER AS [CreatedBy]
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_Fluidshots] TIWT	ON TMQ.TransID = TIWT.TransID AND TMQ.TransSeq = TIWT.TransSeq AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID AND TMQ.SubConnID = TSC.SubConnID
				WHERE TMQ.SubIFace = 'Fluidshots' AND TSC.SubscriberName = 'ProCount' AND convert(numeric(38,0),cast(TIWT.CasingPressure AS float))  > 50000

				INSERT INTO @TBL_ERRORS
				SELECT 'Casing pressure must not be greater than 50000','Casing pressure is greater than 50000',@COUNT

			END

			ELSE IF (@COUNT = 0)
			BEGIN


				SELECT @COUNT = COUNT(*)
				FROM [dbo].[tbl_MsgQueue] TMQ	INNER JOIN [dbo].[tbl_IFace_Fluidshots] TIWT	ON TMQ.TransID = TIWT.TransID AND TMQ.TransSeq = TIWT.TransSeq AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC	ON TMQ.SubID = TSC.SubID AND TMQ.SubConnID = TSC.SubConnID
				WHERE TMQ.SubIFace = 'Fluidshots' AND TSC.SubscriberName = 'ProCount'	

				IF @COUNT > 0
					SET @RETURNVALUE = @RETURNVALUE + 1
				ELSE
					SET @RETURNVALUE = 0	



			END



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
			FOR XML PATH ('ErrorMessage'), ROOT('BR_FS_ERRORS')
		)

		INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg ,FormattedMsg, ErrorTime, MachineName, CreatedBy) 
		VALUES ( 'USP_FS_BusinessRules','StoredProcedure','Fluidshots', @Destination + ' BusinessRule Validations','Error while executing the BusinessRules on Fluidshots Data', @XmlData, GETDATE(),HOST_NAME(), CURRENT_USER)

		SELECT @ErrorLogId = SCOPE_IDENTITY()

	END

	--RETURN VALUE
	SELECT @RETURNVALUE

END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_FS_BusinessRules','StoredProcedure','Fluidshots','Error while executing the BusinessRules on Fluidshots Data',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH

