unit frmSourceView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,System.IniFiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEditHighlighter, SynEditCodeFolding, SynHighlighterCpp, SynEdit, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSourceViewFrm = class(TForm)
    seSource: TSynEdit;
    SynCppSyn1: TSynCppSyn;
    Panel1: TPanel;
    btnClose: TButton;
    btnOptions: TButton;
    btnSaveLocal: TButton;
    sdSource: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnSaveLocalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SourceViewFrm: TSourceViewFrm;

implementation

{$R *.dfm}

uses frmSourceOptions,frmMsg;

procedure TSourceViewFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

procedure TSourceViewFrm.btnOptionsClick(Sender: TObject);
var
aFrm:tSourceOptionsFrm;
Ini:TIniFile;
begin
//show the source options
aFrm:=tSourceOptionsFrm.Create(self);
if aFrm.ShowModal = mrOK then
 begin
 Ini := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
 SynCppSyn1.LoadFromIniFile(Ini);
 Ini.Free;
 end;
aFrm.Free;

end;

procedure TSourceViewFrm.btnSaveLocalClick(Sender: TObject);
var
aFileName:String;
begin
//save a local copy..
if sdSource.Execute then
  begin
  aFileName:=sdSource.FileName;
  if FileExists(aFileName) then
    begin
     if MsgYesNo(aFileName+' already exist, over write??') then
       begin
         seSource.Lines.SaveToFile(aFileName);
       end else exit;
    end else
          seSource.Lines.SaveToFile(aFileName);
       ShowMsg(aFileName+ ' was saved..');
  end;




end;

procedure TSourceViewFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//close
end;

procedure TSourceViewFrm.FormCreate(Sender: TObject);
var
Ini:TIniFile;
begin

Ini := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));

//create
SynCppSyn1.LoadFromIniFile(Ini);
Ini.Free;
end;

end.
