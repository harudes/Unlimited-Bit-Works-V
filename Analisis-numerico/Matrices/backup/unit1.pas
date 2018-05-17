unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ComCtrls, math, MatrixOperations;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ediE: TEdit;
    ediD: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Matriz1: TStringGrid;
    Matriz2: TStringGrid;
    MatrizR: TStringGrid;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
  private
     MatrixOperation: TMatrixOperation;
  public
     procedure fillMatrix();
     procedure fillMatrixR();
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}



{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
   MatrixOperation:=TMatrixOperation.create;
  with MatrixOperation do
  begin
    //SetLength(Matrix1,3);
    //SetLength(Matrix1[0],3);
    //SetLength(Matrix1[1],3);
    //SetLength(Matrix1[2],3);
    //SetLength(Matrix2,3);
    //SetLength(Matrix2[0],3);
    //SetLength(Matrix2[1],3);
    //SetLength(Matrix2[2],3);
  end;
  UpDown1.Associate:=Edit1;
  UpDown2.Associate:=Edit2;
  UpDown3.Associate:=Edit3;
  UpDown4.Associate:=Edit4;
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
    Matriz1.ColCount:=StrToInt(Edit1.text);
end;

procedure TForm1.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
    Matriz1.RowCount:=StrToInt(Edit2.text);
end;

procedure TForm1.UpDown3Click(Sender: TObject; Button: TUDBtnType);
begin
    Matriz2.ColCount:=StrToInt(Edit3.text);
end;

procedure TForm1.UpDown4Click(Sender: TObject; Button: TUDBtnType);
begin
    Matriz2.RowCount:=StrToInt(Edit4.text);
end;

procedure TForm1.fillMatrix();
var
  i,j:integer;
begin
  with MatrixOperation do
  begin
    SetLength(Matrix1,Matriz1.Colcount,Matriz1.Rowcount);
    SetLength(Matrix2,Matriz2.Colcount,Matriz2.Rowcount);
    for i:=0 to Matriz1.Colcount-1 do
    begin
      for j:=0 to Matriz1.Rowcount-1 do
      begin
        Matrix1[i,j]:=StrToFloat(Matriz1.cols[i][j]);
      end;
    end;
    for i:=0 to Matriz2.Colcount-1 do
    begin
      for j:=0 to Matriz2.Rowcount-1 do
      begin
        Matrix2[i,j]:=StrToFloat(Matriz2.cols[i][j]);
      end;
    end;
    Escalar:=StrToFloat(ediE.text);
  end;

end;

procedure TForm1.fillMatrixR();
var
  i,j:integer;
begin
  with MatrixOperation do
  begin
    MatrizR.Colcount:=Length(MatrixR);
    MatrizR.RowCount:=Length(MatrixR[0]);
    for i:=0 to Length(MatrixR)-1 do
    begin
      for j:=0 to Length(MatrixR[0])-1 do
      begin
         MatrizR.cols[i][j]:=FloatToStr(MatrixR[i,j]);
      end;
    end;
    //ediMR00.text:=FloatToStr(MatrixR[0,0]);
    //ediMR01.text:=FloatToStr(MatrixR[1,0]);
    //ediMR02.text:=FloatToStr(MatrixR[2,0]);
    //ediMR10.text:=FloatToStr(MatrixR[0,1]);
    //ediMR11.text:=FloatToStr(MatrixR[1,1]);
    //ediMR12.text:=FloatToStr(MatrixR[2,1]);
    //ediMR20.text:=FloatToStr(MatrixR[0,2]);
    //ediMR21.text:=FloatToStr(MatrixR[1,2]);
    //ediMR22.text:=FloatToStr(MatrixR[2,2]);
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.SumMatrix();
  fillMatrixR();
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.DivMatrix();
  fillMatrixR();
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.Power(StrToInt(ediE.text));
  fillMatrixR();
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.Triangulation();
  fillMatrixR();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.MultiMatrix();
  fillMatrixR();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.ResMatrix();
  fillMatrixR();
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.MultiE();
  fillMatrixR();
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  fillMatrix();
  ediD.text:=FloatToStr(MatrixOperation.Determinant(MatrixOperation.MAtrix1));
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.Transpose();
  fillMatrixR();
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.Attached();
  fillMatrixR();
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  fillMatrix();
  MatrixOperation.Inverse();
  fillMatrixR();
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  fillMatrix();
  ediD.text:=FloatToStr(MatrixOperation.Traza(MatrixOperation.MAtrix1));
end;

end.

