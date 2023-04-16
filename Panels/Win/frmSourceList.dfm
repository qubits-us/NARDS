object SourceListFrm: TSourceListFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'NARD : Source list...'
  ClientHeight = 410
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object btnView: TButton
    Left = 8
    Top = 377
    Width = 75
    Height = 25
    Caption = 'View'
    TabOrder = 0
    OnClick = btnViewClick
  end
  object btnAdd: TButton
    Left = 89
    Top = 377
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object dbSource: TDBGrid
    Left = 8
    Top = 8
    Width = 481
    Height = 362
    DataSource = dsSource
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'SKETCHID'
        Title.Caption = 'Id'
        Width = 51
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ARDID'
        Title.Caption = 'Nard'
        Width = 47
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FILENAME'
        Title.Caption = 'File Name'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VER'
        Title.Caption = 'Ver'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STAMP'
        Title.Caption = 'Last Edit'
        Width = 127
        Visible = True
      end>
  end
  object btnClose: TButton
    Left = 418
    Top = 377
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object dbNav: TDBNavigator
    Left = 184
    Top = 377
    Width = 180
    Height = 25
    DataSource = dsSource
    VisibleButtons = [nbPrior, nbNext, nbDelete, nbPost, nbCancel, nbRefresh]
    TabOrder = 4
  end
  object dsSource: TDataSource
    DataSet = dmDB.qrySourceList
    Left = 16
    Top = 320
  end
  object dlgSelectBin: TOpenDialog
    DefaultExt = '*.ino'
    FileName = '*.ino'
    Title = 'Select file to add..'
    Left = 296
    Top = 296
  end
end
