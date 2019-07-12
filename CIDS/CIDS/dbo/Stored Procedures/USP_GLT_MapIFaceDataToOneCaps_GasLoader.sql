









CREATE PROCEDURE [dbo].[USP_GLT_MapIFaceDataToOneCaps_GasLoader]
@IFaceBatchUIDXml nvarchar(MAX) OUTPUT, @FormattedMsg nvarchar(MAX) OUTPUT, @PubID int OUTPUT, @SubID int OUTPUT, @ArchformattedMsg int = 0, @TotalRecCount int OUTPUT
WITH EXEC AS CALLER
AS
BEGIN TRY
  SELECT DISTINCT TMQ.IFaceBatchUID AS IFaceBatchUID,
                  TMQ.TransID,
                  TMQ.TransSeq,
                  TMQ.SubIFace,
                  TMQ.PubID,
                  TMQ.SubID,
                  TMQ.PubConnID,
                  TMQ.SubConnID,
                  TICD.trans_copy,
                  TICD.AllocActGravity AS gravity,
                  TICD.rc_user_key,
                  SUBSTRING(CONVERT(NVARCHAR(30), GETDATE(), 20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
                  SUBSTRING(CONVERT(NVARCHAR(30), GETDATE(), 20), 12, 8) AS UserTimeStamp,
                  'PROCOUNT' AS UserName,
                  TICD.ProductType,
                  TICD.DispositionCode,
                  TICD.DispositionCodeDescription,
                  TICD.sourcetype,
                  TICD.completionID,
                  TICD.GatheringSystemID,
                  TICD.AreaID,
                  TICD.AreaName,
                  TICD.GatheringSystemName,
                  TICD.activity_date,
                  TICD.BBL,
                  TICD.GAL,
                  TICD.MCF,
				  TICD.[MMBTU],
                  TICD.BTU_content,
                  TICD.BTU_pressure_base,
                  TICD.BTU_wet_dry_ind,
                  TICD.WellPlusCompletionName,
                  TICD.processing_party,
                  --TICD.rc_user_key,
                  TICD.Agr_Det_Sequence,
                  TICD.Agreement_ID,
                  TICD.decktype,
                  TICD.AllocationDateStamp,
                  TICD.AccountantPersonID,
                  TICD.GatheringSystemLockDate,
                  TICD.GatheringSystemLockName,
                  TICD.GatheringSystemAccountantName,
				  CAST(RTRIM(LTRIM(rc_user_key)) AS VARCHAR(50)) + '-' +CONVERT(VARCHAR,[activity_date],112) + '-'+CAST(UPPER(RTRIM(LTRIM([ProductType]))) AS VARCHAR(50)) +'-'+ CAST(RTRIM(LTRIM([Agreement_ID])) AS VARCHAR(50)) + '-'+CAST(UPPER(RTRIM(LTRIM([GatheringSystemName]))) AS VARCHAR(50))+'-'+ CAST([Agr_Det_Sequence] AS VARCHAR(50)) + '-' + CAST(UPPER([processing_party]) AS VARCHAR(50))+'-'+ CAST(RTRIM(LTRIM([WellPlusCompletionName])) AS VARCHAR(50))+ '-'+ CONVERT(VARCHAR,[GatheringSystemLockDate],112) AS UniqueColumn
                  --ROW_NUMBER() OVER (ORDER BY LocAccountNumber2 ASC) AS Line_No
  FROM   (SELECT TMQ.*
          FROM   [dbo].[tbl_MsgQueue] TMQ
                 LEFT JOIN [dbo].[tbl_SubscriberController] TSC ON TMQ.SubID = TSC.SubID AND TSC.SubscriberName = 'ONECALPS'
          WHERE  TMQ.SubIFace = 'GasLoaderTrans' AND TMQ.SubStatus IS NULL
          UNION
          SELECT TMQ1.*
          FROM   [dbo].[tbl_MsgQueue] TMQ1
                 INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
                   ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq = TERRQ.TransSeq
                      AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID AND TMQ1.PubConnID = TERRQ.PubConnID AND TMQ1.
                      SubIFace =
                      TERRQ.SubIFace AND TMQ1.SubIFace = 'GasLoaderTrans'
                 LEFT JOIN [dbo].[tbl_SubscriberController] TSC1 ON TMQ1.SubID = TSC1.SubID AND TSC1.SubscriberName = 'ONECALPS'
          WHERE  TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1) TMQ
INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD
           ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
  --WHERE  (TICD.Agr_Det_Sequence <> ' ' AND TICD.Agr_Det_Sequence <> 'NULL') and (TICD.rc_user_key <> 'NULL' AND TICD.rc_user_key
  --       <> ' ') and (TICD.processing_party <> 'NULL' AND TICD.processing_party <> ' ')

  SET @TotalRecCount    = @@ROWCOUNT

  SET @IFaceBatchUIDXml =
        CAST((SELECT DISTINCT TMQ.IFaceBatchUID
              FROM   (SELECT TMQ.*
                      FROM   [dbo].[tbl_MsgQueue] TMQ
                             LEFT JOIN [dbo].[tbl_SubscriberController] TSC
                               ON TMQ.SubID = TSC.SubID AND TSC.SubscriberName = 'ONECALPS'
                      WHERE  TMQ.SubIFace = 'GasLoaderTrans' AND TMQ.SubStatus IS NULL
                      UNION
                      SELECT TMQ1.*
                      FROM   [dbo].[tbl_MsgQueue] TMQ1
                             INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
                               ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq =
                                  TERRQ.TransSeq AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID AND TMQ1.PubConnID =
                                  TERRQ.PubConnID AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'GasLoaderTrans'
                             LEFT JOIN [dbo].[tbl_SubscriberController] TSC1
                               ON TMQ1.SubID = TSC1.SubID AND TSC1.SubscriberName = 'ONECALPS'
                      WHERE  TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1) TMQ
                     INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD
                       ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
              FOR XML PATH(''), ROOT ( 'IFaceBatchUIDS' )) AS NVARCHAR(MAX))

  IF (@ArchformattedMsg = 1)
    BEGIN
      SET @FormattedMsg =
            (SELECT TMQ.IFaceBatchUID AS IFaceBatchUID,
                    TMQ.SubIFace as SubIFace,
                    TMQ.TransSeq as TransSeq,
                    TMQ.TransID,
                    TMQ.TransSeq,
                    TMQ.SubIFace,
                    TMQ.PubID,
                    TMQ.SubID,
                    TMQ.PubConnID,
                    TMQ.SubConnID,
                    TICD.trans_copy,
                    TICD.AllocActGravity,
                    TICD.BBL,
                    TICD.GAL,
                    TICD.MCF,
					TICD.[MMBTU],
                    TICD.ProductType,
                    TICD.DispositionCode,
                    TICD.DispositionCodeDescription,
                    TICD.sourcetype,
                    TICD.completionID,
                    TICD.GatheringSystemID,
                    TICD.AreaID,
                    TICD.AreaName,
                    TICD.GatheringSystemName,
                    TICD.activity_date,
                    TICD.BTU_content,
                    TICD.BTU_pressure_base,
                    TICD.BTU_wet_dry_ind,
                    TICD.WellPlusCompletionName,
                    TICD.processing_party,
                    TICD.rc_user_key,
                    TICD.Agr_Det_Sequence,
                    TICD.Agreement_ID,
                    TICD.decktype,
                    TICD.AllocationDateStamp,
                    TICD.AccountantPersonID,
                    TICD.GatheringSystemLockDate,
                    TICD.GatheringSystemLockName,
                    TICD.GatheringSystemAccountantName,
                    SUBSTRING(CONVERT(NVARCHAR(30), GETDATE(), 20), 0, 11) + ' 00:00:00.000' AS UserDateStamp,
                    SUBSTRING(CONVERT(NVARCHAR(30), GETDATE(), 20), 12, 8) AS UserTimeStamp,
                    'ProCount' AS UserName
             FROM   (SELECT TMQ.*
                     FROM   [dbo].[tbl_MsgQueue] TMQ
                            LEFT JOIN [dbo].[tbl_SubscriberController] TSC
                              ON TMQ.SubID = TSC.SubID AND TSC.SubscriberName = 'ONECALPS'
                     WHERE  
                     TMQ.SubIFace = 'GasLoaderTrans' AND 
                     TMQ.SubStatus IS NULL
                     UNION
                     SELECT TMQ1.*
                     FROM   [dbo].[tbl_MsgQueue] TMQ1
                            INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
                              ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq =
                                 TERRQ.TransSeq AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID AND TMQ1.PubConnID =
                                 TERRQ.PubConnID AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'GasLoaderTrans'
                            LEFT JOIN [dbo].[tbl_SubscriberController] TSC1
                              ON TMQ1.SubID = TSC1.SubID AND TSC1.SubscriberName = 'ONECALPS'
                     WHERE  TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1) TMQ
                    INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD
                      ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID
             --WHERE  (TICD.Agr_Det_Sequence <> ' ' AND TICD.Agr_Det_Sequence <> 'NULL') and (TICD.rc_user_key <> 'NULL' AND TICD.rc_user_key <> ' ')
             FOR XML PATH('GasLoaderTrans_Record'), ROOT ( 'GasLoaderTrans_To_ProCount' ))
    END

  SELECT @PubID            = PubID, @SubID            = SubID
  FROM   (SELECT DISTINCT TMQ.PubID, TMQ.SubID
          FROM   (SELECT TMQ.*
                  FROM   [dbo].[tbl_MsgQueue] TMQ
                         LEFT JOIN [dbo].[tbl_SubscriberController] TSC
                           ON TMQ.SubID = TSC.SubID AND TSC.SubscriberName = 'ONECALPS'
                  WHERE  TMQ.SubIFace = 'GasLoaderTrans' AND TMQ.SubStatus IS NULL
                  UNION
                  SELECT TMQ1.*
                  FROM   [dbo].[tbl_MsgQueue] TMQ1
                         INNER JOIN [dbo].[tbl_ErrorQueue] TERRQ
                           ON TMQ1.IFaceBatchUID = TERRQ.IFaceBatchUID AND TMQ1.TransID = TERRQ.TransID AND TMQ1.TransSeq =
                              TERRQ.TransSeq AND TMQ1.SubID = TERRQ.SubID AND TMQ1.PubID = TERRQ.PubID AND TMQ1.PubConnID =
                              TERRQ.PubConnID AND TMQ1.SubIFace = TERRQ.SubIFace AND TMQ1.SubIFace = 'GasLoaderTrans'
                         LEFT JOIN [dbo].[tbl_SubscriberController] TSC1
                           ON TMQ1.SubID = TSC1.SubID AND TSC1.SubscriberName = 'ONECALPS'
                  WHERE  TMQ1.SubStatus = 'Failed' AND TERRQ.IsResubmit = 1) TMQ
                 INNER JOIN [dbo].[tbl_IFace_GasLoaderTrans] TICD
                   ON TMQ.TransID = TICD.TransID AND TMQ.TransSeq = TICD.TransSeq AND TMQ.IFaceBatchUID = TICD.IFaceBatchUID) A
END TRY
BEGIN CATCH
  INSERT INTO [CIDS].[dbo].[tbl_ErrorLog](ProcessName, ProcessType, MsgType, Title, ErrorMsg, ErrorNumber, ErrorSeverity,
                                          ErrorTime, MachineName, CreatedBy)
    VALUES      ('USP_GLT_MapIFaceDataToOneCaps_GasLoader', 'StoredProcedure', 'GasLoaderTrans',
                 'Error while fetching the subscriptions data from IFace table', ERROR_MESSAGE(), ERROR_NUMBER(),
                 ERROR_SEVERITY(), GETDATE(), HOST_NAME(),
                 CURRENT_USER)
END CATCH
