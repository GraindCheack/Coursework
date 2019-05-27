unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ExtCtrls, jpeg,
  acPNG;

type
  imageArray = array of array of TImage;
  intDArr = array of array of Integer;
  boolDArr = array of array of Boolean;
  dot = record
    up, down, left, right, flag: Boolean;
  end;
  queuePointer = ^queue;
  queue = record
    i, j: Integer;
    next: queuePointer;
  end;
  stackPointer = ^stack;
  stack = record
    i, j: Integer;
    next: stackPointer;
  end;
  dotDArr = array of array of dot;
  TGenGame = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    tmr1: TTimer;
    lbl2: TLabel;
    img1: TImage;
    btn1: TButton;
    btn2: TButton;
    tmr2: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure ShowGameSettingMenu(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure createGameMenu(Sender: TObject; imageLocation: string; imageHeight, imageWidth, topLocation, leftLocation, amountImI, amountImJ, step: Integer; var imageArr: imageArray);
    procedure ImageHClick(Sender: TObject);
    procedure ImageVClick(Sender: TObject);
    procedure createMap(var numberArr: intDArr; var dotArr: dotDArr; var amountBorder: integer; N, DIF: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure clearGame;
    procedure btn1Click(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TFirstThread = class(TThread)
  private
  protected
    procedure Execute; override;
  end;
  TSecondThread = class(TThread)
  private
  protected
    procedure Execute; override;
  end;

var
  GenGame: TGenGame;
  squareArray, lineArray1, lineArray2, spyLine1, spyLine2, dotArrayImage: imageArray;
  mapLength, LineWidth, checkI, checkJ, check, different, amountBorder, startI, startJ, counter: integer;
  firstForHint: stackPointer;
  mapArr, changeMapArr: intDArr;
  dotArr, checkDotArr, tempDotArr: dotDArr;
  flag, flagforThread, flagForBreak: Boolean;
  sec: TDateTime;
  firstThread: TFirstThread;
  secondThread: TSecondThread;

implementation

uses Unit7, Unit8, Unit10;

{$R *.dfm}

procedure setNumber(dotArr: dotDArr; var tempArr: intDArr; var amountBorder: Integer; N: Integer; var flag: Boolean);
var
  i, j: Integer;
begin
  for i:=0 to N-1 do
    for j:=0 to N-1 do
    begin
      if (dotArr[i+1, j+1].flag=True) and (dotArr[i+1, j+1].right=True) and (dotArr[i+1,j+2].flag=True) and (dotArr[i+1,j+2].left=True) then
      begin
        tempArr[i,j]:=tempArr[i,j]+1;
        flag:=True;
        amountBorder:=amountBorder+1;
      end;
      if (dotArr[i+2, j+1].flag=True) and (dotArr[i+2, j+1].right=True) and (dotArr[i+2,j+2].flag=True) and (dotArr[i+2,j+2].left=True) then
      begin
        tempArr[i,j]:=tempArr[i,j]+1;
        flag:=True;
        amountBorder:=amountBorder+1;
      end;
      if (dotArr[i+1, j+1].flag=True) and (dotArr[i+1, j+1].down=True) and (dotArr[i+2,j+1].flag=True) and (dotArr[i+2,j+1].up=True) then
      begin
        tempArr[i,j]:=tempArr[i,j]+1;
        flag:=True;
        amountBorder:=amountBorder+1;
      end;
      if (dotArr[i+1, j+2].flag=True) and (dotArr[i+1, j+2].down=True) and (dotArr[i+2,j+2].flag=True) and (dotArr[i+2,j+2].up=True) then
      begin
        tempArr[i,j]:=tempArr[i,j]+1;
        flag:=True;
        amountBorder:=amountBorder+1;
      end;
    end;
end;

procedure hideNumber(dotArr: dotDArr; var numberArr: intDArr; var flag: Boolean; var amountBorder, N: Integer);
var
  i, nStep, randomValueI, RandomValueJ: Integer;
  tempArr: intDArr;
  amountArr: array [0..3] of Byte;
  imageLoad: TPicture;
begin
  SetLength(tempArr, N, N);
  setNumber(dotArr, tempArr, amountBorder, N, flag);
  for i:=0 to 3 do
    amountArr[i]:=0;
  Randomize;
  nStep:=N*4-7+Random(3);
  i:=0;
  while (i<>nStep) and (flag=True) and (amountBorder>=N*N) do
  begin
    randomValueI:=Random(N)+1;
    randomValuej:=Random(N)+1;
    if ((tempArr[randomValueI-1, RandomValueJ-1]>0) and (amountArr[tempArr[randomValueI-1, RandomValueJ-1]]<(nStep-(N-2))) and (numberArr[randomValueI, RandomValueJ]=-1))
    or ((tempArr[randomValueI-1, RandomValueJ-1]=0)and(amountArr[0]<N-1)) then
    begin
      numberArr[randomValueI, RandomValueJ]:=tempArr[randomValueI-1,RandomValueJ-1];
      Inc(amountArr[tempArr[randomValueI-1, RandomValueJ-1]]);
      imageLoad:=TPicture.Create;
      imageLoad.LoadFromFile('images\WhiteColor' + IntToStr(numberArr[randomValueI, RandomValueJ]) + '.png');
      squareArray[randomValueI, RandomValueJ].Picture:=imageLoad;
      i:=i+1;
    end;
  end;
end;

procedure addInQueue(var last, first: queuePointer; i, j: Integer);
begin
  if last<>nil then
  begin
    New(last^.next);
    last^.next^.i:=i;
    last^.next^.j:=j;
    last:=last^.next;
  end
  else
  begin
    New(last);
    first:=last;
    last^.i:=i;
    last^.j:=j;
  end;
end;

procedure removeHeadStack(var first: stackPointer);
var
  temp: stackPointer;
begin
  if first<>nil then
  begin
    temp:=first;
    first:=first^.next;
    Dispose(temp);
  end;
end;

procedure addInStack(var first: stackPointer; i, j: Integer);
var
  temp: stackPointer;
begin
  New(temp);
  temp^.i:=i;
  temp^.j:=j;
  temp^.next:=first;
  first:=temp;
end;

procedure cleanArr(var tempArr: intDArr; N: integer);
var
  i, j: integer;
begin
  for i:=0 to N-1 do
    for j:=0 to N-1 do
      tempArr[i,j]:=-1;
end;

procedure fillAround(var tempArr: intDArr; dotArr: dotDArr; var i, j, a, b, N: Integer; var last, first: queuePointer);
begin
  if (i-1>=0) and (tempArr[i-1, j]=-1) and
  ((dotArr[i+1, j+1].right=False) or (dotArr[i+1,j+2].left=False)) then
  begin
    b:=b+1;
    tempArr[i-1, j]:=a+1;
    addInQueue(last, first, i-1, j);
  end;
  if (j-1>=0) and (tempArr[i, j-1]=-1) and
  ((dotArr[i+1, j+1].down=False) or (dotArr[i+2,j+1].up=False)) then
  begin
    b:=b+1;
    tempArr[i, j-1]:=a+1;
    addInQueue(last, first, i, j-1);
  end;
  if (i+1<N) and (tempArr[i+1, j]=-1) and
  ((dotArr[i+2, j+1].right=False) or (dotArr[i+2,j+2].left=False)) then
  begin
    b:=b+1;
    tempArr[i+1, j]:=a+1;
    addInQueue(last, first, i+1, j);
  end;
  if (j+1<N) and (tempArr[i, j+1]=-1) and
  ((dotArr[i+1, j+2].down=False) or (dotArr[i+2,j+2].up=False)) then
  begin
    b:=b+1;
    tempArr[i, j+1]:=a+1;
    addInQueue(last, first, i, j+1);
  end;
end;

procedure fillMap(var tempArr: intDArr; dotArr: dotDArr; N, i, j: Integer);
var
  first, last, temp: queuePointer;
  a, b, c, d: Integer;
begin
  a:=0;
  b:=0;
  first:=nil;
  last:=nil;
  fillAround(tempArr, dotArr, i, j, a, b, N, last, first);
  d:=b;
  a:=1;
  while first<>nil do
  begin
    b:=0;
    for c:=1 to d do
    begin
      fillAround(tempArr, dotArr, first^.i, first^.j, a, b, N, last, first);
      temp:=first;
      first:=first^.next;
      Dispose(temp);
    end;
    d:=b;
    if d=0 then
      Break;
    a:=a+1;
  end;
end;

procedure createBorder(var dotArr: dotDArr; tempArr: intDArr; var first, last: stackPointer; var step :integer; i, j, N, dif, b, c, nStep: integer);
var
  randomValue, tempFlag, tempI, tempJ: integer;
  temp: stackPointer;
begin
  tempFlag:=0;
  randomValue:=10;
  Randomize;
  while (tempFlag<dif)and(tempFlag>=0)and(first<>nil) do
  begin
    if (first<>nil) and
    (not(
    ((dotArr[first^.i, first^.j].up=False) and (dotArr[first^.i-1, first^.j].flag=False)
    and (first^.i-1-b>=0) and (first^.j-c>=0) and ((tempArr[first^.i-1-b, first^.j-c]=tempArr[first^.i-b, first^.j-c]+1)))
    or ((dotArr[first^.i, first^.j].right=False) and (dotArr[first^.i, first^.j+1].flag=False)
    and (first^.j-c+1<N) and (first^.i-b>=0) and ((tempArr[first^.i-b, first^.j-c+1]=tempArr[first^.i-b, first^.j-c]+1)))
    or ((dotArr[first^.i, first^.j].down=False) and (dotArr[first^.i+1, first^.j].flag=False)
    and (first^.i-b+1<N) and (first^.j-c>=0) and ((tempArr[first^.i-b+1, first^.j-c]=tempArr[first^.i-b, first^.j-c]+1)))
    or ((dotArr[first^.i, first^.j].left=False) and (dotArr[first^.i, first^.j-1].flag=False)
    and (first^.j-c-1>=0) and (first^.i-b>=0) and ((tempArr[first^.i-b, first^.j-c-1]=tempArr[first^.i-b, first^.j-c]+1)))
    ))
    then
    begin
      dotArr[first^.i, first^.j].flag:=False;
      tempFlag:=tempFlag-1;
      case randomValue of
        1:
        begin
          dotArr[first^.i, first^.j].down:=False;
          tempI:=first^.i-1;
          tempJ:=first^.j;
        end;
        2:
        begin
          dotArr[first^.i, first^.j].left:=False;
          tempI:=first^.i;
          tempJ:=first^.j+1;
        end;
        3:
        begin
          dotArr[first^.i, first^.j].up:=False;
          tempI:=first^.i+1;
          tempJ:=first^.j;
        end;
        4:
        begin
          dotArr[first^.i, first^.j].right:=False;
          tempI:=first^.i;
          tempJ:=first^.j-1;
        end;
      end;
      if first<>nil then
        removeHeadStack(first);
    end;
    randomValue:=Random(4)+1;
    if (first<>nil)and(randomValue = 1) and (dotArr[first^.i, first^.j].up=False) and (dotArr[first^.i-1, first^.j].flag=False)
    and (first^.i-1-b>=0) and (first^.j-c>=0) and ((tempArr[first^.i-1-b, first^.j-c]=tempArr[first^.i-b, first^.j-c]+1))then
    begin
      dotArr[first^.i, first^.j].up:=True;
      dotArr[first^.i, first^.j].flag:=True;
      dotArr[first^.i-1, first^.j].down:=True;
      tempFlag:=tempFlag+1;
      addInStack(first, first^.i-1, first^.j);
    end
    else
    if (first<>nil)and(randomValue = 2) and (dotArr[first^.i, first^.j].right=False) and (dotArr[first^.i, first^.j+1].flag=False)
    and (first^.j-c+1<N) and (first^.i-b>=0) and ((tempArr[first^.i-b, first^.j-c+1]=tempArr[first^.i-b, first^.j-c]+1)) then
    begin
      dotArr[first^.i, first^.j].right:=True;
      dotArr[first^.i, first^.j].flag:=True;
      dotArr[first^.i, first^.j+1].left:=True;
      tempFlag:=tempFlag+1;
      addInStack(first, first^.i, first^.j+1);
    end
    else
    if (first<>nil)and(randomValue = 3) and (dotArr[first^.i, first^.j].down=False) and (dotArr[first^.i+1, first^.j].flag=False)
    and (first^.i-b+1<N) and (first^.j-c>=0) and ((tempArr[first^.i-b+1, first^.j-c]=tempArr[first^.i-b, first^.j-c]+1)) then
    begin
      dotArr[first^.i, first^.j].down:=True;
      dotArr[first^.i, first^.j].flag:=True;
      dotArr[first^.i+1, first^.j].up:=True;
      tempFlag:=tempFlag+1;
      addInStack(first, first^.i+1, first^.j);
    end
    else
    if (first<>nil)and(randomValue = 4) and (dotArr[first^.i, first^.j].left=False) and (dotArr[first^.i, first^.j-1].flag=False)
    and (first^.j-c-1>=0) and (first^.i-b>=0) and ((tempArr[first^.i-b, first^.j-c-1]=tempArr[first^.i-b, first^.j-c]+1)) then
    begin
      dotArr[first^.i, first^.j].left:=True;
      dotArr[first^.i, first^.j].flag:=True;
      dotArr[first^.i, first^.j-1].right:=True;
      tempFlag:=tempFlag+1;
      addInStack(first, first^.i, first^.j-1);
    end;
  end;
  if tempFlag<0 then
    step:=step-1;
end;

procedure checkWay(N, i, j, b, c: Integer; first: stackPointer; var dotArr: dotDArr; tempArr: intDArr; var flag: Boolean; endFlag: Boolean);
var
  tempDotArr: dotDArr;
  tempFirst: stackPointer;
  k, h: Integer;
begin
  flag:=False;
  if (first<>nil) and (first^.i-b>=0) and (first^.j-c>=0) and (first^.i-b<N) and (first^.j-c<N) then
  begin
    SetLength(tempDotArr, N+3, N+3);
    for k:=0 to N+2 do
      for h:=0 to N+2 do
        tempDotArr[k,h]:=dotArr[k,h];
    cleanArr(tempArr, N);
    tempArr[first^.i-b, first^.j-c]:=0;
    fillMap(tempArr, dotArr, N, first^.i-b, first^.j-c);
    New(tempFirst);
    tempFirst^.i:=first^.i;
    tempFirst^.j:=first^.j;
    tempFirst^.next:=nil;
    while tempFirst<>nil do
    begin
      if (tempFirst<>nil)and((tempFirst^.i-1=i) and (tempFirst^.j=j)) or ((tempFirst^.i+1=i) and (tempFirst^.j=j))
      or ((tempFirst^.i=i) and (tempFirst^.j-1=j)) or ((tempFirst^.i=i) and (tempFirst^.j+1=j))
      or ((tempFirst^.i=i) and (tempFirst^.j=j))  then
      begin
        if (tempFirst<>nil)and(tempFirst^.i-1=i) and (tempFirst^.j=j) then
        begin
          tempDotArr[tempFirst^.i, tempFirst^.j].up:=True;
          tempDotArr[tempFirst^.i-1, tempFirst^.j].down:=True;
        end;
        if (tempFirst<>nil)and(tempFirst^.i+1=i) and (tempFirst^.j=j) then
        begin
          tempDotArr[tempFirst^.i, tempFirst^.j].down:=True;
          tempDotArr[tempFirst^.i+1, tempFirst^.j].up:=True;
        end;
        if (tempFirst<>nil)and(tempFirst^.i=i) and (tempFirst^.j-1=j) then
        begin
          tempDotArr[tempFirst^.i, tempFirst^.j].left:=True;
          tempDotArr[tempFirst^.i, tempFirst^.j-1].right:=True;
        end;
        if (tempFirst<>nil)and(tempFirst^.i=i) and (tempFirst^.j+1=j) then
        begin
          tempDotArr[tempFirst^.i, tempFirst^.j].right:=True;
          tempDotArr[tempFirst^.i, tempFirst^.j+1].left:=True;
        end;
        flag:=True;
        while tempFirst<>nil do
          removeHeadStack(tempFirst);
      end
      else
      if (tempFirst<>nil)and(tempDotArr[tempFirst^.i-1, tempFirst^.j].flag=False)
      and (tempFirst^.i-1-b>=0) and (tempArr[tempFirst^.i-1-b, tempFirst^.j-c]=tempArr[tempFirst^.i-b, tempFirst^.j-c]+1) then
      begin
        tempDotArr[tempFirst^.i, tempFirst^.j].up:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j].flag:=True;
        tempDotArr[tempFirst^.i-1, tempFirst^.j].down:=True;
        tempDotArr[tempFirst^.i-1, tempFirst^.j].flag:=True;
        addInStack(tempFirst, tempFirst^.i-1, tempFirst^.j);
      end
      else
      if (tempFirst<>nil)and(tempDotArr[tempFirst^.i, tempFirst^.j+1].flag=False)
      and (tempFirst^.j-c+1<N) and (tempArr[tempFirst^.i-b, tempFirst^.j-c+1]=tempArr[tempFirst^.i-b, tempFirst^.j-c]+1) then
      begin
        tempDotArr[tempFirst^.i, tempFirst^.j].right:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j].flag:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j+1].left:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j+1].flag:=True;
        addInStack(tempFirst, tempFirst^.i, tempFirst^.j+1);
      end
      else
      if (tempFirst<>nil)and(tempDotArr[tempFirst^.i+1, tempFirst^.j].flag=False)
      and (tempFirst^.i-b+1<N) and (tempArr[tempFirst^.i-b+1, tempFirst^.j-c]=tempArr[tempFirst^.i-b, tempFirst^.j-c]+1) then
      begin
        tempDotArr[tempFirst^.i, tempFirst^.j].down:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j].flag:=True;
        tempDotArr[tempFirst^.i+1, tempFirst^.j].up:=True;
        tempDotArr[tempFirst^.i+1, tempFirst^.j].flag:=True;
        addInStack(tempFirst, tempFirst^.i+1, tempFirst^.j);
      end
      else
      if (tempFirst<>nil)and(tempDotArr[tempFirst^.i, tempFirst^.j-1].flag=False)
      and (tempFirst^.j-c-1>=0) and (tempArr[tempFirst^.i-b, tempFirst^.j-c-1]=tempArr[tempFirst^.i-b, tempFirst^.j-c]+1) then
      begin
        tempDotArr[tempFirst^.i, tempFirst^.j-1].flag:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j].left:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j].flag:=True;
        tempDotArr[tempFirst^.i, tempFirst^.j-1].right:=True;
        addInStack(tempFirst, tempFirst^.i, tempFirst^.j-1);
      end
      else if tempFirst<>nil then
      begin
        tempDotArr[tempFirst^.i, tempFirst^.j].up:=False;
        tempDotArr[tempFirst^.i, tempFirst^.j].right:=False;
        tempDotArr[tempFirst^.i, tempFirst^.j].down:=False;
        tempDotArr[tempFirst^.i, tempFirst^.j].left:=False;
        if tempFirst<>nil then
          removeHeadStack(tempFirst);
      end;
    end;
    if (flag) and (endFlag) then
      for k:=0 to N+2 do
        for h:=0 to N+2 do
          dotArr[k,h]:=tempDotArr[k,h];
    SetLength(tempDotArr, 0, 0);
  end;
