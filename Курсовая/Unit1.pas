unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TGame = class(TForm)
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    btn4: TSpeedButton;
    btn5: TSpeedButton;
    img1: TImage;
    procedure btn1Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Game: TGame;
  showButton, showSetting, showHelp, showLoad, showScore: Boolean;
  buttonGenMenu: array [1..2] of TSpeedButton;

implementation

uses Unit3, Unit4, Unit5, Unit6;

{$R *.dfm}

procedure TGame.OnCreate(Sender: TObject);
var
  i: integer;
  speedButton: TSpeedButton;
  map: TBitmap;
begin
  for i:=1 to 2 do
  begin
    speedButton:=TSpeedButton.Create(self);
    speedButton.Parent:=Game;
    speedButton.Height:=49;
    speedButton.Width:=145;
    speedButton.Tag:=i;
    speedButton.Hide;
    buttonGenMenu[i]:=speedButton;
  end;
  map:=TBitmap.Create;
  buttonGenMenu[1].Left:=128;
  buttonGenMenu[1].Top:=32;
  map.LoadFromFile('images\Buttons_im\setting.bmp');
  buttonGenMenu[1].Glyph:=map;
  buttonGenMenu[2].Left:=40;
  buttonGenMenu[2].Top:=104;
  buttonGenMenu[2].Glyph:=map;
  showButton:=True;
end;

procedure TGame.btn1Click(Sender: TObject);
begin
  close;
end;

procedure TGame.btn5Click(Sender: TObject);
begin
  if showButton then
  begin
    buttonGenMenu[1].Show;
    buttonGenMenu[2].Show;
    showButton:=False;
  end
  else
  begin
    buttonGenMenu[1].Hide;
    buttonGenMenu[2].Hide;
    showButton:=True;
  end;
end;


procedure TGame.btn2Click(Sender: TObject);
begin
  Game.Hide;
  GenGame.ShowModal;
  Game.Show;
end;

end.
