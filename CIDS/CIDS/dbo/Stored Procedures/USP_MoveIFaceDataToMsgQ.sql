CREATE PROCEDURE [dbo].[USP_MoveIFaceDataToMsgQ] 
	@IFaceBatchUIDxml  NVARCHAR(MAX) OUTPUT,
	@SubscriberName NVARCHAR(100),
	@SubIFace NVARCHAR(100),
	@SubID INT,
	@ConnType NVARCHAR(100),
	@RecCount INT OUTPUT,
	@IFaceTableName NVARCHAR(500) OUTPUT,
	@SubConnID INT
AS
BEGIN TRY

		
	IF( @SubscriberName = 'ProCount' )
	BEGIN

		IF( @SubIFace = 'WellTest' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWT.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_WellTest] TIWT 
			WHERE TSB.SubIFace = 'WellTest' AND TSB.ConnType = 'Database' AND  TSB.SubscriberName = 'ProCount' AND TIWT.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_WellTest'

			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_WellTest] TIWT 
				WHERE TSB.SubIFace = 'WellTest' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWT.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		ELSE IF( @SubIFace = 'FluidShots' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIFS.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_FluidShots] TIFS
			WHERE TSB.SubIFace = 'FluidShots' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIFS.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_FluidShots'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_FluidShots] TIFS 
				WHERE TSB.SubIFace = 'FluidShots' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIFS.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		
		ELSE IF( @SubIFace = 'CompletionDaily' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TICD.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_CompletionDaily] TICD
			WHERE TSB.SubIFace = 'CompletionDaily' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TICD.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_CompletionDaily'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_CompletionDaily] TICD 
				WHERE TSB.SubIFace = 'CompletionDaily' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TICD.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		ELSE IF( @SubIFace = 'DownTime' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TICD.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_DownTime] TICD
			WHERE TSB.SubIFace = 'DownTime' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TICD.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_DownTime'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_DownTime] TICD 
				WHERE TSB.SubIFace = 'DownTime' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TICD.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END

		ELSE IF( @SubIFace = 'MeterData' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIMD.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_MeterData] TIMD
			WHERE TSB.SubIFace = 'MeterData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIMD.TranStatus = 1
			AND TIMD.RecordDate <= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_MeterData'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_MeterData] TIMD 
				WHERE TSB.SubIFace = 'MeterData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIMD.TranStatus = 1
				AND TIMD.RecordDate <= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		ELSE IF( @SubIFace = 'InjectionData' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TID.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_InjectionData] TID
			WHERE TSB.SubIFace = 'InjectionData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TID.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_InjectionData'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_InjectionData] TID 
				WHERE TSB.SubIFace = 'InjectionData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TID.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		ELSE IF( @SubIFace = 'WellData' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWD.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_WellData] TIWD
			WHERE TSB.SubIFace = 'WellData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWD.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_WellData'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_WellData] TIWD 
				WHERE TSB.SubIFace = 'WellData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWD.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		ELSE IF( @SubIFace = 'WellStatusChanges' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWSC.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_WellStatusChanges] TIWSC
			WHERE TSB.SubIFace = 'WellStatusChanges' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWSC.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_WellStatusChanges'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_WellStatusChanges] TIWSC 
				WHERE TSB.SubIFace = 'WellStatusChanges' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWSC.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		ELSE IF( @SubIFace = 'GasAnalysisData' AND @ConnType = 'Database')
		BEGIN

			SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWSC.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
			FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_GasAnalysisData] TIWSC
			WHERE TSB.SubIFace = 'GasAnalysisData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWSC.TranStatus = 1
			--AND TIWT.TranDate >= GETDATE()

			SET @RecCount = @@ROWCOUNT
			SET @IFaceTableName = 'tbl_IFace_GasAnalysisData'


			SET @IFaceBatchUIDXml = CAST(
			(
				SELECT 
				distinct IFaceBatchUID 
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_GasAnalysisData] TIWSC 
				WHERE TSB.SubIFace = 'GasAnalysisData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ProCount' AND TIWSC.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()
				FOR XML PATH (''), ROOT('IFaceBatchUIDS')
			) AS NVARCHAR(MAX))

		END
		

	END
	ELSE 
	IF (@SubscriberName = 'ONECALPS')
	 BEGIN
		 IF( @SubIFace = 'TankRunTicket' AND @ConnType = 'Database')
			BEGIN

				SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWSC.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_TankRunTicket] TIWSC
				WHERE TSB.SubIFace = 'TankRunTicket' AND TSB.ConnType = 'Database' AND SubscriberName = 'ONECALPS' AND TIWSC.TranStatus = 1
				----AND TIWT.TranDate >= GETDATE()

				SET @RecCount = @@ROWCOUNT
				SET @IFaceTableName = 'tbl_IFace_TankRunTicket'


				SET @IFaceBatchUIDXml = CAST(
				(
					SELECT 
					distinct IFaceBatchUID 
					FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_TankRunTicket] TIWSC 
					WHERE TSB.SubIFace = 'TankRunTicket' AND TSB.ConnType = 'Database' AND SubscriberName = 'ONECALPS' AND TIWSC.TranStatus = 1
					--AND TIWT.TranDate >= GETDATE()
					FOR XML PATH (''), ROOT('IFaceBatchUIDS')
				) AS NVARCHAR(MAX))

			END
			ELSE IF( @SubIFace = 'GasLoaderTrans' AND @ConnType = 'Database')
			BEGIN

				SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWSC.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_GasLoaderTrans] TIWSC
				WHERE TSB.SubIFace = 'GasLoaderTrans' AND TSB.ConnType = 'Database' AND SubscriberName = 'ONECALPS' AND TIWSC.TranStatus = 1
				--AND TIWT.TranDate >= GETDATE()

				SET @RecCount = @@ROWCOUNT
				SET @IFaceTableName = 'tbl_IFace_GasLoaderTrans'


				SET @IFaceBatchUIDXml = CAST(
				(
					SELECT 
					distinct IFaceBatchUID 
					FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_TankRunTicket] TIWSC 
					WHERE TSB.SubIFace = 'GasLoaderTrans' AND TSB.ConnType = 'Database' AND SubscriberName = 'ONECALPS' AND TIWSC.TranStatus = 1
					--AND TIWT.TranDate >= GETDATE()
					FOR XML PATH (''), ROOT('IFaceBatchUIDS')
				) AS NVARCHAR(MAX))

			END
		END
		ELSE IF (@SubscriberName = 'ODS')
	    BEGIN
		  IF( @SubIFace = 'GasAnalysisData' AND @ConnType = 'Database')
			BEGIN

				SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWSC.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_GasAnalysisData] TIWSC
				WHERE TSB.SubIFace = 'GasAnalysisData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ODS' AND TIWSC.TranStatus = 1
				----AND TIWT.TranDate >= GETDATE()

				SET @RecCount = @@ROWCOUNT
				SET @IFaceTableName = 'tbl_IFace_GasAnalysisData'


				SET @IFaceBatchUIDXml = CAST(
				(
					SELECT 
					distinct IFaceBatchUID 
					FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_GasAnalysisData] TIWSC 
					WHERE TSB.SubIFace = 'GasAnalysisData' AND TSB.ConnType = 'Database' AND SubscriberName = 'ODS' AND TIWSC.TranStatus = 1
					--AND TIWT.TranDate >= GETDATE()
					FOR XML PATH (''), ROOT('IFaceBatchUIDS')
				) AS NVARCHAR(MAX))

			END
			ELSE IF( @SubIFace = 'ODSDownTimeDetails' AND @ConnType = 'Database')
			BEGIN

				SELECT IFaceBatchUID,SubID,SubIFace,TransID,TransSeq,PubID,TSB.SubConnID,TIWSC.PubConnID, GETDATE() CreatedTime, CURRENT_USER CreatedBy
				FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P] TIWSC
				WHERE TSB.SubIFace = 'ODSDownTimeDetails' AND TSB.ConnType = 'Database' AND SubscriberName = 'ODS' AND TIWSC.TranStatus = 1
				----AND TIWT.TranDate >= GETDATE()

				SET @RecCount = @@ROWCOUNT
				SET @IFaceTableName = 'tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P'


				SET @IFaceBatchUIDXml = CAST(
				(
					SELECT 
					distinct IFaceBatchUID 
					FROM [dbo].[tbl_SubscriberController] TSB, [dbo].[tbl_IFace_ODS_LOAD_DOWNTIME_DETAILS_P] TIWSC 
					WHERE TSB.SubIFace = 'ODSDownTimeDetails' AND TSB.ConnType = 'Database' AND SubscriberName = 'ODS' AND TIWSC.TranStatus = 1
					--AND TIWT.TranDate >= GETDATE()
					FOR XML PATH (''), ROOT('IFaceBatchUIDS')
				) AS NVARCHAR(MAX))

			END
	    END

END TRY  
BEGIN CATCH 

	INSERT INTO [CIDS].[dbo].[tbl_ErrorLog] (SubID, SubConnID, ConnType , ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity, ErrorTime, MachineName, CreatedBy) 
	VALUES ( @SubID, @SubConnID, @ConnType, 'USP_MoveIFaceDataToMsgQ','StoredProcedure',@SubIFace,'Error while moving IFace Data to MsgQ',ERROR_MESSAGE(), ERROR_NUMBER(),ERROR_SEVERITY(), GETDATE(),HOST_NAME(), CURRENT_USER)

END CATCH