object ReportLogsFrm: TReportLogsFrm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Log report...'
  ClientHeight = 273
  ClientWidth = 237
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblStart: TLabel
    Left = 16
    Top = 120
    Width = 24
    Height = 15
    Caption = 'Start'
  end
  object lblEnd: TLabel
    Left = 16
    Top = 170
    Width = 20
    Height = 15
    Caption = 'End'
  end
  object lblNards: TLabel
    Left = 89
    Top = 8
    Width = 39
    Height = 15
    Caption = 'Nard Id'
  end
  object Label2: TLabel
    Left = 89
    Top = 56
    Width = 29
    Height = 15
    Caption = 'Var Id'
  end
  object dtStart: TDateTimePicker
    Left = 16
    Top = 141
    Width = 186
    Height = 23
    Date = 44999.000000000000000000
    Time = 0.413785104166891000
    Kind = dtkDateTime
    TabOrder = 0
  end
  object dtEnd: TDateTimePicker
    Left = 16
    Top = 191
    Width = 186
    Height = 23
    Date = 44999.000000000000000000
    Time = 0.413834456019685600
    Kind = dtkDateTime
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 143
    Top = 237
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object btnPreview: TButton
    Left = 16
    Top = 237
    Width = 75
    Height = 25
    Caption = 'Preview'
    TabOrder = 3
    OnClick = btnPreviewClick
  end
  object edNards: TEdit
    Left = 89
    Top = 27
    Width = 121
    Height = 23
    Enabled = False
    TabOrder = 4
    Text = '1'
  end
  object cbAllNards: TCheckBox
    Left = 16
    Top = 28
    Width = 49
    Height = 17
    Caption = 'All'
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = cbAllNardsClick
  end
  object cbAllVars: TCheckBox
    Left = 16
    Top = 78
    Width = 49
    Height = 17
    Caption = 'All'
    Checked = True
    State = cbChecked
    TabOrder = 6
    OnClick = cbAllVarsClick
  end
  object edVarId: TEdit
    Left = 89
    Top = 77
    Width = 121
    Height = 23
    Enabled = False
    TabOrder = 7
    Text = '1'
  end
end
