unit biseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ParseMath;

type
  TBisection = class
    ErrorAllowed: Real;
    SequenceX,
    SequenceE: TstringList;
    operacion: TParseMath;
    A,
    B,
    X:Real;
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

constructor TBisection.create;
begin
  SequenceX:=TstringList.Create();
  SequenceE:=TstringList.Create();
  SequenceX.Add('');
  SequenceE.Add('');
  SequenceE.Add(' ');
  Error:=Top;
  Operacion:=TParseMath.create;
  Operacion.addvariable('x',0);
  A:=0;
  B:=0;
  X:=0;
end;

destructor TBisection.Destroy;
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

function TBisection.Execute():Boolean;
  var ErrorN,xn,An,Bn:Real;
  n:Integer;
begin
  result:=True;
  X:= 0;
  ErrorN:=0;
  Operacion.newvalue('x',A);
  An:=Operacion.evaluate();
  Operacion.newvalue('x',B);
  Bn:=Operacion.evaluate();
  Operacion.newvalue('x',(A+B)/2);
  if Operacion.evaluate()=0 then
     X:=(A+B)/2
  else if An*Bn<0 then
    begin
     n:= 0;
     repeat
       xn:= X;
       X:= (A+B)/2;
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
    end
  else
      result:=False;
  Error:=Top;
end;

end.

