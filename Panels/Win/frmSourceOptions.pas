unit frmSourceOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,System.IniFiles, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSourceOptionsFrm = class(TForm)
    btnClose: TButton;
    cbbBracket: TColorBox;
    cbbChar: TColorBox;
    cbbComment: TColorBox;
    cbbFloat: TColorBox;
    cbbHex: TColorBox;
    cbbIdent: TColorBox;
    cbbIllegal: TColorBox;
    cbbNum: TColorBox;
    cbbOct: TColorBox;
    cbbPreProc: TColorBox;
    cbbReserved: TColorBox;
    cbbSpace: TColorBox;
    cbbString: TColorBox;
    cbbSymbol: TColorBox;
    cbbAss: TColorBox;
    cbfAss: TColorBox;
    cbfBracket: TColorBox;
    cbfChar: TColorBox;
    cbfComment: TColorBox;
    cbfFloat: TColorBox;
    cbfHex: TColorBox;
    cbfIdent: TColorBox;
    cbfIllegal: TColorBox;
    cbfNum: TColorBox;
    cbfOct: TColorBox;
    cbfPreProc: TColorBox;
    cbfReserved: TColorBox;
    cbfSpace: TColorBox;
    cbfString: TColorBox;
    cbfSymbol: TColorBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SourceOptionsFrm: TSourceOptionsFrm;

implementation

{$R *.dfm}

procedure TSourceOptionsFrm.btnCloseClick(Sender: TObject);
var
aIni:tIniFile;

begin

//save the coilors
aIni := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
aIni.WriteInteger('Assembler','Background',cbfAss.Selected);
cbbAss.Selected:=aIni.ReadInteger('Assembler','Background',0);
cbfAss.Selected:=aIni.ReadInteger('Assembler','Foreground',0);

aIni.WriteInteger('Brackets','Background',cbfBracket.Selected);
aIni.WriteInteger('Brackets','Foreground',cbbBracket.Selected);

aIni.WriteInteger('Character','Background',cbfChar.Selected);
aIni.WriteInteger('Character','Foreground',cbbChar.Selected);

aIni.WriteInteger('Comment','Background',cbfComment.Selected);
aIni.WriteInteger('Comment','Foreground',cbbComment.Selected);

aIni.WriteInteger('Float','Background',cbfFloat.Selected);
aIni.WriteInteger('Float','Foreground',cbbFloat.Selected);

aIni.WriteInteger('Hexadecimal','Background',cbfHex.Selected);
aIni.WriteInteger('Hexadecimal','Foreground',cbbHex.Selected);

aIni.WriteInteger('Identifier','Background',cbfIdent.Selected);
aIni.WriteInteger('Identifier','Foreground',cbbIdent.Selected);

aIni.WriteInteger('IllegalChar','Background',cbfIllegal.Selected);
aIni.WriteInteger('IllegalChar','Foreground',cbbIllegal.Selected);

aIni.WriteInteger('Octal','Background',cbfOct.Selected);
aIni.WriteInteger('Octal','Foreground',cbbOct.Selected);

aIni.WriteInteger('Preprocessor','Background',cbfPreProc.Selected);
aIni.WriteInteger('Preprocessor','Foreground',cbbPreProc.Selected);

aIni.WriteInteger('ReservedWord','Background',cbfReserved.Selected);
aIni.WriteInteger('ReservedWord','Foreground',cbbReserved.Selected);

aIni.WriteInteger('Space','Background',cbfSpace.Selected);
aIni.WriteInteger('Space','Foreground',cbbSpace.Selected);

aIni.WriteInteger('Number','Background',cbfNum.Selected);
aIni.WriteInteger('Number','Foreground',cbbNum.Selected);

aIni.WriteInteger('String','Background',cbfString.Selected);
aIni.WriteInteger('String','Foreground',cbbString.Selected);

aIni.WriteInteger('Symbol','Background',cbfSymbol.Selected);
aIni.WriteInteger('Symbol','Foreground',cbbSymbol.Selected);


aIni.Free;




ModalResult:=mrOK;
end;

procedure TSourceOptionsFrm.FormCreate(Sender: TObject);
var
aIni:tIniFile;
begin
//load colors..
 aIni := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
cbfAss.Selected:=aIni.ReadInteger('Assembler','Background',0);
cbbAss.Selected:=aIni.ReadInteger('Assembler','Foreground',0);

cbfBracket.Selected:=aIni.ReadInteger('Brackets','Background',0);
cbbBracket.Selected:=aIni.ReadInteger('Brackets','Foreground',0);

cbfChar.Selected:=aIni.ReadInteger('Character','Background',0);
cbbChar.Selected:=aIni.ReadInteger('Character','Foreground',0);

cbfComment.Selected:=aIni.ReadInteger('Comment','Background',0);
cbbComment.Selected:=aIni.ReadInteger('Comment','Foreground',0);

cbfFloat.Selected:=aIni.ReadInteger('Float','Background',0);
cbbFloat.Selected:=aIni.ReadInteger('Float','Foreground',0);

cbfHex.Selected:=aIni.ReadInteger('Hexadecimal','Background',0);
cbbHex.Selected:=aIni.ReadInteger('Hexadecimal','Foreground',0);

cbfIdent.Selected:=aIni.ReadInteger('Identifier','Background',0);
cbbIdent.Selected:=aIni.ReadInteger('Identifier','Foreground',0);

cbfIllegal.Selected:=aIni.ReadInteger('IllegalChar','Background',0);
cbbIllegal.Selected:=aIni.ReadInteger('IllegalChar','Foreground',0);

cbfOct.Selected:=aIni.ReadInteger('Octal','Background',0);
cbbOct.Selected:=aIni.ReadInteger('Octal','Foreground',0);

cbfPreProc.Selected:=aIni.ReadInteger('Preprocessor','Background',0);
cbbPreProc.Selected:=aIni.ReadInteger('Preprocessor','Foreground',0);

cbfReserved.Selected:=aIni.ReadInteger('ReservedWord','Background',0);
cbbReserved.Selected:=aIni.ReadInteger('ReservedWord','Foreground',0);

cbfSpace.Selected:=aIni.ReadInteger('Space','Background',0);
cbbSpace.Selected:=aIni.ReadInteger('Space','Foreground',0);

cbfNum.Selected:=aIni.ReadInteger('Number','Background',0);
cbbNum.Selected:=aIni.ReadInteger('Number','Foreground',0);


cbfString.Selected:=aIni.ReadInteger('String','Background',0);
cbbString.Selected:=aIni.ReadInteger('String','Foreground',0);

cbfSymbol.Selected:=aIni.ReadInteger('Symbol','Background',0);
cbbSymbol.Selected:=aIni.ReadInteger('Symbol','Foreground',0);


aIni.Free;


end;

end.
