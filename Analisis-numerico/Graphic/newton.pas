unit newton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,ParseMath;

type

  TNewton = class
    ErrorAllowed: Real;
    SequenceX,
    SequenceE:TstringList;
    X:Real;
    Operate:TParseMath;
    Derivate:TParseMath;
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

constructor TNewton.create;
begin
  SequenceX:=TstringList.Create();
  SequenceE:=TstringList.Create();
  SequenceX.Add('');
  SequenceE.Add('');
  Error:=Top;
  X:=0;
  Operate:=TParseMath.create;
  Operate.addvariable('x',0);
  Derivate:=TParseMath.create;
  Derivate.addvariable('x',0);
end;

destructor TNewton.Destroy;
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

function TNewton.Execute():Boolean;
var ErrorN,Xn:Real;
  n:Integer;
begin
  ErrorN:=0;
  n:=0;
  Result:=true;
  SequenceE.Add(' ');
  if (Derivate.evaluate()<>0) then
    begin
      Xn:=X-(Operate.evaluate()/Derivate.evaluate());
      SequenceX.add(FloatToStr(Xn));
      X:=Xn;
      repeat
        Operate.newvalue('x',X);
        Derivate.newvalue('x',X);
        Xn:=X-(Operate.evaluate()/Derivate.evaluate());
        SequenceX.add(FloatToStr(Xn));
        ErrorN:=Error;
        Error:=abs(Xn-x);
        X:=Xn;
        SequenceE.Add(FloatToStr(Error));
        n:= n + 1;
        if(ErrorN<=Error) then
          Result:=false;
      until(Error<=ErrorAllowed) or (n>=Top) or (ErrorN<=Error);
    end
  else
      Result:=false;

 Error:=Top;
end;
end.

