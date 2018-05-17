unit false_position;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ParseMath;

type
  TFalsePosition = class
    ErrorAllowed: Real;
    SequenceX,
    SequenceE: TstringList;
    A,
    B,
    X:Real;
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
  Top = 100000;

constructor TFalsePosition.create;
begin
  SequenceX:=TstringList.Create();
  SequenceE:=TstringList.Create();
  SequenceX.Add('');
  SequenceE.Add('');
  SequenceE.Add(' ');
  Error:=Top;
  Operate:=TParseMath.create;
  Operate.addvariable('x',0);
  A:=0;
  B:=0;
  X:=0;
end;

destructor TFalsePosition.Destroy;
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

function TFalsePosition.Execute():Boolean;
  var xn,An,Bn,ErrorN:Real;
  n:Integer;
begin
  result:=True;
  ErrorN:=0;
  X:= 0;
  Operate.newvalue('x',A);
  An:=Operate.evaluate();
  Operate.newvalue('x',B);
  Bn:=Operate.evaluate();
  if An*Bn<0 then
    begin
     n:= 0;
     repeat
       xn:= X;
       X:= A-(An*((B-A)/(Bn-An)));
       SequenceX.Add( FloatToStr( X ) );
       Operate.newvalue('x',X);
       if Operate.evaluate()*An<0 then
             begin
             B:=X;
             Bn:=Operate.evaluate();
             end
           else
           begin
             A:=X;
             An:=Operate.evaluate();
           end;
       if n > 0 then
         begin
         ErrorN:=Error;
         Error:= abs( X - xn );
         SequenceE.Add(FloatToStr(Error));
         end;
       n:= n + 1;
     until ( Error <= ErrorAllowed ) or ( n >= Top );
    end;
  Error:=Top;
end;

end.

