unit MatrixOperations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, math;
type
Matriz=array of array of Real;
TMatrixOperation = Class
  public
    function SumMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
    function ResMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
    function MultiMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
    function DivMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
    function Power(Matrix1:MAtriz;n:integer):Matriz;
    function MultiE(Matrix1:Matriz;Escalar:Real):Matriz;
    function Transpose(Matrix1:Matriz):Matriz;
    function Attached(Matrix1:Matriz):Matriz;
    function Inverse(Matrix1:Matriz):Matriz;
    function SubAttached(Matrix1:Matriz;n:integer;m:integer):Real;
    function Determinant(M:Matriz):Real;
    function Norma(M:Matriz):Real;
    function Traza(M:Matriz):Real;
    constructor create;
  private

  end;

implementation

function TMatrixOperation.Norma(M:Matriz):Real;
var
  i:integer;
begin
  result:=0;
  for i:=0 to Length(M[0]) do
  begin
     result:=result+(M[0,1]*M[0,1]);
  end;
  resutl:=sqrt(result);
end;

function TMatrixOperation.SumMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
var i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(result,columns,rows);
  for i:=0 to length(result)-1 do
  begin
     for j:=0 to length(result[0])-1 do
     begin
        result[i,j]:=Matrix1[i,j]+Matrix2[i,j];
     end;
  end;
end;

function TMatrixOperation.ResMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
var i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(result,columns);
  for i:=0 to columns-1 do
      SetLength(result[i],rows);
  for i:=0 to length(result)-1 do
  begin
     for j:=0 to length(result[0])-1 do
     begin
        result[i,j]:=Matrix1[i,j]-Matrix2[i,j];
     end;
  end;
end;

function TMatrixOperation.MultiMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
var i,j,k,rows,columns:integer;
begin
  if Length(Matrix1) = Length(Matrix2[0]) then
  begin
    columns:=Length(Matrix2);
    rows:=Length(Matrix1[0]);
    SetLength(result,columns);
    for i:=0 to columns-1 do
    begin
        SetLength(result[i],rows);
        for j:=0 to rows-1 do
            result[i,j]:=0;
    end;
    for i:=0 to Length(Matrix1[0])-1 do
    begin
        for j:=0 to Length(Matrix2)-1 do
        begin
            for k:=0 to Length(Matrix2[0])-1 do
            result[j,i]:=result[j,i] + (Matrix1[k,i] * Matrix2[j,k]);
        end;
    end;
  end;

end;

function TMatrixOperation.DivMatrix(Matrix1:Matriz;Matrix2:Matriz):Matriz;
begin
  SetLength(result,Length(Matrix1),Length(Matrix2));
  result:=MultiMatrix(Matrix1,Inverse(Matrix2));
end;

function TMatrixOperation.Power(Matrix1:Matriz;n:integer):Matriz;
var
  i:integer;
  Matrix2:Matriz;
begin
  SetLength(Matrix2,Length(Matrix1),Length(Matrix1));
  Matrix2:=Matrix1;
  for i:=2 to n do
    Matrix1:=MultiMatrix(Matrix1,Matrix2);
end;

function TMatrixOperation.MultiE(Matrix1:Matriz;Escalar:Real):Matriz;
var i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(result,columns);
  for i:=0 to columns-1 do
      SetLength(result[i],rows);
  for i:=0 to length(result)-1 do
  begin
     for j:=0 to length(result[0])-1 do
     begin
        result[i,j]:=Matrix1[i,j]*Escalar;
     end;
  end;
end;

function TMatrixOperation.Determinant(M:Matriz):Real;
var
  Aux:array of Matriz;
  i,j,k,n,x:integer;
begin
  result:=0;
  n:=Length(M);
  if n=Length(M[0]) then
  begin
     if n = 1 then
        result:=M[0,0]
     else
     begin
       SetLength(Aux,n,n-1,n-1);
       for k:=0 to n-1 do
       begin
         for i:=1 to n-1 do
         begin
           x:=0;
           for j:=0 to n-1 do
           begin
             if j<>k then
               Aux[k,i-1,j-x]:=M[i,j]
             else
               x:=1;
           end;
         end;
       end;
       x:=1;
       for i:=0 to n-1 do
       begin
         result:=result+M[0,i]*x*Determinant(Aux[i]);
         x:=x*-1;
       end;
     end;
  end;
end;

function TMatrixOperation.Transpose(Matrix1:Matriz):Matriz;
var
  i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1[0]);
  rows:=Length(Matrix1);
  SetLength(result,columns,rows);
  for i:=0 to columns-1 do
  begin
     for j:=0 to rows-1 do
     begin
        result[i,j]:=Matrix1[j,i];
     end;
  end;
end;

function TMatrixOperation.SubAttached(Matrix1:Matriz;n:integer;m:integer):Real;
var
  Aux:Matriz;
  i,j,x,y,l:integer;
begin
  l:=Length(Matrix1);
  SetLength(Aux,l-1,l-1);
  x:=0;
  for i:=0 to l-1 do
   begin
     y:=0;
     for j:=0 to l-1 do
     begin
       if (i<>n) and (j<>m) then
         Aux[i-x,j-y]:=Matrix1[i,j]
       else
         begin
           if i=n then
           x:=1;
           if j=m then
           y:=1;
         end;
       end;
     end;
  result:=Determinant(Aux);
end;

function TMatrixOperation.Attached(Matrix1:Matriz):Matriz;
var
  i,j,columns,rows:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(result,columns,rows);
  for i:=0 to columns-1 do
  begin
    for j:=0 to rows-1 do
    begin
      if (abs(i-j) MOD 2)=0 then
      result[i,j]:=SubAttached(Matrix1,i,j)
      else
      result[i,j]:=SubAttached(Matrix1,i,j)*-1;
    end;
  end;
end;

function TMatrixOperation.Inverse(Matrix1:Matriz):Matriz;
var
  d,Escalar:Real;
begin
  d:=Determinant(Matrix1);
  if d<>0 then
  begin
    Escalar:=1/d;
    result:=Attached(Matrix1);
    Matrix1:=result;
    result:=Transpose(Matrix1);
    Matrix1:=result;
    result:=MultiE(result,Escalar);
  end;
end;

function TMatrixOperation.Traza(M:Matriz):Real;
var
  i,j,n:integer;
begin
  result:=0;
  n:=Length(M);
  for i:=0 to n-1 do
  result:=result+M[i,i];
end;

constructor TMatrixOperation.create();

begin

end;

end.

