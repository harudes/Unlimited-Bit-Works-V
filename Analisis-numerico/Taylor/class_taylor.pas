unit class_taylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,math;

type
  TTaylor = class
    ErrorAllowed: Real;
    Sequence,
    Sequence2,
    FunctionList: TstringList;
    FunctionType: Integer;
    AngleType: Integer;
    x: Real;
    Rpta:Real;
    function Execute(): Boolean;
    private
      Error,
      Angle: Real;
      function sen(): Boolean;
      function cos(): Boolean;
      function arcsen(): Boolean;
      function arctan(): Boolean;
      function sinh(): Boolean;
      function cosh(): Boolean;
      function sinhI(): Boolean;
      function tanhI(): Boolean;
      function logn(): Boolean;
      function exp(): Boolean;
    public
      constructor create;
      destructor Destroy; override;

  end;

const
  IsSin = 0;
  IsCos = 1;
  IsArcSen = 2;
  IsArcTan = 3;
  IsSinh = 4;
  IsCosh = 5;
  IsSinhI = 6;
  IsTanhI = 7;
  IsLogn = 8;
  IsExp = 9;

  AngleSexagedecimal = 0;
  AngleRadian = 1;

implementation

const
  Top = 100000;

constructor TTaylor.create;
begin
  Sequence:= TStringList.Create;
  Sequence2:= TStringList.Create;
  FunctionList:= TStringList.Create;
  FunctionList.AddObject( 'sen', TObject( IsSin ) );
  FunctionList.AddObject( 'cos', TObject( IsCos ) );
  FunctionList.AddObject( 'arcsen', TObject( IsArcsen ) );
  FunctionList.AddObject( 'arctan', TObject( IsArctan ) );
  FunctionList.AddObject( 'sinh', TObject( IsSinh ) );
  FunctionList.AddObject( 'cosh', TObject( IsCosh ) );
  FunctionList.AddObject( 'sinh-1', TObject( IsSinhI ) );
  FunctionList.AddObject( 'tanh-1', TObject( IsTanhI ) );
  FunctionList.AddObject( 'logn', TObject( IsLogn ) );
  FunctionList.AddObject( 'exp', TObject( IsExp ) );
  Sequence.Add('');
  Sequence2.Add('');
  Error:= Top;
  x:= 0;

end;

destructor TTaylor.Destroy;
begin
  Sequence.Destroy;
  FunctionList.Destroy;
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function Factorial( n: Integer ): Real;
begin

     if n > 1 then
        Result:= n * Factorial( n -1 )

     else if n >= 0 then
        Result:= 1

     else
        Result:= 0;

end;

function Combinatoria(n:Integer;m:Integer):Real;
begin
   Result:=  Factorial(n)/(Factorial(m)*Factorial(n-m));
end;

function Bernoulli(n:Integer):Real;
var k: Integer;

begin

    Result:= 0;
    k:= 0;
    if n=0 then
       Result:=1;
       exit;
    repeat
      Result:= Result + Combinatoria(n,k)*(Bernoulli(k)/n+1-k);
      k:= k+1;
    until (k=n);
    Result:= Result * (-1);

end;

function TTaylor.Execute( ): Boolean;
begin

   case AngleType of
        AngleRadian: Angle:= x;
        AngleSexagedecimal: Angle:=x * pi/180;
   end;

   case FunctionType of
        IsSin: Result:= sen();
        IsCos: Result:= cos();
        IsArcSen: Result:= arcsen();
        IsArcTan: Result:= arctan();
        IsSinh: Result:= sinh();
        IsCosh: Result:= cosh();
        IsSinhI: Result:= sinhI();
        IsTanhI: Result:= tanhI();
        IsLogn: Result:= logn();
        IsExp: Result:= exp();
   end;
   Error:=Top;

end;

function TTaylor.sen(): Boolean;
var xn: Real;
     n: Integer;
begin
   result:= true;
   Rpta:= 0;
   n:= 0;
   Sequence2.Add( ' ');
   Angle:=Angle - floor(Angle / (2*pi))*pi*2;
   repeat
     xn:= Rpta;
     Rpta:= Rpta + Power(-1, n)/Factorial( 2*n + 1 ) * Power(Angle, 2*n + 1);
     Sequence.Add( FloatToStr( Rpta ) );
     if n > 0 then
       begin
       Error:= abs( Rpta - xn );
       Sequence2.Add( FloatToStr(Error));
     end;
     n:= n + 1;
   until ( Error <= ErrorAllowed ) or ( n >= Top ) ;

end;

