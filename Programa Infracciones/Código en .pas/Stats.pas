
Unit Stats;

Interface
{$CODEPAGE UTF-8}

Uses 
arch_c, Arbol, Arch_I, crt, validaciones,SysUtils,Archivos;

Type 
  t_vector_inf = Array [1..15] Of byte;
Procedure stats_conductores (Var arch:t_arch_c);
Procedure stats_infracciones (Var arch_i: t_arch_i; arbol:t_punt_c; Var arch_c:
                              t_arch_c);
Procedure cant_infracciones_fecha(Var arch:t_arch_i);
Procedure TOTAL(Var ARCH:t_arch_i);

Implementation

Procedure stats_conductores (Var arch:t_arch_c);

Var 
  x: t_dato_c;
  total,reincidencia,scor0: integer;
Begin
  clrscr;
  total := 0;
  reincidencia := 0;
  scor0 := 0;
  seek(arch,0);
  While Not eof(arch) Do
    Begin
      read(arch,x);
      total := total+1;
      If x.reincidencia > 0 Then
        reincidencia := reincidencia+1;
      If x.scoring = 0 Then
        scor0 := scor0+1;
    End;
  WriteLn('');
  writeln((reincidencia*100/total): 0: 2,


































                                      '% de los conductores estan reincertados.'
                                       );
  write((scor0*100/total): 0: 2,


































                             '% de los conductores cuentan con un scoring de 0.'
                              );
  readkey;
End;

Function rangodeedad (anioact,mesact,diaact,anio,mes,dia:integer): byte;

Var 
  anios: 15..100;
Begin
  anios := anioact-anio;
  If (anios = 31) Or (anios = 51) Then
    If ((mesact-mes) < 0) Then
      anios := anios-1
  Else
    If mes=mesact Then
      If ((diaact-dia) < 0) Then
        anios := anios-1;
  If anios < 31 Then
    rangodeedad := 1
  Else
    Begin
      If anios < 51 Then
        rangodeedad := 2
      Else
        rangodeedad := 3;
    End;
End;

Procedure stats_infracciones (Var arch_i: t_arch_i; arbol:t_punt_c; Var arch_c:
                              t_arch_c);

Var 
  x_i: t_dato_i;
  x_c: t_dato_c;
  mesact, anioact,diaact: word;
  mes,dia,anio: SmallInt;
  dni: string[8];
  pos: integer;
  fecha: string[10];
  FechaActual: TDateTime;
  menores,medios,mayores,total: integer;
  edad: byte;
  i: integer;
Begin
  clrscr;
  FechaActual := Date;
  DecodeDate(FechaActual, Anioact, Mesact, Diaact);
  total := 0;
  menores := 0;
  mayores := 0;
  medios := 0;
  i := 0;
  seek(arch_i,i);

  While (Not eof(arch_i)) Do
    Begin
      total := total+1;
      lee_registro_i(arch_i,i,x_i);
      inc(i);
      dni := x_i.DNI;
      pos := buscar_arbol(arbol,dni);
      lee_registro_c(arch_c,pos,x_c);
      fecha := x_c.f_nac;
      texttoint(fecha,anio,mes,dia);
      edad := rangodeedad(anioact,mesact,diaact,anio,mes,dia);
      // PASA
      Case (edad) Of 
        1: menores := menores+1;
        2: medios := medios+1;
        3: mayores := mayores+1;
      End;
      //Pasa 
    End;

  edad := 1;
  If medios > menores Then
    Begin
      edad := 2;
      If mayores > medios Then
        edad := 3;
    End
  Else
    If mayores > menores Then
      edad := 3;
  writeln('');
  Case edad Of 
    1: writeln(




















    'El rango etario más común es entre 18 y 30 años. Con un porcentaje del '
               ,(menores*100/total)
       : 0: 2,'%.');
    2: writeln(




















    'El rango etario más común es Entre 31 y 50 años. Con un porcentaje del '
               ,(medios*100/total):









                                    0









                                    :









                                      2









                                      ,









                                      '%.'









                                      )
    ;
    3: writeln(




















  'El rango etario más común es de mayores a 50 años. Con un porcentaje del '
               ,(mayores*100/total): 0:









                                        2











                                        ,











                                        '%.'











                                        )
    ;
  End;
  readkey;
End;

