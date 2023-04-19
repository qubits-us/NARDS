object dmDB: TdmDB
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object dbConn: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    Properties.Strings = (
      'dialect=3'
      'FirebirdAPI=legacy'
      'RawStringEncoding=DB_CP')
    TransactIsolationLevel = tiReadCommitted
    HostName = '192.168.0.51'
    Port = 0
    Database = 'NARDS'
    User = 'SYSDBA'
    Password = 'qubits'
    Protocol = 'firebird'
    Left = 24
    Top = 16
  end
  object ArdsQry: TZQuery
    Connection = dbConn
    Sequence = seqArds
    SequenceField = 'ARDID'
    SQL.Strings = (
      'select * from ards')
    Params = <>
    Left = 96
    Top = 16
    object ArdsQryARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object ArdsQryGROUPID: TZIntegerField
      FieldName = 'GROUPID'
      Required = True
    end
    object ArdsQryPROCESSID: TZIntegerField
      FieldName = 'PROCESSID'
      Required = True
    end
    object ArdsQryDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
    object ArdsQryLASTIP: TZUnicodeStringField
      FieldName = 'LASTIP'
      Size = 12
    end
    object ArdsQryLASTCONNECTION: TZDateTimeField
      FieldName = 'LASTCONNECTION'
    end
    object ArdsQryONLINE: TZBooleanField
      FieldName = 'ONLINE'
    end
    object ArdsQryFIRMWARE: TZBCDField
      FieldName = 'FIRMWARE'
      Precision = 8
    end
  end
  object tblNardDetails: TZTable
    SortedFields = 'ARDID'
    Connection = dbConn
    Transaction = dbTrans
    TableName = 'ARDS'
    IndexFieldNames = 'ARDID Asc'
    Left = 232
    Top = 16
    object tblNardDetailsARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object tblNardDetailsGROUPID: TZIntegerField
      FieldName = 'GROUPID'
      Required = True
    end
    object tblNardDetailsPROCESSID: TZIntegerField
      FieldName = 'PROCESSID'
      Required = True
    end
    object tblNardDetailsDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
    object tblNardDetailsLASTIP: TZUnicodeStringField
      FieldName = 'LASTIP'
      Size = 12
    end
    object tblNardDetailsLASTCONNECTION: TZDateTimeField
      FieldName = 'LASTCONNECTION'
    end
    object tblNardDetailsONLINE: TZBooleanField
      FieldName = 'ONLINE'
    end
    object tblNardDetailsFIRMWARE: TZBCDField
      FieldName = 'FIRMWARE'
      Precision = 8
    end
  end
  object seqArds: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_ARD_ID'
    Left = 40
    Top = 408
  end
  object seqLogs: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_LOG_ID'
    Left = 40
    Top = 296
  end
  object LogsQry: TZQuery
    Connection = dbConn
    Sequence = seqLogs
    SequenceField = 'LOGID'
    SQL.Strings = (
      'select * from logdata')
    Params = <>
    Left = 160
    Top = 16
    object LogsQrySTAMP: TZDateTimeField
      FieldName = 'STAMP'
    end
    object LogsQryARDID: TZIntegerField
      FieldName = 'ARDID'
    end
    object LogsQryVALUETYPE: TZIntegerField
      FieldName = 'VALUETYPE'
    end
    object LogsQryVALUEINDEX: TZIntegerField
      FieldName = 'VALUEINDEX'
    end
    object LogsQryVALUEINT: TZInt64Field
      FieldName = 'VALUEINT'
    end
    object LogsQryVALUEFLOAT: TZDoubleField
      FieldName = 'VALUEFLOAT'
    end
  end
  object dbTrans: TZTransaction
    Connection = dbConn
    AutoCommit = True
    Left = 24
    Top = 80
  end
  object rptLogs: TfrxReport
    Version = '2022.2.7'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'HP DeskJet 2130 series'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 44994.585963588000000000
    ReportOptions.LastChange = 45034.431941898150000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 400
    Top = 416
    Datasets = <
      item
        DataSet = dsLogs
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 86.929190000000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 3.779530000000000000
          Width = 188.976500000000000000
          Height = 30.236240000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = []
          Memo.UTF8W = (
            'Nards - Log Data')
          ParentFont = False
        end
        object SysMemo1: TfrxSysMemoView
          AllowVectorExport = True
          Left = 585.827150000000000000
          Top = 3.779530000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[DATE]')
          ParentFont = False
        end
        object SysMemo2: TfrxSysMemoView
          AllowVectorExport = True
          Left = 585.827150000000000000
          Top = 30.236240000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[TIME]')
          ParentFont = False
        end
        object SysMemo3: TfrxSysMemoView
          AllowVectorExport = True
          Left = 585.827150000000000000
          Top = 56.692950000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[PAGE#] of [TOTALPAGES#]')
          ParentFont = False
        end
      end
      object ColumnHeader1: TfrxColumnHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 128.504020000000000000
        Width = 740.409927000000000000
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Width = 136.063080000000000000
          Height = 18.897637795275600000
          Frame.Typ = []
          Memo.UTF8W = (
            'Date / Time')
        end
        object Memo8: TfrxMemoView
          AllowVectorExport = True
          Left = 166.299320000000000000
          Width = 22.677180000000000000
          Height = 18.897637800000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'ID')
        end
        object Memo9: TfrxMemoView
          AllowVectorExport = True
          Left = 204.094620000000000000
          Width = 37.795300000000000000
          Height = 18.897637800000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Index')
        end
        object Memo10: TfrxMemoView
          AllowVectorExport = True
          Left = 434.645950000000000000
          Width = 86.929190000000000000
          Height = 18.897637800000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Integer')
        end
        object Memo11: TfrxMemoView
          AllowVectorExport = True
          Left = 555.590910000000000000
          Width = 94.488250000000000000
          Height = 18.897637800000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Float')
        end
        object Memo13: TfrxMemoView
          AllowVectorExport = True
          Left = 253.228510000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Name')
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 18.897674410000000000
        Top = 211.653680000000000000
        Width = 740.409927000000000000
        DataSet = dsLogs
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 166.299320000000000000
          Top = 0.000024410000000002
          Width = 34.015770000000000000
          Height = 15.118120000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."ARDID"]')
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 204.094620000000000000
          Top = 0.000024410000000002
          Width = 37.795300000000000000
          Height = 15.118110236220470000
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."VALUEINDEX"]')
        end
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 434.645950000000000000
          Top = 0.000024410000000002
          Width = 109.606370000000000000
          Height = 15.118110236220470000
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."VALUEINT"]')
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 555.590910000000000000
          Top = 0.000024410000000002
          Width = 147.401670000000000000
          Height = 15.118110236220470000
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."VALUEFLOAT"]')
        end
        object Memo12: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Width = 154.960730000000000000
          Height = 15.118110240000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."STAMP"]')
        end
        object frxDBDataset1DISPLAYNAME: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 249.448980000000000000
          Width = 158.740260000000000000
          Height = 15.118110236220470000
          DataField = 'DISPLAYNAME'
          DataSet = dsLogs
          DataSetName = 'frxDBDataset1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."DISPLAYNAME"]')
        end
      end
    end
  end
  object dsLogs: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSet = qryLogRpt
    BCDToCurrency = False
    DataSetOptions = []
    Left = 496
    Top = 416
  end
  object qryLogRpt: TZQuery
    Connection = dbConn
    SQL.Strings = (
      
        'SELECT r.STAMP, r.ARDID, r.VALUETYPE, r.VALUEINDEX, r.VALUEINT,r' +
        '.VALUEFLOAT, a.DISPLAYNAME'
      'FROM LOGDATA r'
      
        'join ARDVALUES a on r.ARDID = a.ARDID and r.VALUEINDEX = a.VALIN' +
        'DEX'
      '')
    Params = <>
    Left = 496
    Top = 344
    object qryLogRptSTAMP: TZDateTimeField
      FieldName = 'STAMP'
    end
    object qryLogRptARDID: TZIntegerField
      FieldName = 'ARDID'
    end
    object qryLogRptVALUETYPE: TZIntegerField
      FieldName = 'VALUETYPE'
    end
    object qryLogRptVALUEINDEX: TZIntegerField
      FieldName = 'VALUEINDEX'
    end
    object qryLogRptVALUEINT: TZInt64Field
      FieldName = 'VALUEINT'
    end
    object qryLogRptVALUEFLOAT: TZDoubleField
      FieldName = 'VALUEFLOAT'
    end
    object qryLogRptDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
  end
  object mtReportTitle: TZMemTable
    Connection = dbConn
    Left = 496
    Top = 272
    object mtReportTitleLocation: TStringField
      FieldName = 'Location'
      Size = 40
    end
    object mtReportTitleReportRange: TStringField
      FieldName = 'ReportRange'
      Size = 100
    end
  end
  object dsLogTitle: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSet = mtReportTitle
    BCDToCurrency = False
    DataSetOptions = []
    Left = 496
    Top = 200
  end
  object frxUserDataSet1: TfrxUserDataSet
    UserName = 'frxUserDataSet1'
    Left = 496
    Top = 136
  end
  object qryGen: TZQuery
    Connection = dbConn
    Params = <>
    Left = 96
    Top = 80
  end
  object seqCommands: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_COMMAND_ID'
    Left = 40
    Top = 344
  end
  object qryCommands: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from ardcommands')
    Params = <>
    Left = 176
    Top = 88
    object qryCommandsCOMMANDID: TZIntegerField
      FieldName = 'COMMANDID'
      Required = True
    end
    object qryCommandsARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object qryCommandsCOMMAND: TZSmallIntField
      FieldName = 'COMMAND'
    end
    object qryCommandsOP1: TZSmallIntField
      FieldName = 'OP1'
    end
    object qryCommandsOP2: TZSmallIntField
      FieldName = 'OP2'
    end
    object qryCommandsOP3: TZSmallIntField
      FieldName = 'OP3'
    end
    object qryCommandsOP4: TZSmallIntField
      FieldName = 'OP4'
    end
    object qryCommandsVALUEINT: TZInt64Field
      FieldName = 'VALUEINT'
    end
    object qryCommandsVALUEFLOAT: TZDoubleField
      FieldName = 'VALUEFLOAT'
    end
  end
  object qryNardValues: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from ArdValues')
    Params = <>
    Left = 312
    Top = 80
    object qryNardValuesARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object qryNardValuesVALINDEX: TZIntegerField
      FieldName = 'VALINDEX'
      Required = True
    end
    object qryNardValuesDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
    object qryNardValuesVALUEINT: TZInt64Field
      FieldName = 'VALUEINT'
    end
    object qryNardValuesVALUEFLOAT: TZDoubleField
      FieldName = 'VALUEFLOAT'
    end
  end
  object qryScreens: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from Screens')
    Params = <>
    Left = 128
    Top = 152
    object qryScreensSCREENID: TZIntegerField
      FieldName = 'SCREENID'
      Required = True
    end
    object qryScreensDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
  end
  object qryScreenItems: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from ScreenItems')
    Params = <>
    Left = 32
    Top = 152
    object qryScreenItemsSCREENID: TZIntegerField
      FieldName = 'SCREENID'
      Required = True
    end
    object qryScreenItemsITEMID: TZIntegerField
      FieldName = 'ITEMID'
      Required = True
    end
    object qryScreenItemsARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object qryScreenItemsDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
    object qryScreenItemsPOSLEFT: TZIntegerField
      FieldName = 'POSLEFT'
    end
    object qryScreenItemsPOSTOP: TZIntegerField
      FieldName = 'POSTOP'
    end
    object qryScreenItemsHEIGHT: TZIntegerField
      FieldName = 'HEIGHT'
    end
    object qryScreenItemsWIDTH: TZIntegerField
      FieldName = 'WIDTH'
    end
    object qryScreenItemsOFFLINEIMG: TZUnicodeStringField
      FieldName = 'OFFLINEIMG'
      Size = 200
    end
    object qryScreenItemsONLINEIMG: TZUnicodeStringField
      FieldName = 'ONLINEIMG'
      Size = 200
    end
    object qryScreenItemsALERTIMG: TZUnicodeStringField
      FieldName = 'ALERTIMG'
      Size = 200
    end
    object qryScreenItemsONIMG: TZUnicodeStringField
      FieldName = 'ONIMG'
      Size = 200
    end
    object qryScreenItemsOFFIMG: TZUnicodeStringField
      FieldName = 'OFFIMG'
      Size = 200
    end
    object qryScreenItemsSHOWNAME: TZBooleanField
      FieldName = 'SHOWNAME'
    end
    object qryScreenItemsDNLEFT: TZIntegerField
      FieldName = 'DNLEFT'
    end
    object qryScreenItemsDNTOP: TZIntegerField
      FieldName = 'DNTOP'
    end
    object qryScreenItemsDNSIZE: TZIntegerField
      FieldName = 'DNSIZE'
    end
    object qryScreenItemsACTIONID: TZIntegerField
      FieldName = 'ACTIONID'
    end
    object qryScreenItemsACTIONVAL: TZIntegerField
      FieldName = 'ACTIONVAL'
    end
    object qryScreenItemsACTIONVALTYPE: TZIntegerField
      FieldName = 'ACTIONVALTYPE'
    end
    object qryScreenItemsACTIONVALMIN: TZIntegerField
      FieldName = 'ACTIONVALMIN'
    end
    object qryScreenItemsACTIONVALMAX: TZIntegerField
      FieldName = 'ACTIONVALMAX'
    end
    object qryScreenItemsACTIONVALSTEP: TZIntegerField
      FieldName = 'ACTIONVALSTEP'
    end
    object qryScreenItemsPARAMUP1: TZIntegerField
      FieldName = 'PARAMUP1'
    end
    object qryScreenItemsPARAMUP2: TZIntegerField
      FieldName = 'PARAMUP2'
    end
    object qryScreenItemsPARAMUP3: TZIntegerField
      FieldName = 'PARAMUP3'
    end
    object qryScreenItemsPARAMUP4: TZIntegerField
      FieldName = 'PARAMUP4'
    end
  end
  object seqScreens: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_SCREEN_ID'
    Left = 120
    Top = 416
  end
  object qryImg: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from LogImg')
    Params = <>
    Left = 416
    Top = 40
    object qryImgSTAMP: TZDateTimeField
      FieldName = 'STAMP'
    end
    object qryImgARDID: TZIntegerField
      FieldName = 'ARDID'
    end
    object qryImgIMAGE: TZBlobField
      FieldName = 'IMAGE'
    end
  end
  object qryScreenVals: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from ScreenValues')
    Params = <>
    Left = 32
    Top = 224
    object qryScreenValsSCREENID: TZIntegerField
      FieldName = 'SCREENID'
      Required = True
    end
    object qryScreenValsITEMID: TZIntegerField
      FieldName = 'ITEMID'
      Required = True
    end
    object qryScreenValsARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object qryScreenValsVALINDEX: TZIntegerField
      FieldName = 'VALINDEX'
      Required = True
    end
    object qryScreenValsVALUETYPE: TZIntegerField
      FieldName = 'VALUETYPE'
    end
    object qryScreenValsDISPLAYNUM: TZIntegerField
      FieldName = 'DISPLAYNUM'
    end
    object qryScreenValsTRIGIVAL: TZIntegerField
      FieldName = 'TRIGIVAL'
    end
    object qryScreenValsTRIGFVAL: TZSingleField
      FieldName = 'TRIGFVAL'
    end
    object qryScreenValsTRIGCALC: TZIntegerField
      FieldName = 'TRIGCALC'
    end
    object qryScreenValsTRIGTYPE: TZIntegerField
      FieldName = 'TRIGTYPE'
    end
    object qryScreenValsPOSLEFT: TZIntegerField
      FieldName = 'POSLEFT'
    end
    object qryScreenValsPOSTOP: TZIntegerField
      FieldName = 'POSTOP'
    end
    object qryScreenValsFONTSIZE: TZIntegerField
      FieldName = 'FONTSIZE'
    end
    object qryScreenValsFONTCOLOR: TZIntegerField
      FieldName = 'FONTCOLOR'
    end
    object qryScreenValsSVID: TZIntegerField
      FieldName = 'SVID'
      Required = True
    end
  end
  object qryScrnV: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'SELECT r.SCREENID, r.ITEMID, r.ARDID, r.VALINDEX, r.VALUETYPE,'
      
        '    r.DISPLAYNUM, r.TRIGIVAL, r.TRIGFVAL, r.TRIGCALC, r.TRIGTYPE' +
        ', r.POSLEFT,'
      '    r.POSTOP, r.FONTSIZE, r.FONTCOLOR, r.SVID,'
      
        '    (select a.ValueInt from ArdValues a where a.ARDID=r.ARDID an' +
        'd a.VALINDEX = r.VALINDEX ) as ValI,'
      
        '    (select a.ValueFloat from ArdValues a where a.ARDID=r.ARDID ' +
        'and a.VALINDEX = r.VALINDEX ) as ValF'
      'FROM SCREENVALUES r where r.SCREENID =:SID AND r.ITEMID =:IID')
    Params = <
      item
        DataType = ftInteger
        Name = 'SID'
        ParamType = ptInput
        SQLType = stInteger
        Value = 0
      end
      item
        DataType = ftInteger
        Name = 'IID'
        ParamType = ptInput
        SQLType = stInteger
        Value = 0
      end>
    Left = 128
    Top = 224
    ParamData = <
      item
        DataType = ftInteger
        Name = 'SID'
        ParamType = ptInput
        SQLType = stInteger
        Value = 0
      end
      item
        DataType = ftInteger
        Name = 'IID'
        ParamType = ptInput
        SQLType = stInteger
        Value = 0
      end>
    object qryScrnVSCREENID: TZIntegerField
      FieldName = 'SCREENID'
      Required = True
    end
    object qryScrnVITEMID: TZIntegerField
      FieldName = 'ITEMID'
      Required = True
    end
    object qryScrnVARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object qryScrnVVALINDEX: TZIntegerField
      FieldName = 'VALINDEX'
      Required = True
    end
    object qryScrnVVALUETYPE: TZIntegerField
      FieldName = 'VALUETYPE'
    end
    object qryScrnVDISPLAYNUM: TZIntegerField
      FieldName = 'DISPLAYNUM'
    end
    object qryScrnVTRIGIVAL: TZIntegerField
      FieldName = 'TRIGIVAL'
    end
    object qryScrnVTRIGFVAL: TZSingleField
      FieldName = 'TRIGFVAL'
    end
    object qryScrnVTRIGCALC: TZIntegerField
      FieldName = 'TRIGCALC'
    end
    object qryScrnVTRIGTYPE: TZIntegerField
      FieldName = 'TRIGTYPE'
    end
    object qryScrnVPOSLEFT: TZIntegerField
      FieldName = 'POSLEFT'
    end
    object qryScrnVPOSTOP: TZIntegerField
      FieldName = 'POSTOP'
    end
    object qryScrnVFONTSIZE: TZIntegerField
      FieldName = 'FONTSIZE'
    end
    object qryScrnVFONTCOLOR: TZIntegerField
      FieldName = 'FONTCOLOR'
    end
    object qryScrnVSVID: TZIntegerField
      FieldName = 'SVID'
      Required = True
    end
    object qryScrnVVALI: TZInt64Field
      FieldName = 'VALI'
    end
    object qryScrnVVALF: TZDoubleField
      FieldName = 'VALF'
    end
  end
  object seqItemId: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_SCREENITEMS_ID'
    Left = 192
    Top = 424
  end
  object seqScreenVals: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_SCREENVALUES_ID'
    Left = 120
    Top = 352
  end
  object qrySourceList: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'Select * from Sketches')
    Params = <>
    Left = 216
    Top = 152
    object qrySourceListSKETCHID: TZIntegerField
      FieldName = 'SKETCHID'
      Required = True
    end
    object qrySourceListSTAMP: TZDateTimeField
      FieldName = 'STAMP'
      Required = True
    end
    object qrySourceListARDID: TZIntegerField
      FieldName = 'ARDID'
    end
    object qrySourceListVER: TZBCDField
      FieldName = 'VER'
      Precision = 8
    end
    object qrySourceListFILENAME: TZUnicodeStringField
      FieldName = 'FILENAME'
      Size = 512
    end
    object qrySourceListSKETCH: TZBlobField
      FieldName = 'SKETCH'
    end
  end
  object seqSketchID: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_SKETCH_ID'
    Left = 120
    Top = 296
  end
  object qryFirmwareList: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from Firmwares')
    Params = <>
    Left = 216
    Top = 216
    object qryFirmwareListFIRMID: TZIntegerField
      FieldName = 'FIRMID'
      Required = True
    end
    object qryFirmwareListSTAMP: TZDateTimeField
      FieldName = 'STAMP'
      Required = True
    end
    object qryFirmwareListARDID: TZIntegerField
      FieldName = 'ARDID'
    end
    object qryFirmwareListVER: TZBCDField
      FieldName = 'VER'
      Precision = 8
    end
    object qryFirmwareListFIRMWARE: TZBlobField
      FieldName = 'FIRMWARE'
    end
    object qryFirmwareListFILENAME: TZUnicodeStringField
      FieldName = 'FILENAME'
      Size = 200
    end
    object qryFirmwareListNOTE: TZUnicodeStringField
      FieldName = 'NOTE'
      Size = 500
    end
  end
  object seqFirmwareId: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_FIRMWARE_ID'
    Left = 192
    Top = 360
  end
  object qryHashes: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from hashes')
    Params = <>
    Left = 320
    Top = 160
    object qryHashesHASHID: TZIntegerField
      FieldName = 'HASHID'
      Required = True
    end
    object qryHashesHASH: TZInt64Field
      FieldName = 'HASH'
      Required = True
    end
    object qryHashesGROUPID: TZIntegerField
      FieldName = 'GROUPID'
    end
    object qryHashesDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
    object qryHashesACCESSLEVEL: TZIntegerField
      FieldName = 'ACCESSLEVEL'
    end
    object qryHashesLASTACCESS: TZDateTimeField
      FieldName = 'LASTACCESS'
    end
  end
  object seqHashId: TZSequence
    Connection = dbConn
    SequenceName = 'GEN_HASH_ID'
    Left = 200
    Top = 296
  end
  object qryLogView: TZQuery
    Connection = dbConn
    Params = <>
    Left = 328
    Top = 248
  end
  object qryNardParams: TZQuery
    Connection = dbConn
    SQL.Strings = (
      'select * from ArdParams')
    Params = <>
    Left = 400
    Top = 112
    object qryNardParamsARDID: TZIntegerField
      FieldName = 'ARDID'
      Required = True
    end
    object qryNardParamsPARAMINDEX: TZIntegerField
      FieldName = 'PARAMINDEX'
      Required = True
    end
    object qryNardParamsDISPLAYNAME: TZUnicodeStringField
      FieldName = 'DISPLAYNAME'
    end
    object qryNardParamsPARAM1: TZIntegerField
      FieldName = 'PARAM1'
    end
    object qryNardParamsPARAM2: TZIntegerField
      FieldName = 'PARAM2'
    end
    object qryNardParamsPARAM3: TZIntegerField
      FieldName = 'PARAM3'
    end
    object qryNardParamsPARAM4: TZIntegerField
      FieldName = 'PARAM4'
    end
  end
  object sckUDP: TWSocket
    LineEnd = #13#10
    Addr = '192.168.0.255'
    Port = '12010'
    Proto = 'udp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    SocksLevel = '5'
    ExclusiveAddr = False
    ComponentOptions = []
    ListenBacklog = 15
    SocketErrs = wsErrTech
    Left = 512
    Top = 40
  end
end