end;

procedure solutionMap(var numberArr: intDArr; var dotArr: dotDArr; var amountBorder, N, dif: integer);
var
  i, j, nStep, step: Integer;
  flag: Boolean;
  tempArr: intDArr;
  first, checkFirst, lastFirst: stackPointer;
begin
  flag:=False;
  amountBorder:=0;
  while (not flag) or (amountBorder<N*N) do
  begin
    SetLength(dotArr, N+3, N+3);
    for i:=1 to N+1 do
    begin
      dotArr[0, i].flag:=True;
      dotArr[1, i].up:=True;
    end;
    for i:=1 to N+1 do
    begin
      dotArr[i, N+2].flag:=True;
      dotArr[i,  N+1].right:=True;
    end;
    for i:=1 to N+1 do
    begin
      dotArr[N+2, i].flag:=True;
      dotArr[N+1, i].down:=True;
    end;
    for i:=1 to N+1 do
    begin
      dotArr[i, 0].flag:=True;
      dotArr[i, 1].left:=True;
    end;
    SetLength(tempArr, N, N);
    Randomize;
    i:=Random(N)+1;
    j:=Random(N)+1;
    startI:=i;
    startJ:=j;
    New(first);
    checkFirst:=nil;
    lastFirst:=nil;
    first^.i:=i;
    first^.j:=j;
    first^.next:=nil;
    nStep:=0;
    case dif of
      2: nStep:=6*(N div 4);
      4: nStep:=4*(N div 4);
      6: nStep:=2*(N div 4);
    end;
    step:=0;
    while (step<nStep) and (step>=0) do
    begin
      lastFirst:=first;
      checkWay(N, i, j, 1, 1, first, dotArr, tempArr, flag, False);
      if flag then
        createBorder(dotArr, tempArr, first, first, step, i, j, N, dif, 1, 1, nStep)
      else
      begin
        checkWay(N, i, j, 2, 2, first, dotArr, tempArr, flag, False);
        if flag then
          createBorder(dotArr, tempArr, first, first, step, i, j, N, dif, 2, 2, nStep)
        else
        begin
          checkWay(N, i, j, 1, 2, first, dotArr, tempArr, flag, False);
          if flag then
            createBorder(dotArr, tempArr, first, first, step, i, j, N, dif, 1, 2, nStep)
          else
          begin
            checkWay(N, i, j, 2, 1, first, dotArr, tempArr, flag, False);
            if flag then
              createBorder(dotArr, tempArr, first, first, step, i, j, N, dif, 2, 1, nStep)
            else
            begin
              while (first<>checkFirst) and (first<>nil) do
              begin
                dotArr[first^.i, first^.j].flag:=False;
                dotArr[first^.i, first^.j].up:=False;
                dotArr[first^.i, first^.j].down:=False;
                dotArr[first^.i, first^.j].right:=False;
                dotArr[first^.i, first^.j].left:=False;
                removeHeadStack(first);
              end;
              step:=step-2;
            end;
          end;
        end;
      end;
      checkFirst:=lastFirst;
      step:=step+1;
    end;
    flag:=false;
    if step=nStep then
    begin
      if not flag then
        checkWay(N, i, j, 1, 1, first, dotArr, tempArr, flag, True);
      if not flag then
        checkWay(N, i, j, 2, 2, first, dotArr, tempArr, flag, True);
      if not flag then
        checkWay(N, i, j, 1, 2, first, dotArr, tempArr, flag, True);
      if not flag then
        checkWay(N, i, j, 2, 1, first, dotArr, tempArr, flag, True);
      if (flag) then
        hideNumber(dotArr, numberArr, flag, amountBorder, N);
    end;
    if ((step<nStep) and (step>=0)) or (not flag) then
      SetLength(dotArr, 0,0);
  end;
  while first<>nil do
    removeHeadStack(first);
