        //*************************************************************
        // Prototipo de Servicio para obtener las transacciones de una*  
        // cuenta                                                     *
        //*************************************************************

        //Estructura de Entrada
        dcl-ds DS_InpLstTrn qualified;
            cuenta      zoned(11);
            fechaDesde  zoned(8);       
            fechaHasta  zoned(8);
            page        zoned(2);
        end-ds;

        //Estructura de Salida
        dcl-ds DS_OutLstTrn qualified;
          lst_trn       likeds(DS_TrnMove) dim(20);
        end-ds;

        //Estructura de Movimiento de transaccion
        dcl-ds DS_TrnMove qualified;
            fechaTransac    zoned(8); //AAAAMMDD
            horaTransac     zoned(6);
            valorTransac    zoned(15:2);
            descrTransac    char(100);
            SignoTransac    char(1);   
        end-ds;

        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************

        dcl-pr Lst_Trans    int(10);
            In_DevCta       likeds(DS_InpLstTrn);
            Ou_MovCta       likeds(DS_OutLstTrn);
            Ou_Message      char(200);                 
        end-pr;
        

