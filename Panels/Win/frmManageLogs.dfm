object ManageLogsFrm: TManageLogsFrm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Log Management..'
  ClientHeight = 290
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 168
    Top = 8
    Width = 40
    Height = 15
    Caption = 'Nard ID'
  end
  object Label2: TLabel
    Left = 168
    Top = 176
    Width = 62
    Height = 15
    Caption = 'Older than..'
  end
  object btnClose: TButton
    Left = 272
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object cbAllNards: TCheckBox
    Left = 40
    Top = 24
    Width = 97
    Height = 17
    Caption = 'All'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = cbAllNardsClick
  end
  object edNardID: TEdit
    Left = 168
    Top = 24
    Width = 121
    Height = 23
    Enabled = False
    TabOrder = 2
    Text = '0'
  end
  object rgType: TRadioGroup
    Left = 77
    Top = 65
    Width = 153
    Height = 105
    Caption = 'Log'
    ItemIndex = 0
    Items.Strings = (
      'Data Values'
      'Images'
      'Hashes')
    TabOrder = 3
  end
  object cbAllData: TCheckBox
    Left = 40
    Top = 192
    Width = 97
    Height = 17
    Caption = 'All'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = cbAllDataClick
  end
  object dtStart: TDateTimePicker
    Left = 161
    Top = 192
    Width = 186
    Height = 23
    Date = 44999.000000000000000000
    Time = 0.413785104166891000
    Enabled = False
    Kind = dtkDateTime
    TabOrder = 5
  end
  object Delete: TButton
    Left = 40
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 6
    OnClick = DeleteClick
  end
end
