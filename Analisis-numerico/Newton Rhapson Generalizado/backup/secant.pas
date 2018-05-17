unit secant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, MatrixOperations;

type

  funciones=array of TParseMath;

  TSecant = class
    ErrorAllowed,
    h: Real;
    SequenceX,
    SequenceE,variables:TstringList;
    valores:array of Real;
    functions:funciones;
    function Execute(): Boolean;
    private
      Error:Real;
      Matrices:TMatrixOperation;
      function FillJacobiana():Matriz;
    public
      constructor create;
      destructor Destroy; override;
  end;

implementation

const
  Top=100000;

constructor TSecant.create;
var
  i:integer;
begin
  SequenceX:=TstringList.Create();
  SequenceE:=TstringList.Create();
  variables:=TstringList.Create();
  SequenceX.Add('');
  SequenceE.Add('');
  SequenceE.Add(' ');
  Error:=Top;
  Matrices:=TMatrixOperation.create;
end;

destructor TSecant.Destroy;
begin
  SequenceE.Destroy;
  SequenceX.Destroy;
  Matrices.Destroy;
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function TSecant.FillJacobiana():Matriz;
var i,j:integer;
  aux:real;
begin
   SetLength(result,Length(functions),Length(functions));
   for i:=0 to Length(functions)-1 do
      begin
        for j:=0 to variables.count-1 do
           begin
             functions[j].newvalue(variables[i],valores[i]+h);
             aux:=functions[j].evaluate();
             functions[j].newvalue(variables[i],valores[i]-h);
             aux:=(aux-functions[j].evaluate())/(2*h);
             functions[j].newvalue(variables[i],valores[i]);
             result[i,j]:=aux;
           end;
      end;
end;

function TSecant.Execute():Boolean;
var ErrorN:Real;
  Xn,Jacobiana:Matriz;
  n,i,j:Integer;
  algo:string;
begin
  h:=ErrorAllowed/10;
  ErrorN:=0;
  n:=0;
  Result:=true;
  SetLength(Xn,1,Length(functions));
  SetLength(Jacobiana,Length(functions),Length(functions));
  Jacobiana:=FillJacobiana();
  Jacobiana:=Matrices.Inverse(Jacobiana);
  algo:='(';
  for i:=0 to variables.count-1 do
  begin
      algo:=algo+FloatToStr(valores[i])+',';
  end;
  algo:=algo+')';
  SequenceX.add(algo);
  for i:=0 to variables.count-1 do
  begin
      Xn[0,1]:=functions[i].evaluate();
  end;
  Xn:=Matrices.MultiMatrix(jacobiana,Xn);
  Error:=Matrices.norma(Xn);
  for i:=0 to variables.count-1 do
  begin
    Xn[0,i]:=valores[i]-Xn[0,i];
  end;
  algo:='(';
  for i:=0 to variables.count-1 do
  begin
      algo:=algo+FloatToStr(Xn[0,i])+',';
  end;
  for i:=0 to variables.count-1 do
  begin
    valores[i]:=Xn[0,i];
  end;
  algo:=algo+')';
  SequenceX.add(algo);
  SequenceE.add(FloatToStr(Error));
  for i:=0 to variables.count-1 do
  begin
    for j:=0 to variables.count-1 do
    begin
      functions[j].newvalue(variables[i],valores[i]);
    end;
  end;
  repeat
    ErrorN:=Error;
    Jacobiana:=FillJacobiana();
    Jacobiana:=Matrices.Inverse(Jacobiana);
    algo:='(';
    for i:=0 to variables.count-1 do
    begin
      for j:=0 to variables.count-1 do
      begin
        algo:=algo+FloatToStr(jacobiana[i,j])+',';
      end;
    end;
    algo:=algo+')';
    SequenceE.add(algo);
    for i:=0 to variables.count-1 do
    begin
        Xn[0,1]:=functions[i].evaluate();
    end;
    Xn:=Matrices.MultiMatrix(jacobiana,Xn);
    Error:=Matrices.norma(Xn);
    for i:=0 to variables.count-1 do
    begin
      Xn[0,i]:=valores[i]-Xn[0,i];
    end;
    algo:='(';
    for i:=0 to variables.count-1 do
    begin
        algo:=algo+FloatToStr(Xn[0,i])+',';
    end;
    for i:=0 to variables.count-1 do
    begin
      valores[i]:=Xn[0,i];
    end;
    algo:=algo+')';
    SequenceX.add(algo);
    SequenceE.add(FloatToStr(Error));
    for i:=0 to variables.count-1 do
    begin
      for j:=0 to variables.count-1 do
      begin
        functions[j].newvalue(variables[i],valores[i]);
      end;
    end;
    n:= n + 1;
    if(ErrorN<=Error) then
      Result:=false;
  until(Error<=ErrorAllowed) or (n>=Top) or (ErrorN<=Error);
 Error:=Top;
end;

end.
