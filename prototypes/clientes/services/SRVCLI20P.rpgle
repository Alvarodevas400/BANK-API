            //***************************************************************
            // Prototipo de Servicio para crear cliente                     *
            //***************************************************************

            //Estructura de Entrada
            dcl-ds DS_InpRegCli qualified;
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
               ingresos_men     zoned(15:2);
               ingresos_fue      char(30);
               lst_camposAdi    likeds(DS_AdFields) dim(20);   
            end-ds;

            //Estructura de campos adicionales
            dcl-ds DS_AdFields qualified;
                Key     char(4);
                value   char(200);
            end-ds; 

            //*******************************************************
            // Definicion de Prototipo                              *
            //*******************************************************

            dcl-pr Reg_Client    int(10);
                In_DatCli               likeds(DS_InpRegCli);
                Ou_code                 zoned(9);
                Ou_Message              char(200);
            end-pr;
                