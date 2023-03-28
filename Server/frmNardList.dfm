object NardListFrm: TNardListFrm
  Left = 0
  Top = 0
  Caption = 'Nard list...'
  ClientHeight = 379
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    642
    379)
  TextHeight = 15
  object dgNards: TDBGrid
    Left = 8
    Top = 8
    Width = 624
    Height = 328
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsArdsList
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect]
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
        FieldName = 'ARDID'
        Title.Caption = 'Id'
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GROUPID'
        Title.Caption = 'Group'
        Width = 37
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PROCESSID'
        Title.Caption = 'Process'
        Width = 46
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DISPLAYNAME'
        Title.Caption = 'Name'
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LASTIP'
        Title.Caption = 'IP'
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LASTCONNECTION'
        Title.Caption = 'Last Connection'
        Width = 157
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ONLINE'
        Title.Caption = 'Online'
        Width = 41
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FIRMWARE'
        Title.Caption = 'Firmware'
        Width = 55
        Visible = True
      end>
  end
  object BtnClose: TButton
    Left = 559
    Top = 346
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = BtnCloseClick
    ExplicitLeft = 320
  end
  object btnNew: TButton
    Left = 8
    Top = 346
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'New'
    TabOrder = 2
    OnClick = btnNewClick
  end
  object btnEdit: TButton
    Left = 89
    Top = 346
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Edit'
    TabOrder = 3
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 170
    Top = 346
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Delete'
    TabOrder = 4
    OnClick = btnDeleteClick
  end
  object btnSource: TButton
    Left = 296
    Top = 346
    Width = 75
    Height = 25
    Caption = 'Source'
    TabOrder = 5
    OnClick = btnSourceClick
  end
  object btnFirmware: TButton
    Left = 384
    Top = 346
    Width = 75
    Height = 25
    Caption = 'Firmware'
    TabOrder = 6
    OnClick = btnFirmwareClick
  end
  object dsArdsList: TDataSource
    AutoEdit = False
    DataSet = dmDB.ArdsQry
    Left = 288
    Top = 256
  end
end