end;

procedure TGenGame.createMap(var numberArr: intDArr; var dotArr: dotDArr; var amountBorder: integer; N, DIF: Integer);
begin
  cleanArr(numberArr, N+2);
  solutionMap(numberArr, dotArr, amountBorder, N, dif);
end;

procedure TGenGame.Button1Click(Sender: TObject);
begin
  Close;
end;

function checkUser(dotArr: dotDArr; mainNumberArr: intDArr; N, amountBorder: Integer): Boolean;
var
  a, b, c: Integer;
  flag: Boolean;
  first: stackPointer;
  tempDotArr: dotDArr;
  checkNumberArr: intDArr;
begin
  SetLength(checkNumberArr, N-1, N-1);
  setNumber(dotArr, checkNumberArr, b, N-1, flag);
  flag:=True;
  for c:=0 to N-2 do
    for b:=0 to N-2 do
      if (mainNumberArr[c+1, b+1]<>-1) and (mainNumberArr[c+1, b+1]<>checkNumberArr[c, b]) then
      begin
        flag:=False;
      end;
  if flag then
  begin
    SetLength(tempDotArr, N+2, N+2);
    for c:=1 to N do
      for b:=1 to N do
        tempDotArr[c,b]:=dotArr[c,b];
    for c:=1 to N do
      for b:=1 to N do
        if tempDotArr[c, b].flag=True then
        begin
          New(first);
          first^.i:=c;
          first^.j:=b;
          first^.next:=nil;
          a:=0;
          while (flag) and ((a<6) or (first^.i<>c) or (first^.j<>b)) do
          begin
            if a=1 then
              tempDotArr[first^.next^.i, first^.next^.j].flag:=True;
            if (tempDotArr[first^.i-1, first^.j].flag=True) and (tempDotArr[first^.i, first^.j].up=True) and (tempDotArr[first^.i-1, first^.j].down=True) then
            begin
              tempDotArr[first^.i, first^.j].flag:=False;
              addInStack(first, first^.i-1, first^.j);
              a:=a+1;
            end
            else if (tempDotArr[first^.i, first^.j+1].flag=True) and (tempDotArr[first^.i, first^.j].right=True) and (tempDotArr[first^.i, first^.j+1].left=True) then
            begin
              tempDotArr[first^.i, first^.j].flag:=False;
              addInStack(first, first^.i, first^.j+1);
              a:=a+1;
            end
            else if (tempDotArr[first^.i+1, first^.j].flag=True) and (tempDotArr[first^.i, first^.j].down=True) and (tempDotArr[first^.i+1, first^.j].up=True) then
            begin
              tempDotArr[first^.i, first^.j].flag:=False;
              addInStack(first, first^.i+1, first^.j);
              a:=a+1;
            end
            else if (tempDotArr[first^.i, first^.j-1].flag=True) and (tempDotArr[first^.i, first^.j].left=True) and (tempDotArr[first^.i, first^.j-1].right=True) then
            begin
              tempDotArr[first^.i, first^.j].flag:=False;
              addInStack(first, first^.i, first^.j-1);
              a:=a+1;
            end
            else
            begin
              while first<>nil do
                removeHeadStack(first);
              if a>0 then
                flag:=False;
              Break;
            end;
          end;
          while first<>nil do
            removeHeadStack(first);
        end;
  end;
  SetLength(tempDotArr, 0, 0);
  Result:=flag;
