
            //***************************************************************
            // Prototipo de Servicio para actualizar un cliente             *
            //***************************************************************

            //Estructura de Entrada
            dcl-ds DS_InpActCli qualified;
               primer_nombre    char(100);
               segundo_nombre   char(100);
               primer_apellido  char(100);
               segundo_apellido char(100);
               email            char(50); 
               telefono         char(10);
               fecha_nacimiento zoned(8); 
               estado_civil     char(100); 
               ocupacion        char(100);    
               ingresos_men     zoned(15:2);
               ingresos_fue      char(30);
            end-ds;

            //*******************************************************
            // Definicion de Prototipo                              *
            //*******************************************************

            dcl-pr Act_Client    int(10);
                In_code          zoned(9);
                In_DatCli        likeds(DS_InpActCli);
                Ou_Message       char(200);
            end-pr;
                