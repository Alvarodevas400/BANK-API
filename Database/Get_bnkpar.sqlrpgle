**FREE
Ctl-Opt nomain;

//*******************************************
// Modulo para obtener un registro del BNKPARM
//*******************************************

/copy 'prototypes/get_bnkpap.rpgle'

Dcl-Proc GET_BNKPAR export;
  Dcl-Pi GET_BNKPAR int(10);
          In_table    char(2);    
          In_code     char(4);
          Ou_bnkparm  likeds(DS_Bnkparm);
          Ou_Message  char(200);
  End-Pi;

  //Variables Internas 
  dcl-s error int(10);   

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_bnkparm;
clear Ou_Message;

Exec Sql 
   Select * into :Ou_bnkparm from bnkparm 
            where BKPTAB = :In_table and 
                  BKPCOD = :In_code;

if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Get_Bnkparm Obtuvo el error SQL: ' +
                %char(sqlcode); 
   error = 999999;             
else;
   if sqlcode = 100;
      error = 4; 
   endif; 
endif;

return error;  
End-Proc;
