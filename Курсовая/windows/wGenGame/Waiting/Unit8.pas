unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TWaiting = class(TForm)
  
  private
    { Private declarations }
  public
    procedure interruption(Sender: TObject);
    procedure Start(Sender: TObject);
    { Public declarations }
  end;

var
  Waiting: TWaiting;

implementation

uses Unit3;

{$R *.dfm}

procedure TWaiting.interruption(Sender: TObject);
begin
  GenGame.Close;
  Waiting.Close;
end;

procedure TWaiting.Start(Sender: TObject);
begin
  Waiting.Close;
  GenGame.tmr1.Enabled:=True;
end;

end.
