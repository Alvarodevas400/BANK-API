            //***************************************************************
            // Prototipo de Servicio para Obtener cliente por Identificacion*
            //***************************************************************

            //Estructura de Salida
            dcl-ds DS_OutGetCliId qualified;
               codigo_cliente   zoned(9); 
               primer_nombre    char(100);
               segundo_nombre   char(100);
               primer_apellido  char(100);
               segundo_apellido char(100);
               tipo_id          char(1);
               identificacion   char(30);
               email            char(50); 
               telefono         char(10);
               fecha_nacimiento zoned(8); 
               estado_civil     char(100); 
               ocupacion        char(100); 
               estado           char(30);
               ingresos_men     zoned(15:2);
               ingresos_fue      char(30);
               creado_en        char(26); 
            end-ds;

            //*******************************************************
            // Definicion de Prototipo                              *
            //*******************************************************

            dcl-pr Get_CliById    int(10);
                In_TypeId               char(1);
                In_idNumber             char(30);
                Ou_datCli               likeds(DS_OutGetCliId);
                Ou_Message              char(200);
            end-pr;
                