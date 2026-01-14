
Unit Interfaz;

Interface

Uses crt, Archivos,Arch_C,Arch_I, Validaciones,Arbol,Lista_c,vector;


Procedure Menu();

Implementation

Procedure OpConductor(Var seleccionado:byte;Var ARCH:t_arch_c; i:SmallInt);

Var 
  salir: boolean;
  tecla: char;
Begin
  clrscr;
  salir := false;
  seleccionado := 1;
  While Not salir Do
    Begin
      textbackground(black);
      clrscr;
      Consulta_C(ARCH,i);
      WriteLn(' ');
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
      writeln('Modificar datos del Conductor');
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
      writeln('Volver');
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
End;

Procedure IngresarDNI(Var seleccionado:byte);

Var 
  salir: boolean;
  tecla: char;
Begin
  clrscr;
  salir := false;
  seleccionado := 1;
  While Not salir Do
    Begin
      textbackground(black);
      clrscr;
      WriteLn(' ');
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
      writeln('Ingresar DNI');
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
      writeln('Volver');
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
End;

Procedure MenuConductor(Var ARCH:t_arch_c; Var arbol:t_punt_c; Var L:T_LISTA_C);

Var 
  op: byte;
  DNI: string[8];
  i: SmallInt;
Begin
  IngresarDNI(op);
  If (op=1) Then
    Repeat
      DNI_validado(DNI);
      i := buscar_arbol(arbol,DNI);
      If (i = -1) Then
        ALTA_C(ARCH,arbol,L,DNI)
      Else
        Begin
          OpConductor(op,ARCH,i);
          If (op = 1) Then
            Modificar_C(ARCH, i);
        End;
      readkey;
    Until (op = 2);
End;


Procedure OpInfracciones(Var seleccionado:byte);

Var 
  salir: boolean;
  tecla: char;
Begin
  clrscr;
  salir := false;
  seleccionado := 1;
  While Not salir Do
    Begin
      textbackground(black);
      clrscr;
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
      writeln('Alta de infraccion');
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
      writeln('Consulta de Infracción');
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
      writeln('Reclamo de infracción');

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
      writeln('Salir');
      tecla := readkey;

      If tecla=#00 Then
        Begin
          tecla := readkey;
        End;

      Case tecla Of 
        #72: If seleccionado > 1 Then seleccionado := seleccionado-1;
        #80: If seleccionado < 4 Then seleccionado := seleccionado+1;
        #13: salir := true;
      End;
    End;
End;

Procedure MenuInfracciones(Var ARCH:t_arch_i;Var arch2:t_arch_c; arbol:t_punt_c;
                           vector:t_vector;L:T_LISTA_C)
;

Var 
  op: byte;
Begin
  Repeat
    clrscr;
    OpInfracciones(op);
    Case op Of 
      1: ALTA_I (ARCH,arch2,arbol,vector,L);
      2: Consulta_I(ARCH);
      3: MOD_inf(ARCH);
    End;
    readkey;
  Until (op = 4);
End;


Procedure OpListas(Var seleccionado:byte);

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
      writeln('Lista de Conductores por Apellido y Nombre');
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
      writeln('Listado de los infractores a los cuales su scoring llegó a 0');
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
      writeln('Todas las infracciones en un periodo');
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
      writeln('Todas las infracciones de un cond en un período');
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

Procedure MenuListado(Var Arch1:t_arch_c;Var Arch2:t_arch_i;Var arbol:T_PUNT_C;
                      L:T_LISTA_C);

Var 
  op: byte;
Begin
  Repeat
    clrscr;
    OpListas(op);
    Case op Of 
      1: MUESTRA_LISTA_APYNOM(L);
      2: MUESTRA_LISTA_SCORING(L);
      3: periodo(Arch2);
      4: periodo2(Arch2,Arch1,arbol);
    End;
  Until (op=5);
End;



Procedure OpMenu(Var seleccionado:byte);

Var 
  salir: boolean;
  tecla: char;
Begin
  clrscr;
  salir := false;
  seleccionado := 1;
  While Not salir Do
    Begin
      textbackground(black);
      clrscr;
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
      writeln('Conductores');
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
      writeln('Infracciones');

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
      writeln('Listados');

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
      writeln('Salir');

      tecla := readkey;

      If tecla=#00 Then
        Begin
          tecla := readkey;
        End;

      Case tecla Of 
        #72: If seleccionado > 1 Then seleccionado := seleccionado-1;
        #80: If seleccionado < 4 Then seleccionado := seleccionado+1;
        #13: salir := true;
      End;
    End;
End;

Procedure Menu();

Var 
  Arch1: t_arch_c;
  Arch2: t_arch_i;
  Arbol: T_PUNT_C;
  op: byte;
  vector: t_vector;
  L: T_LISTA_C;
Begin
  crear_archivos(Arch1, Arch2);
  Iniciar_Arbol(Arbol, Arch1);
  Iniciar_Lista(L,Arch1);
  crear_vector(vector);
  Repeat
    clrscr;
    OpMenu(op);
    Case op Of 
      1: MenuConductor(Arch1,Arbol,L);
      2: MenuInfracciones(Arch2, Arch1, Arbol,vector,L);
      3: MenuListado(Arch1,Arch2,Arbol,L);
    End;
    readkey;
  Until (op = 4);
  cerrar_archivos(Arch1, Arch2);
End;

End.
