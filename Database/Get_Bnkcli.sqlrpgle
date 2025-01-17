**FREE
Ctl-Opt nomain;

//*******************************************
// Modulo para obtener un registro del BNKCLI
//*******************************************

/Copy 'prototypes/Get_bnkclp.rpgle'

Dcl-Proc GET_BNKCLI export;
  Dcl-Pi GET_BNKCLI int(10);
       In_code      zoned(9);
       Ou_Bnkcli    likeds(DS_Bnkcli);
       Ou_Message   char(200); 
  End-Pi;

  //Variables Internas 
  dcl-s error int(10);   

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_Bnkcli;
clear Ou_Message;

Exec Sql 
   Select * Into :Ou_Bnkcli from bnkcli
            where BKCCOD = :In_code;

if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Get_Bnkcli Obtuvo el error SQL: ' +
                %char(sqlcode); 
   error = 999999;             
else;
   if sqlcode = 100;
      error = 1; 
   endif; 
endif;

return error;  
End-Proc;

