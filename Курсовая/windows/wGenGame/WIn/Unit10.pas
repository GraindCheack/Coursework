unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, Unit3, StdCtrls;

type
  TWin = class(TForm)
    img1: TImage;
    btn1: TButton;
    btn2: TButton;
    lbl1: TLabel;
    img2: TImage;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Win: TWin;

implementation

{$R *.dfm}

procedure TWin.btn2Click(Sender: TObject);
begin
  flag:=True;
  GenGame.clearGame;
  GenGame.FormActivate(GenGame);
  Win.Close;
end;

procedure TWin.btn1Click(Sender: TObject);
begin
  GenGame.Close;
  Win.Close;
end;

end.
