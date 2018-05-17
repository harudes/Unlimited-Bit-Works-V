unit Lagrange;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TLagrange = class
    Xs,Ys: array of Real;
    function Polinomio():string;
    public
      constructor create;
      destructor Destroy; override;
  end;

implementation

constructor TLagrange.create;
begin

end;

destructor TLagrange.Destroy;
begin

end;

function TLagrange.Polinomio():string;
var
  i,j:integer;
begin
  result:='';
  for i:=0 to Length(Ys)-1 do
  begin
      result:=result+FloatToStr(Ys[i])+'*';
      for j:=0 to Length(Xs)-1 do
      begin
          if i<>j then
          begin
            result:=result+'(x-'+FloatToStr(Xs[j])+')/('+FloatToStr(Xs[i])+'-'+FloatToStr(Xs[j])+')';
            if j<Length(Xs)-1 then
               result:=result+'*';
          end;
      end;
      if i<Length(Ys)-1 then
         result:=result+'+'
  end;
  result:=result+'1'
end;

end.

