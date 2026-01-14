
Unit Archivos;

Interface
{$CODEPAGE UTF-8}

Uses 
crt,SysUtils,Arch_C,Arbol,Arch_I,Validaciones,Vector;


Procedure LEE_REGISTRO_C(Var ARCH:t_arch_c; POS:Integer; Var REG:T_DATO_C);
Procedure LEE_REGISTRO_I(Var ARCH:t_arch_i; POS:Integer; Var REG:T_DATO_I);

Procedure crear_archivos (Var arch_c: t_arch_c; Var arch_i: t_arch_i);
Procedure cerrar_archivos (Var arch_c: T_arch_c; Var arch_i: T_arch_i);
Procedure ALTA_C (Var ARCH:t_arch_c; Var arbol,arbol2:t_punt_c; DNI:
                  String);

Procedure Consulta_C(Var arch:t_arch_c; i:Integer);
Procedure Modificar_C(Var arch:t_arch_c; i:Integer);
Procedure BajaLogica(Var arch:t_arch_c; i:Integer);
Procedure ALTA_I (Var ARCH:t_arch_i; Var arch2:t_arch_c; Var arbol,arbol2:
                  t_punt_c;
                  vector:
                  t_vector);

Procedure consulta_i (Var arch:t_arch_i);
Procedure MOD_inf(Var arch:t_arch_i);
Procedure Iniciar_Arbol(Var arbol:t_punt_c;Var arbol2:t_punt_c; Var arch:
                        t_arch_c);

Procedure Revisa_estado(Var ARCH:t_arch_c);

Procedure listado_de_conductores (arbol: t_punt_c; Var arch: t_arch_c);

Procedure listado_de_scoring (arbol: t_punt_c; Var arch: t_arch_c);



Procedure periodo(Var ARCH:t_arch_i);
Procedure periodo2(Var ARCH:t_arch_i; Arbol:T_PUNT_C);
Procedure TextToInt (fecha:String; Var anio:Integer;Var mes:Integer;Var dia:
                     Integer);


Implementation

Procedure crear_archivos (Var arch_c: t_arch_c; Var arch_i: t_arch_i);
Begin
  crear_archivo_c(arch_c);
  crear_archivo_i(arch_i);
End;


Procedure cerrar_archivos (Var arch_c: T_arch_c; Var arch_i: T_arch_i);
Begin
  cerrar_archivo_c(arch_c);
  cerrar_archivo_i(arch_i);
End;

Procedure LEE_REGISTRO_C(Var ARCH:t_arch_c; POS:Integer; Var REG:T_DATO_C);
Begin
  SEEK(ARCH, POS);
  READ(ARCH, REG);
End;

Procedure GUARDA_REGISTRO_C(Var ARCH:t_arch_c; Var POS:Integer; REG:T_DATO_C);
Begin
  SEEK(ARCH, POS);
  WRITE(ARCH, REG);
End;

Procedure TextToInt (fecha:String; Var anio:Integer;Var mes:Integer;Var dia:
                     Integer);

Var 
  aux: string[4];
  aux2,aux3: string[2];
Begin
  aux := copy(fecha,1,4);
  anio := strtoint(aux);
  If (fecha[7] <> '/') Then
    aux2 := copy(fecha,6,2)
  Else
    aux2 := fecha[6];
  mes := strtoint(aux2);
  If (fecha[8] = '/') Then
    aux3 := copy(fecha,9,2)
  Else
    aux3 := copy(fecha,8,2);
  dia := strtoint(aux3);
End;

Procedure tam_min(Var text:String);

Var 
  aux: string;
  x,y: Integer;
Begin
  x := WhereX;
  y := WhereY;
  Repeat
    Readln(aux);
    If (Length(aux) = 0) Then
      BorrarLinea(x,y);
  Until (Length(aux) <>0);
  text := aux;
End;

Function ComparaBaja(fecha1:String;fecha2:Integer): Boolean;

Var 
  aux: string;
  n: Integer;
  i: byte;
Begin
  aux := '';
  For i:=1 To 4 Do
    aux := aux+fecha1[i];

  n := fecha2-StrToInt(aux);
  If (n>70) Then
    ComparaBaja := true
  Else
    ComparaBaja := false;
End;

Procedure Revisa_estado(Var ARCH:t_arch_c);