Procedure cant_infracciones_fecha(Var arch:t_arch_i);

Var 
  aniomin,mesmin,diamin,aniomax,mesmax,diamax: integer;
  fechamax,fechamin,fecha: string;
  x: t_dato_i;
  total: integer;
  valido: boolean;
Begin
  clrscr;
  writeln('A continuacion ingrese la fecha minima.');
  tomarfecha(fechamin);
  texttoint(fechamin,aniomin,mesmin,diamin);
  valido := true;
  Repeat
    If Not valido Then
      Begin
        writeln('Fecha maxima menor que la minima. Intenta de nuevo.');
        readkey;
      End;
    clrscr;
    writeln('A continuacion ingrese la fecha maxima.');
    tomarfecha(fechamax);
    texttoint(fechamax,aniomax,mesmax,diamax);
    //añadi el repeat para q meta bien la maxima y el if para q de el msj
    valido := ValidarFechasLim(aniomin,aniomax,mesmin,mesmax,diamin,diamax);
  Until valido;
  seek(arch,0);
  total := 0;
  While Not eof(arch) Do
    Begin
      read(arch,x);
      fecha := x.f_inf;
      If validarperiodo(aniomin,mesmin,diamin,aniomax,mesmax,diamax,fecha)
        Then
        total := total+1;
    End;
  WriteLn('');
  write(total,' infracciones entre ',fechamin,' y ',fechamax,'.');
  readkey;
End;

Function inf_comun(v2:t_vector_inf): byte;

Var 
  i: byte;
  ac: integer;
Begin
  ac := 0;
  For i:=1 To 15 Do
    If (ac < v2[i]) Then
      Begin
        ac := v2[i];
        inf_comun := i;
      End;

End;

Procedure reset_vector(Var v2:t_vector_inf);

Var 
  i: byte;
Begin
  For i:=1 To 15 Do
    v2[i] := 0;
End;

Procedure mostrar_columnas_infr (anio:Integer);
Begin
  clrscr;
  textcolor(red);
  write('AÑO: ');
  textcolor(white);
  writeln(anio);
  textcolor(red);
  write('MES  CANTIDAD INFRACCIONES  INFRACCION COMUN');
  textcolor(white);
End;

Procedure mostrar_total(mes,cant,tipo:integer);

Var 
  y: Integer;
Begin
  y := Wherey;
  Inc(y);
  gotoxy(1,y);
  writeln(mes,'     ',cant,'                       ',tipo);
End;


Procedure TOTAL(Var ARCH:t_arch_i);

Var 
  REG: T_DATO_I;
  pos,anio,mes,dia,ActAnio,ActMes,infr,cant: Integer;
  i: byte;
  fecha: string;
  v1: array [1..12] Of Integer = (0,0,0,0,0,0,0,0,0,0,0,0);
  v2: t_vector_inf;

Begin
  Seek(ARCH,0);
  pos := 0;
  LEE_REGISTRO_I(ARCH,pos,REG);
  fecha := REG.F_inf;
  TextToInt(fecha,anio,mes,dia);
  ActAnio := anio;
  ActMes := mes;
  mostrar_columnas_infr(ActAnio);
  reset_vector(v2);
  While Not Eof(ARCH) Do
    Begin
      LEE_REGISTRO_I(ARCH,pos,REG);
      fecha := REG.F_inf;
      TextToInt(fecha,anio,mes,dia);
      If (anio = ActAnio) Then
        If (mes = ActMes) Then
          Begin
            v1[mes] := v1[mes]+1;
            infr := REG.Tipo;
            v2[infr] := v2[infr]+1;
          End
      Else
        Begin
          cant := v1[ActMes];
          i := inf_comun(v2);
          mostrar_total(ActMes,cant,i);
          ActMes := mes;
          reset_vector(v2);
          v1[mes] := v1[mes]+1;
          infr := REG.Tipo;
          v2[infr] := v2[infr]+1;
        End
      Else
        Begin
          WriteLn('Presione una tecla para pasar al siguiente año.');
          readkey;
          ActAnio := anio;
          mostrar_columnas_infr(ActAnio);
        End;
      Inc(pos);
    End;
  cant := v1[ActMes];
  i := inf_comun(v2);
  mostrar_total(ActMes,cant,i);
  readkey;
End;
End.
