unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Lagrange, parsemath,secant;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsFuncSeries2: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    chartGraphicsLineSeries2: TLineSeries;
    ediLagrange: TEdit;
    ediX: TEdit;
    ediY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblL: TLabel;
    lblAnswer: TLabel;
    pnlRight: TPanel;
    trbMin: TTrackBar;
    X,Y:TStringList;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure chartGraphicsFuncSeries2Calculate(const AX: Double; out AY: Double
      );
    procedure FormCreate(Sender:TObject);
    procedure trbMinChange(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
  private
      A,B:string;
      Lagrange : TLagrange;
      Funcion,Funcion2:TParseMath;
      Secant:TSecant;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Lagrange := TLagrange.create;
  Funcion :=TParseMath.create;
  Funcion.addvariable('x',0);
  Funcion2 :=TParseMath.create;
  Funcion2.addvariable('x',0);
  X:=TStringList.Create;
  Y:=TStringList.Create;
  Secant:=TSecant.create;
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries2.ShowLines:= False;
  chartGraphicsLineSeries2.ShowPoints:= True;
end;

procedure TForm1.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
  chartGraphics.Extent.XMax:= trbMin.Position*-1;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  X.Add(ediX.text);
  Y.Add(ediY.text);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i:integer;
begin
  //chartGraphicsLineSeries1.Clear;
  SetLength(Lagrange.Xs,X.count);
  SetLength(Lagrange.Ys,Y.count);
  for i:=0 to X.count-1 do
  begin
    Lagrange.Xs[i]:=StrToFloat(X[i]);
  end;
  for i:=0 to Y.count-1 do
  begin
    Lagrange.Ys[i]:=StrToFloat(Y[i]);
  end;
  for i:=0 to X.count-1 do
  begin
    chartGraphicsLineSeries1.AddXY(StrToFloat(X[i]),StrToFloat(Y[i]));
  end;
  A:=Lagrange.Polinomio();
  ediLagrange.text:=A;
  Funcion.expression:=A;
  chartGraphicsFuncSeries1.Active:= False;
  chartGraphicsFuncSeries1.Active:= True;
  X.Clear;
  Y.Clear;
  SetLength(Lagrange.Xs,0);
  SetLength(Lagrange.Ys,0);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i:integer;
begin
  //chartGraphicsLineSeries1.Clear;
  SetLength(Lagrange.Xs,X.count);
  SetLength(Lagrange.Ys,Y.count);
  for i:=0 to X.count-1 do
  begin
    Lagrange.Xs[i]:=StrToFloat(X[i]);
  end;
  for i:=0 to Y.count-1 do
  begin
    Lagrange.Ys[i]:=StrToFloat(Y[i]);
  end;
  for i:=0 to X.count-1 do
  begin
    chartGraphicsLineSeries1.AddXY(StrToFloat(X[i]),StrToFloat(Y[i]));
  end;
  B:=Lagrange.Polinomio();
  ediLagrange.text:=B;
  Funcion2.expression:=B;
  chartGraphicsFuncSeries2.Active:= False;
  chartGraphicsFuncSeries2.Active:= True;
  X.Clear;
  Y.Clear;
  SetLength(Lagrange.Xs,0);
  SetLength(Lagrange.Ys,0);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i:integer;
  n:real;
begin
    for i:=-10 to 10 do
    begin
      n:=i;
      Secant.X:=n;
      Secant.ErrorAllowed:=0.0000001;
      Secant.Operate.expression:='('+A+')-('+B+')';
      Secant.Operate.newvalue('x',n);
      if Secant.Execute() then
      begin
          funcion.newvalue('x',Secant.X);
          chartGraphicsLineSeries2.AddXY( Secant.X, funcion.evaluate() );
          lblAnswer.caption:='('+FloatToStr(Secant.X)+','+FloatToStr(funcion.evaluate())+')';
      end
      else
          lblAnswer.caption:='No se puede resolver';
      Secant.SequenceX.clear();
      Secant.SequenceE.clear();
      Secant.SequenceX.Add('');
      Secant.SequenceE.Add('');
    end;

end;

procedure TForm1.chartGraphicsFuncSeries2Calculate(const AX: Double; out
  AY: Double);
begin
  Funcion2.newvalue('x',AX);
  AY:= Funcion2.evaluate();
end;

procedure TForm1.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  Funcion.newvalue('x',AX);
  AY:= Funcion.evaluate();
end;

end.

