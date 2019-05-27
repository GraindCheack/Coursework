unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, acPNG, StdCtrls, jpeg;

type
  TGameAn = class(TForm)
    img1: TImage;
    img2: TImage;
    img3: TImage;
    img4: TImage;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  showButton, showSetting, showHelp, showLoad, showScore: Boolean;
  GameAn: TGameAn;

implementation

uses Unit3, Unit4, Unit5, Unit6, Unit1;

{$R *.dfm}

procedure TGameAn.btn1Click(Sender: TObject);
begin
  Close;
end;

procedure TGameAn.btn2Click(Sender: TObject);
begin
  Game.Hide;
  GameAn.Hide;
  GenGame.ShowModal;
  Game.Show;
end;

procedure TGameAn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  flag:=True;
end;

end.
