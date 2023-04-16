unit frmMsg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMsgFrm = class(TForm)
    lblMsg: TLabel;
    btnYes: TButton;
    btnNo: TButton;
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

 function MsgYesNo(aStr:string):boolean;
 procedure ShowMsg(aStr:string);

var
  MsgFrm: TMsgFrm;

implementation

{$R *.dfm}


function MsgYesNo(aStr:string):boolean;
begin
  MsgFrm:=tMsgFrm.Create(application);
  MsgFrm.lblMsg.Caption:=aStr;
 if MsgFrm.ShowModal=mrYes then
   result:=true else result:=false;
 MsgFrm.Free;
end;

procedure  ShowMsg(aStr:string);
begin
  MsgFrm:=tMsgFrm.Create(application);
  MsgFrm.lblMsg.Caption:=aStr;
  MsgFrm.btnYes.Visible:=false;
  msgFrm.btnNo.Caption:='Ok';
  MsgFrm.ShowModal;
  MsgFrm.Free;
end;


procedure TMsgFrm.btnNoClick(Sender: TObject);
begin
ModalResult:=mrNo;
end;

procedure TMsgFrm.btnYesClick(Sender: TObject);
begin
ModalResult:=mrYes;
end;

end.
