object SourceViewFrm: TSourceViewFrm
  Left = 0
  Top = 0
  Caption = 'NARD Source View'
  ClientHeight = 502
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object seSource: TSynEdit
    Left = 0
    Top = 0
    Width = 666
    Height = 469
    Align = alClient
    Color = clBlack
    ActiveLineColor = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 0
    UseCodeFolding = False
    Gutter.Color = clGray
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.Bands = <
      item
        Kind = gbkMarks
        Width = 13
      end
      item
        Kind = gbkLineNumbers
      end
      item
        Kind = gbkFold
      end
      item
        Kind = gbkTrackChanges
      end
      item
        Kind = gbkMargin
        Width = 3
      end>
    Highlighter = SynCppSyn1
    Lines.Strings = (
      'seSource')
    RightEdgeColor = clGray
    SelectedColor.Alpha = 0.400000005960464500
    ExplicitTop = 33
    ExplicitWidth = 624
    ExplicitHeight = 408
  end
  object Panel1: TPanel
    Left = 0
    Top = 469
    Width = 666
    Height = 33
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 0
    ExplicitWidth = 624
    DesignSize = (
      666
      33)
    object btnClose: TButton
      Left = 584
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object SynCppSyn1: TSynCppSyn
    CommentAttri.Foreground = clLime
    BracketAttri.Foreground = clFuchsia
    DirecAttri.Foreground = clMoneyGreen
    IdentifierAttri.Foreground = clTeal
    KeyAttri.Foreground = clAqua
    NumberAttri.Foreground = clPurple
    FloatAttri.Foreground = clSkyBlue
    HexAttri.Foreground = clCream
    StringAttri.Foreground = clTeal
    CharAttri.Foreground = clYellow
    SymbolAttri.Foreground = clFuchsia
    Left = 472
    Top = 288
  end
end
