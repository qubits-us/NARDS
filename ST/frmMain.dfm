object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = 'Nard Serial Termianl'
  ClientHeight = 410
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnClose = FormClose
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 359
    Width = 744
    Height = 51
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 464
    ExplicitWidth = 679
    DesignSize = (
      744
      51)
    object lblPort: TLabel
      Left = 4
      Top = 6
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object lblBaud: TLabel
      Left = 80
      Top = 8
      Width = 33
      Height = 15
      Caption = 'Baude'
    end
    object Label1: TLabel
      Left = 296
      Top = 8
      Width = 24
      Height = 15
      Caption = 'Data'
    end
    object edPort: TEdit
      Left = 4
      Top = 24
      Width = 73
      Height = 23
      TabOrder = 0
      Text = '3'
    end
    object cbBaud: TComboBox
      Left = 80
      Top = 24
      Width = 145
      Height = 23
      ItemIndex = 6
      TabOrder = 1
      Text = '9600'
      Items.Strings = (
        '150'
        '300'
        '600'
        '1200'
        '2400'
        '4800'
        '9600'
        '19200'
        '38400'
        '57600'
        '115200')
    end
    object btnOpenClose: TButton
      Left = 232
      Top = 22
      Width = 50
      Height = 25
      Caption = 'Open'
      TabOrder = 2
      OnClick = btnOpenCloseClick
    end
    object edLine: TEdit
      Left = 296
      Top = 24
      Width = 354
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      ExplicitWidth = 289
    end
    object btnSend: TButton
      Left = 657
      Top = 23
      Width = 72
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Send'
      TabOrder = 4
      OnClick = btnSendClick
      ExplicitLeft = 592
    end
    object cbCR: TCheckBox
      Left = 656
      Top = 4
      Width = 33
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'CR'
      TabOrder = 5
      ExplicitLeft = 591
    end
    object cbLF: TCheckBox
      Left = 699
      Top = 4
      Width = 34
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'LF'
      Checked = True
      State = cbChecked
      TabOrder = 6
      ExplicitLeft = 634
    end
  end
  object serTerm: TAdTerminal
    Left = 0
    Top = 0
    Width = 744
    Height = 359
    CaptureFile = 'NARD.CAP'
    ComPort = ComPort
    HideScrollbars = True
    Scrollback = False
    Align = alClient
    Color = clBlack
    Emulator = emuTTY
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 624
    ExplicitHeight = 400
  end
  object MainMenu1: TMainMenu
    Left = 560
    Top = 112
    object File1: TMenuItem
      Caption = '&File'
      object File2: TMenuItem
        Caption = '&Exit'
        OnClick = File2Click
      end
    end
    object erminal1: TMenuItem
      Caption = '&Terminal'
      object menEmulation: TMenuItem
        Caption = '&Emulation'
        object menEmuNone: TMenuItem
          Caption = 'None'
          OnClick = menEmuNoneClick
        end
        object menEmuTTY: TMenuItem
          Caption = 'TTY'
          Checked = True
          OnClick = menEmuTTYClick
        end
        object menEmuVT100: TMenuItem
          Caption = 'VT100'
          OnClick = menEmuVT100Click
        end
      end
      object menCapture: TMenuItem
        Caption = '&Capture'
        OnClick = menCaptureClick
      end
      object menTracing: TMenuItem
        Caption = 'T&racing'
        OnClick = menTracingClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object ComPort: TApdComPort
    AutoOpen = False
    TraceName = 'NARD.TRC'
    LogName = 'NARD.LOG'
    OnPortClose = ComPortPortClose
    OnPortOpen = ComPortPortOpen
    Left = 560
    Top = 256
  end
  object emuTTY: TAdTTYEmulator
    Terminal = serTerm
    Left = 560
    Top = 184
  end
  object emuVT100: TAdVT100Emulator
    Answerback = 'APROterm'
    DisplayUpperASCII = False
    Left = 560
    Top = 40
  end
end