Var 
  FechaActual: TDateTime;
  pos,anio,mes,dia: Integer;
  anio2,mes2,dia2: word;
  x: T_DATO_C;
  fecha: string;
Begin
  pos := 0;
  Seek(arch,0);
  FechaActual := Now;
  DecodeDate(FechaActual,anio2,mes2,dia2);
  While Not Eof(ARCH) Do
    Begin
      LEE_REGISTRO_C(ARCH,pos,x);
      fecha := x.F_hab;
      TextToInt(fecha,anio,mes,dia);
      If (x.scoring = 0) And (anio = anio2) And (mes = mes2) And (dia=dia2) Then
        Begin
          x.Habilitado := true;
          x.scoring := 20;
        End;
      GUARDA_REGISTRO_C(ARCH,pos,x);
      Inc(pos);
    End;
End;

Procedure CARGA_registro_C(Var r: T_DATO_C; Clave:String);

Var 
  FechaActual: TDateTime;
  fecha,aux1,aux2: string;
  Anio, Mes, Dia: Word;
Begin
  writeln('A continuacion ingrese los datos del conductor.');
  delay(1000);
  clrscr;
  With r Do
    Begin
      writeln('DNI: ',Clave);
      DNI := Clave;
      WRITE('Apellido y Nombre: ');
      tam_min(ApyNom);
      Write('Ingrese numero de telefono: ');
      TomarNum(Tel);
      Write('Ingrese Correo de contacto: ');
      tam_min(e_mail);
      Write('Fecha de nacimiento. ');
      TomarFecha(fecha);
      F_nac := fecha;
      FechaActual := Date;
      DecodeDate(FechaActual, Anio, Mes, Dia);
      If (Mes < 10) Then
        aux1 := '0'+IntToStr(Mes)
      Else
        aux1 := IntToStr(mes);
      If (Dia < 10) Then
        aux2 := '0'+IntToStr(Dia)
      Else
        aux2 := IntToStr(Dia);
      F_Hab := IntToStr(Anio) + '/' + aux1 + '/' + aux2;
      scoring := 20;
      Habilitado := TRUE;
      Reincidencia := 0;
      BajaLog := ComparaBaja(fecha,Anio);
    End;
End;

Procedure LEE_REGISTRO_I(Var ARCH:t_arch_i; POS:Integer; Var REG:T_DATO_I);
Begin
  SEEK(ARCH, POS);
  READ(ARCH, REG);
End;

Procedure GUARDA_REGISTRO_I(Var ARCH:t_arch_i; POS:Integer; REG:T_DATO_I);
Begin
  SEEK(ARCH, POS);
  WRITE(ARCH, REG);
End;

Procedure opciones_tipo_infraccion (Var validado: word; min,max:byte);

Var 
  inf: string;
  x,y: Integer;
Begin
  validado := 20;
  write('Ingrese un numero del ',min,' al ',max,
        ', o 0 si desea ver las otras opciones: ');
  x := WhereX;
  y := WhereY;
  Repeat
    readln(inf);
    If (validar_num(inf)) Then
      validado := StrToInt(inf);
    borrarlinea(x,y);
    gotoxy(x,y);
  Until ((validado > min-1) And (validado < max+1)) Or (validado = 0);
End;

Procedure carga_tipo_inf (vector:t_vector; Var validado:word);

Var 
  salir,hoja1: boolean;
  i,min,max: byte;
Begin
  hoja1 := true;
  writeln('A continuacion ingrese el tipo de infraccion.');
  delay(2500);
  clrscr;
  Repeat
    If hoja1 Then
      Begin
        min := 1;
        max := 10;
      End
    Else
      Begin
        min := 11;
        max := 15;
      End;
    For i:=min To max Do
      writeln(i,'- ',vector[i].nombre);
    opciones_tipo_infraccion(validado,min,max);
    If validado <> 0 Then
      salir := true
    Else
      Begin
        If hoja1 Then
          hoja1 := false
        Else
          hoja1 := true;
      End;
    clrscr;
  Until salir;
End;

Procedure CARGA_registro_I(Var r: T_DATO_I;DNI_ingresado:String; vector:t_vector
);

Var 
  FechaActual: TDateTime;
  validado,Anio, Mes, Dia: word;
  aux1,aux2: string;
Begin
  carga_tipo_inf(vector,validado);
  With r Do
    Begin
      Tipo := validado;
      DNI := DNI_ingresado;
      FechaActual := Date;
      DecodeDate(FechaActual, Anio, Mes, Dia);
      If (Mes < 10) Then //Menor que 10 para quedar de la forma 09, 08
        aux1 := '0'+IntToStr(Mes)
      Else
        aux1 := IntToStr(mes);
      If (Dia < 10) Then
        aux2 := '0'+IntToStr(Dia)
      Else
        aux2 := IntToStr(Dia);
      F_inf := IntToStr(Anio) + '/' + aux1 + '/' + aux2;
      p_desc := vector[Tipo].num;
      reclamo := false;
    End;
End;

// ABMC Archivo conductor

// ALTA

Function confirmar_datos(): boolean;

Var 
  key: char;
  salir: boolean;
Begin

  writeln('');
  writeln('Confirma estos datos? S/N');
  salir := false;
  Repeat
    key := Readkey;
    If (UpCase(key) = 'S') Then
      Begin
        confirmar_datos := true;
        salir := true;
      End
    Else
      If (UpCase(key) = 'N') Then
        Begin
          confirmar_datos := false;
          salir := true;
        End;
  Until salir;
End;

Procedure ALTA_C (Var ARCH:t_arch_c; Var arbol,arbol2:t_punt_c; DNI:
                  String);

Var 
  R: T_DATO_C;
  POS: Integer;
  confirmar: boolean;
Begin
  CLRSCR;
  Repeat
    CARGA_registro_C(R,DNI);
    confirmar := confirmar_datos();
  Until confirmar;
  POS := FILESIZE(ARCH);
  GUARDA_REGISTRO_C(ARCH, POS, R);
  Insertar_Arbol(arbol,R.DNI,POS);
  Insertar_Arbol(arbol2,R.ApyNom,POS);
End;

// Consulta

Procedure Mostrar_Registro_C(X:T_DATO_C);
Begin
  WriteLn('DNI del Conductor: ',X.DNI);
  WRITEln('Apellido y Nombre: ',X.ApyNom);
  WriteLn('Fecha de nacimiento: ',X.F_nac);
  WriteLn('Ingrese numero de telefono: ',X.Tel);
  WriteLn('Ingrese Correo de contacto: ',X.e_mail);
  WriteLn('Ingrese fecha de habilitacion: ',X.F_hab);
  WriteLn('Scoring: ',X.scoring);
  If X.Habilitado Then
    WriteLn('Estado: Habilitado')
  Else
    Writeln('Estado: Deshabilitado');
  WriteLn('Reincidencias: ',X.Reincidencia);
  If X.BajaLog Then
    WriteLn('Baja lógica: Confirmada.')
End;

Procedure Consulta_C(Var arch:t_arch_c; i:Integer);

Var 
  X: T_DATO_C;
Begin
  clrscr;
  LEE_REGISTRO_C(arch,i,X);
  Mostrar_Registro_C(X);
End;

//Modificaciones

Procedure rehabilitacion (reincidencias:byte; Var fecha_r:String);

Var 
  FechaActual: TDateTime;
  anio,mes,dia,dias,repetir,contador: word;
  mes1,dia1: string;
  vector: array [1..12] Of byte = (0,0,0,0,0,0,0,0,0,0,0,0);
  lleno: boolean;
Begin
  FechaActual := Now;
  WriteLn('La fecha y hora actual son: ',FechaActual);
  DecodeDate(FechaActual,anio,mes,dia);
  writeln(anio,' ',mes,' ',dia);
  readkey;
  vector[mes] := dia;
  If reincidencias<4 Then
    dias := 60*reincidencias
  Else
    Begin
      repetir := reincidencias-3;
      dias := 180;
      For contador:=1 To repetir Do
        dias := dias*2;
    End;
  lleno := false;
  Repeat
    Case mes Of 
      1,3,5,7,8,10,12: If vector[mes] = 31 Then
                         lleno := true;
      4,6,9,11: If vector[mes] = 30 Then
                  lleno := true;
      2: If vector[mes] = 29 Then
           lleno := true;
    End;
    If Not lleno Then
      vector[mes] := vector[mes]+1
    Else
      Begin
        vector[mes] := 0;
        If mes = 12 Then
          Begin
            inc(anio);
            mes := 1;
          End
        Else
          inc(mes);
        vector[mes] := 1;
        lleno := false;
      End;
    dec(dias);
  Until dias = 0;
  If (mes<10) Then
    mes1 := '0'+IntToStr(mes)
  Else
    mes1 := IntToStr(mes);
  If (dia<10) Then
    dia1 := '0'+IntToStr(dia)
  Else
    dia1 := IntToStr(dia);

  fecha_r := IntToStr(anio)+ '/'+mes1+'/'+dia1;
