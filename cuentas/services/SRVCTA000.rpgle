**FREE
Ctl-Opt nomain;
Ctl-Opt debug(*yes);
Ctl-Opt bnddir('DSRVCTA000');

//************************************************************
//  Servicio para obtener informacion de una cuenta          *  
//************************************************************

//Copys
//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkmsp'

//Modulo
/Copy 'prototypes/cuentas/modules/Get_AccInp'

//Programa de Servicio
/Copy 'prototypes/cuentas/services/SRVCTA00P'


Dcl-Proc Get_InfAcc     export;
  Dcl-Pi Get_InfAcc     int(10);
        In_Account      zoned(11);
        Ou_datCta       likeds(DS_OutGetAccount);
        Ou_Message      char(200);
  End-Pi;

  //Variables Internas
  dcl-s error           int(10);

  //*********************************************************  
  //Main                                                    *
  //*********************************************************

  clear Ou_datCta;
  clear Ou_Message;

  if In_Account <> 0;
     error = GET_ACCINF(In_Account:Ou_datCta);   
  else;
    error = 22;  
  endif;  

  GET_BNKMSG(error:Ou_Message);  
  return error;

//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'SRVCTA000';
endsr;
End-Proc;
