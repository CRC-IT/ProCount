--exec [dbo].[USP_MapIFaceDataToProCount_BatachIDs] 'GasLoaderTrans'
CREATE PROCEDURE [dbo].[USP_MapIFaceDataToProCount_BatachIDs]
@SubIFace varchar(20)
AS
BEGIN TRY

	SELECT A.IFaceBatchUID FROM
	(
		SELECT 
		DISTINCT TMQ.IFaceBatchUID
		FROM
		(
			--FETCH NEW WELLTEST RECORDS EXCEPT BUSINESS FAILUIRES
			SELECT TMQ.* FROM
			(
				--NEW WELLTEST RECORDS 
				SELECT Distinct IFaceBatchUID FROM [dbo].[tbl_MsgQueue] TMQ
				LEFT JOIN [dbo].[tbl_SubscriberController] TSC
					ON TMQ.SubID = TSC.SubID  AND TSC.SubscriberName = 'ProCount'
				WHERE TMQ.SubIFace = @SubIFace AND  TMQ.SubStatus IS NULL

			

			)TMQ

			UNION 

			--ERROR QUEUE WELLTEST RECORDS WHICH ARE READY FOR RESUBMIT
			SELECT TMQ1.IFaceBatchUID FROM [dbo].[tbl_MsgQueue] TMQ1
			INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
				ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID 
				AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
				AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID
				AND TMQ1.PubConnID = TERRQ.PubConnID
				AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = @SubIFace
			LEFT JOIN  [dbo].[tbl_SubscriberController] TSC1
				ON TMQ1.SubID = TSC1.SubID  AND TSC1.SubscriberName = 'ProCount'
			WHERE TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1


		)TMQ
		--where TMQ.IFaceBatchUID='D3B8C74A-A583-4E61-81A0-82E2AF6FF95F'
	)A 


END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( 'USP_MapIFaceDataToProCount_BatachIDs','StoredProcedure',@SubIFace,'Error while fetching the WellTest subscriptions data from IFace table',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH

