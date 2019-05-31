

CREATE PROCEDURE [dbo].[USP_CD_MapIFaceDataToProCount]
@IFaceBatchUIDXml nvarchar(max) output,
@FormattedMsg nvarchar(max) output,
@PubID int output,
@SubID int output,
@ArchformattedMsg int = 0,
@TotalRecCount int output,
@IFaceBatchID uniqueidentifier
AS
BEGIN TRY

	SELECT distinct
	TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
	TICD.API14 AS API14,
	TICD.LastscaneDate as RecordDate,
	'00:00:00' as RecordTime,
	TICD.StrokesPerMinute as StrokesPerMinute,
	Round(TICD.RunHours,2) as HoursFlowed,
	TICD.CasingPressure as CasingPressure,
	Round(TICD.TubingPressure,1) as TubingPressure,
	TICD.TubingTemperature as TubingTemperature,
	TICD.FlowlineTemperature as FlowlineTemperature,
	TICD.PumpDepth as PumpDepth,
	Round(TICD.[IdleTime],2) as IdleTime,
	33 as UserID,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp
	FROM
	(
		SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
		LEFT JOIN [dbo].[tbl_SubscriberController] TSC
			ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'CompletionDaily'
		WHERE TMQ.SubIFace = 'CompletionDaily' AND  TMQ.SubStatus IS NULL

		UNION 

		SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'CompletionDaily'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


	)TMQ
	INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD
	ON TMQ.TransID = TICD.TransID 
	AND TMQ.TransSeq = TICD.TransSeq	
	AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
	WHERE TICD.IFaceBatchUID = @IFaceBatchID AND (TICD.CasingPressure >= 5000 ) AND (TICD.TubingTemperature >= 5000 ) AND (TICD.LastscaneDate > '2019-02-28')

	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'CompletionDaily' AND  TMQ.SubStatus IS NULL

			UNION 

			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'CompletionDaily'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD
		ON TMQ.TransID = TICD.TransID 
		AND TMQ.TransSeq = TICD.TransSeq	
		AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
		FOR XML PATH (''), ROOT('IFaceBatchUIDS')

	) AS NVARCHAR(MAX))

	IF(@ArchformattedMsg = 1)
	BEGIN
		
		SET @FormattedMsg =
		(
			SELECT 
			TMQ.IFaceBatchUID AS IFaceBatchUID,
			TMQ.SubConnID as SubConnID,
			TMQ.PubConnID as PubConnID,
			TMQ.SubIFace as SubIFace,
			TMQ.SubID as SubID,
			TMQ.PubID as PubID,
			TMQ.TransSeq as TransSeq,
			TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
			TICD.API14 AS API14,
			TICD.LastscaneDate as RecordDate,
			TICD.RunHours as HoursFlowed,
			TICD.CasingPressure as CasingPressure,
			TICD.TubingPressure as TubingPressure,
			TICD.TubingTemperature as TubingTemperature,
			TICD.FlowlineTemperature as FlowlineTemperature,
			TICD.PumpDepth as PumpDepth,
			33 as UserID,
			SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
	        SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp
			FROM
			(
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'CompletionDaily' AND  TMQ.SubStatus IS NULL

				UNION 

				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'CompletionDaily'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD
			ON TMQ.TransID = TICD.TransID 
			AND TMQ.TransSeq = TICD.TransSeq	
			AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
			FOR XML PATH ('CompletionDaily_Record'), ROOT('CompletionDaily_To_ProCount')

		) 


	END
		
	SELECT @PubID = PubID, @SubID = SubID FROM
	(
		SELECT 
		DISTINCT TMQ.PubID, TMQ.SubID 
		FROM
		(
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'CompletionDaily' AND  TMQ.SubStatus IS NULL

			UNION 

			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'CompletionDaily'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_CompletionDaily] TICD
		ON TMQ.TransID = TICD.TransID 
		AND TMQ.TransSeq = TICD.TransSeq	
		AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
	    WHERE TICD.IFaceBatchUID = @IFaceBatchID
	)A


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_CD_MapIFaceDataToProCount','StoredProcedure','CompletionDaily','Error while fetching the subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH









