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
  object Button1: TButton
    Left = 8
    Top = 376
    Width = 75
    Height = 25
    Caption = 'View'
    TabOrder = 0
  end
  object Button2: TButton
    Left = 89
    Top = 377
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
  end
  object Button3: TButton
    Left = 170
    Top = 377
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 2
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 481
    Height = 362
    DataSource = dsSource
    ReadOnly = True
    TabOrder = 3
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
  object Button4: TButton
    Left = 418
    Top = 377
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = Button4Click
  end
  object dsSource: TDataSource
    DataSet = dmDB.qrySourceList
    Left = 16
    Top = 320
  end
end
