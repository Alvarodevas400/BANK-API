
         //******************************************************* 
         // Prototipo Obtener una lista de registros del BKNPARM*
         //******************************************************
         
         dcl-pr LST_BNKPAR  int(10); 
                In_table        char(2);    
                In_code         char(4);
                Ou_lstBnkparm   likeds(DS_Bnkparm) dim(30);
                Ou_Message      char(200);
         end-pr;
