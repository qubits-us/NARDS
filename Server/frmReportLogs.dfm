object ReportLogsFrm: TReportLogsFrm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Log report...'
  ClientHeight = 179
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblStart: TLabel
    Left = 24
    Top = 16
    Width = 24
    Height = 15
    Caption = 'Start'
  end
  object lblEnd: TLabel
    Left = 24
    Top = 66
    Width = 20
    Height = 15
    Caption = 'End'
  end
  object dtStart: TDateTimePicker
    Left = 24
    Top = 37
    Width = 186
    Height = 23
    Date = 44999.000000000000000000
    Time = 0.413785104166891000
    Kind = dtkDateTime
    TabOrder = 0
  end
  object dtEnd: TDateTimePicker
    Left = 24
    Top = 87
    Width = 186
    Height = 23
    Date = 44999.000000000000000000
    Time = 0.413834456019685600
    Kind = dtkDateTime
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 151
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object btnPreview: TButton
    Left = 8
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Preview'
    TabOrder = 3
    OnClick = btnPreviewClick
  end
end
