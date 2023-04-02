object MainFrm: TMainFrm
  Left = 2
  Top = 0
  Caption = 'NARDS'
  ClientHeight = 611
  ClientWidth = 783
  Color = clBtnFace
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object sbMain: TStatusBar
    Left = 0
    Top = 592
    Width = 783
    Height = 19
    Panels = <
      item
        Text = 'Ready'
        Width = 500
      end
      item
        Text = 'Nards: 0'
        Width = 100
      end
      item
        Text = 'Server Offline..'
        Width = 100
      end>
  end
  object mLog: TMemo
    Left = 0
    Top = 447
    Width = 783
    Height = 145
    Align = alBottom
    Color = clBlack
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    StyleElements = [seBorder]
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 41
    Align = alTop
    TabOrder = 2
    DesignSize = (
      783
      41)
    object btnMode: TButton
      Left = 2
      Top = 8
      Width = 33
      Height = 25
      Caption = 'N'
      TabOrder = 0
      OnClick = btnModeClick
    end
    object btnPrevScreen: TButton
      Left = 48
      Top = 8
      Width = 35
      Height = 25
      Caption = '<'
      TabOrder = 1
      OnClick = btnPrevScreenClick
    end
    object edCurrentScreen: TEdit
      Left = 89
      Top = 9
      Width = 168
      Height = 23
      TabOrder = 2
      Text = 'Default'
    end
    object btnNextScreen: TButton
      Left = 263
      Top = 8
      Width = 33
      Height = 25
      Caption = '>'
      TabOrder = 3
      OnClick = btnNextScreenClick
    end
    object btnNew: TButton
      Left = 662
      Top = 8
      Width = 50
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'New'
      TabOrder = 4
      OnClick = btnNewClick
    end
    object btnDelete: TButton
      Left = 718
      Top = 8
      Width = 50
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Delete'
      TabOrder = 5
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 606
      Top = 8
      Width = 50
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Edit'
      TabOrder = 6
      OnClick = btnEditClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 688
    Top = 136
    object File1: TMenuItem
      Caption = '&File'
      object Server1: TMenuItem
        Caption = '&Server'
        object Server2: TMenuItem
          Caption = 'Start'
          OnClick = Server2Click
        end
        object Stop1: TMenuItem
          Caption = 'Stop'
          OnClick = Stop1Click
        end
        object Stop2: TMenuItem
          Caption = 'Config'
          OnClick = Stop2Click
        end
      end
      object File2: TMenuItem
        Caption = '&Exit'
        OnClick = File2Click
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object View2: TMenuItem
        Caption = 'Messages'
        Checked = True
        OnClick = View2Click
      end
      object ScreenPanel1: TMenuItem
        Caption = 'Screen Panel'
        Checked = True
        OnClick = ScreenPanel1Click
      end
    end
    object Nards1: TMenuItem
      Caption = '&Nards'
      object List1: TMenuItem
        Caption = 'Nard List'
        OnClick = List1Click
      end
      object Hashes1: TMenuItem
        Caption = 'Hashes'
        OnClick = Hashes1Click
      end
    end
    object Logs1: TMenuItem
      Caption = '&Logs'
      object menLogsReport: TMenuItem
        Caption = '&Report'
        OnClick = menLogsReportClick
      end
      object menLogView: TMenuItem
        Caption = 'View'
        OnClick = menLogViewClick
      end
      object menLogManage: TMenuItem
        Caption = 'Manage'
        OnClick = menLogManageClick
      end
    end
    object heme1: TMenuItem
      Caption = '&Theme'
      object heme2: TMenuItem
        Caption = 'Light'
        OnClick = heme2Click
      end
      object Dark1: TMenuItem
        Caption = 'Dark'
        Checked = True
        OnClick = Dark1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Help2: TMenuItem
        Caption = '&About'
        OnClick = Help2Click
      end
    end
  end
  object tmrRefreshNards: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrRefreshNardsTimer
    Left = 688
    Top = 72
  end
  object pmNard: TPopupMenu
    Left = 688
    Top = 200
    object AddNard1: TMenuItem
      Caption = 'Add Nard'
    end
  end
end