end;

procedure UserWin;
begin
  Win.Left:=GenGame.Left;
  Win.Top:=GenGame.Top;
  GenGame.Hide;
  Win.Show;
end;

procedure TGenGame.ImageHClick(Sender: TObject);
var
  i, j, k: Integer;
begin
  i:=(Sender as TImage).Tag div 100;
  j:=(Sender as TImage).Tag mod 100 div 10;
  k:=(Sender as TImage).Tag mod 10;
  if k=0 then
  begin
    (Sender as TImage).Tag:=(Sender as TImage).Tag + 1;
    lineArray1[i, j].Show;
    checkDotArr[i+1,j+1].right:=True;
    checkDotArr[i+1,j+1].flag:=True;
    checkDotArr[i+1,j+2].left:=True;
    checkDotArr[i+1,j+2].flag:=True;
  end
  else
  begin
    (Sender as TImage).Tag:=(Sender as TImage).Tag - 1;
    lineArray1[i, j].Hide;
    checkDotArr[i+1,j+1].right:=false;
    checkDotArr[i+1,j+2].left:=false;
  end;
  if checkUser(checkDotArr, mapArr, mapLength-1, amountBorder) then
    UserWin;
end;

procedure TGenGame.ImageVClick(Sender: TObject);
var
  i, j, k: Integer;
