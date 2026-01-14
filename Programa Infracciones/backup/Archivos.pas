
Unit Archivos;

Interface

Uses 
crt,SysUtils,Arch_C,Arbol,Arch_I,Validaciones,Vector,Lista_c;



Procedure crear_archivos (Var arch_c: t_arch_c; Var arch_i: t_arch_i);
Procedure cerrar_archivos (Var arch_c: T_arch_c; Var arch_i: T_arch_i);
Procedure ALTA_C (Var ARCH:t_arch_c; Var arbol:t_punt_c; Var L:T_LISTA_C; DNI:
                  String);

Procedure Consulta_C(Var arch:t_arch_c; i:SmallInt);
Procedure Modificar_C(Var arch:t_arch_c; i:SmallInt);
Procedure BajaLogica(Var arch:t_arch_c; i:SmallInt);
Procedure ALTA_I (Var ARCH:t_arch_i; Var arch2:t_arch_c; arbol:t_punt_c; vector:
                  t_vector;L:T_LISTA_C);

Procedure consulta_i (Var arch:t_arch_i);
Procedure MOD_inf(Var arch:t_arch_i);
Procedure Iniciar_Arbol(Var arbol:t_punt_c; Var arch:t_arch_c);
Procedure Iniciar_Lista(Var L:T_LISTA_C; Var arch:t_arch_c);

Procedure MUESTRA_LISTA_APYNOM(L:T_LISTA_C);
Procedure MUESTRA_LISTA_SCORING(L:T_LISTA_C);
Procedure periodo(Var ARCH:t_arch_i);
Procedure periodo2(Var ARCH:t_arch_i;Var ARCH2:t_arch_c; Arbol:T_PUNT_C);


Implementation
//Crear Archivos




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

Procedure LEE_REGISTRO_C(Var ARCH:t_arch_c; POS:SmallInt; Var REG:T_DATO_C);
Begin
  SEEK(ARCH, POS);
  READ(ARCH, REG);
End;

Procedure GUARDA_REGISTRO_C(Var ARCH:t_arch_c; Var POS:SmallInt; REG:T_DATO_C);
Begin
  SEEK(ARCH, POS);
  WRITE(ARCH, REG);
End;


Procedure CARGA_registro_C(Var r: T_DATO_C; Clave:String);

Var 
  FechaActual: TDateTime;
  fecha: string;
  Anio, Mes, Dia: Word;
Begin
  writeln('A continuacion ingrese los datos del conductor.');
  delay(1500);
  clrscr;
  With r Do
    Begin
      DNI := Clave;
      WRITE('Apellido y Nombre: ');
      ReadLn(ApyNom);
      ValFecha(fecha);
      F_nac := fecha;
      Write('Ingrese numero de telefono: ');
      READLN (TEL);
      Write('Ingrese Correo de contacto: ');
      ReadLn(e_mail);
      FechaActual := Date;
      DecodeDate(FechaActual, Anio, Mes, Dia);
      F_Hab := IntToStr(Anio) + '/' + IntToStr(Mes) + '/' + IntToStr(Dia);
      scoring := 20;
      Habilitado := TRUE;
      Reincidencia := 0;
      BajaLog := False;
    End;
End;

Procedure LEE_REGISTRO_I(Var ARCH:t_arch_i; POS:SmallInt; Var REG:T_DATO_I);
Begin
  SEEK(ARCH, POS);
  READ(ARCH, REG);
End;

Procedure GUARDA_REGISTRO_I(Var ARCH:t_arch_i; POS:SmallInt; REG:T_DATO_I);
Begin
  SEEK(ARCH, POS);
  WRITE(ARCH, REG);
End;

Procedure CARGA_registro_I(Var r: T_DATO_I;DNI_ingresado:String; vector:t_vector
);

Var 
  FechaActual: TDateTime;
  validado,Anio, Mes, Dia: word;
  i: byte;
  inf: string;

Begin
  writeln('A continuacion ingrese el tipo de infraccion.');
  delay(3500);
  clrscr;
  With r Do
    Begin
      DNI := DNI_ingresado;
      FechaActual := Date;
      DecodeDate(FechaActual, Anio, Mes, Dia);
      F_inf := IntToStr(Anio) + '/' + IntToStr(Mes) + '/' + IntToStr(Dia);
      For i:=1 To 15 Do
        Begin
          writeln(i,'- ',vector[i].nombre);
          writeln('');
          If (i=5) Then
            Begin
              WriteLn('Presione una tecla para continuar');
              readkey;
              clrscr;
            End;
          If (i=10) Then
            Begin
              WriteLn('Presione una tecla para continuar');
              readkey;
              readkey;
              clrscr;
            End;
        End;
      validado := 0;
      Repeat
        write('Ingrese un numero del 1 al 15: ');
        readln(inf);
        If (validar_num(inf)) Then
          validado := StrToInt(inf);
      Until ((validado > 0) And (validado < 16));
      Tipo := validado;
      p_desc := vector[Tipo].num;
      reclamo := false;
    End;
