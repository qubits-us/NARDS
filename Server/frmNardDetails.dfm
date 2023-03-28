object NardDetailsFrm: TNardDetailsFrm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Nard Details'
  ClientHeight = 344
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblID: TLabel
    Left = 64
    Top = 27
    Width = 39
    Height = 15
    Caption = 'Nard Id'
  end
  object lblGroup: TLabel
    Left = 57
    Top = 67
    Width = 46
    Height = 15
    Caption = 'Group Id'
  end
  object lblProcess: TLabel
    Left = 50
    Top = 107
    Width = 53
    Height = 15
    Caption = 'Process Id'
  end
  object lblName: TLabel
    Left = 71
    Top = 147
    Width = 32
    Height = 15
    Caption = 'Name'
  end
  object lblFirmware: TLabel
    Left = 54
    Top = 184
    Width = 49
    Height = 15
    Caption = 'Firmware'
  end
  object lblConnection: TLabel
    Left = 21
    Top = 230
    Width = 82
    Height = 15
    Caption = 'Last Connected'
  end
  object lblIp: TLabel
    Left = 69
    Top = 259
    Width = 34
    Height = 15
    Caption = 'Last IP'
  end
  object edArdID: TDBEdit
    Left = 109
    Top = 24
    Width = 121
    Height = 23
    DataField = 'ARDID'
    DataSource = dsNardDetails
    TabOrder = 0
  end
  object edGroupId: TDBEdit
    Left = 109
    Top = 64
    Width = 121
    Height = 23
    DataField = 'GROUPID'
    DataSource = dsNardDetails
    TabOrder = 1
  end
  object edProcessId: TDBEdit
    Left = 109
    Top = 104
    Width = 121
    Height = 23
    DataField = 'PROCESSID'
    DataSource = dsNardDetails
    TabOrder = 2
  end
  object edName: TDBEdit
    Left = 109
    Top = 144
    Width = 121
    Height = 23
    DataField = 'DISPLAYNAME'
    DataSource = dsNardDetails
    TabOrder = 3
  end
  object edConnection: TDBEdit
    Left = 109
    Top = 227
    Width = 160
    Height = 23
    DataField = 'LASTCONNECTION'
    DataSource = dsNardDetails
    ReadOnly = True
    TabOrder = 4
  end
  object edIp: TDBEdit
    Left = 109
    Top = 256
    Width = 160
    Height = 23
    DataField = 'LASTIP'
    DataSource = dsNardDetails
    ReadOnly = True
    TabOrder = 5
  end
  object edFirmware: TDBEdit
    Left = 109
    Top = 181
    Width = 121
    Height = 23
    DataField = 'FIRMWARE'
    DataSource = dsNardDetails
    TabOrder = 6
  end
  object btnSave: TButton
    Left = 203
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 7
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 28
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object dsNardDetails: TDataSource
    DataSet = dmDB.tblNardDetails
    Left = 24
    Top = 32
  end
end
