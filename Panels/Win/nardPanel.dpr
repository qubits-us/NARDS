program nardPanel;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {MainFrm},
  uPacketDefs in '..\common\uPacketDefs.pas',
  NardView in 'NardView.pas',
  dmDatabase in 'dmDatabase.pas' {dmDB: TDataModule},
  frmNardList in 'frmNardList.pas' {NardListFrm},
  frmNardDetails in 'frmNardDetails.pas' {NardDetailsFrm},
  frmNardView in 'frmNardView.pas' {NardViewFrm},
  frmReportLogs in 'frmReportLogs.pas' {ReportLogsFrm},
  frmReportPreview in 'frmReportPreview.pas' {ReportPreviewFrm},
  Vcl.Themes,
  Vcl.Styles,
  frmNardLayout in 'frmNardLayout.pas' {NardLayoutFrm},
  frmGetStr in 'frmGetStr.pas' {GetStrFrm},
  frmAbout in 'frmAbout.pas' {AboutFrm},
  frmServerConfig in 'frmServerConfig.pas' {ServerConfigFrm},
  frmScreenVals in 'frmScreenVals.pas' {ScreenValsFrm},
  frmSourceView in 'frmSourceView.pas' {SourceViewFrm},
  frmMsg in 'frmMsg.pas' {MsgFrm},
  frmSourceList in 'frmSourceList.pas' {SourceListFrm},
  frmFirmwareList in 'frmFirmwareList.pas' {FirmwareListFrm},
  frmHashList in 'frmHashList.pas' {HashListFrm},
  frmManageLogs in 'frmManageLogs.pas' {ManageLogsFrm},
  frmLogView in 'frmLogView.pas' {LogViewFrm},
  frmNardValAdj in 'frmNardValAdj.pas' {NardValAdjFrm},
  frmNardImages in 'frmNardImages.pas' {NardImagesFrm},
  frmSourceOptions in 'frmSourceOptions.pas' {SourceOptionsFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 MineShaft');
  Application.Title := 'Nard Panel';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
