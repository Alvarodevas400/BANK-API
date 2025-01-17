**FREE
Ctl-Opt nomain;

//*******************************************
// Modulo para obtener un registro del BNKMSG
//*******************************************

/Copy 'prototypes/get_bnkmsp.rpgle'

Dcl-Proc GET_BNKMSG export;
  Dcl-Pi GET_BNKMSG;
         In_Code     int(10);
         Ou_Message  char(200);
  End-Pi;

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_Message;

Exec Sql 
   Select BKMDSC into :Ou_Message from bnkmsg 
            where BKMCOD = : In_Code; 
                  
if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Get_Bnkmsg Obtuvo el error SQL: ' +
                %char(sqlcode);           
else;
   if sqlcode = 100;
      Ou_Message = 'CODIGO DE MENSAJE NO PARAMETRIZADO';  
   endif; 
endif;
End-Proc;
