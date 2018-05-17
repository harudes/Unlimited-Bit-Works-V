unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ComCtrls, secant,ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ediE: TEdit;
    ediF: TEdit;
    Label5: TLabel;
    Memo1: TMemo;
    stgData: TStringGrid;
    stgFunctions: TStringGrid;
    stgValues: TStringGrid;
    UpDown1: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FillTable(ColumnXn : TStringList; ColumnE : TStringList);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private
    Secante:TSecant;
  public

  end;

var
  Form1: TForm1;

implementation

const
     ColN=0;
     ColXn=1;
     ColE=2;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FillTable(ColumnXn : TStringList; ColumnE : TStringList);
var i:Integer;
begin
  with stgData do begin
      RowCount:= ColumnXn.Count;
      Cols[ ColXn ].Assign( ColumnXn );
      Cols[ ColE ].Assign( ColumnE );
      for i:= 1 to RowCount - 1 do
      begin
          Cells[ ColN, i ]:= IntToStr( i );
      end;
  end;
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  stgFunctions.RowCount:=StrToInt(ediF.text)+1;
  stgValues.RowCount:=StrToInt(ediF.text)+1;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j,funciones:integer;
begin
  funciones:=stgFunctions.RowCount-1;
  SetLength(Secante.valores,funciones);
  SetLength(Secante.functions,funciones);
  for i:=0 to Length(Secante.functions)-1 do
     Secante.functions[i]:=TParseMath.create;
  for i:=1 to funciones do
  begin
     //Secante.valores[i-1]:=StrToFloat(stgValues.Cols[0][2]);
     Secante.valores[i-1]:=1;
     Secante.functions[i-1].Expression:=stgFunctions.Cols[0][i];
     Secante.variables.add('v'+FloatToStr(i));
  end;
  for i:=0 to secante.variables.count-1 do
  begin
      for j:=0 to secante.variables.count-1 do
      begin
          Secante.functions[i].AddVariable( Secante.variables[j], Secante.valores[j]);
      end;
  end;
  Secante.ErrorAllowed:=StrToFloat(ediE.text);
  Secante.execute();
  FillTable(Secante.SequenceX,Secante.SequenceE);
  Secante.destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Secante:=TSecant.create;
  UpDown1.Associate:=ediF;
end;

end.

