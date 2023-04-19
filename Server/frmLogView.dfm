object LogViewFrm: TLogViewFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'View Logs'
  ClientHeight = 441
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 296
    Width = 658
    Height = 145
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 536
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object mSQL: TMemo
      Left = 16
      Top = 6
      Width = 577
      Height = 100
      Lines.Strings = (
        
          'SELECT r.STAMP, r.ARDID, r.VALUETYPE, r.VALUEINDEX, r.VALUEINT,r' +
          '.VALUEFLOAT, a.DISPLAYNAME'
        'FROM LOGDATA r'
        
          'join ARDVALUES a on r.ARDID = a.ARDID and r.VALUEINDEX = a.VALIN' +
          'DEX')
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object BtnExecSQL: TButton
      Left = 16
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Exec SQL'
      TabOrder = 2
      OnClick = BtnExecSQLClick
    end
    object btnExport: TButton
      Left = 96
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Export'
      TabOrder = 3
      OnClick = btnExportClick
    end
  end
  object dgResult: TDBGrid
    Left = 0
    Top = 0
    Width = 658
    Height = 296
    Align = alClient
    DataSource = dsLogs
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dsLogs: TDataSource
    DataSet = dmDB.qryLogView
    Left = 576
    Top = 304
  end
  object dlgExportFile: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Comma Seperated Values|*.csv|Text|*.txt'
    FilterIndex = 0
    Title = 'Exporting results...'
    Left = 600
    Top = 360
  end
end
