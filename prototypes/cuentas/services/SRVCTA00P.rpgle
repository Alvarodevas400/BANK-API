

        //*************************************************************
        // Prototipo de Servicio para obtener el detalle de una cuenta*
        //*************************************************************

        //Estrutura de Salida
        dcl-ds DS_OutGetAccount qualified;
               codigo_cliente   zoned(9);
               tipo             char(100); 
               moneda           char(3);
               disponible       zoned(15:2); 
               estado           char(1); 
               agencia          char(100);
               oficial          char(100);
               fecha_apertura   zoned(8); //AAAAMMDD
               fecha_cierre     zoned(8);
               fecha_ult_mov    zoned(8); 
        end-ds;

        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************

        dcl-pr Get_InfAcc   int(10);
            In_Account      zoned(11);
            Ou_datCta       likeds(DS_OutGetAccount);
            Ou_Message      char(200);
        end-pr;
        