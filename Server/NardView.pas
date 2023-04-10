unit NardView;

interface

{
  NardView Component..
  something old made new..

  3.5.2023  ~q
}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;


type
   TParamSet = array[0..3] of integer;
  // what type of test mode..
  TModeTest = (mtNone, mtRecord, mtLoop);
  // shared click event for all encapsulated components..
  TNardViewClickEvent = procedure(Sender: TObject) of Object;
  TNardViewMouseEvent = procedure (Sender: TObject ; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of Object;

  // the component..
  TNardView = class(TCustomPanel)

  private
    { Private declarations }
    FModeTestType: TModeTest;
     //nard nnum
    FNardNumberLbl: TLabel;
    //nard name
    FNameLbl: TLabel;
    //displayed values 1 and 2
    FDV1Lbl: TLabel;
    FDV2Lbl: TLabel;

    FNardImage: TImage;
    FIndicatorImage: TImage;
    fParamsDown:TParamSet;
    fParamsUp:TParamSet;
    fParamIndex:integer;
    fNoClick:Boolean;

    fIsNardOn: Boolean;
    FWorkInProgress: Boolean;
    FIsBusy: integer;
    FGroupNumber: integer;
    FProcessNumber: integer;
    FTimeSequence: Boolean;
    FItemId: integer;
    FOnClicked: TNardViewClickEvent;
    FOnDown:TNardViewMouseEvent;
    FOnUp:tNardViewMouseEvent;

    FNardPicture: TPicture;
    FIndicatorPicture: TPicture;
    FNardIsSlow: Boolean;
    FNardOnline: Boolean;
    FShowDV2: Boolean;
    fShowDV1:boolean;
    FRepairLock: Boolean;
    fSelected: Boolean;
    fShowText:boolean;
    procedure SetRepairLock(Value: Boolean);
    procedure SetShowDV1(Value: Boolean);
    procedure SetShowDV2(Value: Boolean);
    procedure TheIPictChanged(Sender: TObject);
    procedure ThePictChanged(Sender: TObject);
    Function CreateLbls(S: String): TLabel;
    Procedure DoClick(Sender: TObject);
    Procedure DoDown(Sender:TObject ; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure DoUp(Sender:TObject ; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetIndicatorImage(Value: TPicture);
    procedure SetNardImage(Value: TPicture);
    procedure SetIsCommBusy(Value: integer);
    Function GetNardNumber: integer;
    procedure SetNardNumber(Value: integer);
    procedure SetOnline(Value: Boolean);
    procedure SetNardIsSlow(Value: Boolean);
    Procedure SetModeTestType(Value: TModeTest);
    Function GetNardName: String;
    Procedure SetNardName(S: String);
    Function GetNardOn: Boolean;
    Procedure SetNardOn(b: Boolean);
    procedure SetWorkInProgress(Value: Boolean);
    Function GetDV1: string;
    Procedure SetDV1(val: string);
    procedure SetGroupNumber(Value: integer);
    procedure SetProcessNumber(Value: integer);
    Procedure SetTimedLoop(Value: Boolean);
    procedure SetSelected(Value: Boolean);
    procedure SetStatusMsg(Value: String);
    function GetStatusMsg: String;

  protected
    { Protected declarations }
    property Caption;
  public
    { Public declarations }
    // override the create method of the panel..
    constructor Create(AOwner: TComponent; aWidth:integer; aHeight:integer); reintroduce;
    // override the destroy and clean up things..
    destructor Destroy; override;
    property DownParams:TParamSet read fParamsDown write fParamsDown;
    property UpParams:TParamSet read fParamsUp write fParamsUp;

  published
    { Published declarations }
    Property NoClick:boolean read fNoClick write fNoClick;
    Property Selected: Boolean read fSelected write SetSelected;
    Property Locked: Boolean Read FRepairLock Write SetRepairLock Default False;
    property ShowDV1: Boolean read FShowDV1 write SetShowDV1;
    property ShowDV2: Boolean read FShowDV2 write SetShowDV2;
    // now for some standard properties..
    property ParentBackground;
    property ParentColor;
    property StyleElements;
    property Color;
    property TabStop;
    property TabOrder;
    property Enabled;
    property Visible;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property DragKind;
    property DragMode;
    property OnEndDock;
    Property ParamIndex:integer read fParamIndex write fParamIndex;
    Property GroupNumber: integer Read FGroupNumber Write SetGroupNumber default 0;
    Property ProcessNumber: integer Read FProcessNumber Write SetProcessNumber Default 0;
    property OnLine: Boolean Read FNardOnline write SetOnline default False;
    property IsBusy: integer Read FIsBusy write SetIsCommBusy default 0;
    property WorkInProgress: Boolean Read FWorkInProgress Write SetWorkInProgress default False;
    Property TestMode: TModeTest Read FModeTestType write SetModeTestType default mtNone;
    Property Slow: Boolean Read FNardIsSlow Write SetNardIsSlow Default False;
    Property NardNumber: integer Read GetNardNumber write SetNardNumber;
    Property OnClicked: TNardViewClickEvent Read FOnClicked write FOnClicked;
    Property OnDown:TNardViewMouseEvent read fOnDown write fOnDown;
    Property OnUp:TNardViewMouseEvent read fOnUp write fOnUp;
    property IndicatorImage: TPicture Read FIndicatorPicture Write SetIndicatorImage;
    Property NardImage: TPicture Read FNardPicture write SetNardImage;
    Property NardName: String Read GetNardName write SetNardName;
    Property IsOn: Boolean Read GetNardOn write SetNardOn;
    Property TimeLoop: Boolean Read FTimeSequence write SetTimedLoop default False;
    Property ItemID: integer Read FItemId write fItemId;
    Property LblVal1:tLabel Read FDV1Lbl write FDV1Lbl;
    Property LblVal2:tLabel Read FDV2Lbl write FDV2Lbl;
    Property LblNardName:tLabel read FNameLbl write fNameLbl;
    Property LblNardNum:tLabel read fNardNumberLbl write fNardNumberLbl;


  end;



implementation


constructor TNardView.Create(AOwner: TComponent; aWidth:integer; aHeight:integer);
var
i:integer;
begin
  inherited Create(AOwner);
   //init params
   for I := 0 to 3 do
     begin
       fParamsUp[i]:=0;
       fParamsDown[i]:=0;
     end;

  fNoClick:=false;
  fParamIndex:=0;

  ParentColor := False;
  ParentBackground := False;
  BevelInner := bvNone;
  BevelOuter :=bvNone;
  BevelKind := bkNone;
  fShowText:=False;
 // StyleElements := [];
   NardNumber := 1;
  // set the size of the control..
  Width := aWidth;
  Height := aHeight;
  Caption := '';
  // default color on creation..
  Color := clNavy;

  FNardImage := TImage.Create(Self);
  FNardImage.Parent := Self;
  FNardImage.Visible := True;
  FNardImage.SetBounds(1, 1, Width, Height);
  FNardImage.Stretch := true;
  FNardImage.OnClick := DoClick;
  FNardImage.OnMouseDown := DoDown;
  FNardImage.OnMouseUp := DoUp;
  FNardImage.Transparent := False;
  FNardPicture := TPicture.Create;
  // assign the change event..
  FNardPicture.OnChange := ThePictChanged;
  FIndicatorImage := TImage.Create(Self);
  FIndicatorImage.Parent := Self;
  FIndicatorImage.Visible := False;
  FIndicatorImage.SetBounds(8, 61, Width div 3, Height div 3);
  // FIndicatorImage.Stretch:=True;
  FIndicatorImage.Transparent := True;
  FIndicatorImage.OnClick := DoClick;
  FIndicatorPicture := TPicture.Create;
  // assign the change event..
  FIndicatorPicture.OnChange := TheIPictChanged;


  FNameLbl := CreateLbls('00:00');
  // position it..
  FNameLbl.SetBounds(2, 8, Width-4, 25);
  FNameLbl.AutoSize := False;
  FNameLbl.Font.Size := 8;
  FNameLbl.Font.Color := clBlack;
  FNameLbl.Font.Style := [fsBold];
  FNameLbl.Transparent := True;
  FNameLbl.BringToFront;
  FNameLbl.StyleElements :=[];


  FDV1Lbl := CreateLbls('00.00');
  FDV1Lbl.AutoSize := False;
  FDV1Lbl.SetBounds(2, 38, Width-4, 25);
  FDV1Lbl.Alignment := taCenter;
  FDV1Lbl.Font.Size := 12;
  FDV1Lbl.Font.Style := [fsBold];
  FDV1Lbl.Font.Color := clBlack;
  FDV1Lbl.Transparent := true;
  FDV1Lbl.BringToFront;
  FDV1Lbl.StyleElements :=[];



  FDV2Lbl := CreateLbls('00.00');
  FDV2Lbl.AutoSize := False;
  FDV2Lbl.SetBounds(2, 10, Width-4, 25);
  FDV2Lbl.Transparent := true;
  FDV2Lbl.Font.Color := clBlack;
  FDV2Lbl.Font.Style := [fsBold];
  FDV2Lbl.Font.Size := 12;
  FDV2Lbl.BringToFront;
  FDV2Lbl.Visible := False;
  FDV2Lbl.WordWrap := False;
  FDV2Lbl.Alignment := taCenter;
  FDV2Lbl.StyleElements := [];



  FNardNumberLbl := CreateLbls('1');
  // position it..
  FNardNumberLbl.AutoSize := False;
  FNardNumberLbl.Alignment := taCenter;
  FNardNumberLbl.SetBounds(70, 68, 23, 24);
  FNardNumberLbl.BringToFront;
  FNardNumberLbl.Transparent := True;
  FNardNumberLbl.Font.Color := clBlack;
  FNardNumberLbl.Font.Style := [fsBold];
  FNardNumberLbl.Font.Size := 14;
  fNardNumberLbl.StyleElements :=[];
  fNardNumberLbl.Visible :=false;

  // not on!!
  IsOn := False;

  // assign our shared click event..
  OnClick := DoClick;
end; // constructor..

// override the destructor to clean up things..
destructor TNardView.Destroy;
begin
  // get rid of the shit we created!!
  FNardPicture.Free;
  FIndicatorPicture.Free;
  FNardImage.Free;
  FIndicatorImage.Free;


  FNardNumberLbl.Free;
  FDV2Lbl.Free;
  FNameLbl.Free;
  FDV1Lbl.Free;
  inherited Destroy;
end;

// function that creates and returns a lebel..
Function TNardView.CreateLbls(S: String): TLabel;
begin
  Result := TLabel.Create(Self);
  Result.Parent := Self;
  Result.Visible := True;
  Result.Caption := S;
  // dont forget to set the common click event..
  Result.OnClick := DoClick;
end;

// set the status message
procedure TNardView.SetStatusMsg(Value: String);
begin
  FDV2Lbl.Caption := Value;
end;

// get the status message
function TNardView.GetStatusMsg: String;
begin
  Result := FDV2Lbl.Caption;
End;

procedure TNardView.SetRepairLock(Value: Boolean);
begin
  FRepairLock := Value;
end;


procedure TNardView.SetShowDV1(Value: Boolean);
begin
  FShowDV1 := Value;
  if FShowDV1 then
  begin
    if not FDV1Lbl.Visible then
    begin
      FDV1Lbl.Visible := True;
    End;
  end
  else
  begin
    if FDV1Lbl.Visible then
    begin
      FDV1Lbl.Visible := False;
    end;
  end;
end;


procedure TNardView.SetShowDV2(Value: Boolean);
begin
  FShowDV2 := Value;
  if FShowDV2 then
  begin
    if not FDV2Lbl.Visible then
    begin
      FDV2Lbl.Visible := True;
    End;
  end
  else
  begin
    if FDV2Lbl.Visible then
    begin
      FDV2Lbl.Visible := False;
    end;
  end;
end;


procedure TNardView.SetIsCommBusy(Value: integer);
begin
  FIsBusy := Value;
  if FIsBusy > 0 then
  begin
    if FNameLbl.Visible then
    begin
      FNameLbl.Visible := False;
      FDV1Lbl.Visible := False;
      FIndicatorImage.Visible := False;
      FDV2Lbl.Visible := False;
    end;
  end
  else
  begin
    if fIsNardOn then
    begin
      if not FNameLbl.Visible then
      begin
        FNameLbl.Visible := True;
        if FShowDV2 then
          FDV2Lbl.Visible := True;
        if FShowDV1 then
          FDV1Lbl.Visible := True;
        FIndicatorImage.Visible := True;
      end;
    end;
  end;

end;


procedure TNardView.SetGroupNumber(Value: integer);
begin
  FGroupNumber := Value;
end;

procedure TNardView.SetNardIsSlow(Value: Boolean);
Begin
  if Value <> FNardIsSlow then
    FNardIsSlow := Value;
end;

procedure TNardView.SetOnline(Value: Boolean);
begin
  if Value then
  begin
    FNardOnline := True;
    FNameLbl.Visible := False;
    FDV1Lbl.Visible := False;
    FDV2Lbl.Visible := False;
    if fIsNardOn then
    begin
      // show the labels we need
      FNameLbl.Visible := True;
      if FShowDV2 then
        FDV2Lbl.Visible := True ;
    if FShowDV1 then
        FDV1Lbl.Visible := True;
      FIndicatorImage.Visible := True;
    end
    else
    begin
      FNameLbl.Visible := False;
      FDV1Lbl.Visible := False;
      FIndicatorImage.Visible := False;
      FDV2Lbl.Visible := False;
    end;
  end
  else
  begin
    FNardOnline := False;
    FNameLbl.Visible := False;
    FDV1Lbl.Visible := False;
    FIndicatorImage.Visible := False;
    FDV2Lbl.Visible := False;
  end;
end;

Function TNardView.GetDV1: string;
begin
  Result := FDV1Lbl.Caption;
end;

// our shared click event..
procedure TNardView.DoClick(Sender: TObject);
begin
  if Assigned(FOnClicked) then
    FOnClicked(Self);
end;

procedure TNardView.DoDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if Assigned(fOnDown) then
     fOnDown(Self,Button,Shift,x,y);
end;

procedure TNardView.DoUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if Assigned(fOnUp) then
    fOnUp(Self,Button,Shift,x,y);
end;

procedure TNardView.SetModeTestType(Value: TModeTest);
begin
  if Value <> FModeTestType then
    FModeTestType := Value;
end;

procedure TNardView.SetWorkInProgress(Value: Boolean);
begin
  if Value <> FWorkInProgress then
    FWorkInProgress := Value;
end;


procedure TNardView.SetDV1(val: string);
begin
  FDV1Lbl.Caption := val;
end;

Function TNardView.GetNardName: String;
begin
  Result := FNameLbl.Caption;
end;

procedure TNardView.SetNardName(S: String);
begin
  FNameLbl.Caption := S;
end;

procedure TNardView.SetNardImage(Value: TPicture);
begin
  FNardPicture.Assign(Value);
end;

procedure TNardView.SetIndicatorImage(Value: TPicture);
begin
  FIndicatorPicture.Assign(Value);
end;

Function TNardView.GetNardOn: Boolean;
begin
  Result := fIsNardOn;
end;

procedure TNardView.SetNardOn(b: Boolean);
begin
  if b then
  begin
    fIsNardOn := True;
    FNameLbl.Visible := True;
    if FShowDV2 then
      FDV2Lbl.Visible := True;
    if FShowDV1 then
      FDV1Lbl.Visible := True;
     FIndicatorImage.Visible := True;
  end
  else
  begin
    fIsNardOn := False;
    FNameLbl.Visible := False;
    FDV1Lbl.Visible := False;
    FIndicatorImage.Visible := False;
    FDV2Lbl.Visible := False;
  end;
end;

Function TNardView.GetNardNumber: integer;
begin
  Result := StrToInt(FNardNumberLbl.Caption);
end;

Procedure TNardView.SetNardNumber(Value: integer);
begin
  FNardNumberLbl.Caption := IntToStr(Value);
end;

procedure TNardView.SetProcessNumber(Value: integer);
begin
  FProcessNumber := Value;
end;

// if the picture changes do this..
procedure TNardView.ThePictChanged(Sender: TObject);
begin
  FNardImage.Picture.Assign(FNardPicture);
end;

// if the indicator picture has changed!!
procedure TNardView.TheIPictChanged(Sender: TObject);
begin
  FIndicatorImage.Picture.Assign(FIndicatorPicture);
end;

procedure TNardView.SetTimedLoop(Value: Boolean);
begin
  FTimeSequence := Value;
end;


procedure TNardView.SetSelected(Value: Boolean);
begin
  if Value <> fSelected then
  begin
    if Value then
    begin
      fSelected := True;
    end
    else
    begin
      fSelected := False;
    end;
  end;
end;


end.