End;





// ABMC Archivo conductor

// ALTA


Procedure ALTA_C (Var ARCH:t_arch_c; Var arbol:t_punt_c; Var L:T_LISTA_C; DNI:
                  String);

Var 
  R: T_DATO_C;
  POS: SmallInt;
Begin
  CLRSCR;
  CARGA_registro_C(R,DNI);
  POS := FILESIZE(ARCH);
  GUARDA_REGISTRO_C(ARCH, POS, R);
  Insertar_Arbol(arbol,R.DNI,POS);
  AGREGAR(L,R);
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
    WriteLn('Dado de baja por edad.')
End;

Procedure Consulta_C(Var arch:t_arch_c; i:SmallInt);

Var 
  X: T_DATO_C;
Begin
  clrscr;
  LEE_REGISTRO_C(arch,i,X);
  Mostrar_Registro_C(X);
End;

//Modificaciones


Procedure Actualiza_scoring(Var arch:t_arch_c; P:byte; i:SmallInt);

Var 
  x: T_DATO_C;
  res: SmallInt;
Begin
  lee_registro_c(arch,i,x);
  res := x.scoring-P;
  If (res < 1) Then
    Begin
      x.habilitado := false;
      x.scoring := 0;
      x.Reincidencia := x.Reincidencia + 1;
    End
  Else
    x.scoring := res;
  Guarda_registro_c(arch,i,x);
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
      writeln('Salir');
      tecla := readkey;

      If tecla=#00 Then
        Begin
          tecla := readkey;
        End;

      Case tecla Of 
        #72: If seleccionado > 1 Then seleccionado := seleccionado-1;
        #80: If seleccionado < 5 Then seleccionado := seleccionado+1;
        #13: salir := true;
      End;
    End;
End;

Procedure OpConfirmar(Var seleccionado:byte);

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


Procedure Modificar_C(Var arch:t_arch_c; i:SmallInt);

Var 
  ac: byte;
  X: T_DATO_C;
Begin
  LEE_REGISTRO_C(arch,i,X);
  writeln('A continuacion se mostraran los datos actuales: ');
  Repeat
    Opciones(ac,X);
    Case ac Of 
      1: ReadLn(X.ApyNom);
      2: ValFecha(X.F_nac);
      3: ReadLn(X.Tel);
      4: ReadLn(X.e_mail);
    End;
  Until (ac = 5);
  OpConfirmar(ac);
  If (ac = 1) Then
    Begin
      GUARDA_REGISTRO_C(arch,i,X);
      writeln('Se mostraran los cambios a continuación.');
      Mostrar_Registro_C(X);
    End;
  readkey;
  clrscr;
End;

// Baja 
Procedure BajaLogica(Var arch:t_arch_c; i:SmallInt);

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

Procedure Iniciar_Arbol(Var arbol:t_punt_c; Var arch:t_arch_c);

Var 
  i: SmallInt;
  X: T_DATO_C;
Begin
  Crear_Arbol(arbol);
  If (FileSize(arch) <> 0) Then
    Begin
      i := 0;
      While Not Eof(arch) Do
        Begin
          LEE_REGISTRO_C(arch,i,X);
          Insertar_Arbol(arbol,X.DNI,i);
          BajaLogica(arch, i);
          Inc(i);
        End;
    End;
End;

Procedure Iniciar_Lista(Var L:T_LISTA_C; Var arch:t_arch_c);

Var 
  i: SmallInt;
  X: T_DATO_C;
Begin
  CREARLISTA(L);
  If (FileSize(arch) <> 0) Then
    Begin
      i := 0;
      While Not Eof(arch) Do
        Begin
          LEE_REGISTRO_C(arch,i,X);
          AGREGAR(L,X);
          Inc(i);
        End;
    End;

End;



// ABMC Archivo Infracciones

Procedure ALTA_I (Var ARCH:t_arch_i; Var arch2:t_arch_c; arbol:t_punt_c; vector:
                  t_vector;L:T_LISTA_C);

Var 
  R: T_DATO_I;
  P: byte;
  i,POS: SmallInt;
  DNI: string[8];
Begin
  CLRSCR;
  Write('Ingrese DNI del infractor: ');
  ReadLn(DNI);
  i := buscar_arbol(arbol,DNI);
  If (i = -1) Then
    Begin
      ALTA_C(arch2,arbol,L,DNI);
      i := FileSize(arch2) - 1;
    End;
  CARGA_registro_I(R,DNI,vector);
  POS := FILESIZE(ARCH);
  GUARDA_REGISTRO_I(ARCH, POS, R);
  P := R.P_desc;
  Actualiza_scoring(arch2,P,i);
End;

// MODIFICAR Infracciones


Procedure mostrar_datos_i (reg:T_DATO_I);
Begin
  With reg Do
    Begin
      WriteLn('DNI: ',DNI);
      WriteLn('Fecha de infraccion: ',F_inf);
      WriteLn('Tipo de infraccion: ',Tipo);
      WriteLn('Puntos a descontar: ',P_desc);
      write('Reclamo: ');
      If reclamo Then
        writeln('Si')
      Else
        writeln('No');
    End;
End;

Function busqueda_binaria (Var arch:t_arch_i;n:word): SmallInt;

Var 
  x: t_dato_i;
  a,b,m: word;
Begin
  a := 0;
  b := FileSize(arch)-1;
  busqueda_binaria := -1;
  Repeat
    m := (a+b)Div 2;
    Seek(arch,m);
    Read(arch,x);
    If (n = x.N_inf) Then
      busqueda_binaria := m
    Else
      If (n < x.N_inf) Then
        b := m-1
    Else
      a := m+1;
  Until (a > b) Or (busqueda_binaria <> -1)
End;



Procedure MOD_inf(Var arch:t_arch_i);

Var 
  x: T_DATO_I;
  pos: SmallInt;
  n: word;
  op: byte;
Begin
  clrscr;
  Write('Ingrese Numero de infraccion: ');
  ReadLn(n);
  pos := busqueda_binaria(arch,n);
  If (pos = -1) Then
    WriteLn('No se encontro la infraccion solicitada.')
  Else
    Begin
      LEE_REGISTRO_I(arch,Pos,X);
      mostrar_datos_i(X);
      OpConfirmar(op);
      If (op = 1) Then
        Begin
          x.reclamo := true;
          guarda_registro_i(arch,pos,x);
        End;
    End;
End;



Procedure consulta_i (Var arch:t_arch_i);

Var 
  pos,n: SmallInt;
  X: T_DATO_I;
Begin
  clrscr;
  Write('Ingrese Numero de infraccion: ');
  ReadLn(n);
  pos := busqueda_binaria(arch,n);
  If (pos<> -1) Then
    Begin
      LEE_REGISTRO_I(arch,pos,X);
      mostrar_datos_i(X);
    End
  Else
    WriteLn('No se ha encontrado la infraccion')
End;


// Listas Conductor

Procedure MUESTRA_LISTA_APYNOM(L:T_LISTA_C);

Var 
  E: T_DATO_C;
Begin
  PRIMERO(L);
  While Not FIN(L) Do
    Begin
      RECUPERAR(L,E);
      Mostrar_Registro_C(E);
      SIGUIENTE(L);
    End;
  readkey;
End;

Procedure MUESTRA_LISTA_SCORING(L:T_LISTA_C);

Var 
  E: T_DATO_C;
Begin
  PRIMERO(L);
  While Not FIN(L) Do
    Begin
      RECUPERAR(L,E);
      If (E.scoring = 0) Then
        Mostrar_Registro_C(E);
      SIGUIENTE(L);
    End;
  readkey;
End;

//Listado Infracciones en periodo determinado



Procedure periodo(Var ARCH:t_arch_i);

Var 
  Fecha1,Fecha2: string;
  X: T_DATO_I;
  i: word;
  valido: boolean;
Begin
  If (FileSize(ARCH) <> 0) Then
    Begin
      WriteLn('Ingrese la primer fecha dentro del periodo: ');
      ValFecha(Fecha1);
      WriteLn('Ingrese la fecha final del periodo: ');
      ValFecha(Fecha2);
      i := 0;
      While Not Eof(ARCH) Do
        Begin
          LEE_REGISTRO_I(ARCH,i,X);
          valido := PeriodoVal(Fecha1,Fecha2,X.F_inf);
          If valido Then
            mostrar_datos_i(X);
          Inc(i);
        End;
    End
  Else
    Writeln('No hay infracciones cargadas');
  readkey;
End;

Procedure periodo2(Var ARCH:t_arch_i;Var ARCH2:t_arch_c; Arbol:T_PUNT_C);

Var 
  DNI,Fecha1,Fecha2: string;
  X: T_DATO_I;
  i: word;
  pos: SmallInt;
  valido: boolean;
Begin
  If (FileSize(ARCH) <> 0) Then
    Begin
      DNI_validado(DNI);
      pos := buscar_arbol(Arbol,DNI);
      If (pos <> -1) Then
        Begin
          WriteLn('Ingrese la primer fecha dentro del periodo: ');
          ValFecha(Fecha1);
          WriteLn('Ingrese la fecha final del periodo: ');
          ValFecha(Fecha2);
          i := 0;
          While Not Eof(ARCH) Do
            Begin
              LEE_REGISTRO_I(ARCH,i,X);
              valido := PeriodoVal(Fecha1,Fecha2,X.F_inf);
              If valido And (x.DNI = DNI) Then
                mostrar_datos_i(X);
              Inc(i);
            End;
        End
      Else
        WriteLn('No se ha encontrado registro de un conductor con el DNI ',DNI)
    End
  Else
    WriteLn('No hay infracciones cargadas.');
  readkey;
End;


End.