begin
  i:=(Sender as TImage).Tag div 100;
  j:=(Sender as TImage).Tag mod 100 div 10;
  k:=(Sender as TImage).Tag mod 10;
  if k=0 then
  begin
    (Sender as TImage).Tag:=(Sender as TImage).Tag + 1;
    lineArray2[i, j].Show;
    checkDotArr[i+1,j+1].down:=True;
    checkDotArr[i+1,j+1].flag:=True;
    checkDotArr[i+2,j+1].up:=True;
    checkDotArr[i+2,j+1].flag:=True;
  end
  else
  begin
    (Sender as TImage).Tag:=(Sender as TImage).Tag - 1;
    lineArray2[i, j].Hide;
    checkDotArr[i+1,j+1].down:=false;
    checkDotArr[i+2,j+1].up:=false;
  end;
  if checkUser(checkDotArr, mapArr, mapLength-1, amountBorder) then
    UserWin;
end;

procedure TGenGame.createGameMenu(Sender: TObject; imageLocation: string; imageHeight, imageWidth, topLocation, leftLocation, amountImI, amountImJ, step: Integer; var imageArr: imageArray);
var
  i, j, topL, leftL: Integer;
  image: TImage;
  imageLoad: TPicture;
begin
  topL:=topLocation;
  for i:=0 to amountImI-1 do
  begin
    leftL:=leftLocation;
    for j:=0 to amountImJ-1 do
    begin
      image:=TImage.Create(GenGame);
      image.Parent:=GenGame;
      image.Height:= imageHeight;
      image.Width:= imageWidth;
      image.Top:=topL;
      image.Left:=leftL;
      image.Stretch:=True;
      imageLoad:=TPicture.Create;
      imageLoad.LoadFromFile(imageLocation);
      image.Picture:=imageLoad;
      image.Proportional:=True;
      leftL:= leftL + step;
      imageArr[i, j] := image;
      imageArr[i, j].Tag := i*100 + j*10;
    end;
    topL := topL + step;
  end;
