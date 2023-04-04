object SourceOptionsFrm: TSourceOptionsFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'SourceOptionsFrm'
  ClientHeight = 492
  ClientWidth = 457
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
    Left = 112
    Top = 8
    Width = 62
    Height = 15
    Caption = 'Foreground'
  end
  object Label2: TLabel
    Left = 248
    Top = 8
    Width = 64
    Height = 15
    Caption = 'Background'
  end
  object Label3: TLabel
    Left = 45
    Top = 31
    Width = 55
    Height = 15
    Caption = 'Assembler'
  end
  object Label4: TLabel
    Left = 56
    Top = 67
    Width = 44
    Height = 15
    Caption = 'Brackets'
  end
  object Label5: TLabel
    Left = 49
    Top = 99
    Width = 51
    Height = 15
    Caption = 'Character'
  end
  object Label6: TLabel
    Left = 46
    Top = 131
    Width = 54
    Height = 15
    Caption = 'Comment'
  end
  object Label7: TLabel
    Left = 74
    Top = 163
    Width = 26
    Height = 15
    Caption = 'Float'
  end
  object Label8: TLabel
    Left = 31
    Top = 195
    Width = 69
    Height = 15
    Caption = 'Hexadecimal'
  end
  object Label9: TLabel
    Left = 53
    Top = 227
    Width = 47
    Height = 15
    Caption = 'Identifier'
  end
  object Label10: TLabel
    Left = 41
    Top = 255
    Width = 59
    Height = 15
    Caption = 'Illegal Char'
  end
  object Label11: TLabel
    Left = 56
    Top = 284
    Width = 44
    Height = 15
    Caption = 'Number'
  end
  object Label12: TLabel
    Left = 72
    Top = 311
    Width = 28
    Height = 15
    Caption = 'Octal'
  end
  object Label13: TLabel
    Left = 32
    Top = 340
    Width = 68
    Height = 15
    Caption = 'Preprocessor'
  end
  object Label14: TLabel
    Left = 24
    Top = 367
    Width = 76
    Height = 15
    Caption = 'ReservedWord'
  end
  object Label15: TLabel
    Left = 69
    Top = 394
    Width = 31
    Height = 15
    Caption = 'Space'
  end
  object Label16: TLabel
    Left = 69
    Top = 422
    Width = 31
    Height = 15
    Caption = 'String'
  end
  object Label17: TLabel
    Left = 60
    Top = 451
    Width = 40
    Height = 15
    Caption = 'Symbol'
  end
  object btnClose: TButton
    Left = 374
    Top = 459
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object cbbBracket: TColorBox
    Left = 240
    Top = 64
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 1
  end
  object cbbChar: TColorBox
    Left = 240
    Top = 96
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 2
  end
  object cbbComment: TColorBox
    Left = 240
    Top = 128
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 3
  end
  object cbbFloat: TColorBox
    Left = 240
    Top = 160
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 4
  end
  object cbbHex: TColorBox
    Left = 240
    Top = 192
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 5
  end
  object cbbIdent: TColorBox
    Left = 240
    Top = 224
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 6
  end
  object cbbIllegal: TColorBox
    Left = 240
    Top = 252
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 7
  end
  object cbbNum: TColorBox
    Left = 240
    Top = 280
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 8
  end
  object cbbOct: TColorBox
    Left = 240
    Top = 308
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 9
  end
  object cbbPreProc: TColorBox
    Left = 240
    Top = 336
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 10
  end
  object cbbReserved: TColorBox
    Left = 240
    Top = 364
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 11
  end
  object cbbSpace: TColorBox
    Left = 240
    Top = 392
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 12
  end
  object cbbString: TColorBox
    Left = 240
    Top = 420
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 13
  end
  object cbbSymbol: TColorBox
    Left = 240
    Top = 448
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 14
  end
  object cbbAss: TColorBox
    Left = 240
    Top = 29
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 15
  end
  object cbfAss: TColorBox
    Left = 120
    Top = 28
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 16
  end
  object cbfBracket: TColorBox
    Left = 120
    Top = 64
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 17
  end
  object cbfChar: TColorBox
    Left = 120
    Top = 96
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 18
  end
  object cbfComment: TColorBox
    Left = 120
    Top = 128
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 19
  end
  object cbfFloat: TColorBox
    Left = 120
    Top = 160
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 20
  end
  object cbfHex: TColorBox
    Left = 120
    Top = 192
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 21
  end
  object cbfIdent: TColorBox
    Left = 120
    Top = 224
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 22
  end
  object cbfIllegal: TColorBox
    Left = 120
    Top = 252
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 23
  end
  object cbfNum: TColorBox
    Left = 120
    Top = 280
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 24
  end
  object cbfOct: TColorBox
    Left = 120
    Top = 308
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 25
  end
  object cbfPreProc: TColorBox
    Left = 120
    Top = 336
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 26
  end
  object cbfReserved: TColorBox
    Left = 120
    Top = 364
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 27
  end
  object cbfSpace: TColorBox
    Left = 120
    Top = 392
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 28
  end
  object cbfString: TColorBox
    Left = 120
    Top = 420
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 29
  end
  object cbfSymbol: TColorBox
    Left = 120
    Top = 448
    Width = 80
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 30
  end
end
