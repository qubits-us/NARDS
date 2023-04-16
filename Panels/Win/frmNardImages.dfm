object NardImagesFrm: TNardImagesFrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Nard images..'
  ClientHeight = 441
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object dbStamp: TDBText
    Left = 8
    Top = 8
    Width = 529
    Height = 17
    Alignment = taCenter
    DataField = 'STAMP'
    DataSource = dsImages
  end
  object btnClose: TButton
    Left = 472
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object dbImg: TDBImage
    Left = 8
    Top = 31
    Width = 529
    Height = 346
    DataField = 'IMAGE'
    DataSource = dsImages
    TabOrder = 1
  end
  object dbnImg: TDBNavigator
    Left = 8
    Top = 408
    Width = 228
    Height = 25
    DataSource = dsImages
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbRefresh]
    TabOrder = 2
  end
  object dsImages: TDataSource
    DataSet = dmDB.qryImg
    Left = 368
    Top = 384
  end
end
