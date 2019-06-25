
CREATE PROCEDURE [dbo].[USP_RT_MapIFaceDataToOneCaps_RunTickets]
@IFaceBatchUIDXml nvarchar(MAX) OUTPUT, @FormattedMsg nvarchar(MAX) OUTPUT, @PubID int OUTPUT, @SubID int OUTPUT, @ArchformattedMsg int = 0, @TotalRecCount int OUTPUT
WITH EXEC AS CALLER
AS
BEGIN TRY

	SELECT distinct
	TMQ.IFaceBatchUID AS IFaceBatchUID,
	TMQ.TransID,TMQ.TransSeq,TMQ.SubIFace,TMQ.PubID,TMQ.SubID,TMQ.PubConnID,TMQ.SubConnID,
	TICD.RecordDate AS ProductionDate,
	TICD.[MerrickID] AS Ticket_ID,
	TICD.[RunTicketDate] as Ticket_Date,
	TICD.RunTicketNumber as Ticket_No,
	TICD.GrossBarrels as TotalBBLS,
	TICD.convertedgravity as Gravity,
	TICD.LocAccountNumber1 as Agr_Det_Sequence,
	TICD.LocAccountNumber2 as Agreement_ID,
	TICD.LocationID as Party_Property ,
	TICD.SourceType,
	TICD.purchaser,
	TICD.producttype,
	TICD.AccountantPersonID,
	TICD.AllocActGravity,
	TICD.AllocationDateStamp,
	TICD.BusinessEnitity,
	TICD.completionID,
	TICD.decktype,
	TICD.DispositionCode,
	TICD.DispositionCodeDescription,
	TICD.GatheringSystemAccountantName,
	TICD.GatheringSystemID,
	TICD.GatheringSystemLockDate,
	TICD.GatheringSystemLockName,
	TICD.GatheringSystemName,
	TICD.vol,
	TICD.WellPlusCompletionName,
	CASE WHEN TICD.AreaID  = ' '  THEN
	--Replace(LTRIM(RTRIM(TICD.AreaID)),' ','')  
	NULL
	ELSE
	TICD.AreaID
	END as org_segno,
	--LEFT(TICD.AreaID, CHARINDEX('.', TICD.AreaID) - 1) + '.' + SUBSTRING(TICD.AreaID,(CHARINDEX('.',TICD.AreaID)+1),6) FormattedVarchar,
	TICD.AreaName,
	TICD.COMPMID,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
	SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp
	FROM
	(
		SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
		LEFT JOIN [dbo].[tbl_SubscriberController] TSC
			ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'TankRunTicket'
		WHERE TMQ.SubIFace = 'TankRunTicket' AND  TMQ.SubStatus IS NULL

		UNION 

		SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
		INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
			ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
			AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
			AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
			AND TMQ1.PubConnID = TERRQ.PubConnID
			AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'TankRunTicket'
		LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
			ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
		WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1

	)TMQ
	INNER JOIN [dbo].[tbl_IFace_TankRunTicket] TICD ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq	AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
	WHERE TICD.LocAccountNumber1  <> ' ' AND TICD.LocAccountNumber1 <> 'NULL' --and TICD.AreaID <> ''

	SET @TotalRecCount  = @@ROWCOUNT


	SET @IFaceBatchUIDXml = CAST(
	(
		SELECT DISTINCT TMQ.IFaceBatchUID 
		FROM
		(
			SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
			LEFT JOIN [dbo].[tbl_SubscriberController] TSC
				ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
			WHERE TMQ.SubIFace = 'TankRunTicket' AND  TMQ.SubStatus IS NULL

			UNION 

			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'TankRunTicket'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
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
			TICD.RecordDate AS ProductionDate,
			TICD.[MerrickID] AS Ticket_ID,
			TICD.[RunTicketDate] as Ticket_Date,
			TICD.RunTicketNumber as Ticket_No,
			TICD.GrossBarrels as TotalBBLS,
			TICD.convertedgravity as Gravity,
			TICD.LocAccountNumber1 as Agr_Det_Sequence,
			TICD.LocAccountNumber2 as Agreement_ID,
			TICD.LocationID as Party_Property ,
			TICD.SourceType,
			TICD.purchaser,
			TICD.producttype,
			TICD.AreaID as org_segno,
			TICD.AreaName,
			TICD.COMPMID,
			TICD.AccountantPersonID,
			TICD.AllocActGravity,
			TICD.AllocationDateStamp,
			TICD.BusinessEnitity,
			TICD.completionID,
			TICD.decktype,
			TICD.DispositionCode,
			TICD.DispositionCodeDescription,
			TICD.GatheringSystemAccountantName,
			TICD.GatheringSystemID,
			TICD.GatheringSystemLockDate,
			TICD.GatheringSystemLockName,
			TICD.GatheringSystemName,
			TICD.vol,
			TICD.WellPlusCompletionName,
			SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
	        SUBSTRING( CONVERT(NVARCHAR(30), GETDATE(),20), 12, 8) AS UserTimeStamp
			FROM
			(
				SELECT TMQ.* FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = 'TankRunTicket' AND  TMQ.SubStatus IS NULL

				UNION 

				SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
				INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
					ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
					AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
					AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
					AND TMQ1.PubConnID = TERRQ.PubConnID
					AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'TankRunTicket'
				LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
					ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
				WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


			)TMQ
			INNER JOIN [dbo].[tbl_IFace_TankRunTicket] TICD
			ON TMQ.TransID = TICD.TransID 
			AND TMQ.TransSeq = TICD.TransSeq	
			AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
			FOR XML PATH ('TankRunTicket_Record'), ROOT('TankRunTicket_To_ProCount')

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
			WHERE TMQ.SubIFace = 'TankRunTicket' AND  TMQ.SubStatus IS NULL

			UNION 

			SELECT TMQ1.* FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'TankRunTicket'
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
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
	VALUES ( 'USP_RT_MapIFaceDataToOneCaps_RunTickets','StoredProcedure','TankRunTicket','Error while fetching the subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH
