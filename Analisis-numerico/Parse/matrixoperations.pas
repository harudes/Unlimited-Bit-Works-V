unit MatrixOperations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, math;
type
Matriz=array of array of Real;
TMatrixOperation = Class
  Matrix1: Matriz;
  Matrix2: Matriz;
  MatrixR: Matriz;
  Escalar: Real;
  public
    procedure SumMatrix();
    procedure ResMatrix();
    procedure MultiMatrix();
    procedure DivMatrix();
    procedure Power(n:integer);
    procedure MultiE();
    procedure Transpose();
    procedure Attached();
    procedure Inverse();
    function SubAttached(n:integer;m:integer):Real;
    function Determinant(M:Matriz):Real;
    function Traza(M:Matriz):Real;
    constructor create;
  private

  end;

implementation

procedure TMatrixOperation.SumMatrix();
var i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(MatrixR,columns);
  for i:=0 to columns-1 do
      SetLength(MatrixR[i],rows);
  for i:=0 to length(MatrixR)-1 do
  begin
     for j:=0 to length(MatrixR[0])-1 do
     begin
        MatrixR[i,j]:=Matrix1[i,j]+Matrix2[i,j];
     end;
  end;
end;

procedure TMatrixOperation.ResMatrix();
var i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(MatrixR,columns);
  for i:=0 to columns-1 do
      SetLength(MatrixR[i],rows);
  for i:=0 to length(MatrixR)-1 do
  begin
     for j:=0 to length(MatrixR[0])-1 do
     begin
        MatrixR[i,j]:=Matrix1[i,j]-Matrix2[i,j];
     end;
  end;
end;

procedure TMatrixOperation.MultiMatrix();
var i,j,k,rows,columns:integer;
begin
  if Length(Matrix1) = Length(Matrix2[0]) then
  begin
    columns:=Length(Matrix2);
    rows:=Length(Matrix1[0]);
    SetLength(MatrixR,columns);
    for i:=0 to columns-1 do
    begin
        SetLength(MatrixR[i],rows);
        for j:=0 to rows-1 do
            MatrixR[i,j]:=0;
    end;
    for i:=0 to Length(Matrix1[0])-1 do
    begin
        for j:=0 to Length(Matrix2)-1 do
        begin
            for k:=0 to Length(Matrix2[0])-1 do
            MatrixR[j,i]:=MatrixR[j,i] + (Matrix1[k,i] * Matrix2[j,k]);
        end;
    end;
  end;

end;

procedure TMatrixOperation.DivMatrix();
begin
  SetLength(MatrixR,Length(Matrix1),Length(Matrix1));
  MatrixR:=Matrix2;
  Matrix2:=Matrix1;
  Matrix1:=MatrixR;
  Inverse();
  Matrix1:=Matrix2;
  Matrix2:=MatrixR;
  MultiMatrix();
end;

procedure TMatrixOperation.Power(n:integer);
var
  i:integer;
begin
  Matrix2:=Matrix1;
  for i:=2 to n do
  begin
    MultiMatrix();
    Matrix1:=MatrixR;
  end;
end;

procedure TMatrixOperation.MultiE();
var i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(MatrixR,columns);
  for i:=0 to columns-1 do
      SetLength(MatrixR[i],rows);
  for i:=0 to length(MatrixR)-1 do
  begin
     for j:=0 to length(MatrixR[0])-1 do
     begin
        MatrixR[i,j]:=Matrix1[i,j]*Escalar;
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

procedure TMatrixOperation.Transpose();
var
  i,j,rows,columns:integer;
begin
  columns:=Length(Matrix1[0]);
  rows:=Length(Matrix1);
  SetLength(MatrixR,columns,rows);
  for i:=0 to columns-1 do
  begin
     for j:=0 to rows-1 do
     begin
        MatrixR[i,j]:=Matrix1[j,i];
     end;
  end;
end;

function TMatrixOperation.SubAttached(n:integer;m:integer):Real;
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

procedure TMatrixOperation.Attached();
var
  i,j,columns,rows:integer;
begin
  columns:=Length(Matrix1);
  rows:=Length(Matrix1[0]);
  SetLength(MatrixR,columns,rows);
  for i:=0 to columns-1 do
  begin
    for j:=0 to rows-1 do
    begin
      if (abs(i-j) MOD 2)=0 then
      MatrixR[i,j]:=SubAttached(i,j)
      else
      MatrixR[i,j]:=SubAttached(i,j)*-1;
    end;
  end;
end;

procedure TMatrixOperation.Inverse();
var
  d:Real;
begin
  d:=Determinant(Matrix1);
  if d<>0 then
  begin
    Escalar:=1/d;
    Attached();
    Matrix1:=MatrixR;
    Transpose();
    Matrix1:=MatrixR;
    MultiE();
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

