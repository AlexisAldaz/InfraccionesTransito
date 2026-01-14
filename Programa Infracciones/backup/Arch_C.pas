
Unit Arch_C;

Interface

//NO LLAMAR OTRAS UNIT
//[8]
//[40]//;
//[10];
//[13];
//[50];
//[10];

Const 
  ruta_cond = 'c:\Prueba_File\conductor.dat';

Type 
  T_DATO_C = Record
    DNI: string;

    ApyNom: String;

    F_nac: string;

    Tel: string;

    e_mail: string;

    scoring: 0..20;
    Habilitado: boolean;
    BajaLog: Boolean;
    F_hab: string;

    Reincidencia: byte;
  End;

  t_arch_c = file Of T_DATO_C;

Procedure cerrar_archivo_c (Var arch: t_arch_c);
Procedure crear_archivo_c (Var arch: t_arch_c);


Implementation


Procedure crear_archivo_c (Var arch: t_arch_c);
Begin
  assign(arch,ruta_cond);
    {$I-}
  reset(arch);
    {$I+}
  If IOResult<>0 Then
    rewrite(arch);
End;

Procedure cerrar_archivo_c (Var arch: t_arch_c);
Begin
  close(arch);
End;




End.
