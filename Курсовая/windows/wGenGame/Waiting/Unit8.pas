unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Buttons,
  acPNG, ExtCtrls,
  StdCtrls;

type
  TWaiting = class(TForm)
    btn2: TSpeedButton;
    btn1: TSpeedButton;
    img1: TImage;
    lbl1: TLabel;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Waiting: TWaiting;

implementation

uses Unit3,
  Unit7;

{$R *.dfm}

procedure TWaiting.btn2Click(Sender: TObject);
begin
  GenGame.tmr1.Enabled:=True;
  Waiting.Close;
end;

procedure TWaiting.btn1Click(Sender: TObject);
begin
  flagForBreak:=True;
  GenGame.Close;
  Waiting.Close;
end;

procedure TWaiting.img1Click(Sender: TObject);
begin
  gamesetting.bringtofront;
end;

procedure TWaiting.FormCreate(Sender: TObject);
begin
  GameSetting.BringToFront;
end;

end.