end;

procedure TGenGame.ShowGameSettingMenu(Sender: TObject);
var
  squareL, i, j: Integer;
begin
  Application.ProcessMessages;
  Waiting.btn2.Hide;
  Waiting.btn1.Hide;
  flagforThread:=True;
  while flagforThread do
  begin
  end;
  SetLength(squareArray, mapLength, mapLength);
  SetLength(lineArray1, mapLength-1, mapLength-2);
  SetLength(spyLine1, mapLength-1, mapLength-2);
  SetLength(lineArray2, mapLength-2, mapLength-1);
  SetLength(spyLine2, mapLength-2, mapLength-1);
  SetLength(dotArrayImage, mapLength-1, mapLength-1);
  SetLength(mapArr, mapLength, mapLength);
  SetLength(checkDotArr, mapLength+1, mapLength+1);
  squareL:=480 div (mapLength - 2);
  createGameMenu(GenGame, 'images\WhiteColor.png', squareL, squareL, 32, 250, mapLength, mapLength, squareL, squareArray);
  createGameMenu(GenGame, 'images\DotImage.png', LineWidth, LineWidth, squareL + 32 - LineWidth div 2, squareL + 250 - LineWidth div 2, mapLength-1, mapLength-1, squareL, dotArrayImage);
  createGameMenu(GenGame, 'images\LineImageH.png', LineWidth, squareL-LineWidth, squareL + 32 - LineWidth div 2, squareL + 250 + LineWidth div 2, mapLength-1, mapLength-2, squareL, lineArray1);
  createGameMenu(GenGame, 'images\LineImageV.png', squareL-LineWidth, LineWidth, squareL + 32 + LineWidth div 2, squareL + 250 - LineWidth div 2, mapLength-2, mapLength-1, squareL, lineArray2);
  createGameMenu(GenGame, 'images\WhiteColor.png', LineWidth, squareL-LineWidth, squareL + 32 - LineWidth div 2, squareL + 250 + LineWidth div 2, mapLength-1, mapLength-2, squareL, spyLine1);
  createGameMenu(GenGame, 'images\WhiteColor.png', squareL-LineWidth, LineWidth, squareL + 32 + LineWidth div 2, squareL + 250 - LineWidth div 2, mapLength-2, mapLength-1, squareL, spyLine2);
  Waiting.btn1.Show;
  for i:=0 to mapLength-2 do
    for j:=0 to mapLength-3 do
    begin
      lineArray1[i, j].Hide;
      spyLine1[i, j].OnClick := imageHClick;
    end;
  for i:=0 to mapLength-3 do
    for j:=0 to mapLength-2 do
    begin
      lineArray2[i, j].Hide;
      spyLine2[i, j].OnClick := ImageVClick;
    end;
  createMap(mapArr, dotArr, amountBorder, mapLength-2, different);
  flag:=False;
  Waiting.btn2.Show;
