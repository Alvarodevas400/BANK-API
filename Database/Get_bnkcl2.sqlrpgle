**FREE
Ctl-Opt nomain;

  //*********************************************
  // Modulo para obtener registro del bnkcli    *
  // usando la identificacion                   *
  //*********************************************

/Copy 'prototypes/Get_bnkclp.rpgle'
/Copy 'prototypes/Get_bnkc2p.rpgle'

Dcl-Proc GET_BNKCL2     export;
  Dcl-Pi GET_BNKCL2     int(10);
        In_tid          char(1);
        In_id           char(30);
        Ou_Bnkcli       likeds(DS_Bnkcli);
        Ou_Message      char(200); 
  End-Pi;

  //Variables internas
  dcl-s error int(10);  

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_Message;
clear Ou_Bnkcli; 

Exec Sql 
   Select * Into :Ou_Bnkcli from bnkcli
            where BKCTID = :In_tid and 
                  BKCIDN = :In_id;

if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Get_Bnkcl2 Obtuvo el error SQL: ' +
                %char(sqlcode); 
   error = 999999;             
else;
   if sqlcode = 100;
      error = 2; 
   endif; 
endif;

return error;
End-Proc;
