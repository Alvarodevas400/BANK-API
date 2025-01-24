        //******************************************************
        // Prototipo de Servicio para reversar transacciones *  
        //******************************************************

        

        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************

        dcl-pr REV_TRAN     int(10);
            In_TraInf       likeds(DS_InpRegTrn);
        end-pr;
        