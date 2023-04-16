object MsgFrm: TMsgFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Message'
  ClientHeight = 115
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblMsg: TLabel
    Left = 16
    Top = 16
    Width = 225
    Height = 49
    AutoSize = False
    Caption = 'lblMsg'
    WordWrap = True
  end
  object btnYes: TButton
    Left = 72
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Yes'
    TabOrder = 0
    OnClick = btnYesClick
  end
  object btnNo: TButton
    Left = 166
    Top = 82
    Width = 75
    Height = 25
    Caption = 'No'
    TabOrder = 1
    OnClick = btnNoClick
  end
end
