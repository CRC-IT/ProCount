
CREATE PROCEDURE [dbo].[USP_WSC_MapIFaceDataToProCount]
@IFaceBatchUIDXml nvarchar(max) output,
@FormattedMsg nvarchar(max) output,
@PubID int output,
@SubID int output,
@ArchformattedMsg int = 0,
@TotalRecCount int output,
@IFaceBatchID uniqueidentifier
AS
BEGIN TRY


	SELECT TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
	TWSC.API14 AS API14,
	TWSC.NodeID AS CompletionName,
	SUBSTRING(CONVERT(nvarchar, TWSC.ModifiedDate, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.ModifiedDate, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.ModifiedDate, 112), 7,2) + ' 00:00:00.000'  AS LastStatusChangedDate,
	SUBSTRING(CONVERT(nvarchar, TWSC.RecordDate, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.RecordDate, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.RecordDate, 112), 7,2) + ' 00:00:00.000'  AS StartDate,
	TWSC.ChangeSetField AS ChangeSetField,
	TWSC.ChangeSetValue AS ChangeSetValue,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp,
	33 as UserID
	FROM
	(
		--FETCH NEW WellStatusChanges RECORDS EXCEPT BUSINESS FAILUIRES
		SELECT TMQ.* FROM
		(
			--NEW WellStatusChanges RECORDS 
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'WellStatusChanges' AND  TMQ.SubStatus IS NULL

			EXCEPT

			--BUSINESS RULE FAILURES
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1


		)TMQ

		UNION 

		--ERROR QUEUE WellStatusChanges RECORDS WHICH ARE READY FOR RESUBMIT
		SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


	)TMQ
	INNER JOIN [dbo].[tbl_IFace_WellStatusChanges] TWSC
	ON TMQ.TransID = TWSC.TransID 
	AND TMQ.TransSeq = TWSC.TransSeq	
	AND TMQ.IFaceBatchUID = TWSC.IFaceBatchUID
	AND TWSC.IFaceBatchUID=@IFaceBatchID --AND TWSC.RecordDate >='2019-05-01'

	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			--FETCH NEW WellStatusChanges RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW WellStatusChanges RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'WellStatusChanges' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE WellStatusChanges RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_WellStatusChanges] TWSC
		ON TMQ.TransID = TWSC.TransID 
		AND TMQ.TransSeq = TWSC.TransSeq	
		AND TMQ.IFaceBatchUID = TWSC.IFaceBatchUID
		AND TWSC.IFaceBatchUID=@IFaceBatchID
		FOR XML PATH (''), ROOT('IFaceBatchUIDS')

	) AS NVARCHAR(MAX))

	IF(@ArchformattedMsg = 1)
	BEGIN
		
		SET @FormattedMsg =
		(
			SELECT TMQ.IFaceBatchUID AS IFaceBatchUID,
			TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
			TWSC.API14 AS API14,
			TWSC.NodeID AS CompletionName,
			SUBSTRING(CONVERT(nvarchar, TWSC.ModifiedDate, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.ModifiedDate, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.ModifiedDate, 112), 7,2) + ' 00:00:00.000'  AS LastStatusChangedDate,
			SUBSTRING(CONVERT(nvarchar, TWSC.RecordDate, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.RecordDate, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TWSC.RecordDate, 112), 7,2) + ' 00:00:00.000'  AS StartDate,
			TWSC.ChangeSetField AS ChangeSetField,
			TWSC.ChangeSetValue AS ChangeSetValue,
			SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
			SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp
			FROM
			(
				--FETCH NEW WellStatusChanges RECORDS EXCEPT BUSINESS FAILUIRES
				SELECT TMQ.* FROM
				(
					--NEW WellStatusChanges RECORDS 
					SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
					LEFT JOIN [dbo].[tbl_SubscriberController] TSC
						ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
					WHERE TMQ.SubIFace = 'WellStatusChanges' AND  TMQ.SubStatus IS NULL

					EXCEPT

					--BUSINESS RULE FAILURES
					SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
					INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
						ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
						AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
						AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
						AND TMQ1.PubConnID = TERRQ.PubConnID
						AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
					LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
						ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
					WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

				)TMQ

				UNION 

				--ERROR QUEUE WellStatusChanges RECORDS WHICH ARE READY FOR RESUBMIT
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN [dbo].[tbl_IFace_WellStatusChanges] TWSC
			ON TMQ.TransID = TWSC.TransID 
			AND TMQ.TransSeq = TWSC.TransSeq	
			AND TMQ.IFaceBatchUID = TWSC.IFaceBatchUID
			AND TWSC.IFaceBatchUID=@IFaceBatchID
			FOR XML PATH ('WellStatusChanges_Record'), ROOT('WellStatusChanges_To_ProCount')

		) 


	END
		
	SELECT @PubID = PubID, @SubID = SubID FROM
	(
		SELECT 
		DISTINCT TMQ.PubID, TMQ.SubID 
		FROM
		(
			--FETCH NEW WellStatusChanges RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW WellStatusChanges RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'WellStatusChanges' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE WellStatusChanges RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellStatusChanges'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_WellStatusChanges] TWSC
		ON TMQ.TransID = TWSC.TransID 
		AND TMQ.TransSeq = TWSC.TransSeq	
		AND TMQ.IFaceBatchUID = TWSC.IFaceBatchUID
		AND TWSC.IFaceBatchUID=@IFaceBatchID
	)A


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_WSC_MapIFaceDataToProCount','StoredProcedure','WellStatusChanges','Error while fetching the WellStatusChanges subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH


