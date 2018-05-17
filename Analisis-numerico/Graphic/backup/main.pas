unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries,
  TATransformations, TAChartCombos, TAStyles, TAIntervalSources, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, biseccion,
  false_position,newton,secant,ParseMath;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGraph: TButton;
    btnPoint: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    chkProportional: TCheckBox;
    ediPointX: TEdit;
    ediPointY: TEdit;
    ediError: TEdit;
    ediF: TEdit;
    ediD: TEdit;
    Edit1: TEdit;
    ediXn: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblAnswer: TLabel;
    pnlRight: TPanel;
    rdgShow: TRadioGroup;
    stgData: TStringGrid;
    trbMax: TTrackBar;
    trbMin: TTrackBar;
    procedure btnGraphClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure chkProportionalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rdgShowClick(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private
       Bisection:TBisection;
       FalsePosition:TFalsePosition;
       Newton:TNewton;
       Secant:TSecant;
       Funcion:TParseMath;
       procedure ShowTable();
       procedure HideTable();
       procedure FillTable(ColumnXn : TStringList; ColumnE : TStringList);
  public

  end;

var
  frmMain: TfrmMain;

implementation

const
     ColN=0;
     ColXn=1;
     ColE=2;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnGraphClick(Sender: TObject);
begin
  funcion.expression:=ediF.text;
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= False;
  chartGraphicsFuncSeries1.Active:= True;
end;

procedure TfrmMain.btnPointClick(Sender: TObject);
var x, y: Real;
begin
  x:= StrToFloat(ediPointX.Text);
  y:= StrToFloat( ediPointY.Text );
  chartGraphicsLineSeries1.AddXY( x, y );
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var x1,x2:Real;
begin
    x1:=StrToFLoat(ediPointX.text);
    x2:=StrToFLoat(ediPointY.text);
    with Bisection do
    begin
       A:=x1;
       B:=x2;
       ErrorAllowed:=StrToFloat(ediError.Text);
       Operacion.expression:=ediF.text;
    end;

    if Bisection.Execute() then
    begin
        chartGraphicsLineSeries1.clear;
        chartGraphicsLineSeries1.AddXY( Bisection.X, 0 );
        lblAnswer.caption:=FloatToStr(Bisection.X);
    end
    else
        lblAnswer.caption:='No se puede resolver';
    FillTable(Bisection.SequenceX,Bisection.SequenceE);
    Bisection.SequenceX.clear();
    Bisection.SequenceE.clear();
    Bisection.SequenceX.Add('');
    Bisection.SequenceE.Add('');
    Bisection.SequenceE.Add(' ');
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var x1,x2:Real;
begin
    x1:=StrToFLoat(ediPointX.text);
    x2:=StrToFLoat(ediPointY.text);
    FalsePosition.A:=x1;
    FalsePosition.B:=x2;
    FalsePosition.ErrorAllowed:=StrToFloat(ediError.Text);
    FalsePosition.Operate.expression:=ediF.text;
    if FalsePosition.Execute() then
    begin
        chartGraphicsLineSeries1.clear;
        chartGraphicsLineSeries1.AddXY( FalsePosition.X, 0 );
        lblAnswer.caption:=FloatToStr(FalsePosition.X);
    end
    else
        lblAnswer.caption:='No se puede resolver';
    FillTable(FalsePosition.SequenceX,FalsePosition.SequenceE);
    FalsePosition.SequenceX.clear();
    FalsePosition.SequenceE.clear();
    FalsePosition.SequenceX.Add('');
    FalsePosition.SequenceE.Add('');
    FalsePosition.SequenceE.Add(' ');
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var x:Real;
begin
    x:=StrToFLoat(ediXn.text);
    Newton.X:=x;
    Newton.ErrorAllowed:=StrToFloat(ediError.Text);
    Newton.Operate.expression:=ediF.text;
    Newton.Derivate.expression:=ediD.text;
    Newton.Operate.newvalue('x',x);
    Newton.Derivate.newvalue('x',x);
    if Newton.Execute() then
    begin
        chartGraphicsLineSeries1.clear;
        chartGraphicsLineSeries1.AddXY( Newton.X, 0 );
        lblAnswer.caption:=FloatToStr(Newton.X);
    end
    else
        lblAnswer.caption:='No se puede resolver';
    FillTable(Newton.SequenceX,Newton.SequenceE);
    Newton.SequenceX.clear();
    Newton.SequenceE.clear();
    Newton.SequenceX.Add('');
    Newton.SequenceE.Add('');
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var x:Real;
begin
    x:=StrToFLoat(ediXn.text);
    Secant.X:=x;
    Secant.ErrorAllowed:=StrToFloat(ediError.Text);
    Secant.Operate.expression:=ediF.text;
    Secant.Operate.newvalue('x',x);
    if Secant.Execute() then
    begin
        chartGraphicsLineSeries1.clear;
        chartGraphicsLineSeries1.AddXY( Secant.X, 0 );
        lblAnswer.caption:=FloatToStr(Secant.X);
    end
    else
        lblAnswer.caption:='No se puede resolver';
    FillTable(Secant.SequenceX,Secant.SequenceE);
    Secant.SequenceX.clear();
    Secant.SequenceE.clear();
    Secant.SequenceX.Add('');
    Secant.SequenceE.Add('');
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  Funcion.expression:=ediF.text;
  Funcion.newvalue('x',StrToFloat(Edit1.text));
  label7.Caption:=FloatToStr(funcion.evaluate());
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

procedure TfrmMain.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  funcion.newvalue('x',AX);
  AY:= funcion.evaluate();;
end;

procedure TfrmMain.chkProportionalChange(Sender: TObject);
begin
  chartGraphics.Proportional:= not chartGraphics.Proportional;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Bisection:=TBisection.create;
  FalsePosition:=TFalsePosition.create;
  Newton:=TNewton.create;
  Secant:=TSecant.create;
  Funcion:=TParseMath.create;
  Funcion.addvariable('x',0);
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
end;

procedure TfrmMain.ShowTable();
begin
  stgData.Visible:=true;
  chartGraphics.Visible:=false;
end;

procedure TfrmMain.FillTable(ColumnXn : TStringList; ColumnE : TStringList);
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

procedure TfrmMain.HideTable();
begin
  stgData.Visible:=false;
  chartGraphics.Visible:=true;
end;

procedure TfrmMain.rdgShowClick(Sender: TObject);
begin
  case rdgShow.Itemindex  of
       0: HideTable();
       1: ShowTable();
  end;
end;

procedure TfrmMain.trbMaxChange(Sender: TObject);
begin
  chartGraphics.Extent.XMax:= trbMax.Position;
end;

procedure TfrmMain.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
end;

end.

