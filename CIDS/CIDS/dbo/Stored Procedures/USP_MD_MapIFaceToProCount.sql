CREATE PROCEDURE [dbo].[USP_MD_MapIFaceToProCount]
@IFaceBatchUIDXml nvarchar(max) output,
@FormattedMsg nvarchar(max) output,
@PubID int output,
@SubID int output,
@ArchformattedMsg int = 0,
@TotalRecCount int output,
@IFaceBatchID uniqueidentifier
AS
BEGIN TRY


	SELECT Distinct 0 as Sequence_no,
	--ROW_NUMBER() OVER (ORDER BY TMQ.TransID)  Sequence_no,
	TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,
	TMQ.SubIFace,
	TMQ.PubID,
	TMQ.SubID,
	TMQ.PubConnID,
	TMQ.SubConnID,
	LTRIM(RTRIM(TIWT.MeterID)) MeterID,
	 --ROW_NUMBER() OVER (ORDER BY TMQ.TransId)  AS MerrickId,
	SUBSTRING(CONVERT(nvarchar, DATEADD(D,1,TIWT.[RecordDate]), 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, DATEADD(D,1,TIWT.[RecordDate]), 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, DATEADD(D,1,TIWT.[RecordDate]), 112), 7,2)   AS RecordDate,
	'00:00:00' AS RecordTime,
	 1 AS ObjectType,
	Round(TIWT.MeterTemperature,1) as MeterTemperature,
	Round(TIWT.MeterVolumePreviousDay,2) as MeterVolumePreviousDay,
	Convert(float,TIWT.MeterFlowHours) as MeterFlowhours,
	Round(TIWT.MeterPressureStatic,2) as MeterPressureStatic,
	Round(TIWT.MeterPressureDifferential,2) as MeterPressureDifferential,
	Round(TIWT.Energy,2) as Energy,
	17 as Datasourcecode,
	14.73 as EstPressureBase,
	2 as BackgroundTaskFlag,
	getdate() as UserDateStamp,
	CASE WHEN TIWT.MeterVolumePreviousDay = 0 THEN 0
    ELSE
    TIWT.Energy/TIWT.MeterVolumePreviousDay END as EstBTUFactor,
	33 as UserID
	FROM
	(
		--FETCH NEW MeterData RECORDS EXCEPT BUSINESS FAILUIRES
		SELECT TMQ.* FROM
		(
			--NEW MeterData RECORDS 
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'MeterData' AND  TMQ.SubStatus IS NULL

			EXCEPT

			----BUSINESS RULE FAILURES
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1


		)TMQ

		UNION 

		--ERROR QUEUE MeterData RECORDS WHICH ARE READY FOR RESUBMIT
		SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


	)TMQ
	INNER JOIN [dbo].[tbl_IFace_MeterData] TIWT
	ON TMQ.TransID = TIWT.TransID 
	AND TMQ.TransSeq = TIWT.TransSeq	
	AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
	WHERE TIWT.IFaceBatchUID = @IFaceBatchID and TIWT.RecordDate > getdate()-3  and (TIWT.MeterFlowHours) <=24 
	


	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			--FETCH NEW MeterData RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW MeterData RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'MeterData' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE MeterData RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_MeterData] TIWT
		ON TMQ.TransID = TIWT.TransID 
		AND TMQ.TransSeq = TIWT.TransSeq	
		AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
		AND TIWT.IFaceBatchUID = @IFaceBatchID
		FOR XML PATH (''), ROOT('IFaceBatchUIDS')

	) AS NVARCHAR(MAX))

	IF(@ArchformattedMsg = 1)
	BEGIN
		
		SET @FormattedMsg =
		(
			SELECT 
			--ROW_NUMBER() OVER (ORDER BY TMQ.TransID)  Sequence_no,
			TMQ.IFaceBatchUID AS IFaceBatchUID,
			TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
			--ROW_NUMBER() OVER (ORDER BY TMQ.TransId)  AS MerrickId,
			LTRIM(RTRIM(TIWT.MeterID)) MeterID,
			SUBSTRING(CONVERT(nvarchar, TIWT.RecordDate, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.RecordDate, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.RecordDate, 112), 7,2)   AS RecordDate,
			'00:00:00' AS RecordTime,
			 1 AS ObjectType,
			TIWT.MeterTemperature,
			TIWT.MeterVolumePreviousDay,
			TIWT.MeterFlowHours,
			TIWT.MeterPressureStatic,
			TIWT.MeterPressureDifferential,
	        TIWT.Energy,
			33 as UserID
			FROM
			(
				--FETCH NEW MeterData RECORDS EXCEPT BUSINESS FAILUIRES
				SELECT TMQ.* FROM
				(
					--NEW MeterData RECORDS 
					SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
					LEFT JOIN [dbo].[tbl_SubscriberController] TSC
						ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
					WHERE TMQ.SubIFace = 'MeterData' AND  TMQ.SubStatus IS NULL

					EXCEPT

					--BUSINESS RULE FAILURES
					SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
					INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
						ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
						AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
						AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
						AND TMQ1.PubConnID = TERRQ.PubConnID
						AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
					LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
						ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
					WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

				)TMQ

				UNION 

				--ERROR QUEUE MeterData RECORDS WHICH ARE READY FOR RESUBMIT
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN [dbo].[tbl_IFace_MeterData] TIWT
			ON TMQ.TransID = TIWT.TransID 
			AND TMQ.TransSeq = TIWT.TransSeq	
			AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
			AND TIWT.IFaceBatchUID = @IFaceBatchID
			FOR XML PATH ('MeterData_Record'), ROOT('MeterData_To_ProCount')

		) 


	END
		
	SELECT @PubID = PubID, @SubID = SubID FROM
	(
		SELECT 
		DISTINCT TMQ.PubID, TMQ.SubID 
		FROM
		(
			--FETCH NEW MeterData RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW MeterData RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'MeterData' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE MeterData RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'MeterData'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_MeterData] TIWT
		ON TMQ.TransID = TIWT.TransID 
		AND TMQ.TransSeq = TIWT.TransSeq	
		AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
		AND TIWT.IFaceBatchUID = @IFaceBatchID
	
	)A


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_MT_MapIFaceDataToProCount','StoredProcedure','MeterData','Error while fetching the MeterData subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH

