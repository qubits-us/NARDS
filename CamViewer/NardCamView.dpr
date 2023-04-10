program NardCamView;

uses
  Vcl.Forms,
  frmCamView in 'frmCamView.pas' {CamViewFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCamViewFrm, CamViewFrm);
  Application.Run;
end.
