         //************************************************** 
         // Prototipo Obtener registro del BKNPARM          *
         //**************************************************

         dcl-ds DS_Bnkparm ExtName('BNKPARM') qualified end-ds;
         
         dcl-pr Get_bnkPar  int(10); 
                In_table    char(2);    
                In_code     char(4);
                Ou_bnkparm  likeds(DS_Bnkparm);
                Ou_Message  char(200);
         end-pr;

         
            

         
