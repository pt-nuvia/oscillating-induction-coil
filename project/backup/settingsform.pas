unit settingsForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ActnList, MaskEdit, Spin;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButtonCancel: TButton;
    ButtonOk: TButton;
    CheckBoxWindowing: TCheckBox;
    Combo_km: TComboBox;
    FlEdit_f1: TFloatSpinEdit;
    FlEdit_max_phi: TFloatSpinEdit;
    FlEdit_phi1: TFloatSpinEdit;
    FlEdit_noise: TFloatSpinEdit;
    Label5: TLabel;
    Sn: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure Edit_f1EditingDone(Sender: TObject);
    procedure Edit_f1KeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }



procedure TForm2.ButtonOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TForm2.Edit_f1EditingDone(Sender: TObject);
begin
  //if Edit_f1.Text = '' then Edit_f1.Text:= '0';
  //if Edit_f2.Text = '' then Edit_f2.Text:= '0';
  //if Edit_f3.Text = '' then Edit_f3.Text:= '0';
  //if Edit_a1.Text = '' then Edit_a1.Text:= '0';
  //if Edit_a2.Text = '' then Edit_a2.Text:= '0';
  //if Edit_a3.Text = '' then Edit_a3.Text:= '0';
  //if Edit_phi1.Text = '' then Edit_phi1.Text:= '0';
  //if Edit_phi2.Text = '' then Edit_phi2.Text:= '0';
  //if Edit_phi3.Text = '' then Edit_phi3.Text:= '0';
end;


procedure TForm2.Edit_f1KeyPress(Sender: TObject; var Key: char);
begin
   if not (Key in [#8, '-', '0'..'9']) then Key := #0;
end;

procedure TForm2.ButtonCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;


end.

