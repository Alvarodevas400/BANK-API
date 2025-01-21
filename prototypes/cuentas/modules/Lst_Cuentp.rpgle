
         //************************************************** 
         // Prototipo para obtener un listado de cuentas    *
         //**************************************************

         dcl-pr Lst_Cuenta         int(10);
                In_code            zoned(9);
                Ou_lstCuentas      likeds(DS_OutLstAccount);
         end-pr;
         