End;

Procedure Actualiza_scoring(Var arch:t_arch_c; P:byte;Var i:Integer);

Var 
  x: T_DATO_C;
  res,ac: Integer;
  fecha: string;
Begin
  lee_registro_c(arch,i,x);
  res := x.scoring-P;
  If (res > 0) Then
    Begin
      x.scoring := res;
      Guarda_registro_c(arch,i,x);
    End
  Else
    If ((res < 0) Or (res = 0)) And (x.scoring > 0) Then
      Begin
        x.habilitado := false;
        x.scoring := 0;
        x.Reincidencia := x.Reincidencia + 1;
        ac := x.Reincidencia;
        rehabilitacion(ac,fecha);
        x.F_hab := fecha;
        Guarda_registro_c(arch,i,x);
      End
End;

Procedure Opciones(Var seleccionado:byte;X:T_DATO_C);

Var 
  salir: boolean;
  tecla: char;
Begin
  salir := false;
  seleccionado := 1;
  While Not salir Do
    Begin
      textbackground(black);
      clrscr;
      Mostrar_Registro_C(X);
      WriteLn('');
      WriteLn('Que desea modificar?');
      If (seleccionado = 1) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('ApyNom');
      If (seleccionado = 2) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('Fecha de Nacimiento');
      If (seleccionado = 3) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('Telefono');

      If (seleccionado = 4) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('e-mail');

      If (seleccionado = 5) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      WriteLn('Dar de baja');
      If (seleccionado = 6) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('Guardar Cambios');
      If (seleccionado = 7) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('Volver');
      tecla := readkey;

      If tecla=#00 Then
        Begin
          tecla := readkey;
        End;

      Case tecla Of 
        #72: If seleccionado > 1 Then seleccionado := seleccionado-1;
        #80: If seleccionado < 7 Then seleccionado := seleccionado+1;
        #13: salir := true;
      End;
    End;
  textbackground(black);
End;

Procedure Modificar_C(Var arch:t_arch_c; i:Integer);

Var 
  ac: byte;
  X: T_DATO_C;
  fecha,tel: string;
Begin
  LEE_REGISTRO_C(arch,i,X);
  writeln('A continuacion se mostraran los datos actuales: ');
  Repeat
    Opciones(ac,X);
    WriteLn('');
    If ac<>2 Then
      write('Ingrese el cambio: ');
    Case ac Of 
      1: tam_min(X.ApyNom);
      2:
         Begin
           TomarFecha(fecha);
           X.F_nac := fecha;
         End;
      3:
         Begin
           TomarNum(tel);
           X.Tel := tel;
         End;
      4: tam_min(X.e_mail);
      5: x.BajaLog := True;
      6: GUARDA_REGISTRO_C(arch,i,X);
    End;
  Until (ac = 7);
  clrscr;
End;

// Baja 
Procedure BajaLogica(Var arch:t_arch_c; i:Integer);

Var 
  Nacimiento: string;
  anio_nac: word;
  X: T_DATO_C;
  //FechaActual: TDateTime;
  Anio, Mes, Dia: Word;
Begin
  LEE_Registro_C(arch,i,X);
  DecodeDate(Date,Anio,mes,dia);
  Nacimiento := Copy(X.F_nac,1,4);
  anio_nac := StrToInt(Nacimiento);
  If ((Anio - anio_nac) > 70) Then
    X.BajaLog := True;
  GUARDA_REGISTRO_C(arch,i,X);

End;

Procedure Iniciar_Arbol(Var arbol:t_punt_c;Var arbol2:t_punt_c; Var arch:
                        t_arch_c);

Var 
  i: Integer;
  X: T_DATO_C;
