**FREE
Ctl-Opt nomain;
ctl-opt debug(*yes);
Ctl-Opt bnddir('DSRVCTA200');

//************************************************************
//  Servicio para crear una cuenta                           *  
//************************************************************

//Copys
//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkclp'
/Copy 'prototypes/Get_bnkpap'
/Copy 'prototypes/Get_bnkmsp'

//Modulos
/Copy 'prototypes/cuentas/modules/crt_cuentp'

//Programa de Servicio
/Copy 'prototypes/cuentas/services/SRVCTA20P'

Dcl-Proc Sav_Cuenta         export;
  Dcl-Pi Sav_Cuenta         int(10);
          In_infCta         likeds(Ds_InpSavAccount); 
          Ou_Cuenta         zoned(11); 
          Ou_Message        char(200);
  End-Pi;

  //Variables internas
  dcl-s error int(10);

  //*********************************************************  
  //Main                                                    *
  //*********************************************************
  
  clear Ou_Message;
  clear Ou_Cuenta;

  error = Val_Entrada(In_infCta);
  if error = 0;
     error = Crt_Cuenta(In_InfCta:Ou_Cuenta);
  endif;
  GET_BNKMSG(error:Ou_Message);
  return error;  

 //*********************************************************  
 //Rutina de Error                                         *
 //********************************************************* 
  begsr *PSSR;
     DUMP 'SRVCTA300';
  endsr;
End-Proc;

//*********************************************************  
//Validacion de campos de entrada                         *
//********************************************************* 
dcl-proc Val_Entrada;
    dcl-pi Val_Entrada  int(10);
        In_infCta         likeds(Ds_InpSavAccount);
    end-pi;

    //Variables Interna
    dcl-s error int(10);
    dcl-s Ou_Message char(200);
    dcl-s In_table char(2);
    dcl-s In_codeparm char(4);

    //Estructuras Internas
    dcl-ds Ou_Bnkcli likeds(DS_Bnkcli);
    dcl-ds Ou_bnkparm likeds(DS_Bnkparm);

//*********************************************************  
//Inicio de procedimiento                                  *
//********************************************************* 

   error = GET_BNKCLI(In_infCta.code:Ou_Bnkcli:Ou_Message);

   if error = 0;
      In_table = 'TA';
      In_codeparm = In_infCta.tipo;
      error = GET_BNKPAR(In_table:In_codeparm:Ou_bnkparm:Ou_Message);
      if error <> 0;
         error = 24;
      endif;  
   endif; 

   if error = 0 and In_infCta.moneda <> 'COP';
      error = 23;
   endif;

    if error = 0;
      In_table = 'AG';
      In_codeparm = In_infCta.agencia;
      error = GET_BNKPAR(In_table:In_codeparm:Ou_bnkparm:Ou_Message);
      if error <> 0;
         error = 25;
      endif;  
   endif; 

   if error = 0;
      In_table = 'OF';
      In_codeparm = In_infCta.oficial;
      error = GET_BNKPAR(In_table:In_codeparm:Ou_bnkparm:Ou_Message);
      if error <> 0;
         error = 26;
      endif;  
   endif;

   return error;  
end-proc;


