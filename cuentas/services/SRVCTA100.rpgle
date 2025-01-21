**FREE
Ctl-Opt nomain;
Ctl-Opt debug(*yes);
Ctl-Opt bnddir('DSRVCTA100');

//************************************************************
//  Servicio para obtener las cuentas de un cliente          *  
//************************************************************

//Copys
//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkmsp'

//Modulo
/Copy 'prototypes/cuentas/modules/Lst_cuentp'

//Programa de Servicio
/Copy 'prototypes/cuentas/services/SRVCTA10P'


Dcl-Proc Lst_AllAcc     export;
  Dcl-Pi Lst_AllAcc     int(10);
        In_Code         zoned(9);
        Ou_datCta       likeds(DS_OutLstAccount);
        Ou_Message      char(200);
  End-Pi;

  //Variables Internas
  dcl-s error           int(10);

  //*********************************************************  
  //Main                                                    *
  //*********************************************************

  clear Ou_datCta;
  clear Ou_Message;

  if In_Code <> 0;
     error = LST_CUENTA(In_code:Ou_datCta); 
  else;
    error = 5;  
  endif;  

  GET_BNKMSG(error:Ou_Message);  
  return error;

//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'SRVCTA100';
endsr;
End-Proc;
