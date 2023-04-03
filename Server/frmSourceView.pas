unit frmSourceView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEditHighlighter, SynEditCodeFolding, SynHighlighterCpp, SynEdit, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSourceViewFrm = class(TForm)
    seSource: TSynEdit;
    SynCppSyn1: TSynCppSyn;
    Panel1: TPanel;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SourceViewFrm: TSourceViewFrm;

implementation

{$R *.dfm}

procedure TSourceViewFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

procedure TSourceViewFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//close
end;

procedure TSourceViewFrm.FormCreate(Sender: TObject);
begin

//create
end;

end.