Begin
  Crear_Arbol(arbol);
  Crear_Arbol(arbol2);
  If (FileSize(arch) <> 0) Then
    Begin
      i := 0;
      While Not Eof(arch) Do
        Begin
          LEE_REGISTRO_C(arch,i,X);
          Insertar_Arbol(arbol,X.DNI,i);
          Insertar_Arbol(arbol2,X.ApyNom,i);
          BajaLogica(arch, i);
          Inc(i);
        End;
    End;
End;

// ABMC Archivo Infracciones

Procedure mostrar_datos_i (reg:T_DATO_I);
Begin
  With reg Do
    Begin
      TextColor(green);
      WriteLn('DNI: ',DNI);
      WriteLn('Fecha de infraccion: ',F_inf);
      WriteLn('Tipo de infraccion: ',Tipo);
      WriteLn('Puntos a descontar: ',P_desc);
      write('Reclamo: ');
      If reclamo Then
        writeln('Si')
      Else
        writeln('No');
      TextColor(white);
    End;
End;

Procedure OpConfirmar(Var seleccionado:byte;X:T_DATO_I);

Var 
  salir: boolean;
  tecla: char;
Begin
  salir := false;
  seleccionado := 1;
  While Not salir Do
    Begin
      textbackground(black);
      clrscr;
      mostrar_datos_i(X);
      WriteLn('Esta seguro de los cambios?');
      If (seleccionado = 1) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('Confirmar');
      If (seleccionado = 2) Then
        Begin
          TextBackground(White);
          TextColor(Black);
        End
      Else
        Begin
          TextBackground(Black);
          TextColor(white);
        End;
      writeln('Cancelar');
      tecla := readkey;

      If tecla=#00 Then
        Begin
          tecla := readkey;
        End;

      Case tecla Of 
        #72: If seleccionado > 1 Then seleccionado := seleccionado-1;
        #80: If seleccionado < 2 Then seleccionado := seleccionado+1;
        #13: salir := true;
      End;
    End;
  textbackground(black);
End;

Function confirmar_dni (dni:String): boolean;

Var 
  key: char;
  exit: boolean;
Begin
  writeln('Confirmar DNI? S/N');
  exit := false;
  Repeat
    key := Readkey;
    If (UpCase(key) = 'S') Then
      Begin
        confirmar_dni := true;
        exit := true;
      End
    Else
      If (UpCase(key) = 'N') Then
        Begin
          confirmar_dni := false;
          exit := true;
        End
  Until exit;
End;

Procedure ALTA_I (Var ARCH:t_arch_i; Var arch2:t_arch_c;Var arbol,arbol2:
                  t_punt_c;
                  vector:
                  t_vector);

Var 
  R: T_DATO_I;
  P: byte;
  i,POS: Integer;
  DNI: string[8];
  salir: boolean;
Begin
  Repeat
    clrscr;
    Write('Ingrese DNI del infractor: ');
    ReadLn(DNI);
    salir := confirmar_dni(DNI);
  Until salir;
  i := buscar_arbol(arbol,DNI);
  If (i < 0) Or (i>FileSize(arch2)) Then
    Begin
      ALTA_C(arch2,arbol,arbol2,DNI);
      i := FileSize(arch2) - 1;
    End;
  salir := false;
  Repeat
    CARGA_registro_I(R,DNI,vector);
    clrscr;
    mostrar_datos_i(R);
    salir := confirmar_datos();
  Until salir;
  POS := FILESIZE(ARCH);
  R.N_inf := POS;
  GUARDA_REGISTRO_I(ARCH, POS, R);
  P := R.P_desc;
  Actualiza_scoring(arch2,P,i);

End;
// MODIFICAR Infracciones

// Solo pueden reclamar la infracción de la cual se encarga un juez
Procedure MOD_inf(Var arch:t_arch_i);

Var 
  x: T_DATO_I;
  pos: Integer;
  n: string;
  op: byte;
Begin
  clrscr;
  Write('Ingrese Numero de infraccion: ');
  TomarNum(n);
  pos := StrToInt(n);
  If (pos > (FileSize(arch) - 1))Then
    Begin
      WriteLn('No se encontro la infraccion solicitada.');
      readkey;
    End
  Else
    Begin
      LEE_REGISTRO_I(arch,Pos,X);
      Repeat
        clrscr;
        OpConfirmar(op,X);
        If (op = 1) Then
          Begin
            x.reclamo := true;
            guarda_registro_i(arch,pos,x);
          End;
      Until (op=1) Or (op=2);
    End;
