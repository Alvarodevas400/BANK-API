        //*************************************************************
        // Prototipo de Servicio para registrar transacciones
        //*************************************************************

        //Enum

        dcl-enum ACCION_TRANSACCION qualified;
          CREAR     'C';
          REVERSO   'R';
        end-enum;

        dcl-enum TIPO_TRANSACCION qualified;
          DEBITO        'DB';
          CREDITO       'CR';
        end-enum;

        //Estructura de Entrada
        dcl-ds DS_InpRegTrn qualified;
            referencia      char(20); //Referencia Unica
            lst_transa      likeds(Ds_RegTrn) dim(6);
            typTransac      char(1); // C=Crear R = Reversar
        end-ds;

        //Estructura de Salida
        dcl-ds DS_OutRegTrn qualified;
             lst_response likeds(DS_ResRegTrn) dim(10);
        end-ds;

        //Estrcutura de transaccion
        dcl-ds Ds_RegTrn qualified;
               secuencia    zoned(1);
               tipo         char(2); //DB = Debito y CR = Credito 
               cuenta       zoned(11);
               codTransacc  char(4); 
               dscTransacc  char(100);
               amoTransacc  zoned(15:2); 
               ccyTransacc  char(3);
        end-ds;

        //Estructura de Respuesta de Transaccion
        dcl-ds DS_ResRegTrn qualified;
               secuencia    zoned(1); 
               errorCod     int(10);
               errordsc     char(100); 
        end-ds;

        //******************************************************
        //Definicion de Prototipo                              *
        //******************************************************
        dcl-pr PROC_TRAN    int(10);
            In_TraInf       likeds(DS_InpRegTrn);    
            Ou_Response     likeds(DS_OutRegTrn);
            Ou_Message      char(200);
        end-pr;
        


