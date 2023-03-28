object ReportPreviewFrm: TReportPreviewFrm
  Left = 0
  Top = 0
  Caption = 'Report Preview...'
  ClientHeight = 689
  ClientWidth = 883
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  DesignSize = (
    883
    689)
  TextHeight = 15
  object rptPreview: TfrxPreview
    Left = 0
    Top = 8
    Width = 875
    Height = 627
    OutlineVisible = True
    OutlineWidth = 185
    ThumbnailVisible = False
    FindFmVisible = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    UseReportHints = True
    OutlineTreeSortType = dtsUnsorted
    HideScrolls = False
    ExplicitWidth = 616
    ExplicitHeight = 401
  end
  object btnClose: TButton
    Left = 800
    Top = 656
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
    ExplicitLeft = 541
    ExplicitTop = 430
  end
end