End;



Procedure consulta_i (Var arch:t_arch_i);

Var 
  n: string;
  pos: Integer;
  X: T_DATO_I;
Begin
  clrscr;
  Write('Ingrese Numero de infraccion: ');
  TomarNum(n);
  pos := StrToInt(n);
  If (FileSize(arch) <> 0)  And (Not (pos > (FileSize(arch) -
     1)))Then
    Begin
      LEE_REGISTRO_I(arch,pos,X);
      mostrar_datos_i(X);
    End
  Else
    WriteLn('No se ha encontrado la infraccion');
  readkey;
End;


// Listas Conductor

Procedure SigPag(Var i:byte);

Var 
  key: char;
Begin
  i := 0;
  WriteLn('Presione una tecla para ir a la siguiente página.');
  key := readkey;
  If (key = #00) Then
    key := readkey;
  clrscr;
End;

// MODIFICAR SIN USAR LISTA
Procedure escribir_datos_lista (dni,apynom:String; score: byte);

Var 
  y: integer;
Begin
  y := WhereY;
  inc(y);
  gotoxy(1,y);
  write(dni,'  ',apynom);
  gotoxy(47,y);
  write(score);
End;

Procedure recorrer_arbol (arbol:T_PUNT_C; Var arch: t_arch_c);

Var 
  reg: T_DATO_C;
Begin
  LEE_REGISTRO_C(arch, arbol^.Pos, reg);
  If (arbol^.SAI <> Nil) Then
    Begin
      recorrer_arbol(arbol^.SAI,arch);
      escribir_datos_lista(reg.DNI,reg.ApyNom,reg.scoring);
    End
  Else
    Begin
      escribir_datos_lista(reg.DNI,reg.ApyNom,reg.scoring);
    End;
  If (arbol^.SAD <> Nil) Then
    recorrer_arbol(arbol^.SAD,arch);
End;

Procedure listado_de_conductores (arbol: t_punt_c; Var arch: t_arch_c);

Var 
  x: integer;
Begin
  clrscr;
  textColor(red);
  write('DNI');
  x := 12;
  gotoxy(x,1);
  write('ApyNom');
  x := 47;
  gotoxy(x,1);
  WriteLn('Puntos');
  textcolor(white);
  Seek(arch,0);
  recorrer_arbol (arbol,arch);
  readkey;
End;

Procedure recorrer_arbol_scoring (arbol:T_PUNT_C; Var arch: t_arch_c; Var
                                  advertencia:boolean);

Var 
  reg: T_DATO_C;
Begin
  LEE_REGISTRO_C(arch, arbol^.Pos, reg);

  If (arbol^.SAI <> Nil) Then
    Begin
      recorrer_arbol_scoring(arbol^.SAI,arch,advertencia);
      If (reg.scoring = 0) Then
        Begin
          escribir_datos_lista(reg.DNI,reg.ApyNom,reg.scoring);
          advertencia := true;
        End;

    End;
  If (arbol^.SAD <> Nil) Then
    recorrer_arbol_scoring(arbol^.SAD,arch,advertencia);
End;

Procedure listado_de_scoring (arbol: t_punt_c; Var arch: t_arch_c);

Var 
  x: integer;
  advertencia: boolean;
Begin
  advertencia := false;
  clrscr;
  textColor(red);
  write('DNI');
  x := 12;
  gotoxy(x,1);
  write('ApyNom');
  x := 47;
  gotoxy(x,1);
  WriteLn('Puntos');
  textcolor(white);
  Seek(arch,0);
  recorrer_arbol_scoring (arbol,arch,advertencia);
  If Not advertencia Then
    Begin
      writeln('');
      WriteLn('No se encontraron conductores con 0 de scoring.');
    End;
  readkey;
End;

//Listado Infracciones en periodo determinado





Procedure lista_de_infracciones ();
Begin
  textcolor(red);
  writeln('DNI       Tipo  P.D.  Fecha   ');
  writeln('');
  textcolor(white);
End;

Procedure Datos_i(REG:T_DATO_I);

Var 
  y: integer;
Begin
  y := Wherey;
  inc(y);
  gotoxy(1,y);
  write(REG.DNI,'   ',REG.Tipo);
  gotoxy(19,y);
  write(REG.P_desc);
  gotoxy(23,y);
  write(REG.F_inf);
End;


Procedure periodo(Var ARCH:t_arch_i);

Var 
  Fecha1,Fecha2,Fecha3: string;
  X: T_DATO_I;
  i: word;
  j: byte;
  valido,existen: boolean;
  mesmin,mesmax,aniomin,aniomax,diamin,diamax: integer;
Begin
  existen := false;
  clrscr;
  If (FileSize(ARCH) <> 0) Then
    Begin
      WriteLn('Ingrese la primer fecha dentro del periodo: ');
      TomarFecha(Fecha1);
      TextToInt(fecha1,aniomin,mesmin,diamin);
      WriteLn('');
      valido := true;
      Repeat
        If Not valido Then
          Begin
            writeln('Fecha final menor que la primer fecha. Intente de nuevo.');
            readkey;
          End;
        clrscr;
        WriteLn('Ingrese la fecha final del periodo: ');
        TomarFecha(Fecha2);
        TextToInt(fecha2,aniomax,mesmax,diamax);
        valido := ValidarFechasLim(aniomin,aniomax,mesmin,mesmax,diamin,diamax);
      Until valido;
      i := 0;
      j := 0;
      clrscr;
      lista_de_infracciones();
      While Not Eof(ARCH) Or (i=0) Do
        Begin
          LEE_REGISTRO_I(ARCH,i,X);
          Fecha3 := x.F_inf;
          valido := ValidarPeriodo(aniomin,mesmin,diamin,aniomax,mesmax,diamax
                    ,
                    Fecha3);
          If valido Then
            Begin
              Datos_i(X);
              existen := true;
            End;
          Inc(i);
          Inc(j);
          If (j = 30) And (Not Eof(ARCH)) Then
            Begin
              SigPag(j);
              lista_de_infracciones();
            End;
        End;
    End
  Else
    Writeln('No hay infracciones cargadas');
  If Not existen Then
    writeln('No hay infracciones dentro del periodo.');
  readkey;
  readkey;
End;

Procedure periodo2(Var ARCH:t_arch_i; Arbol:T_PUNT_C);

Var 
  DNI,Fecha1,Fecha2: string;
  X: T_DATO_I;
  i: word;
  j: byte;
  pos: Integer;
  valido, existen: boolean;
  mesmin,mesmax,aniomin,aniomax,diamin,diamax: integer;
Begin
  clrscr;
  If (FileSize(ARCH) <> 0) Then
    Begin
      DNI_validado(DNI);
      pos := buscar_arbol(Arbol,DNI);
      If (pos > -1) Then
        Begin
          WriteLn('Ingrese la primer fecha dentro del periodo: ');
          TomarFecha(Fecha1);
          TextToInt(fecha1,aniomin,mesmin,diamin);
          WriteLn('');
          valido := true;
          Repeat
            If Not valido Then
              Begin
                writeln('Fecha final menor que Fecha inicial. Intente de nuevo.'
                );
                readkey;
              End;
            clrscr;
            WriteLn('Ingrese la fecha final del periodo: ');
            TomarFecha(Fecha2);
            TextToInt(fecha2,aniomax,mesmax,diamax);
            valido := ValidarFechasLim(aniomin,aniomax,mesmin,mesmax,diamin,
                      diamax);
          Until valido;
          i := 0;
          j := 0;
          clrscr;
          lista_de_infracciones();
          While Not Eof(ARCH) Or (i=0) Do
            Begin
              LEE_REGISTRO_I(ARCH,i,X);
              valido := ValidarPeriodo(aniomin,mesmin,diamin,aniomax,mesmax,
                        diamax,x.F_inf);
              If valido And (x.DNI = DNI) Then
                Datos_i(X);
              existen := true;
              Inc(i);
              Inc(j);
              If (j = 30) And (Not Eof(ARCH)) Then
                Begin
                  SigPag(j);
                  lista_de_infracciones();
                End;

            End;
        End
      Else
        WriteLn('No se ha encontrado registro de un conductor con el DNI ',DNI,
                '.'
        )
    End
  Else
    WriteLn('No hay infracciones cargadas.');
  If Not existen Then
    writeln('No existen infracciones dentro del periodo.');
  readkey;
  readkey;
End;
End.
