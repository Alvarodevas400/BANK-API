        //*************************************************
        // Prototipo de Servicio para crear una cuenta  
        //*************************************************

        //Estructura Entrada
        dcl-ds Ds_InpSavAccount     qualified;
               code                 zoned(9);
               tipo                 char(4);
               moneda               char(3);
               agencia              char(4);
               oficial              char(4);
        end-ds;
        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************

        dcl-pr Sav_Cuenta int(10);
               In_infCta    likeds(Ds_InpSavAccount); 
               Ou_Cuenta    zoned(11); 
               Ou_Message   char(200); 
        end-pr;
        