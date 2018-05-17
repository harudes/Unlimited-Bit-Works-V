unit class_false_position;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  TFalsePosition = class
    ErrorAllowed: Real;
    SequenceA,
    SequenceB,
    SequenceX,
    SequenceE,
    SequenceS,
    FunctionList: TstringList;
    Operation: Integer;
    A,
    B:Real;
    function Execute(): Real;
    private
      Error:Real;
      function Operate(n:Real):Real;
    public
      constructor create;
      destructor Destroy; override;
    end;

  const
    IsSin = 0;
    IsCos = 1;

implementation
const
  Top = 100000;

constructor TFalsePosition.create;
begin
  SequenceA:=TstringList.Create();
  SequenceB:=TstringList.Create();
  SequenceX:=TstringList.Create();
  SequenceE:=TstringList.Create();
  SequenceS:=TstringList.Create();
  FunctionList:= TStringList.Create;
  FunctionList.AddObject( 'sen', TObject( IsSin ) );
  FunctionList.AddObject( 'cos', TObject( IsCos ) );
  SequenceA.Add('');
  SequenceB.Add('');
  SequenceX.Add('');
  SequenceE.Add('');
  SequenceS.Add('');
  Error:=Top;
  A:=0;
  B:=0;

end;

destructor TFalsePosition.Destroy;
begin
  SequenceA.Destroy;
  SequenceB.Destroy;
  SequenceX.Destroy;
  FunctionList.Destroy;
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function TFalsePosition.Execute():Real;
  var xn,An,Bn:Real;
  n:Integer;
begin
  Result:= 0;
  An:=Operate(A);
  Bn:=Operate(B);
  if An*Bn<0 then
    begin
     n:= 0;
     repeat
       SequenceE.Add( FloatToStr(Error));
       SequenceA.Add( FloatToStr(A));
       SequenceB.Add( FloatToStr(B));
       xn:= Result;
       SequenceX.Add( FloatToStr( Result ) );
       Result:= A-(An*((B-A)/(Bn-An)));
       if Operate(Result)*a<0 then
             begin
             B:=Result;
             Bn:=Operate(B);
             SequenceS.Add('-');
             end
           else
           begin
             A:=Result;
             An:=Operate(A);
             SequenceS.Add('+');
           end;
       if n > 0 then
         begin
         Error:= abs( Result - xn );

         end;
       n:= n + 1;
     until ( Error <= ErrorAllowed ) or ( n >= Top ) ;
    end;
  Error:=Top;
end;

function TFalsePosition.Operate(n:Real):Real;
begin
        Result:= Power(n,2);
end;

end.

