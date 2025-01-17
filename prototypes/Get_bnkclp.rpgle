        //*********************************************
        // Prototipo para obtener registro del bnkcli *
        //*********************************************

        dcl-ds DS_Bnkcli ExtName('BNKCLI') qualified end-ds;

        //Prototipo
        dcl-pr GET_BNKCLI   int(10);
               In_code      zoned(9);
               Ou_Bnkcli    likeds(DS_Bnkcli);
               Ou_Message   char(200); 
        end-pr;
        
