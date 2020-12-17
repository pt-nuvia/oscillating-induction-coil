unit main;

{$mode objfpc}{$H+}

interface

uses
  Type_Def, settingsForm, Classes, SysUtils, FileUtil, TAGraph, TASeries,
  TAFuncSeries, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BSplineSeries4: TBSplineSeries;
    BSplineSeries2: TBSplineSeries;
    BSplineSeries6: TBSplineSeries;
    FFTSeries: TLineSeries;
    ledit_fft_resolution: TLabeledEdit;
    ledit_sampling: TLabeledEdit;
    ledit_signal_length: TLabeledEdit;
    MainMenu1: TMainMenu;
    MenuAction: TMenuItem;
    MenuGenerate: TMenuItem;
    MenuSettings: TMenuItem;
    SignalSeries: TLineSeries;
    ChartRight: TChart;
    ChartLeft: TChart;
    PanelRight: TPanel;
    PanelLeft: TPanel;
    PanelBottom: TPanel;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuGenerateClick(Sender: TObject);
    procedure MenuSettingsClick(Sender: TObject);
  private

  public

  const

  pi = 3.1415926535897932;

  var
// --- settings ---
f1, max_phi, phi1 : double;
km: integer;
wind: boolean;
// ----------------
signal : RV;        {pointer to real vector}
csignal: CV;        {pointer to complex vector}
size_of_signal: integer;
set_NOISE: double;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses

  utilities;

procedure TForm1.MenuSettingsClick(Sender: TObject);

begin

 Form2.showModal;

 size_of_signal:= StrToInt(Form2.Combo_km.Text);

 f1:= Form2.FlEdit_f1.Value;
 max_phi:= Form2.FlEdit_max_phi.Value;
 phi1:= Form2.FlEdit_phi1.Value;
 set_NOISE:= Form2.FlEdit_noise.Value;
 wind:= Form2.CheckBoxWindowing.Checked;

 MenuGenerateClick(Form1);

end;

procedure TForm1.MenuGenerateClick(Sender: TObject);
var
  i, n1: integer;
  x, y: double;
  df,dt,f,temp : double;
  itemp : integer;
  max_phi_rad : double;
  w1 : double;
  signal_length_sec : double;

begin

  New(signal); New(csignal);   {Dynamic allocation of vectors}

  SignalSeries.Clear;
  FFTSeries.Clear;

  w1 := 2*pi*f1;
  max_phi_rad := (max_phi * pi )/ 180;
  signal_length_sec := 5;                        // signal length - 5 sec
  dt:= signal_length_sec/size_of_signal;

  ledit_signal_length.Text:=FloatToStr(signal_length_sec);
  ledit_sampling.Text := FloatToStr(size_of_signal/signal_length_sec);

  for i:=1 to size_of_signal do
  begin

    x:= dt*(i-1);
    //y:= sin(w1*x + phi1*pi/180);
    y:= sin(max_phi_rad * sin(w1*x) + phi1*pi/180) *
        max_phi_rad * w1 * cos(w1*x);
    signal^[i]:= y;
    SignalSeries.AddXY(x, y);

  end;

  if wind then
  HannWindowing (signal, size_of_signal); // ------ windowing -------

  for i:=1 to size_of_signal do
  begin
    csignal^[i][1]:=signal^[i];
    csignal^[i][2]:=0.0;
  end;

  km:= -1;
  itemp:= size_of_signal;
  while itemp <> 0 do
  begin
    itemp:= itemp >>1;
    km:= km + 1;
  end;

    fft(csignal, km);               // ------ FFT -------

    n1:=size_of_signal DIV 2;
    for i:=1 to n1 do
    begin
      temp:=sqrt(csignal^[i][1]*csignal^[i][1]+csignal^[i][2]*csignal^[i][2]);
      if (i>1) then temp:=2*temp;
      signal^[i]:=temp
    end;
    {calculate frequency step df}
    df:=1.0/(size_of_signal*dt);
    ledit_fft_resolution.Text:= FloatToStr(df);


    BSplineSeries2.Clear;
    BSplineSeries4.Clear;
    BSplineSeries6.Clear;

    f:=0.0;

    for i:=1 to n1 do
    begin
      FFTSeries.AddXY(f, signal^[i]) ;
      //BSplineSeries2.AddXY(f, signal^[i]);
      //BSplineSeries4.AddXY(f, signal^[i]);
      //BSplineSeries6.AddXY(f, signal^[i]);

      f:=f+df;
    end;



    Dispose(signal); Dispose(csignal);



end;

procedure TForm1.FormShow(Sender: TObject);

begin
  size_of_signal:= 4096;
  f1:= 3;
  max_phi:= 10;
  phi1:= 0;
  set_NOISE:= 0;
  Form2.FlEdit_max_phi.Value:= max_phi;
  Form2.FlEdit_f1.Value:= f1;
  Form2.FlEdit_phi1.Value:= phi1;
  Form2.FlEdit_noise.Value:= set_NOISE;
  Form2.Combo_km.Text:= IntToStr(size_of_signal);
  Form2.CheckBoxWindowing.Checked:= true;

  ledit_signal_length.Clear;
  ledit_sampling.Clear;
  ledit_fft_resolution.Clear;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

