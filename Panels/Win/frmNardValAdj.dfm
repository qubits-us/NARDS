object NardValAdjFrm: TNardValAdjFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSizeToolWin
  Caption = 'Nard value set...'
  ClientHeight = 155
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblValDesc: TLabel
    Left = 16
    Top = 32
    Width = 60
    Height = 15
    Caption = 'Value index'
  end
  object btnSet: TButton
    Left = 142
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Set'
    TabOrder = 0
    OnClick = btnSetClick
  end
  object btnAbort: TButton
    Left = 16
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Abort'
    TabOrder = 1
    OnClick = btnAbortClick
  end
  object edVal: TEdit
    Left = 16
    Top = 53
    Width = 201
    Height = 23
    TabOrder = 2
    Text = '0'
  end
end
