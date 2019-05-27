unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls,
  Animate, GIFCtrl,
  acPNG;

type
  TGame = class(TForm)
    img1: TImage;
    tmr1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TFirstThreadGen = class(TThread)  // объявление класса потока, где процедура execute выполняется при создании потока
  private
  protected
    procedure Execute; override;
  end;

var
  Game: TGame;
  threadGen: TFirstThreadGen;
  iAn: Integer;
  flag: Boolean;

implementation

uses Unit9;

{$R *.dfm}

procedure TFirstThreadGen.Execute; // действия, которые в потоке. Здесь у меня открывается форма в новом потоке
begin
  GameAn.Show;
  threadGen.Terminate;
end;

procedure TGame.tmr1Timer(Sender: TObject);
begin
  if iAn=300 then
    iAn:=0;
  Game.img1.Picture.LoadFromFile('windows\wAnimation\animate4\'+intToStr(1000+iAn)+'.jpg');
  iAn:=iAn+1;
  GameAn.Top:=Game.Top;
  GameAn.Left:=Game.Left;
  GameAn.Height:=Game.Height;
  GameAn.Width:=Game.Width;
end;

procedure TGame.FormActivate(Sender: TObject);
begin
  if flag then
  begin
    Close;
    Exit;
  end;
  iAn:=0;
  threadGen := nil;
  threadGen := TFirstThreadGen.Create(true); // выделение памяти и само создание потока
  threadGen.FreeOnTerminate := True;
  threadGen.Resume;  // поток запускается. Выполняется Execute
  tmr1.Enabled:=True;
end;

procedure TGame.FormHide(Sender: TObject);
begin
  tmr1.Enabled:=False;
end;

end.
