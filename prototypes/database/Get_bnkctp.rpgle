
        //*********************************************
        // Prototipo para obtener un registro del bnkcta *
        //*********************************************

        dcl-ds DS_Bnkcta ExtName('BNKCTA') qualified end-ds;

        //Prototipo
        dcl-pr GET_BNKCTA   int(10);
               In_account   zoned(11);
               Ou_Bnkcta    likeds(DS_Bnkcta);
               Ou_Message   char(200); 
        end-pr;