unit mainbolzano;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls, class_biseccion, class_false_position;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnExecute: TButton;
    cboFunctions: TComboBox;
    ediA: TEdit;
    ediB: TEdit;
    ediError: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    memResult: TMemo;
    rdgMethod: TRadioGroup;
    stgData: TStringGrid;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Bisection:TBisection;
    FalsePosition:TFalsePosition;
  public

  end;

var
  Form1: TForm1;

implementation

const
   ColN = 0;
   ColA = 1;
   ColB = 2;
   ColX = 3;
   ColS = 4;
   ColE = 5;
{$R *.lfm}

{ TForm1 }

procedure TForm1.btnExecuteClick(Sender: TObject);
  var
    x: Real;

    procedure FillStringGrid;
    var i: Integer;
        Error: Real;
    begin

      with stgData do
      for i:= 1 to RowCount - 1 do
      begin
          Cells[ ColN, i ]:= IntToStr( i );
      end;

    end;

begin
  if rdgMethod.ItemIndex=0 then
  begin
  Bisection.A:=StrToFloat(ediA.Text);
  Bisection.B:=StrToFloat(ediB.Text);
  Bisection.Operation:= Integer( cboFunctions.ItemIndex );
  Bisection.ErrorAllowed:= StrToFloat( ediError.Text );
  memResult.Lines.Add( 'F(' + FloatToStr(Bisection.Execute()) + ')=0') ;

  with stgData do begin
      RowCount:= Bisection.SequenceA.Count;
      Cols[ ColA ].Assign( Bisection.SequenceA );
      Cols[ ColB ].Assign( Bisection.SequenceB );
      Cols[ ColE ].Assign( Bisection.SequenceE );
      Cols[ 4 ].Assign( Bisection.SequenceS );
      Cols[ ColX ].Assign( Bisection.SequenceX );
  end;
  with Bisection do begin
    SequenceA.Clear;
    SequenceB.Clear;
    SequenceE.Clear;
    SequenceX.Clear;
    SequenceS.Clear;
    SequenceA.Add('');
    SequenceB.Add('');
    SequenceE.Add('');
    SequenceS.Add('');
    SequenceX.Add('');
  end;
  FillStringGrid;
  end
  else if rdgMethod.ItemIndex=1 then
  begin
  FalsePosition.A:=StrToFloat(ediA.Text);
  FalsePosition.B:=StrToFloat(ediB.Text);
  FalsePosition.Operation:= Integer( cboFunctions.ItemIndex );
  FalsePosition.ErrorAllowed:= StrToFloat( ediError.Text );
  memResult.Lines.Add( 'F(' + FloatToStr(FalsePosition.Execute()) + ')=0') ;

  with stgData do begin
      RowCount:= FalsePosition.SequenceA.Count;
      Cols[ ColA ].Assign( FalsePosition.SequenceA );
      Cols[ ColB ].Assign( FalsePosition.SequenceB );
      Cols[ ColE ].Assign( FalsePosition.SequenceE );
      Cols[ 4 ].Assign( FalsePosition.SequenceS );
      Cols[ ColX ].Assign( FalsePosition.SequenceX );
  end;
  with FalsePosition do begin
    SequenceA.Clear;
    SequenceB.Clear;
    SequenceE.Clear;
    SequenceX.Clear;
    SequenceS.Clear;
    SequenceA.Add('');
    SequenceB.Add('');
    SequenceE.Add('');
    SequenceS.Add('');
    SequenceX.Add('');
  end;
  FillStringGrid;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Bisection:= TBisection.create;
  FalsePosition:= TFalsePosition.create;
  cboFunctions.Items.Assign( Bisection.FunctionList );
  cboFunctions.ItemIndex:= 0;
end;

end.

