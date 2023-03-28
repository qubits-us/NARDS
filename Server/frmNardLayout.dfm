object NardLayoutFrm: TNardLayoutFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Nard Layout...'
  ClientHeight = 347
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    607
    347)
  TextHeight = 15
  object lblItemID: TLabel
    Left = 405
    Top = 324
    Width = 70
    Height = 15
    Alignment = taRightJustify
    Anchors = []
    AutoSize = False
    Caption = 'lblItemID'
  end
  object lblNormal: TLabel
    Left = 8
    Top = 194
    Width = 76
    Height = 15
    Caption = 'Normal Image'
  end
  object lblOffline: TLabel
    Left = 8
    Top = 144
    Width = 72
    Height = 15
    Caption = 'Offline Image'
  end
  object lblAlert: TLabel
    Left = 8
    Top = 294
    Width = 61
    Height = 15
    Caption = 'Alert Image'
  end
  object lnlID: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 15
    Caption = 'Nard ID'
  end
  object lblTop: TLabel
    Left = 8
    Top = 48
    Width = 19
    Height = 15
    Caption = 'Top'
  end
  object lblLeft: TLabel
    Left = 8
    Top = 90
    Width = 20
    Height = 15
    Caption = 'Left'
  end
  object lblHeight: TLabel
    Left = 116
    Top = 48
    Width = 36
    Height = 15
    Caption = 'Height'
    Visible = False
  end
  object lblWidth: TLabel
    Left = 114
    Top = 90
    Width = 32
    Height = 15
    Caption = 'Width'
    Visible = False
  end
  object lblOnImg: TLabel
    Left = 8
    Top = 244
    Width = 52
    Height = 15
    Caption = 'On Image'
  end
  object lblNameTop: TLabel
    Left = 528
    Top = 192
    Width = 54
    Height = 15
    Caption = 'Name Top'
  end
  object lblNameLeft: TLabel
    Left = 528
    Top = 232
    Width = 55
    Height = 15
    Caption = 'Name Left'
  end
  object lblNameSize: TLabel
    Left = 528
    Top = 272
    Width = 55
    Height = 15
    Caption = 'Name Size'
  end
  object btnUpdate: TButton
    Left = 513
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 0
    OnClick = btnUpdateClick
  end
  object edNardID: TEdit
    Left = 8
    Top = 24
    Width = 82
    Height = 23
    TabOrder = 1
    Text = '1'
  end
  object edLeft: TEdit
    Left = 8
    Top = 107
    Width = 65
    Height = 23
    TabOrder = 2
    Text = 'edLeft'
    OnChange = edLeftChange
  end
  object edTop: TEdit
    Left = 8
    Top = 64
    Width = 65
    Height = 23
    TabOrder = 3
    Text = 'edTop'
    OnChange = edTopChange
  end
  object edHeight: TEdit
    Left = 116
    Top = 64
    Width = 65
    Height = 23
    TabOrder = 4
    Visible = False
    OnChange = edHeightChange
  end
  object edWidth: TEdit
    Left = 116
    Top = 107
    Width = 65
    Height = 23
    TabOrder = 5
    Visible = False
    OnChange = edWidthChange
  end
  object edNormalImg: TEdit
    Left = 8
    Top = 215
    Width = 202
    Height = 23
    TabOrder = 6
    Text = 'default'
  end
  object btnSelectN: TButton
    Left = 216
    Top = 214
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 7
    OnClick = btnSelectNClick
  end
  object edOfflineImg: TEdit
    Left = 8
    Top = 165
    Width = 202
    Height = 23
    TabOrder = 8
    Text = 'default'
  end
  object edAlertImg: TEdit
    Left = 8
    Top = 315
    Width = 202
    Height = 23
    TabOrder = 9
    Text = 'default'
  end
  object btnSelectO: TButton
    Left = 216
    Top = 164
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 10
    OnClick = btnSelectOClick
  end
  object btnSelectA: TButton
    Left = 216
    Top = 314
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 11
    OnClick = btnSelectAClick
  end
  object DBGrid1: TDBGrid
    Left = 264
    Top = 8
    Width = 335
    Height = 120
    DataSource = dsScreenVals
    TabOrder = 12
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'VALINDEX'
        ReadOnly = True
        Title.Caption = 'Index'
        Width = 33
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALUETYPE'
        ReadOnly = True
        Title.Caption = 'Type'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DISPLAYNUM'
        Title.Caption = 'DV#'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POSLEFT'
        Title.Caption = 'Left'
        Width = 42
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POSTOP'
        Title.Caption = 'Top'
        Width = 47
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FONTSIZE'
        Title.Caption = 'Size'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FONTCOLOR'
        Title.Caption = 'Color'
        Width = 65
        Visible = True
      end>
  end
  object btnAdd: TButton
    Left = 280
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 13
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 400
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 14
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 518
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 15
    OnClick = btnDeleteClick
  end
  object edOnImg: TEdit
    Left = 8
    Top = 265
    Width = 202
    Height = 23
    TabOrder = 16
    Text = 'default'
  end
  object Button1: TButton
    Left = 216
    Top = 264
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 17
  end
  object edName: TEdit
    Left = 104
    Top = 24
    Width = 145
    Height = 23
    TabOrder = 18
    Text = 'edName'
  end
  object cbShowName: TCheckBox
    Left = 104
    Top = 6
    Width = 97
    Height = 17
    Caption = 'Show name'
    TabOrder = 19
    OnClick = cbShowNameClick
  end
  object edVtop: TEdit
    Left = 528
    Top = 208
    Width = 60
    Height = 23
    TabOrder = 20
    Text = 'edVtop'
  end
  object edVLeft: TEdit
    Left = 528
    Top = 248
    Width = 60
    Height = 23
    TabOrder = 21
    Text = 'edVLeft'
  end
  object edVSize: TEdit
    Left = 528
    Top = 288
    Width = 60
    Height = 23
    TabOrder = 22
    Text = 'edVSize'
  end
  object btnSetV: TButton
    Left = 524
    Top = 165
    Width = 64
    Height = 25
    Caption = 'Show'
    TabOrder = 23
    OnClick = btnSetVClick
  end
  object dlgSelPic: TOpenPictureDialog
    Title = 'Select image...'
    Left = 280
    Top = 280
  end
  object dsScreenVals: TDataSource
    DataSet = dmDB.qryScreenVals
    Left = 280
    Top = 256
  end
end
