program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Game},
  Unit2 in 'windows\wLoad\Unit2.pas' {Load},
  Unit3 in 'windows\wGenGame\Unit3.pas' {GenGame},
  Unit4 in 'windows\wHelp\Unit4.pas' {Help},
  Unit5 in 'windows\wScore\Unit5.pas' {Score},
  Unit6 in 'windows\wSetting\Unit6.pas' {Setting},
  Unit7 in 'windows\wGenGame\GameSetting\Unit7.pas' {GameSetting},
  Unit8 in 'windows\wGenGame\Waiting\Unit8.pas' {Waiting};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGame, Game);
  Application.CreateForm(TLoad, Load);
  Application.CreateForm(TGenGame, GenGame);
  Application.CreateForm(THelp, Help);
  Application.CreateForm(TScore, Score);
  Application.CreateForm(TSetting, Setting);
  Application.CreateForm(TGameSetting, GameSetting);
  Application.CreateForm(TWaiting, Waiting);
  Application.Run;
end.
