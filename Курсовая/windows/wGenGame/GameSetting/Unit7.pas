unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit3, Buttons;

type
  listPoint = ^list;
  list = record
    next: listPoint;
    prev: listPoint;
    difInt: Integer;
    difStr: string;
  end;
  TGameSetting = class(TForm)
    lbl1: TLabel;
    Label1: TLabel;
    lbl2: TLabel;
    btn4: TSpeedButton;
    btn5: TSpeedButton;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GameSetting: TGameSetting;
  first: listPoint;

implementation

{$R *.dfm}

procedure TGameSetting.btn1Click(Sender: TObject);
begin
  mapLength := 7;
  LineWidth := 33;
  Close;
end;

procedure TGameSetting.btn2Click(Sender: TObject);
begin
  mapLength := 9;
  LineWidth := 23;
  Close;
end;

procedure TGameSetting.btn3Click(Sender: TObject);
begin
  mapLength := 11;
  LineWidth := 18;
  close;      
end;

procedure TGameSetting.FormCreate(Sender: TObject);
begin
  new(first);
  first^.difInt:=4;
  first^.difStr:='Стандартная';
  New(first^.next);
  first^.next^.difInt:=2;
  first^.next^.difStr:='Сложная';
  first^.next^.prev:=first;
  New(first^.prev);
  first^.prev^.difInt:=6;
  first^.prev^.difStr:='Лёгкая';
  first^.prev^.next:=first;
  first^.prev^.prev:=first^.next;
  first^.next^.next:=first^.prev;
  different:=4;
end;

procedure TGameSetting.btn4Click(Sender: TObject);
begin
  first:=first^.prev;
  different:=first^.difInt;
  lbl2.Caption:=first^.difStr;
end;

procedure TGameSetting.btn5Click(Sender: TObject);
begin
  first:=first^.next;
  different:=first^.difInt;
  lbl2.Caption:=first^.difStr;
end;

procedure TGameSetting.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  flagforThread:=False;
end;

end.
