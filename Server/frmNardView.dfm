object NardViewFrm: TNardViewFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Nard Details...'
  ClientHeight = 332
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblNardID: TLabel
    Left = 16
    Top = 8
    Width = 39
    Height = 15
    Caption = 'Nard Id'
  end
  object lblCommand: TLabel
    Left = 16
    Top = 64
    Width = 57
    Height = 15
    Caption = 'Command'
  end
  object lblIndex: TLabel
    Left = 16
    Top = 115
    Width = 29
    Height = 15
    Caption = 'Index'
  end
  object lblValue: TLabel
    Left = 16
    Top = 198
    Width = 28
    Height = 15
    Caption = 'Value'
  end
  object lblType: TLabel
    Left = 16
    Top = 154
    Width = 24
    Height = 15
    Caption = 'Type'
  end
  object lblP1: TLabel
    Left = 16
    Top = 240
    Width = 13
    Height = 15
    Caption = 'P1'
  end
  object lblP2: TLabel
    Left = 80
    Top = 240
    Width = 13
    Height = 15
    Caption = 'P2'
  end
  object lblP3: TLabel
    Left = 16
    Top = 280
    Width = 13
    Height = 15
    Caption = 'P3'
  end
  object lblP4: TLabel
    Left = 80
    Top = 280
    Width = 13
    Height = 15
    Caption = 'P4'
  end
  object edNardID: TEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 23
    ReadOnly = True
    TabOrder = 0
    Text = '1'
  end
  object btnExec: TButton
    Left = 152
    Top = 79
    Width = 65
    Height = 25
    Caption = 'Execute'
    TabOrder = 1
    OnClick = btnExecClick
  end
  object edExec: TEdit
    Left = 16
    Top = 80
    Width = 121
    Height = 23
    NumbersOnly = True
    TabOrder = 2
    Text = '0'
  end
  object edIndex: TEdit
    Left = 16
    Top = 130
    Width = 121
    Height = 23
    NumbersOnly = True
    TabOrder = 3
    Text = '0'
  end
  object edValue: TEdit
    Left = 16
    Top = 213
    Width = 121
    Height = 23
    NumbersOnly = True
    TabOrder = 4
    Text = '0'
  end
  object btnSet: TButton
    Left = 152
    Top = 140
    Width = 65
    Height = 25
    Caption = 'Set'
    TabOrder = 5
    OnClick = btnSetClick
  end
  object btnGet: TButton
    Left = 152
    Top = 170
    Width = 65
    Height = 25
    Caption = 'Get'
    TabOrder = 6
    OnClick = btnGetClick
  end
  object cmbType: TComboBox
    Left = 16
    Top = 172
    Width = 121
    Height = 23
    ItemIndex = 0
    TabOrder = 7
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
  object pgMain: TPageControl
    Left = 228
    Top = 8
    Width = 385
    Height = 272
    ActivePage = tsImages
    TabOrder = 8
    object tsValues: TTabSheet
      Caption = 'Values'
      object dgValues: TDBGrid
        Left = 32
        Top = 3
        Width = 289
        Height = 196
        DataSource = dsValues
        TabOrder = 0
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
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DISPLAYNAME'
            Title.Caption = 'Name'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALUEINT'
            Title.Caption = 'Int'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALUEFLOAT'
            Title.Caption = 'Float'
            Width = 50
            Visible = True
          end>
      end
      object btnRefresh: TButton
        Left = 144
        Top = 205
        Width = 75
        Height = 25
        Caption = 'Refresh'
        TabOrder = 1
        OnClick = btnRefreshClick
      end
    end
    object tsParams: TTabSheet
      Caption = 'Params'
      ImageIndex = 2
      object DBGrid1: TDBGrid
        Left = 3
        Top = 3
        Width = 371
        Height = 187
        DataSource = dsParams
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'PARAMINDEX'
            ReadOnly = True
            Title.Caption = 'Index'
            Width = 38
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DISPLAYNAME'
            Title.Caption = 'Name'
            Width = 106
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PARAM1'
            Title.Caption = 'P1'
            Width = 44
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PARAM2'
            Title.Caption = 'P2'
            Width = 44
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PARAM3'
            Title.Caption = 'P3'
            Width = 44
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PARAM4'
            Title.Caption = 'P4'
            Width = 44
            Visible = True
          end>
      end
      object DBNavigator2: TDBNavigator
        Left = 72
        Top = 205
        Width = 225
        Height = 25
        DataSource = dsParams
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
        TabOrder = 1
      end
    end
    object tsImages: TTabSheet
      Caption = 'Images'
      ImageIndex = 1
      object DBText1: TDBText
        Left = 40
        Top = 0
        Width = 273
        Height = 17
        DataField = 'STAMP'
        DataSource = dsImg
      end
      object DBImage1: TDBImage
        Left = 32
        Top = 18
        Width = 289
        Height = 196
        DataField = 'IMAGE'
        DataSource = dsImg
        TabOrder = 0
      end
      object DBNavigator1: TDBNavigator
        Left = 93
        Top = 216
        Width = 228
        Height = 25
        DataSource = dsImg
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbRefresh]
        ConfirmDelete = False
        TabOrder = 1
      end
      object btnGetImage: TButton
        Left = 32
        Top = 216
        Width = 40
        Height = 25
        Caption = 'Get'
        TabOrder = 2
        OnClick = btnGetImageClick
      end
    end
  end
  object btnClose: TButton
    Left = 538
    Top = 299
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 9
    OnClick = btnCloseClick
  end
  object edP1: TEdit
    Left = 16
    Top = 253
    Width = 57
    Height = 23
    NumbersOnly = True
    TabOrder = 10
    Text = '0'
  end
  object edP2: TEdit
    Left = 79
    Top = 253
    Width = 58
    Height = 23
    NumbersOnly = True
    TabOrder = 11
    Text = '0'
  end
  object edP3: TEdit
    Left = 16
    Top = 296
    Width = 57
    Height = 23
    NumbersOnly = True
    TabOrder = 12
    Text = '0'
  end
  object edP4: TEdit
    Left = 79
    Top = 296
    Width = 58
    Height = 23
    NumbersOnly = True
    TabOrder = 13
    Text = '0'
  end
  object btnSetParams: TButton
    Left = 152
    Top = 272
    Width = 65
    Height = 25
    Caption = 'Set'
    TabOrder = 14
    OnClick = btnSetParamsClick
  end
  object dsValues: TDataSource
    DataSet = dmDB.qryNardValues
    Left = 152
    Top = 16
  end
  object dsImg: TDataSource
    DataSet = dmDB.qryImg
    Left = 824
    Top = 168
  end
  object dsParams: TDataSource
    DataSet = dmDB.qryNardParams
    Left = 344
    Top = 288
  end
end
