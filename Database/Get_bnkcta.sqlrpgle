**FREE
Ctl-Opt nomain;

//*******************************************
// Modulo para obtener un registro del BNKCTA
//*******************************************

/Copy 'prototypes/Get_bnkctp'

Dcl-Proc GET_BNKCTA export;
  Dcl-Pi GET_BNKCTA int(10);
       In_account   zoned(11);
       Ou_Bnkcta    likeds(DS_Bnkcta);
       Ou_Message   char(200); 
  End-Pi;

  //Variables Internas 
  dcl-s error int(10);   

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_Bnkcta;
clear Ou_Message;

Exec Sql 
   Select * Into :Ou_Bnkcta from bnkcta
            where BKACUE = :In_account;

if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Get_Bnkcta Obtuvo el error SQL: ' +
                %char(sqlcode); 
   error = 999999;             
else;
   if sqlcode = 100;
      error = 20; 
   endif; 
endif;

return error;  
End-Proc;

