unit frmGetStr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TGetStrFrm = class(TForm)
    edValue: TEdit;
    lblCaption: TLabel;
    btnCancel: TButton;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetStr(aPrompt:string):string;

var
  GetStrFrm: TGetStrFrm;

implementation

{$R *.dfm}


function GetStr(aPrompt:String):String;
begin
  GetStrFrm:=tGetStrFrm.Create(Application);
  GetStrFrm.lblCaption.Caption:=aPrompt;
  if GetStrFrm.ShowModal=mrOK then
    result:=GetStrFrm.edValue.Text else result:='UserCanceled';
  GetStrFrm.Free;
end;


procedure TGetStrFrm.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TGetStrFrm.btnOkClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

end.
