

CREATE PROCEDURE [dbo].[USP_DT_MapIFaceDataTo_ODSLOAD]
@IFaceBatchUIDXml nvarchar(max) output,
@FormattedMsg nvarchar(max) output,
@PubID int output,
@SubID int output,
@ArchformattedMsg int = 0,
@TotalRecCount int output
AS
BEGIN TRY

	SELECT 
	TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,
	TMQ.SubIFace,TMQ.PubID,
	TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
	TICD.ObjectMerrickID AS COMP_SK,
	TICD.OriginalDateEntered  AS ENTRY_DT,
	TICD.DowntimeHours ,
	TICD.DowntimeCode AS  DDOWN_RSN_1,
	'ProCount' AS UserName

	FROM
	(
		SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
		LEFT JOIN [dbo].[tbl_SubscriberController] TSC
			ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ELPSPD.WORLD'
		WHERE TMQ.SubIFace = 'ODSDownTimeDetails' AND  TMQ.SubStatus IS NULL

		UNION 

		SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'ODSDownTimeDetails'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ELPSPD.WORLD'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1

	)TMQ
	INNER JOIN [dbo].[tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P] TICD ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq	AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
	

	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ELPSPD.WORLD'
			WHERE TMQ.SubIFace = 'ODSDownTimeDetails' AND  TMQ.SubStatus IS NULL

			UNION 

			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'ODSDownTimeDetails'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ELPSPD.WORLD'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_TankRunTicket] TICD
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
		  	TICD.ObjectMerrickID AS COMP_SK,
			TICD.OriginalDateEntered  AS ENTRY_DT,
			TICD.DowntimeHours ,
			TICD.DowntimeCode AS  DDOWN_RSN_1,
	       'ProCount' AS UserName
			FROM
			(
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ELPSPD.WORLD'
				WHERE TMQ.SubIFace = 'ODSDownTimeDetails' AND  TMQ.SubStatus IS NULL

				UNION 

				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'ELPSPD.WORLD'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P TICD
			ON TMQ.TransID = TICD.TransID 
			AND TMQ.TransSeq = TICD.TransSeq	
			AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
			FOR XML PATH ('ODSDownTimeDetails_Record'), ROOT('ODSDownTimeDetails_To_ODS_LOAD')
			 
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
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ELPSPD.WORLD'
			WHERE TMQ.SubIFace = 'ODSDownTimeDetails' AND  TMQ.SubStatus IS NULL

			UNION 

			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'GasLoaderTrans'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ELPSPD.WORLD'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		INNER JOIN [dbo].[tbl_IFace_TankRunTicket] TICD
		ON TMQ.TransID = TICD.TransID 
		AND TMQ.TransSeq = TICD.TransSeq	
		AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
	)A


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_GLT_MapIFaceDataToOneCaps_GasLoader','StoredProcedure','GasLoaderTrans','Error while fetching the subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH









