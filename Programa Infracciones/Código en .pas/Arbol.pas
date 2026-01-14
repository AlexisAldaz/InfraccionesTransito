
Unit Arbol;

Interface

Type 
  T_PUNT_C = ^T_NODO_C;

  T_NODO_C = Record
    INFO: string[100];
    SAI: T_PUNT_C;
    SAD: T_PUNT_C;
    Pos: Integer;
  End;

Procedure Insertar_Arbol(Var arbol: t_punt_c; Clave:String;Pos_arch:Integer);
Function buscar_arbol(arbol: t_punt_c; Clave: String): Integer;
Procedure Crear_Arbol (Var arbol:t_punt_c);


Implementation

Procedure Crear_Arbol (Var arbol:t_punt_c);
Begin
  arbol := Nil;
End;

Procedure Insertar_Arbol(Var arbol: t_punt_c; Clave:String;Pos_arch:Integer);
Begin
  If arbol = Nil Then
    Begin
      new(arbol);
      arbol^.INFO := Clave;
      arbol^.SAI := Nil;
      arbol^.SAD := Nil;
      arbol^.Pos := Pos_arch;
    End
  Else
    If arbol^.info > Clave  Then
      Insertar_Arbol(arbol^.SAI, Clave,Pos_arch)
  Else
    Insertar_Arbol(arbol^.SAD, Clave,Pos_arch)
End;



Function buscar_arbol(arbol: t_punt_c; Clave: String): Integer;

Begin
  If (arbol=Nil) Then
    buscar_arbol := (-1)
  Else
    If (arbol^.info = Clave) Then
      buscar_arbol := arbol^.Pos
  Else
    If (arbol^.info > Clave) Then
      buscar_arbol := buscar_arbol(arbol^.SAI, Clave)
  Else
    buscar_arbol := buscar_arbol(arbol^.SAD, Clave);
End;


End.
