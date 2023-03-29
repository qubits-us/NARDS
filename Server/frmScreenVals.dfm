object ScreenValsFrm: TScreenValsFrm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Screen item value...'
  ClientHeight = 379
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblIndex: TLabel
    Left = 16
    Top = 11
    Width = 29
    Height = 15
    Caption = 'Index'
  end
  object lblType: TLabel
    Left = 16
    Top = 61
    Width = 24
    Height = 15
    Caption = 'Type'
  end
  object lblDisplay: TLabel
    Left = 16
    Top = 107
    Width = 38
    Height = 15
    Caption = 'Display'
  end
  object lblTrigVal: TLabel
    Left = 16
    Top = 157
    Width = 67
    Height = 15
    Caption = 'Trigger Value'
  end
  object lblTrigType: TLabel
    Left = 16
    Top = 207
    Width = 63
    Height = 15
    Caption = 'Trigger Type'
  end
  object lblTop: TLabel
    Left = 16
    Top = 256
    Width = 19
    Height = 15
    Caption = 'Top'
  end
  object lblLeft: TLabel
    Left = 152
    Top = 257
    Width = 20
    Height = 15
    Caption = 'Left'
  end
  object lblFontColor: TLabel
    Left = 152
    Top = 302
    Width = 56
    Height = 15
    Caption = 'Font Color'
  end
  object lblFontSize: TLabel
    Left = 16
    Top = 302
    Width = 47
    Height = 15
    Caption = 'Font Size'
  end
  object btnCancel: TButton
    Left = 198
    Top = 349
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 16
    Top = 349
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object rgCalcType: TRadioGroup
    Left = 176
    Top = 117
    Width = 81
    Height = 105
    Caption = 'Calc Trig'
    ItemIndex = 0
    Items.Strings = (
      '>'
      '='
      '<')
    TabOrder = 2
  end
  object edIndex: TEdit
    Left = 16
    Top = 32
    Width = 121
    Height = 23
    TabOrder = 3
    Text = '0'
  end
  object cmbType: TComboBox
    Left = 16
    Top = 82
    Width = 145
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = 'Integer'
    Items.Strings = (
      'Integer'
      'Float')
  end
  object edDisplay: TEdit
    Left = 16
    Top = 128
    Width = 121
    Height = 23
    TabOrder = 5
    Text = '0'
  end
  object edTrigVal: TEdit
    Left = 16
    Top = 178
    Width = 121
    Height = 23
    TabOrder = 6
    Text = '0'
  end
  object cmbTrigType: TComboBox
    Left = 16
    Top = 228
    Width = 145
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 7
    Text = 'none'
    Items.Strings = (
      'none'
      'on'
      'alert')
  end
  object edTop: TEdit
    Left = 16
    Top = 277
    Width = 121
    Height = 23
    TabOrder = 8
    Text = '0'
  end
  object edLeft: TEdit
    Left = 152
    Top = 278
    Width = 121
    Height = 23
    TabOrder = 9
    Text = '0'
  end
  object edFontSize: TEdit
    Left = 16
    Top = 320
    Width = 121
    Height = 23
    TabOrder = 10
    Text = '10'
  end
  object edFontColor: TEdit
    Left = 152
    Top = 320
    Width = 121
    Height = 23
    TabOrder = 11
    Text = '0'
  end
end