end;

procedure TGenGame.clearGame;
var
  i, j: Integer;
begin
  GenGame.lbl2.Caption:='0:00:00';
  GenGame.tmr1.Enabled:=False;
  for i:=0 to mapLength-1 do
    for j:=0 to mapLength-1 do
      squareArray[i, j].Free;
  for i:=0 to mapLength-2 do
    for j:=0 to mapLength-3 do
      lineArray1[i, j].Free;
  for i:=0 to mapLength-3 do
    for j:=0 to mapLength-2 do
      lineArray2[i, j].Free;
  for i:=0 to mapLength-2 do
    for j:=0 to mapLength-2 do
      dotArrayImage[i, j].Free;
  SetLength(squareArray, 0, 0);
  SetLength(checkDotArr, 0, 0);
  SetLength(lineArray1, 0, 0);
  SetLength(spyLine1, 0, 0);
  SetLength(lineArray2, 0, 0);
  SetLength(spyLine2, 0, 0);
  SetLength(dotArrayImage, 0, 0);
  SetLength(mapArr, 0, 0);
  SetLength(dotArr, 0, 0);
  while firstForHint<>nil do
    removeHeadStack(firstForHint);
end;

procedure TGenGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  flag:=True;
  clearGame;
  flagForBreak:=False;
end;

procedure TGenGame.Button2Click(Sender: TObject);
var
  i, j, k: Integer;
begin
  for i:=0 to mapLength-2 do
    for j:=0 to mapLength-3 do
    begin
      lineArray1[i, j].Hide;
      k:=spyLine1[i, j].Tag mod 10;
      if k=1 then
        spyLine1[i, j].Tag:=spyLine1[i, j].Tag-1;
    end;
  for i:=0 to mapLength-3 do
    for j:=0 to mapLength-2 do
    begin
      lineArray2[i, j].Hide;
      k:=spyLine2[i, j].Tag mod 10;
      if k=1 then
        spyLine2[i, j].Tag:=spyLine2[i, j].Tag-1;
    end;
  for i:=1 to mapLength-1 do
    for j:=1 to mapLength-1 do
    begin
      checkDotArr[i,j].up:=False;
      checkDotArr[i,j].right:=False;
      checkDotArr[i,j].down:=False;
      checkDotArr[i,j].left:=False;
      checkDotArr[i,j].flag:=False;
    end;
end;

procedure TSecondThread.Execute;
begin
  while flagforThread do
  begin
  end;
  GameSetting.Show;
  GenGame.ShowGameSettingMenu(GenGame);
  secondThread.Terminate;
end;

procedure TFirstThread.Execute;
begin
  Waiting.Show;
  flagforThread:=False;
  Waiting.Left:=GenGame.Left+3;
  Waiting.Top:=GenGame.Top+25;
  firstThread.Terminate
end;

procedure TGenGame.Button3Click(Sender: TObject);
begin
  flag:=True;
  clearGame;
  FormActivate(GenGame);
end;

procedure TGenGame.FormActivate(Sender: TObject);
begin
  if flag and (not flagForBreak) then
  begin
    flagforThread:=True;
    firstThread := nil;
    firstThread := TFirstThread.Create(true);
    firstThread.FreeOnTerminate := True;
    firstThread.Resume;
    secondThread := nil;
    secondThread := TSecondThread.Create(true);
    secondThread.Priority:=tpTimeCritical;
    secondThread.FreeOnTerminate := True;
    secondThread.Resume;
    GenGame.Hide;
    btn2.Hide;
    btn1.Show;
  end;
end;

procedure TGenGame.FormCreate(Sender: TObject);
begin
  flag:=True;
  sec:=StrToTime('00:00:01');
end;

procedure TGenGame.tmr1Timer(Sender: TObject);
begin
  lbl2.Caption:=TimeToStr(StrToTime(lbl2.Caption)+sec);
end;


procedure TGenGame.btn1Click(Sender: TObject);
var
  i, j: integer;
