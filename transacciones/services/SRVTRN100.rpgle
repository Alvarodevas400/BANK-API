**FREE

Ctl-Opt nomain;
ctl-opt bnddir('DSRVTRN100');

//************************************************************
//  Servicio para registrar transacciones                    *  
//************************************************************
dcl-f BNKTRNL0 usage(*input) usropn keyed;

//Copys
//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkmsp'
/Copy 'prototypes/Get_bnkctp'

//Modulos
/Copy 'prototypes/transaccion/modules/SAV_TRANSP'
/Copy 'prototypes/transaccion/modules/REV_TRANSP'

//Programa de Servicio
/Copy 'prototypes/transaccion/services/SRVTRN10P'

//Variable Global
dcl-s niError zoned(2);

Dcl-Proc PROC_TRAN  export; 
  Dcl-Pi PROC_TRAN  int(10);
          In_TraInf             likeds(DS_InpRegTrn); 
          Ou_Response           likeds(DS_OutRegTrn); 
          Ou_Message            char(200);
  End-Pi;  

  //Variables Internas
  dcl-s error           int(10);

  //*********************************************************  
  //Main                                                    *
  //*********************************************************

  clear Ou_Message;
  clear Ou_Response;
  niError = 1;

  error = Val_Entrada(In_TraInf : Ou_Response);
  
  if error = 0;
     select In_TraInf.typTransac;
       when-is ACCION_TRANSACCION.CREAR;
            error = SAV_TRAN(In_TraInf); 
       when-is ACCION_TRANSACCION.REVERSO;
            error = REV_TRAN(In_TraInf);
     endsl;
  endif;

GET_BNKMSG(error:Ou_Message);
return error;  
End-Proc;

//*********************************************************  
// Validacion de Campos de Entrada                        *
//*********************************************************
dcl-proc Val_Entrada;
    dcl-pi Val_Entrada   int(10);
           In_TraInf     likeds(DS_InpRegTrn);
           Ou_Response   likeds(DS_OutRegTrn); 
    end-pi;
   
   //Variables Internas
   dcl-s error      int(10);
   dcl-s ni         zoned(2);
   dcl-s Ou_Message char(200);
   
   //Estructuras Internas
   dcl-ds Ou_bnkcta         likeds(DS_bnkcta);
   dcl-ds clatrn            likerec(RBNKTRN : *key);
   dcl-ds reg_transaccion   likeds(Ds_RegTrn);
     
//*********************************************************  
// Inicio procedimiento                                   *
//*********************************************************

 //Validar Referencia
 if In_TraInf.referencia = *blanks;
    error = 30;
 endif;

//Validar tipo de transaccion
if error = 0;
   if In_TraInf.typTransac <> ACCION_TRANSACCION.CREAR and
      In_TraInf.typTransac <> ACCION_TRANSACCION.REVERSO;
      error = 32; 
    endif;  
endif;

//Validar si transaccion fue reversada
if error = 0 and In_TraInf.typTransac = ACCION_TRANSACCION.REVERSO;
   clatrn.BKTREF = In_TraInf.referencia;
   clatrn.BKTREV = ACCION_TRANSACCION.REVERSO;
   if not %open(BNKTRNL0);
       open BNKTRNL0; 
   endif; 

   chain %kds(clatrn) BNKTRNL0;
   close BNKTRNL0;
   
   if %found();
      error = 40;
   endif;
endif;


// Validar lista de transacciones 
if error = 0 and 
   In_TraInf.typTransac <> ACCION_TRANSACCION.REVERSO;

   for-each reg_transaccion in In_TraInf.lst_transa;
    if reg_transaccion.codTransacc <> *blanks;
       
       //Validar al cuenta
       error = GET_BNKCTA(reg_transaccion.cuenta:
                          Ou_Bnkcta:Ou_Message);
       if error = 0;
          if Ou_bnkcta.BKASTS <> 'A';
             error = 39;
             Sav_Error(reg_transaccion.secuencia:error:Ou_Response);
            leave;
          endif;
       endif;

       //Validar tipo de transaccion
       if reg_transaccion.tipo <> TIPO_TRANSACCION.CREDITO and
          reg_transaccion.tipo <> TIPO_TRANSACCION.DEBITO;
          error = 31;
          Sav_Error(reg_transaccion.secuencia: error:Ou_Response);
          leave;
       endif;

       //Validar descripcion de la transaccion 
       if reg_transaccion.dscTransacc = *blanks;
          error = 33;
          Sav_Error(reg_transaccion.secuencia: error:Ou_Response);
          leave;
       endif;

       //Validar monto de la transaccion 
       if reg_transaccion.amoTransacc <= *zeros;
          error = 35;
          Sav_Error(reg_transaccion.secuencia: error:Ou_Response);
          leave;
       endif;

       //Validar moneda
       if reg_transaccion.ccyTransacc <> 'COP';
          error = 23;
          Sav_Error(reg_transaccion.secuencia: error:Ou_Response);
          leave;
       endif;

       //Validar saldo de cuenta
       if reg_transaccion.tipo = TIPO_TRANSACCION.DEBITO;
          if Ou_bnkcta.BKABAL < reg_transaccion.amoTransacc;
             error = 37;
             Sav_Error(reg_transaccion.secuencia: error:Ou_Response);
             leave;
          endif;  
       endif;
    endif;  
   endfor;
endif;

if error <> *zeros and 
error <> 30 and 
error <> 32 and
error <> 40;
    error = 36;
endif;


return error;
end-proc;    
//*********************************************************  
// Procedimiento para Grabar Errores en transacciones     *
//*********************************************************
dcl-proc Sav_Error;
    dcl-pi *N;
            In_Secuencia    zoned(1);
            In_codError     int(10);
            Ou_Response     likeds(DS_OutRegTrn);
    end-pi;
   
   //Variables Internas
   dcl-s error          int(10);
   dcl-s Ou_DscError    char(200);
   
   //Estructuras Internas
   dcl-ds Ou_bnkcta         likeds(DS_bnkcta);
   dcl-ds clatrn            likerec(RBNKTRN : *key);
   dcl-ds reg_Error         likeds(DS_ResRegTrn);
     
//*********************************************************  
// Inicio procedimiento                                   *
//********************************************************* 

   clear reg_Error;
   GET_BNKMSG(In_codError:Ou_DscError); 
   reg_Error.errorCod       =   In_codError;
   reg_Error.secuencia      =   In_Secuencia;
   reg_Error.errordsc       =   Ou_DscError; 
   Ou_Response.lst_response(niError) = reg_Error; 
   niError += 1;
end-proc;