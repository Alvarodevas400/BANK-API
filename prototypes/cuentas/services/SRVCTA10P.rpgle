
        //*************************************************************
        // Prototipo de Servicio para obtener un listado de cuentas de 
        // un cliente
        //*************************************************************

        //Estructura de la Cuenta
        dcl-ds Ds_Cuenta    qualified;
               cuenta       zoned(11);
               tipo         char(100);
               moneda       char(3);
               disponible   zoned(15:2);
               estado       char(1);
        end-ds;

        //Estructura de salida
        dcl-ds Ds_OutLstAccount qualified;
            lst_cuentas likeds(Ds_Cuenta) dim(10);
        end-ds;

        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************

        dcl-pr Lst_AllAcc   int(10);
               In_code      zoned(9);
               Ou_datCta    likeds(Ds_OutLstAccount);
               Ou_Message   char(200); 
        end-pr;
        
