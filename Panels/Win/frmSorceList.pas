unit frmSorceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,dmDatabase;

type
  TSorceListFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DBGrid1: TDBGrid;
    Button4: TButton;
    dsSource: TDataSource;
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SorceListFrm: TSorceListFrm;

implementation

{$R *.dfm}



procedure TSorceListFrm.Button4Click(Sender: TObject);
begin
ModalResult:=mrOK;
end;

end.
