object HashListFrm: THashListFrm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Hashes'
  ClientHeight = 393
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object btnClose: TButton
    Left = 406
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object btnDel: TButton
    Left = 96
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 1
    OnClick = btnDelClick
  end
  object btnAdd: TButton
    Left = 8
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = btnAddClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 473
    Height = 329
    DataSource = dsHashes
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'HASH'
        ReadOnly = True
        Title.Caption = 'Hash'
        Width = 116
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DISPLAYNAME'
        Title.Caption = 'Name'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ACCESSLEVEL'
        Title.Caption = 'Level'
        Width = 34
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LASTACCESS'
        ReadOnly = True
        Title.Caption = 'Last Seen'
        Width = 159
        Visible = True
      end>
  end
  object dsHashes: TDataSource
    DataSet = dmDB.qryHashes
    Left = 24
    Top = 400
  end
end
