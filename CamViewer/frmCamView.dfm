object CamViewFrm: TCamViewFrm
  Left = 0
  Top = 0
  Caption = 'NARDS: Cam Viewer'
  ClientHeight = 489
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object imgCam: TImage
    Left = 0
    Top = 41
    Width = 624
    Height = 318
    Align = alClient
    Stretch = True
    ExplicitLeft = 88
    ExplicitTop = 104
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitTop = 40
    ExplicitWidth = 185
    object Label1: TLabel
      Left = 8
      Top = 13
      Width = 45
      Height = 15
      Caption = 'Nard IP :'
    end
    object lblPort: TLabel
      Left = 232
      Top = 13
      Width = 28
      Height = 15
      Caption = 'Port :'
    end
    object edIP: TEdit
      Left = 56
      Top = 12
      Width = 145
      Height = 23
      TabOrder = 0
      Text = '192.168.0.141'
    end
    object edPort: TEdit
      Left = 272
      Top = 12
      Width = 121
      Height = 23
      TabOrder = 1
      Text = '12001'
    end
  end
  object pblBottom: TPanel
    Left = 0
    Top = 448
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 96
    ExplicitTop = 272
    ExplicitWidth = 185
    object btnClose: TButton
      Left = 528
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
    end
    object btnConnect: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 1
      OnClick = btnConnectClick
    end
    object btnDiscon: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 2
      OnClick = btnDisconClick
    end
  end
  object mLog: TMemo
    Left = 0
    Top = 359
    Width = 624
    Height = 89
    Align = alBottom
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clAqua
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'mLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    StyleElements = [seBorder]
  end
  object sckCam: TWSocket
    LineEnd = #13#10
    Port = '12001'
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    SocksLevel = '5'
    ExclusiveAddr = False
    ComponentOptions = []
    ListenBacklog = 15
    OnDataAvailable = sckCamDataAvailable
    OnSessionClosed = sckCamSessionClosed
    OnSessionConnected = sckCamSessionConnected
    OnSocksConnected = sckCamSocksConnected
    OnError = sckCamError
    OnBgException = sckCamBgException
    OnSocksError = sckCamSocksError
    SocketErrs = wsErrTech
    onException = sckCamException
    Left = 456
    Top = 24
  end
end
