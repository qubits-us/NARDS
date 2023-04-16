object NardLayoutFrm: TNardLayoutFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Nard Item...'
  ClientHeight = 334
  ClientWidth = 655
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
    655
    334)
  TextHeight = 15
  object lblItemID: TLabel
    Left = 440
    Top = 312
    Width = 70
    Height = 15
    Alignment = taRightJustify
    Anchors = []
    AutoSize = False
    Caption = 'lblItemID'
    ExplicitLeft = 405
    ExplicitTop = 324
  end
  object btnUpdate: TButton
    Left = 566
    Top = 304
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnUpdateClick
  end
  object DBGrid1: TDBGrid
    Left = 306
    Top = 8
    Width = 335
    Height = 120
    DataSource = dsScreenVals
    TabOrder = 1
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
    Left = 320
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 440
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 3
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 558
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
    OnClick = btnDeleteClick
  end
  object btnSetV: TButton
    Left = 306
    Top = 304
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Show'
    TabOrder = 5
    OnClick = btnSetVClick
  end
  object pcMain: TPageControl
    Left = 8
    Top = 8
    Width = 281
    Height = 310
    ActivePage = tsGen
    TabOrder = 6
    object tsGen: TTabSheet
      Caption = 'Main'
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
      object lblHeight: TLabel
        Left = 116
        Top = 48
        Width = 36
        Height = 15
        Caption = 'Height'
      end
      object lblLeft: TLabel
        Left = 8
        Top = 90
        Width = 20
        Height = 15
        Caption = 'Left'
      end
      object lblWidth: TLabel
        Left = 114
        Top = 90
        Width = 32
        Height = 15
        Caption = 'Width'
      end
      object edNardID: TEdit
        Left = 8
        Top = 24
        Width = 82
        Height = 23
        TabOrder = 0
        Text = '1'
      end
      object cbShowName: TCheckBox
        Left = 104
        Top = 6
        Width = 97
        Height = 17
        Caption = 'Show name'
        TabOrder = 1
        OnClick = cbShowNameClick
      end
      object edName: TEdit
        Left = 104
        Top = 24
        Width = 145
        Height = 23
        TabOrder = 2
        Text = 'edName'
      end
      object edHeight: TEdit
        Left = 116
        Top = 64
        Width = 65
        Height = 23
        TabOrder = 3
        OnChange = edHeightChange
      end
      object edTop: TEdit
        Left = 8
        Top = 64
        Width = 65
        Height = 23
        TabOrder = 4
        Text = '0'
        OnChange = edTopChange
      end
      object edWidth: TEdit
        Left = 116
        Top = 107
        Width = 65
        Height = 23
        TabOrder = 5
        OnChange = edWidthChange
      end
      object edLeft: TEdit
        Left = 8
        Top = 107
        Width = 65
        Height = 23
        TabOrder = 6
        Text = '0'
        OnChange = edLeftChange
      end
      object GroupBox1: TGroupBox
        Left = 4
        Top = 136
        Width = 185
        Height = 116
        Caption = 'Name'
        TabOrder = 7
        object lblNameSize: TLabel
          Left = 88
          Top = 20
          Width = 20
          Height = 15
          Caption = 'Size'
        end
        object lblNameLeft: TLabel
          Left = 14
          Top = 64
          Width = 20
          Height = 15
          Caption = 'Left'
        end
        object lblNameTop: TLabel
          Left = 14
          Top = 20
          Width = 19
          Height = 15
          Caption = 'Top'
        end
        object edVLeft: TEdit
          Left = 14
          Top = 80
          Width = 60
          Height = 23
          TabOrder = 0
          Text = '0'
        end
        object edVSize: TEdit
          Left = 88
          Top = 40
          Width = 60
          Height = 23
          TabOrder = 1
          Text = '10'
        end
        object edVtop: TEdit
          Left = 14
          Top = 40
          Width = 60
          Height = 23
          TabOrder = 2
          Text = '0'
        end
      end
    end
    object tsImg: TTabSheet
      Caption = 'Images'
      ImageIndex = 1
      object lblAlert: TLabel
        Left = 8
        Top = 163
        Width = 61
        Height = 15
        Caption = 'Alert Image'
      end
      object lblOnImg: TLabel
        Left = 8
        Top = 113
        Width = 52
        Height = 15
        Caption = 'On Image'
      end
      object lblNormal: TLabel
        Left = 8
        Top = 63
        Width = 76
        Height = 15
        Caption = 'Normal Image'
      end
      object lblOffline: TLabel
        Left = 8
        Top = 13
        Width = 72
        Height = 15
        Caption = 'Offline Image'
      end
      object edNormalImg: TEdit
        Left = 8
        Top = 84
        Width = 202
        Height = 23
        TabOrder = 0
        Text = 'default'
      end
      object edAlertImg: TEdit
        Left = 8
        Top = 184
        Width = 202
        Height = 23
        TabOrder = 1
        Text = 'default'
      end
      object btnSelectA: TButton
        Left = 224
        Top = 183
        Width = 41
        Height = 25
        Caption = '...'
        TabOrder = 2
        OnClick = btnSelectAClick
      end
      object btnSelectOn: TButton
        Left = 224
        Top = 133
        Width = 41
        Height = 25
        Caption = '...'
        TabOrder = 3
        OnClick = btnSelectOnClick
      end
      object edOnImg: TEdit
        Left = 8
        Top = 134
        Width = 202
        Height = 23
        TabOrder = 4
        Text = 'default'
      end
      object btnSelectN: TButton
        Left = 224
        Top = 83
        Width = 41
        Height = 25
        Caption = '...'
        TabOrder = 5
        OnClick = btnSelectNClick
      end
      object btnSelectO: TButton
        Left = 224
        Top = 33
        Width = 41
        Height = 25
        Caption = '...'
        TabOrder = 6
        OnClick = btnSelectOClick
      end
      object edOfflineImg: TEdit
        Left = 8
        Top = 34
        Width = 202
        Height = 23
        TabOrder = 7
        Text = 'default'
      end
    end
    object tsAct: TTabSheet
      Caption = 'Action'
      ImageIndex = 2
      object lblType: TLabel
        Left = 104
        Top = 63
        Width = 55
        Height = 15
        Caption = 'Value Type'
      end
      object lblIndex: TLabel
        Left = 8
        Top = 63
        Width = 41
        Height = 15
        Caption = 'Value Id'
      end
      object lblAction: TLabel
        Left = 8
        Top = 13
        Width = 35
        Height = 15
        Caption = 'Action'
      end
      object cmbAction: TComboBox
        Left = 8
        Top = 34
        Width = 217
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnChange = cmbActionChange
        Items.Strings = (
          'None'
          'Show Nard Info'
          'Execute Command'
          'Toggle Value'
          'Adjust Value'
          'Show Nard Images'
          'Set Parameters'
          'Drive Parameters')
      end
      object cmbActionValType: TComboBox
        Left = 104
        Top = 80
        Width = 121
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = 'Byte'
        Items.Strings = (
          'Byte'
          'Word'
          'int16'
          'int32'
          'uint32'
          'Single'
          'Double')
      end
      object edValID: TEdit
        Left = 8
        Top = 80
        Width = 65
        Height = 23
        TabOrder = 2
        Text = '0'
      end
      object pcActions: TPageControl
        Left = 8
        Top = 109
        Width = 229
        Height = 148
        ActivePage = tsActionMain
        TabOrder = 3
        object tsActionMain: TTabSheet
          Caption = 'Set'
          object lblMax: TLabel
            Left = 112
            Top = 58
            Width = 23
            Height = 15
            Caption = 'Max'
          end
          object lblValMin: TLabel
            Left = 16
            Top = 58
            Width = 21
            Height = 15
            Caption = 'Min'
          end
          object lblParam2: TLabel
            Left = 112
            Top = 8
            Width = 43
            Height = 15
            Caption = 'Param 2'
            Visible = False
          end
          object lblStepBy: TLabel
            Left = 16
            Top = 8
            Width = 23
            Height = 15
            Caption = 'Step'
          end
          object EdMin: TEdit
            Left = 16
            Top = 74
            Width = 82
            Height = 23
            TabOrder = 0
            Text = '0'
          end
          object edMax: TEdit
            Left = 112
            Top = 74
            Width = 82
            Height = 23
            TabOrder = 1
            Text = '1'
          end
          object edStep: TEdit
            Left = 16
            Top = 24
            Width = 82
            Height = 23
            TabOrder = 2
            Text = '1'
          end
          object edParam2: TEdit
            Left = 112
            Top = 24
            Width = 82
            Height = 23
            TabOrder = 3
            Text = '0'
            Visible = False
          end
        end
        object tsActionUp: TTabSheet
          Caption = 'Up'
          ImageIndex = 1
          TabVisible = False
          object lblParam1Up: TLabel
            Left = 16
            Top = 8
            Width = 43
            Height = 15
            Caption = 'Param 1'
          end
          object lblParam2Ip: TLabel
            Left = 112
            Top = 8
            Width = 43
            Height = 15
            Caption = 'Param 2'
          end
          object lblParam3Up: TLabel
            Left = 16
            Top = 58
            Width = 43
            Height = 15
            Caption = 'Param 3'
          end
          object lblParam4Up: TLabel
            Left = 112
            Top = 58
            Width = 43
            Height = 15
            Caption = 'Param 4'
          end
          object edParam1Up: TEdit
            Left = 16
            Top = 24
            Width = 82
            Height = 23
            TabOrder = 0
            Text = '0'
          end
          object edParam2Up: TEdit
            Left = 112
            Top = 24
            Width = 82
            Height = 23
            TabOrder = 1
            Text = '0'
          end
          object edParam3Up: TEdit
            Left = 16
            Top = 74
            Width = 82
            Height = 23
            TabOrder = 2
            Text = '0'
          end
          object edParam4Up: TEdit
            Left = 112
            Top = 74
            Width = 82
            Height = 23
            TabOrder = 3
            Text = '0'
          end
        end
      end
    end
  end
  object dlgSelPic: TOpenPictureDialog
    Title = 'Select image...'
    Left = 528
    Top = 208
  end
  object dsScreenVals: TDataSource
    DataSet = dmDB.qryScreenVals
    Left = 376
    Top = 208
  end
end