begin
  SetLength(tempDotArr, mapLength+1, mapLength+1);
  for i:=0 to mapLength do
    for j:=0 to mapLength do
      tempDotArr[i,j]:=dotArr[i,j];
  counter:=0;
  tmr2.Enabled:=True;
  tmr1.Enabled:=False;
  btn1.Hide;
  btn2.Show;
  New(firstForHint);
  firstForHint.i:=startI;
  firstForHint.j:=startJ;
  firstForHint.next:=nil;
end;

procedure TGenGame.tmr2Timer(Sender: TObject);
begin
  if counter = 2 then
    tempDotArr[startI, startJ].flag:=True;
  if (tempDotArr[firstForHint^.i-1, firstForHint^.j].flag=True) and (tempDotArr[firstForHint^.i, firstForHint^.j].up=True) and (tempDotArr[firstForHint^.i-1, firstForHint^.j].down=True) then
  begin
    tempDotArr[firstForHint^.i, firstForHint^.j].flag:=False;
    addInStack(firstForHint, firstForHint^.i-1, firstForHint^.j);
    counter:=counter+1;
    if spyLine2[firstForHint^.i-1, firstForHint^.j-1].Tag mod 10 = 0 then
    begin
      spyLine2[firstForHint^.i-1, firstForHint^.j-1].Tag:=spyLine2[firstForHint^.i-1, firstForHint^.j-1].Tag + 1;
      lineArray2[firstForHint^.i-1, firstForHint^.j-1].Show;
      checkDotArr[firstForHint^.i,firstForHint^.j].down:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j].flag:=True;
      checkDotArr[firstForHint^.i+1,firstForHint^.j].up:=True;
      checkDotArr[firstForHint^.i+1,firstForHint^.j].flag:=True;
    end;
  end
  else if (tempDotArr[firstForHint^.i, firstForHint^.j+1].flag=True) and (tempDotArr[firstForHint^.i, firstForHint^.j].right=True) and (tempDotArr[firstForHint^.i, firstForHint^.j+1].left=True) then
  begin
    tempDotArr[firstForHint^.i, firstForHint^.j].flag:=False;
    addInStack(firstForHint, firstForHint^.i, firstForHint^.j+1);
    counter:=counter+1;
    if spyLine1[firstForHint^.i-1, firstForHint^.j-2].Tag mod 10 = 0 then
    begin
      spyLine1[firstForHint^.i-1, firstForHint^.j-2].Tag:=spyLine1[firstForHint^.i-1, firstForHint^.j-2].Tag + 1;
      lineArray1[firstForHint^.i-1, firstForHint^.j-2].Show;
      checkDotArr[firstForHint^.i,firstForHint^.j].left:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j].flag:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j-1].right:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j-1].flag:=True;
    end;
  end
  else if (tempDotArr[firstForHint^.i+1, firstForHint^.j].flag=True) and (tempDotArr[firstForHint^.i, firstForHint^.j].down=True) and (tempDotArr[firstForHint^.i+1, firstForHint^.j].up=True) then
  begin
    tempDotArr[firstForHint^.i, firstForHint^.j].flag:=False;
    addInStack(firstForHint, firstForHint^.i+1, firstForHint^.j);
    counter:=counter+1;
    if spyLine2[firstForHint^.i-2, firstForHint^.j-1].Tag mod 10 = 0 then
    begin
      spyLine2[firstForHint^.i-2, firstForHint^.j-1].Tag:=spyLine2[firstForHint^.i-2, firstForHint^.j-1].Tag + 1;
      lineArray2[firstForHint^.i-2, firstForHint^.j-1].Show;
      checkDotArr[firstForHint^.i,firstForHint^.j].up:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j].flag:=True;
      checkDotArr[firstForHint^.i-1,firstForHint^.j].down:=True;
      checkDotArr[firstForHint^.i-1,firstForHint^.j].flag:=True;
    end;
  end
  else if (tempDotArr[firstForHint^.i, firstForHint^.j-1].flag=True) and (tempDotArr[firstForHint^.i, firstForHint^.j].left=True) and (tempDotArr[firstForHint^.i, firstForHint^.j-1].right=True) then
  begin
    tempDotArr[firstForHint^.i, firstForHint^.j].flag:=False;
    addInStack(firstForHint, firstForHint^.i, firstForHint^.j-1);
    counter:=counter+1;
    if spyLine1[firstForHint^.i-1, firstForHint^.j-1].Tag mod 10 = 0 then
    begin
      spyLine1[firstForHint^.i-1, firstForHint^.j-1].Tag:=spyLine1[firstForHint^.i-1, firstForHint^.j-1].Tag + 1;
      lineArray1[firstForHint^.i-1, firstForHint^.j-1].Show;
      checkDotArr[firstForHint^.i,firstForHint^.j].right:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j].flag:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j+1].left:=True;
      checkDotArr[firstForHint^.i,firstForHint^.j+1].flag:=True;
    end;
  end;
  if (startI=firstForHint.i) and (startJ=firstForHint.j) and (counter>0) then
    btn2Click(btn2);
end;

procedure TGenGame.btn2Click(Sender: TObject);
begin
  if checkUser(checkDotArr, mapArr, mapLength-1, amountBorder) then
    UserWin;
  btn2.hide;
  tmr2.Enabled:=False;
  tmr1.Enabled:=True;
  while firstForHint<>nil do
    removeHeadStack(firstForHint);
  SetLength(tempDotArr, 0, 0);
end;

end.
