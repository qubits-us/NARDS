unit frmNardValAdj;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TNardValAdjFrm = class(TForm)
    btnSet: TButton;
    btnAbort: TButton;
    edVal: TEdit;
    lblValDesc: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ValMin:integer;
    ValMax:integer;
    OrigVal:integer;
    NewVal:integer;
  end;

var
  NardValAdjFrm: TNardValAdjFrm;

implementation

{$R *.dfm}

uses
  frmMsg;

procedure TNardValAdjFrm.btnAbortClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TNardValAdjFrm.btnSetClick(Sender: TObject);
begin
try
NewVal:=StrToInt(edVal.Text);
except on e:exception do
  begin
    ShowMsg('Invalid value!');
    exit;
  end;

end;
ModalResult:=mrOK;
end;

procedure TNardValAdjFrm.FormCreate(Sender: TObject);
begin
  ValMin:=0;
  ValMax:=1;
  OrigVal:=0;
  NewVal:=0;
end;

end.
