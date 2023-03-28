object GetStrFrm: TGetStrFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Enter new value'
  ClientHeight = 113
  ClientWidth = 271
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblCaption: TLabel
    Left = 8
    Top = 8
    Width = 92
    Height = 15
    Caption = 'Enter new value...'
  end
  object edValue: TEdit
    Left = 8
    Top = 29
    Width = 249
    Height = 23
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 182
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOk: TButton
    Left = 96
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = btnOkClick
  end
end
