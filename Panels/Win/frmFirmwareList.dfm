object FirmwareListFrm: TFirmwareListFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'NARD : Firmwares...'
  ClientHeight = 370
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object dTxtFileName: TDBText
    Left = 24
    Top = 192
    Width = 393
    Height = 17
    DataField = 'FILENAME'
    DataSource = dsFirmwares
  end
  object lblNotes: TLabel
    Left = 16
    Top = 220
    Width = 31
    Height = 15
    Caption = 'Notes'
  end
  object dbgFirmwares: TDBGrid
    Left = 16
    Top = 8
    Width = 409
    Height = 177
    DataSource = dsFirmwares
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
        ReadOnly = True
        Title.Caption = 'Id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ARDID'
        ReadOnly = True
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
        ReadOnly = True
        Title.Caption = 'Last Edit'
        Width = 160
        Visible = True
      end>
  end
  object btnAdd: TButton
    Left = 175
    Top = 340
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnLoad: TButton
    Left = 256
    Top = 340
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object btnClose: TButton
    Left = 350
    Top = 340
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object dbNotes: TDBMemo
    Left = 16
    Top = 240
    Width = 401
    Height = 81
    DataField = 'NOTE'
    DataSource = dsFirmwares
    MaxLength = 500
    TabOrder = 4
  end
  object DBNavigator1: TDBNavigator
    Left = 7
    Top = 340
    Width = 162
    Height = 25
    DataSource = dsFirmwares
    VisibleButtons = [nbPrior, nbNext, nbDelete, nbPost, nbCancel, nbRefresh]
    TabOrder = 5
  end
  object dsFirmwares: TDataSource
    DataSet = dmDB.qryFirmwareList
    Left = 368
    Top = 296
  end
  object dlgSelectBin: TOpenDialog
    DefaultExt = '*.bin'
    FileName = '*.bin'
    Title = 'Select firmware file to add..'
    Left = 296
    Top = 296
  end
end
