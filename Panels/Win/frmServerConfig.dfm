object ServerConfigFrm: TServerConfigFrm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Server Config...'
  ClientHeight = 441
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblServerName: TLabel
    Left = 48
    Top = 14
    Width = 67
    Height = 15
    Caption = 'Server Name'
  end
  object lblServerIP: TLabel
    Left = 48
    Top = 64
    Width = 45
    Height = 15
    Caption = 'Server Ip'
  end
  object lblServerPort: TLabel
    Left = 48
    Top = 109
    Width = 57
    Height = 15
    Caption = 'Server Port'
  end
  object btnCancel: TButton
    Left = 181
    Top = 407
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 8
    Top = 407
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object edServerName: TEdit
    Left = 48
    Top = 35
    Width = 121
    Height = 23
    TabOrder = 2
    Text = 'NARDS'
  end
  object edServerIp: TEdit
    Left = 48
    Top = 80
    Width = 121
    Height = 23
    TabOrder = 3
    Text = '0.0.0.0'
  end
  object edServerPort: TEdit
    Left = 48
    Top = 130
    Width = 121
    Height = 23
    NumbersOnly = True
    TabOrder = 4
    Text = '12000'
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 159
    Width = 209
    Height = 234
    Caption = 'Database'
    TabOrder = 5
    object lblDBPort: TLabel
      Left = 32
      Top = 70
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object lblDbUser: TLabel
      Left = 32
      Top = 110
      Width = 41
      Height = 15
      Caption = 'Db User'
    end
    object lblHost: TLabel
      Left = 32
      Top = 29
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object lblDbPass: TLabel
      Left = 32
      Top = 149
      Width = 41
      Height = 15
      Caption = 'Db Pass'
    end
    object lblDbName: TLabel
      Left = 32
      Top = 192
      Width = 50
      Height = 15
      Caption = 'Db Name'
    end
    object edHost: TEdit
      Left = 32
      Top = 46
      Width = 121
      Height = 23
      TabOrder = 0
      Text = 'localhost'
    end
    object edDBport: TEdit
      Left = 32
      Top = 86
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 1
      Text = '3050'
    end
    object edDbUser: TEdit
      Left = 32
      Top = 126
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'SYSDBA'
    end
    object edDbPass: TEdit
      Left = 32
      Top = 166
      Width = 121
      Height = 23
      PasswordChar = '*'
      TabOrder = 3
      Text = 'qubits'
    end
    object edDbName: TEdit
      Left = 32
      Top = 206
      Width = 121
      Height = 23
      TabOrder = 4
      Text = 'NARDS'
    end
  end
end
