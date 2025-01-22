        //*************************************************************
        // Prototipo de Modulo para crear una cuenta                  *
        //*************************************************************


        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************
        dcl-pr Crt_Cuenta       int(10);
            In_InfCta           likeds(DS_InpSavAccount);  
            Ou_Cuenta           zoned(11);
        end-pr;
        
