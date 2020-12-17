unit utilities;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Type_def;

procedure GenerateSignal;
procedure HannWindowing (var arr:RV; arr_size: integer);
PROCEDURE FFT(VAR A:CV; M:INTEGER);



implementation

procedure GenerateSignal;
begin

end;

procedure HannWindowing (var arr:RV; arr_size: integer);
var
i: integer;
dx, wd: double;
begin
  dx := (2 * pi)/(arr_size);
  for i:=1 to arr_size do
  begin
    wd := (1 - cos(dx*i));
    arr^[i] := arr^[i] * wd;
  end;

end;

PROCEDURE FFT(VAR A:CV; M:INTEGER);
{**************************************************************
*             FAST FOURIER TRANSFORM PROCEDURE                *
* ----------------------------------------------------------- *
* This procedure calculates the fast Fourier transform of a   *
* real function sampled in N points 0,1,....,N-1. N must be a *
* power of two (2 power M).                                   *
*  T being the sampling duration, the maximum frequency in    *
* the signal can't be greater than fc = 1/(2T). The resulting *
* specter H(k) is discrete and contains the frequencies:      *
*         fn = k/(NT) with k = -N/2,.. -1,0,1,2,..,N/2.       *
*         H(0) corresponds to null fréquency.                 *
*         H(N/2) corresponds to fc frequency.                 *
* ----------------------------------------------------------- *
* INPUTS:                                                     *
*                                                             *
*        A(i)  complex vector of size N, the real part of     *
*              which contains the N sampled points of real    *
*              signal to analyse (time spacing is constant).  *
*                                                             *
*          M   integer such as N=2^M                          *
*                                                             *
* OUTPUTS:                                                    *
*                                                             *
*        A(i)  complex vector of size N, the vector modulus   *
*              contain the frequencies of input signal, the   *
*              vector angles contain the corresponding phases *
*              (not used here).                               *
*                                                             *
*                                     J-P Moreau/J-P Dumont   *
**************************************************************}
VAR U,W,T                   :Complex;
N,NV2,NM1,J,I,IP,K,L,LE,LE1 :INTEGER;
Phi,temp                    :REAL_AR;

BEGIN
  N:=(2 SHL (M-1));
  NV2:=(N SHR 1);
  NM1:=N-1;
  J:=1;
  FOR I:=1 TO NM1 DO
  BEGIN
    if (I<J) then
    BEGIN
      T:=A^[J];
      A^[J]:=A^[I];
      A^[I]:=T;
    END; (* if *)
    K:=NV2;
    if K<J then
    REPEAT
      J:=J-K;
      K:=(K SHR 1);
    UNTIL K>=J;
    J:=J+K;
  END;  (* Do *)
  LE:=1;
  FOR L:=1 TO M DO
  BEGIN
    LE1:=LE;
    LE:=(LE SHL 1);
    U[1]:=1.0;
    U[2]:=0.0;
    Phi:= Pi/LE1;
    W[1]:=Cos(Phi);
    W[2]:=Sin(Phi);
    FOR J:=1 TO LE1 DO
    BEGIN
      I:=J-LE;
      WHILE I< N-LE DO
      BEGIN
        I:=I+LE;
        IP:=I+LE1;
        T[1]:=A^[ip][1]*U[1]-A^[ip][2]*U[2];
        T[2]:=A^[ip][1]*U[2]+A^[ip][2]*U[1];
        A^[ip][1]:=A^[i][1]-T[1];
        A^[ip][2]:=A^[i][2]-T[2];
        A^[i][1]:=A^[i][1]+T[1];
        A^[i][2]:=A^[i][2]+T[2];
      END; (* WHILE *)
      temp:=U[1];
      U[1]:=W[1]*U[1]-W[2]*U[2];
      U[2]:=W[1]*U[2]+W[2]*temp;
    END;
  END;
  FOR I:=1 TO N DO
  BEGIN
    A^[I][1]:=A^[I][1]/N;
    A^[I][2]:=A^[I][2]/N;
  END
END;


end.

