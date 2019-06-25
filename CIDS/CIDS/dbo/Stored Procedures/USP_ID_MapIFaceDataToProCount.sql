


CREATE PROCEDURE [dbo].[USP_ID_MapIFaceDataToProCount]
@IFaceBatchUIDXml nvarchar(max) output,
@FormattedMsg nvarchar(max) output,
@PubID int output,
@SubID int output,
@ArchformattedMsg int = 0,
@TotalRecCount int output,
@IFaceBatchID uniqueidentifier
AS
BEGIN TRY


	SELECT distinct 0 as Sequence_no,
	--ROW_NUMBER() OVER (ORDER BY TMQ.TransID)  Sequence_no,
	TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
	TIWT.[API14]  AS API_NO14,
	SUBSTRING(CONVERT(nvarchar, TIWT.[RecordDate], 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.[RecordDate], 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.[RecordDate], 112), 7,2)   AS RecordDate,
	'00:00:00' AS RecordTime,
	 1 AS ObjectType,
	TIWT.[LineTemperature],
	TIWT.[YesterdayInjectionWater],
	TIWT.YesterdayInjectionCO2,
	TIWT.YesterdayInjectionSteam,
	TIWT.YesterdayInjectionGas,
	TIWT.InjectionPressure,
    CASE WHEN ISNULL(TIWT.CasingPressureDailyHigh,0) >= ISNULL(TIWT.CasingPressure,0) THEN 
        CASE WHEN ISNULL(TIWT.CasingPressureDailyHigh,0) > ISNULL(TIWT.SupplyPressure,0) THEN
	        TIWT.CasingPressureDailyHigh
	    ELSE 
		    TIWT.SupplyPressure
	    END
	   ELSE
	      CASE WHEN ISNULL(TIWT.CasingPressureDailyHigh,0) <= ISNULL(TIWT.CasingPressure,0) THEN
		  CASE WHEN ISNULL(TIWT.CasingPressure,0) > ISNULL(TIWT.SupplyPressure,0) THEN
	            TIWT.CasingPressure
	      ELSE 
		        TIWT.SupplyPressure
		  END
		  END
    END CasingPressure,
  	TIWT.CasingPressureDailyHigh,
	TIWT.CasingPressureDailyLow,
	TIWT.SupplyPressure,
	TIWT.InjectionRateSetpoint,
	TIWT.InjectionPressureSetpoint,
	TIWT.NodeID,
	33 as UserID
	FROM
	(
		--FETCH NEW InjectionData RECORDS EXCEPT BUSINESS FAILUIRES
		SELECT TMQ.* FROM
		(
			--NEW InjectionData RECORDS 
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'InjectionData' AND  TMQ.SubStatus IS NULL

			EXCEPT

			----BUSINESS RULE FAILURES
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1


		)TMQ

		UNION 

		--ERROR QUEUE InjectionData RECORDS WHICH ARE READY FOR RESUBMIT
		SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1 


	)TMQ
	INNER JOIN [dbo].[tbl_IFace_InjectionData] TIWT
	ON TMQ.TransID = TIWT.TransID 
	AND TMQ.TransSeq = TIWT.TransSeq	
	AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
	WHERE TIWT.IFaceBatchUID = @IFaceBatchID --AND (convert(numeric(38,0),cast(TIWT.CasingPressure AS float))  >=  5000 OR  convert(numeric(38,0),cast(TIWT.CasingPressure AS float)) <0)  AND (TIWT.InjectionPressure >= 4000) AND RecordDate > '2019-02-28 00:00:00.000'
	


	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			--FETCH NEW InjectionData RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW InjectionData RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'InjectionData' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE InjectionData RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_InjectionData] TIWT
		ON TMQ.TransID = TIWT.TransID 
		AND TMQ.TransSeq = TIWT.TransSeq	
		AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
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
			TIWT.[API14]  AS API_NO14,
			SUBSTRING(CONVERT(nvarchar, TIWT.[RecordDate], 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.[RecordDate], 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.[RecordDate], 112), 7,2)   AS RecordDate,
			'00:00:00' AS RecordTime,
			 1 AS ObjectType,
			TIWT.[LineTemperature],
			TIWT.[YesterdayInjectionWater],
			TIWT.YesterdayInjectionCO2,
			TIWT.YesterdayInjectionSteam,
			TIWT.YesterdayInjectionGas,
			TIWT.InjectionPressure,
			CASE WHEN ISNULL(TIWT.CasingPressureDailyHigh,0) >= ISNULL(TIWT.CasingPressure,0) THEN 
			CASE WHEN ISNULL(TIWT.CasingPressureDailyHigh,0) > ISNULL(TIWT.SupplyPressure,0) THEN
				TIWT.CasingPressureDailyHigh
			ELSE 
				TIWT.SupplyPressure
			END
		   ELSE
			  CASE WHEN ISNULL(TIWT.CasingPressureDailyHigh,0) <= ISNULL(TIWT.CasingPressure,0) THEN
			  CASE WHEN ISNULL(TIWT.CasingPressure,0) > ISNULL(TIWT.SupplyPressure,0) THEN
					TIWT.CasingPressure
			  ELSE 
					TIWT.SupplyPressure
			  END
			  END
		    END CasingPressure,
			TIWT.CasingPressureDailyHigh,
			TIWT.CasingPressureDailyLow,
			TIWT.SupplyPressure,
			TIWT.InjectionRateSetpoint,
			TIWT.InjectionPressureSetpoint,
			TIWT.NodeID,
			33 as UserID
			FROM
			(
				--FETCH NEW InjectionData RECORDS EXCEPT BUSINESS FAILUIRES
				SELECT TMQ.* FROM
				(
					--NEW InjectionData RECORDS 
					SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
					LEFT JOIN [dbo].[tbl_SubscriberController] TSC
						ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
					WHERE TMQ.SubIFace = 'InjectionData' AND  TMQ.SubStatus IS NULL

					EXCEPT

					--BUSINESS RULE FAILURES
					SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
					INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
						ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
						AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
						AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
						AND TMQ1.PubConnID = TERRQ.PubConnID
						AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
					LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
						ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
					WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

				)TMQ

				UNION 

				--ERROR QUEUE InjectionData RECORDS WHICH ARE READY FOR RESUBMIT
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN [dbo].[tbl_IFace_InjectionData] TIWT
			ON TMQ.TransID = TIWT.TransID 
			AND TMQ.TransSeq = TIWT.TransSeq	
			AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
			AND TIWT.IFaceBatchUID = @IFaceBatchID
			FOR XML PATH ('InjectionData_Record'), ROOT('InjectionData_To_ProCount')

		) 


	END
		
	SELECT @PubID = PubID, @SubID = SubID FROM
	(
		SELECT 
		DISTINCT TMQ.PubID, TMQ.SubID 
		FROM
		(
			--FETCH NEW InjectionData RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW InjectionData RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'InjectionData' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE InjectionData RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'InjectionData'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_InjectionData] TIWT
		ON TMQ.TransID = TIWT.TransID 
		AND TMQ.TransSeq = TIWT.TransSeq	
		AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
	)A


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_ID_MapIFaceDataToProCount','StoredProcedure','InjectionData','Error while fetching the InjectionData subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH

