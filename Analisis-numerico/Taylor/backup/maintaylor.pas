unit maintaylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, class_taylor, math;

type

  { TfrmTaylor }

  TfrmTaylor = class(TForm)
    BbtnExecute: TButton;
    cboFunctions: TComboBox;
    ediError: TEdit;
    ediX: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    memResult: TMemo;
    Panel1: TPanel;
    rdgAngleType: TRadioGroup;
    stgData: TStringGrid;
    procedure BbtnExecuteClick(Sender: TObject);
    procedure cboFunctionsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure rdgAngleTypeClick(Sender: TObject);
  private
     Taylor: TTaylor;
  public

  end;

var
  frmTaylor: TfrmTaylor;

implementation

const
     ColN = 0;
     ColSequence = 1;
     ColError = 2;

{$R *.lfm}

{ TfrmTaylor }

procedure TfrmTaylor.BbtnExecuteClick(Sender: TObject);
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
  Taylor.x:= StrToFloat( ediX.Text );
  (* when we sincronize *)
  Taylor.FunctionType:= PtrInt( cboFunctions.Items.Objects[ cboFunctions.ItemIndex ] );
  Taylor.ErrorAllowed:= StrToFloat( ediError.Text );

  (* when we dont sincronize *)
  case rdgAngleType.ItemIndex of
       0: Taylor.AngleType:= AngleSexagedecimal;
       1: Taylor.AngleType:= AngleRadian;
  end;

  if Taylor.Execute() then
     memResult.Lines.Add( cboFunctions.Text + '(' +  ediX.Text + ') = ' + FloatToStr( Taylor.Rpta ) )
  else
     memResult.Lines.Add('Ese número no se encuentra en el Dominio de la función');


  with stgData do begin
      RowCount:= Taylor.Sequence.Count;
      Cols[ ColSequence ].Assign( Taylor.Sequence );
      Cols[ ColError ].Assign( Taylor.Sequence2 );
  end;
  with Taylor do
  begin
    Sequence.Clear;
    Sequence2.Clear;
    Sequence.Add('');
    Sequence2.Add('');
  end;
  FillStringGrid;

end;

procedure TfrmTaylor.cboFunctionsChange(Sender: TObject);
begin

end;

procedure TfrmTaylor.FormCreate(Sender: TObject);
begin
   Taylor:= TTaylor.create;
   cboFunctions.Items.Assign( Taylor.FunctionList );
   cboFunctions.ItemIndex:= 0;
end;

procedure TfrmTaylor.FormDestroy(Sender: TObject);
begin
  Taylor.Destroy;
end;

procedure TfrmTaylor.Label2Click(Sender: TObject);
begin

end;

procedure TfrmTaylor.rdgAngleTypeClick(Sender: TObject);
begin

end;

end.

