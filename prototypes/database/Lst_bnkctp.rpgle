
        //********************************************************* 
        // Prototipo para obtener una lista de cuentas por cliente*
        //*********************************************************

        //Prototipo
        dcl-pr LST_BNKCTA      int(10);
               In_code         zoned(9);
               Ou_lstBnkcta    likeds(DS_Bnkcta) dim(10);
               Ou_Message      char(200); 
        end-pr;