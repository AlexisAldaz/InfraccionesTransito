
Unit Validaciones;

Interface
{$CODEPAGE UTF-8}

Uses 
CRT,SysUtils;

Procedure DNI_validado(Var DNI:String);
Procedure TomarFecha(Var Fecha:String);
Function validar_num(n:String): Boolean;
Function ValidarPeriodo (aniomin,mesmin,diamin,aniomax,mesmax,diamax:integer;
                         fecha:String): boolean;
Procedure TomarNum(Var num:String);
Procedure BorrarLinea(x,y:integer);
Function ValidarFechasLim (aniomin,aniomax,mesmin,mesmax,diamin,diamax:integer):




                                                                         boolean
;

Implementation

Function validar_num(n:String): Boolean;

Var 
  i: byte;
  AUX: SmallInt;
Begin
  validar_num := true;
  AUX := Length(n);
  If (AUX > 0) Then
    Begin
      For i:=1 To AUX Do
        If (Ord(n[i]) < 48) Or (Ord(n[i]) > 57) Then
          validar_num := False
    End
  Else
    validar_num := false
End;

Procedure leer_dni(Var DNI:String);
Begin
  clrscr;
  write('Ingrese DNI sin puntos: ');
  readln(DNI);
End;

Function val_DNI(DNI:String): boolean;
Begin
  clrscr;
  val_DNI := true;
  If length(dni)<>8 Then
    val_DNI := false
  Else
    If Not validar_num(DNI) Then
      val_DNI := false;
End;



Procedure DNI_validado(Var DNI:String);

Var 
  salir: boolean;
Begin
  salir := true;
  Repeat
    leer_dni(DNI);
    salir := val_DNI(DNI);
  Until salir;
End;



Function ValidarFecha(anio, mes, dia: integer): Boolean;

Var 
  diasPorMes: array [1..12] Of integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31
                                          , 30, 31);
Begin
  ValidarFecha := true;

  If (anio < 1920) Or (anio > 2025) Then
    Begin
      ValidarFecha := false;
    End;

  If (mes < 1) Or (mes > 12) Then
    Begin
      ValidarFecha := false;
    End;

  If (dia < 1) Or (dia > diasPorMes[mes]) Then
    Begin
      ValidarFecha := false;
    End;
End;
// Tenerlo solo como funciones

Procedure BorrarLinea(x,y:integer);
Begin
  Gotoxy(x,y);
  clreol;
End;


Procedure TomarNum(Var num:String);

Var 
  x,y: Integer;
Begin
  x := WhereX;
  y := WhereY;
  Repeat
    ReadLn(num);
    If (Not validar_num(num)) Then
      BorrarLinea(x,y);
  Until validar_num(num);
End;


Procedure TomarFecha(Var Fecha:String);

Var 
  dia,mes,anio: string;
  n1,n2,n3: SmallInt;
  valido,cond: Boolean;
  aux: smallint;
  x,y: integer;
Begin
  writeln('El dia y el mes deben ser de 2 digitos. Por ejemplo 01');
  writeln('');
  Repeat
    valido := true;
    cond := false;
    Write('Ingrese año: ');
    Repeat
      y := WhereY;
      x := WhereX;
      TomarNum(anio);
      aux := StrToInt(anio);
      If (aux<2025) And (aux>1900) Then
        cond := true
      Else
        Begin
          BorrarLinea(x,y);
          gotoxy(x,y);
        End;
    Until cond;
    cond := false;
    Write('Ingrese Mes: ');
    Repeat
      y := WhereY;
      x := WhereX;
      TomarNum(mes);
      aux := StrToInt(mes);
      If (aux<13) And (aux>0) And (Length(mes) = 2) Then
        cond := true
      Else
        Begin
          BorrarLinea(x,y);
          gotoxy(x,y);
        End;
    Until cond;
    cond := false;
    Write('Ingrese dia: ');
    Repeat
      y := WhereY;
      x := WhereX;
      TomarNum(dia);
      aux := StrToInt(dia);
      If (aux<31) And (aux>0) And (Length(dia) = 2)Then
        cond := true
      Else
        Begin
          BorrarLinea(x,y);
          gotoxy(x,y);
        End;
    Until cond;
    n1 := StrToInt(dia);
    n2 := StrToInt(mes);
    n3 := StrToInt(anio);
    If Not ValidarFecha(n3,n2,n1) Then
      valido := false;
    If (Not valido) Then
      Begin
        writeln('Fecha mal ingresada.');
        WriteLn('');
      End;
  Until (valido);
  Fecha := anio+'/'+mes+'/'+dia;
End;

Function ValidarPeriodo (aniomin,mesmin,diamin,aniomax,mesmax,diamax:integer;
                         fecha:String): boolean;

Var 
  n: integer;
  aux: string[4];
Begin
  ValidarPeriodo := true;
  aux := copy(fecha,1,4);
  n := strtoint(aux);
  If (n < aniomin) Or (n > aniomax) Then
    ValidarPeriodo := false
  Else
    Begin
      If (n = aniomin) Then
        Begin
          aux := copy(fecha,6,2);
          n := strtoint(aux);
          If (n < mesmin) Then
            validarperiodo := false
          Else
            If (n=mesmin) Then
              Begin
                aux := copy(fecha,9,2);
                n := strtoint(aux);
                If (n < diamin) Then
                  ValidarPeriodo := false;
              End;
        End
      Else
        If (n = aniomax) Then
          Begin
            aux := copy(fecha,6,2);
            n := strtoint(aux);
            If (n > mesmax) Then
              validarperiodo := false
            Else
              If (n = mesmax) Then
                Begin
                  aux := copy(fecha,9,2);
                  n := strtoint(aux);
                  If (n > diamax) Then
                    ValidarPeriodo := false;
                End;
          End;
    End;
End;



Function ValidarFechasLim (aniomin,aniomax,mesmin,mesmax,diamin,diamax:integer)
: boolean;
Begin
  ValidarFechasLim := true;
  If aniomin>aniomax Then
    ValidarFechasLim := false
  Else
    Begin
      If aniomin=aniomax Then
        Begin
          If mesmin>mesmax Then
            ValidarFechasLim := false
          Else
            If mesmin=mesmax Then
              If diamin>diamax Then
                ValidarFechasLim := false;
        End;
    End;
End;
End.
v