object AboutFrm: TAboutFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About'
  ClientHeight = 129
  ClientWidth = 186
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 117
    Height = 15
    Caption = 'NARDS - Server 1.0.0.0'
  end
  object Label2: TLabel
    Left = 32
    Top = 48
    Width = 96
    Height = 15
    Caption = 'GitHub /qubits-us'
  end
  object Button1: TButton
    Left = 53
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = Button1Click
  end
end
