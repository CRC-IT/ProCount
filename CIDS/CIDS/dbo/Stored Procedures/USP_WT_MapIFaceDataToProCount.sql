CREATE PROCEDURE [dbo].[USP_WT_MapIFaceDataToProCount]
@IFaceBatchUIDXml nvarchar(max) output,
@FormattedMsg nvarchar(max) output,
@PubID int output,
@SubID int output,
@ArchformattedMsg int = 0,
@TotalRecCount int output,
@IFaceBatchID uniqueidentifier
AS
BEGIN TRY


	SELECT DISTINCT 0 as Sequence_no,
	--ROW_NUMBER() OVER (ORDER BY TMQ.TransID)  Sequence_no,
	TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
	TIWT.API_NO14 AS API_NO14,
	CONVERT(VARCHAR, DATEADD(DAY, 1, SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) ), 121)  AS RecordDate,
	'00:00:00' AS RecordTime,
	2 AS DetailCalcFlag,
	0 AS TestTypeID,
	0 AS TestAllocationFlag,
	1 AS UsedinAllocationFlag,
	1 AS ValidTestFlag,
	0 AS MeasuredTestFlag,
	1 AS RegulatoryTestFlag,
	0 AS RunEfficencyCalcFlag,
	CAST(TIWT.COMMENTS AS VARCHAR(200)) AS TestComment,
	1 AS GasRate24HourFlag,
	17 AS DataSourceCode,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS RegulatoryEffectiveDate,
	CONVERT(VARCHAR, DATEADD(DAY, 1, SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) ), 121) AS AllocationEffectiveDate,  
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS DueDate,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS PotentialTestDate,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS CompletedDate,
	'00:00:00' AS CompletedTime,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS StartFlowDate,
	'00:00:00' StartFlowTime,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS EndFlowDate,
	'00:00:00' EndFlowTime,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS StartTestDate,
	'00:00:00' StartTestTime,
	SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS EndTestDate,
	'00:00:00' EndTestTime,
	24 AS TestHours,
	0 AS PreTestHours,
	0 AS PumpHours,
	TIWT.OIL_RATE AS OilProduction,
	TIWT.OIL_RATE AS OilProductionNet,
	TIWT.WATER_RATE AS WaterProduction,
	TIWT.GAS_RATE AS GasProduction,
	TIWT.TOTAL_GAS_PROD AS GasProductionNet,
	TIWT.GAS_LIFT_RATE AS GasInjection,
	TIWT.GAS_RATE AS DailyProductionRateGas,
	TIWT.OIL_RATE AS DailyProductionRateOil,
	TIWT.WATER_RATE AS DailyProductionRateWater,
	TIWT.OIL_GRAVITY AS GravityOil,
	TIWT.OIL_GRAVITY AS APIGravity,
	0 AS GravityWater,
	TIWT.BSW AS BSWPercent,
	TIWT.GAS_OIL_RATIO AS GasOilRatio,
	TIWT.GRAV_GAS AS GasGravity,
	TIWT.CASING_PRESS AS FlowingCasingPressure,
	TIWT.WELLHEAD_TEMP AS FlowingTemperature,
	TIWT.WELLHEAD_TEMP AS SurfaceTemperature,
	TIWT.WELLHEAD_TEMP AS AmbientAirTemperature,
	TIWT.SEP_PRESS AS SeparatorPressure,
	TIWT.WELLHEAD_TEMP AS ObservedTemperature,
	TIWT.PBH_PRESS AS StaticPressure,
	TIWT.CHOKE_SIZE AS ChokeSize,
	TIWT.SEP_PRESS AS SeparatorPresure,
	TIWT.GAS_OIL_RATIO AS GasFluidRatio,
	TIWT.GAS_RATE AS DailyInterpolationRateGas,
	TIWT.OIL_RATE AS DailyInterpolationRateOil,
	TIWT.WATER_RATE AS DailyInterpolationRateWater,
	TIWT.LINE_PRESS AS LinePressure,
	24 AS TestDurationHours,
	TIWT.GAS_RATE AS TestGasVolume,
	TIWT.OIL_RATE AS TestOilVolume,
	TIWT.WATER_RATE AS TestWaterVolume,
	2 AS DeleteFlag,
	2 AS BackgroundTaskFlag,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp,
	TIWT.WATER_CUT AS WaterCut,
	TIWT.PBH_PRESS AS BottomHolePressure,
	TIWT.TUBING_PRESS AS FlowingTubingPressure,
	TIWT.PUMP_BORE_SIZE AS PumpSize,
	TIWT.STROKE_LENGTH AS StrokeLine,
	TIWT.PUMP_EFF AS Efficiency,
	TIWT.STROKES_MINUTE AS StrokesPerMinute,
	TIWT.FLUID_LEVEL AS FluidLevel,
	TIWT.TUBING_PRESS AS TubingPressure,
	33 as UserID
	FROM
	(
		--FETCH NEW WELLTEST RECORDS EXCEPT BUSINESS FAILUIRES
		SELECT TMQ.* FROM
		(
			--NEW WELLTEST RECORDS 
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'WellTest' AND  TMQ.SubStatus IS NULL

			EXCEPT

			--BUSINESS RULE FAILURES
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1


		)TMQ

		UNION 

		--ERROR QUEUE WELLTEST RECORDS WHICH ARE READY FOR RESUBMIT
		SELECT DISTINCT  TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


	)TMQ
	INNER JOIN [dbo].[tbl_IFace_WellTest] TIWT
	ON TMQ.TransID = TIWT.TransID 
	AND TMQ.TransSeq = TIWT.TransSeq	
	AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
	WHERE TIWT.IFaceBatchUID = @IFaceBatchID AND convert(numeric(38,0),cast(TIWT.CASING_PRESS AS float)) <=  50000 AND TIWT.WELL_TEST_DATE >getdate()-3
	--WHERE TIWT.WELL_TEST_DATE >= '2018-07-07' --and TMQ.IFaceBatchUID ='800c5d75-23d3-4a37-bfbd-6124f007956d'
	--order by TIWT.WELL_TEST_DATE 

	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			--FETCH NEW WELLTEST RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW WELLTEST RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'WellTest' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE WELLTEST RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_WellTest] TIWT
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
			TMQ.IFaceBatchUID AS IFaceBatchUID,
			TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
			TIWT.API_NO14 AS API_NO14,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000'  AS RecordDate,
			'00:00:00' AS RecordTime,
			2 AS DetailCalcFlag,
			0 AS TestTypeID,
			0 AS TestAllocationFlag,
			1 AS UsedinAllocationFlag,
			1 AS ValidTestFlag,
			0 AS MeasuredTestFlag,
			1 AS RegulatoryTestFlag,
			0 AS RunEfficencyCalcFlag,
			CAST(TIWT.COMMENTS AS VARCHAR(200)) AS TestComment,
			1 AS GasRate24HourFlag,
			17 AS DataSourceCode,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS RegulatoryEffectiveDate,
			CONVERT(VARCHAR, DATEADD(DAY, -1, SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) ), 121) AS AllocationEffectiveDate,  
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS DueDate,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS PotentialTestDate,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS CompletedDate,
			'00:00:00' AS CompletedTime,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS StartFlowDate,
			'00:00:00' StartFlowTime,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS EndFlowDate,
			'00:00:00' EndFlowTime,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS StartTestDate,
			'00:00:00' StartTestTime,
			SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 1,4) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 5,2) +'-'+ SUBSTRING(CONVERT(nvarchar, TIWT.WELL_TEST_DATE, 112), 7,2) + ' 00:00:00.000' AS EndTestDate,
			'00:00:00' EndTestTime,
			TIWT.TEST_HOURS AS TestHours,
			0 AS PreTestHours,
			0 AS PumpHours,
			TIWT.OIL_RATE AS OilProduction,
			TIWT.OIL_RATE AS OilProductionNet,
			TIWT.WATER_RATE AS WaterProduction,
			TIWT.GAS_RATE AS GasProduction,
			TIWT.TOTAL_GAS_PROD AS GasProductionNet,
			TIWT.GAS_LIFT_RATE AS GasInjection,
			TIWT.GAS_RATE AS DailyProductionRateGas,
			TIWT.OIL_RATE AS DailyProductionRateOil,
			TIWT.WATER_RATE AS DailyProductionRateWater,
			TIWT.OIL_GRAVITY AS GravityOil,
			TIWT.OIL_GRAVITY AS APIGravity,
			0 AS GravityWater,
			TIWT.BSW AS BSWPercent,
			TIWT.GAS_OIL_RATIO AS GasOilRatio,
			TIWT.GRAV_GAS AS GasGravity,
			TIWT.CASING_PRESS AS FlowingCasingPressure,
			TIWT.WELLHEAD_TEMP AS FlowingTemperature,
			TIWT.WELLHEAD_TEMP AS SurfaceTemperature,
			TIWT.WELLHEAD_TEMP AS AmbientAirTemperature,
			TIWT.SEP_PRESS AS SeparatorPressure,
			TIWT.WELLHEAD_TEMP AS ObservedTemperature,
			TIWT.PBH_PRESS AS StaticPressure,
			TIWT.CHOKE_SIZE AS ChokeSize,
			TIWT.SEP_PRESS AS SeparatorPresure,
			TIWT.GAS_OIL_RATIO AS GasFluidRatio,
			TIWT.GAS_RATE AS DailyInterpolationRateGas,
			TIWT.OIL_RATE AS DailyInterpolationRateOil,
			TIWT.WATER_RATE AS DailyInterpolationRateWater,
			TIWT.LINE_PRESS AS LinePressure,
			24 AS TestDurationHours,
			TIWT.GAS_RATE AS TestGasVolume,
			TIWT.OIL_RATE AS TestOilVolume,
			TIWT.WATER_RATE AS TestWaterVolume,
			2 AS DeleteFlag,
			2 AS BackgroundTaskFlag,
			SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
			SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp,
			33 as UserID,
			TIWT.WATER_CUT AS WaterCut,
		    TIWT.PBH_PRESS AS BottomHolePressure,
			TIWT.TUBING_PRESS AS FlowingTubingPressure,
			TIWT.PUMP_BORE_SIZE AS PumpSize,
			TIWT.STROKE_LENGTH AS StrokeLine,
			TIWT.PUMP_EFF AS Efficiency,
			TIWT.STROKES_MINUTE AS StrokesPerMinute,
			TIWT.FLUID_LEVEL AS FluidLevel,
			TIWT.TUBING_PRESS AS TubingPressure
			FROM
			(
				--FETCH NEW WELLTEST RECORDS EXCEPT BUSINESS FAILUIRES
				SELECT TMQ.* FROM
				(
					--NEW WELLTEST RECORDS 
					SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
					LEFT JOIN [dbo].[tbl_SubscriberController] TSC
						ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
					WHERE TMQ.SubIFace = 'WellTest' AND  TMQ.SubStatus IS NULL

					EXCEPT

					--BUSINESS RULE FAILURES
					SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
					INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
						ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
						AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
						AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
						AND TMQ1.PubConnID = TERRQ.PubConnID
						AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
					LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
						ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
					WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

				)TMQ

				UNION 

				--ERROR QUEUE WELLTEST RECORDS WHICH ARE READY FOR RESUBMIT
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN [dbo].[tbl_IFace_WellTest] TIWT
			ON TMQ.TransID = TIWT.TransID 
			AND TMQ.TransSeq = TIWT.TransSeq	
			AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
			FOR XML PATH ('WellTest_Record'), ROOT('WellTest_To_ProCount')

		) 


	END
		
	SELECT @PubID = PubID, @SubID = SubID FROM
	(
		SELECT 
		DISTINCT TMQ.PubID, TMQ.SubID 
		FROM
		(
			--FETCH NEW WELLTEST RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW WELLTEST RECORDS 
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'WellTest' AND  TMQ.SubStatus IS NULL

				EXCEPT

				--BUSINESS RULE FAILURES
				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus IS NULL AND TERRQ.IsBussRuleFail = 1

			)TMQ

			UNION 

			--ERROR QUEUE WELLTEST RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'WellTest'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_WellTest] TIWT
		ON TMQ.TransID = TIWT.TransID 
		AND TMQ.TransSeq = TIWT.TransSeq	
		AND TMQ.IFaceBatchUID = TIWT.IFaceBatchUID
	)A


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_WT_MapIFaceDataToProCount','StoredProcedure','WellTest','Error while fetching the WellTest subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH

