
Unit Arch_I;

Interface
//[8];
//[10];

Const 

  ruta_infra = 'c:\Prueba_File\infracciones.dat';

Type 


  T_DATO_I = Record
    DNI: string;

    F_inf: string;

    Tipo: 1..15;
    P_desc: 1..20;
    reclamo: boolean;
    N_inf: SmallInt;
  End;


  t_arch_i = file Of T_DATO_I;

Procedure crear_archivo_i (Var arch: t_arch_i);
Procedure cerrar_archivo_i (Var arch: t_arch_i);


Implementation

Procedure crear_archivo_i (Var arch: t_arch_i);
Begin
  assign(arch,ruta_infra);
    {$I-}
  reset(arch);
    {$I+}
  If IOResult<>0 Then
    rewrite(arch);
End;

Procedure cerrar_archivo_i (Var arch: t_arch_i);
Begin
  close(arch);
End;



End.
