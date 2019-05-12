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
    procedure interruption;
    procedure Start;
    { Public declarations }
  end;

var
  Waiting: TWaiting;

implementation

uses Unit3;

{$R *.dfm}

procedure TWaiting.interruption;
begin
  GenGame.Close;
  Waiting.Close;
end;

procedure TWaiting.Start;
begin
  Waiting.Close;
end;

end.
