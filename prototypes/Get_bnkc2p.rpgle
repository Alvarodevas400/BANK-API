        //*********************************************
        // Prototipo para obtener registro del bnkcli 
        // usando la identificacion                   *
        //*********************************************

        //Prototipo
        dcl-pr GET_BNKCL2   int(10);
               In_tid       char(1);
               In_id        char(30);
               Ou_Bnkcli    likeds(DS_Bnkcli);
               Ou_Message   char(200); 
        end-pr;