
Unit vector;

Interface

{$CODEPAGE UTF-8}

Type 
  t_dato_vector = Record
    num: 1..20;
    nombre: string;
  End;
  t_vector = ARRAY [1..15] Of t_dato_vector;

Procedure crear_vector (Var vector:t_vector);

Implementation

Procedure crear_vector (Var vector:t_vector);
Begin
  vector[1].nombre := (





                  'Por falta de pago del peaje o contraprestacion por transito.'
                      );
  vector[2].nombre := (





 'Por obstruir el paso legitimo de peatones u otros vehiculos en una bocacalle.'
                      );
  vector[3].nombre := (





'Por no facilitar, los camiones y maquinarias especiales, el adelantamiento en caminos angostos, corriendose a la banquina periodicamente.'
                      );
  vector[4].nombre := (





'Por haber iniciado el cruce, aun con luz verde, sin tener espacio suficiente del otro lado de la encrucijada.'
                      );
  vector[5].nombre := (





'Por detenerse irregularmente sobre la calzada o banquina, excepto emergencias y los casos debidamente reglamentados.'
                      );
  vector[6].nombre := (





'Por circular sin portar, excepto las motocicletas, un matafuegos y balizas portatiles de acuerdo a la reglamentacion.'
                      );
  vector[7].nombre := (





 'Por utilizar franquicia de transito no reglamentaria, o usarla indebidamente.'
                      );
  vector[8].nombre := (





          'Por no usar los ocupantes los correajes de seguridad reglamentarios.'
                      );
  vector[9].nombre := (





               'Por no respetar las indicaciones de las luces de los semaforos.'
                      );
  vector[10].nombre := ('Por no respetar las reglas especiales para rotondas.');
  vector[11].nombre := (





'Por no retroceder el conductor del vehiculo que desciende en las cuestas estrechas, salvo que este lleve acoplado y el que asciende no.'
                       );
  vector[12].nombre := (





'Por no cumplir con las obligaciones legales para participes de un accidente de transito.'
                       );
  vector[13].nombre := (





'Por conducir bajo los efectos de estupefacientes o medicamentos que alteren los parametros normales para la conduccion segura.'
                       );
  vector[14].nombre := (





'Por participar u organizar, en la via publica, competencias no autorizadas de destreza o velocidad con automotores.'
                       );
  vector[15].nombre := (





           'Por conducir estando inhabilitado o con la habilitacion suspendida.'
                       );
  vector[1].num := 1;
  vector[2].num := 2;
  vector[3].num := 2;
  vector[4].num := 2;
  vector[5].num := 2;
  vector[6].num := 2;
  vector[7].num := 4;
  vector[8].num := 4;
  vector[9].num := 4;
  vector[10].num := 5;
  vector[11].num := 5;
  vector[12].num := 10;
  vector[13].num := 10;
  vector[14].num := 20;
  vector[15].num := 20;
End;
End.
