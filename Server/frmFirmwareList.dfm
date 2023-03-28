object FirmwareListFrm: TFirmwareListFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'NARD : Firmwares...'
  ClientHeight = 399
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 16
    Top = 8
    Width = 409
    Height = 337
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'FIRMID'
        Title.Caption = 'Id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ARDID'
        Title.Caption = 'Nard Id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VER'
        Title.Caption = 'Ver'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STAMP'
        Title.Caption = 'Last Edit'
        Width = 160
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 16
    Top = 366
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 113
    Top = 366
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 216
    Top = 366
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 3
  end
  object Button4: TButton
    Left = 350
    Top = 366
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = Button4Click
  end
  object DataSource1: TDataSource
    DataSet = dmDB.qryFirmwareList
    Left = 64
    Top = 248
  end
end
