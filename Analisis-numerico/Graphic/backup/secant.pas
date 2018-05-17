unit secant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,ParseMath;

type

  TSecant = class
    ErrorAllowed: Real;
    SequenceX,
    SequenceE:TstringList;
    X,h:Real;
    Operate:TParseMath;
    function Execute(): Boolean;
    private
      Error:Real;
    public
      constructor create;
      destructor Destroy; override;
  end;

implementation

const
  Top=100000;

constructor TSecant.create;
begin
  SequenceX:=TstringList.Create();
  SequenceE:=TstringList.Create();
  SequenceX.Add('');
  SequenceE.Add('');;
  Error:=Top;
  Operate:=TParseMath.create;
  Operate.addvariable('x',0);
  X:=0;
  h:=0;
end;

destructor TSecant.Destroy;
begin
  SequenceE.Destroy;
  SequenceX.Destroy;
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;
end;

function TSecant.Execute():Boolean;
var ErrorN,Xn,temp:Real;
  n:Integer;
begin
  temp:=0;
  h:=ErrorAllowed/10;
  ErrorN:=0;
  n:=0;
  Result:=true;
  SequenceE.Add(' ');
  SequenceE.Add(' ');
  Xn:=2*h*Operate.evaluate();
  Operate.newvalue('x',x+h);
  temp:=temp+Operate.evaluate();
  Operate.newvalue('x',x-h);
  temp:=temp-Operate.evaluate();
  Xn:=x-Xn/temp;
  SequenceX.add(FloatToStr(Xn));
  X:=Xn;
  repeat
    temp:=0;
    Operate.newvalue('x',X);
    Xn:=2*h*Operate.evaluate();
    Operate.newvalue('x',x+h);
    temp:=temp+Operate.evaluate();
    Operate.newvalue('x',x-h);
    temp:=temp-Operate.evaluate();
    Xn:=x-Xn/temp;
    SequenceX.add(FloatToStr(Xn));
    ErrorN:=Error;
    Error:=abs(Xn-x);
    X:=Xn;
    SequenceE.Add(FloatToStr(Error));
    n:= n + 1;
    if(ErrorN<=Error) then
      Result:=false;
  until(Error<=ErrorAllowed) or (n>=Top) or (ErrorN<=Error);

 Error:=Top;
end;

end.