function TTaylor.cos(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  Angle:=Angle - floor(Angle / (2*pi))*pi*2;
  repeat
    xn:= Rpta;
    Rpta:= Rpta + Power( -1, n)/Factorial(2*n) * Power( Angle, 2*n );
    Sequence.Add( FloatToStr( Rpta ) );
    if n > 0 then
       begin
       Error:= abs( Rpta - xn );
       Sequence2.Add( FloatToStr(Error));
       end;
    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );

end;

function TTaylor.arcsen(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  if abs(angle)<1 then
     begin
          repeat
      xn:= Rpta;
      Rpta:= Rpta + Factorial(2*n)*Power(Angle,2*n+1)/(Power(4,n)*Power(Factorial(n),2)*(2*n+1));
      Sequence.Add( FloatToStr( Rpta ) );
      if n > 0 then
         begin
         Error:= abs( Rpta - xn );
         Sequence2.Add( FloatToStr(Error));
         end;
      n:= n + 1;
      until ( Error < ErrorAllowed ) or ( n >= Top );
     end
  else
     result:=False;
end;

function TTaylor.arctan(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  if abs(angle)<1 then
  begin
    repeat
    xn:= Rpta;
    Rpta:= Rpta + Power(-1,n)*Power(Angle,2*n+1)/(2*n+1);
    Sequence.Add( FloatToStr( Rpta ) );
    if n > 0 then
       begin
       Error:= abs( Rpta - xn );
       Sequence2.Add( FloatToStr(Error));
       end;
    n:= n + 1;
    until ( Error < ErrorAllowed ) or ( n >= Top );
  end
  else
    result:=False;


end;

function TTaylor.sinh(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  repeat
    xn:= Rpta;
    Rpta:= Rpta + 1/Factorial(2*n+1)*Power(Angle,2*n+1);
    Sequence.Add( FloatToStr( Rpta ) );
    if n > 0 then
       begin
       Error:= abs( Rpta - xn );
       Sequence2.Add( FloatToStr(Error));
       end;
    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );

end;

function TTaylor.cosh(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  repeat
      xn:= Rpta;
      Rpta:= Rpta + 1/Factorial(2*n)*Power(Angle,2*n);
      Sequence.Add( FloatToStr( Rpta ) );
      if n > 0 then
         begin
         Error:= abs( Rpta - xn );
         Sequence2.Add( FloatToStr(Error));
         end;
      n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );

end;

function TTaylor.sinhI(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  if abs(angle)<1 then
  begin
    repeat
      xn:= Rpta;
      Rpta:= Rpta + Power(-1,n)*Factorial(2*n)/(Power(4,n)*Power(Factorial(n),2)*(2*n+1))*Power(Angle,2*n+1);
      Sequence.Add( FloatToStr( Rpta ) );
      if n > 0 then
         begin
         Error:= abs( Rpta - xn );
         Sequence2.Add( FloatToStr(Error));
         end;
      n:= n + 1;
    until ( Error < ErrorAllowed ) or ( n >= Top );
  end
  else
      result:=False;


end;

function TTaylor.tanhI(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  if abs(angle)<1 then
  begin
    repeat
      xn:= Rpta;
      Rpta:= Rpta + 1/(2*n+1)*Power(Angle,2*n+1);
      Sequence.Add( FloatToStr( Rpta ) );
      if n > 0 then
         begin
         Error:= abs( Rpta - xn );
         Sequence2.Add( FloatToStr(Error));
         end;
      n:= n + 1;
    until ( Error < ErrorAllowed ) or ( n >= Top );
  end
  else
      result:=False;


end;

function TTaylor.logn(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  repeat
    xn:= Rpta;
    Rpta:= Rpta + 1/(2*n+1)*power((angle-1)/(angle+1),2*n+1);
    Sequence.Add( FloatToStr( Rpta ) );
    if n > 0 then
       begin
       Error:= abs( Rpta - xn );
       Sequence2.Add( FloatToStr(Error));
       end;
    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );
  Rpta:=Rpta*2;
end;

function TTaylor.exp(): Boolean;
var xn: real;
    n: Integer;

begin
  result:=True;
  Rpta:= 0;
  n:= 0;
  Sequence2.Add( ' ');
  repeat
    xn:= Rpta;
    Rpta:= Rpta + Power( Angle, n)/Factorial(n);
    Sequence.Add( FloatToStr( Rpta ) );
    if n > 0 then
       begin
       Error:= abs( Rpta - xn );
       Sequence2.Add( FloatToStr(Error));
       end;
    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );

end;

end.

