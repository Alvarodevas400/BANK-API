**FREE
Ctl-Opt nomain;

//************************************************************
//  Modulo para grabar transacciones                         *   
//************************************************************
dcl-f BNKCTA usage(*update) usropn keyed;
dcl-f BNKTRN usage(*output) usropn;

//Copy 

//Helper
/Copy 'prototypes/GLOBAL_DS'

//Modulo
/Copy 'prototypes/transaccion/modules/SAV_TRANSP'

//Programa de Servicio
/Copy 'prototypes/transaccion/services/SRVTRN10P'

Dcl-Proc SAV_TRAN       export;
  Dcl-Pi SAV_TRAN       int(10);
      In_TraInf         likeds(DS_InpRegTrn);  
  End-Pi;

  //Variables Internas
  dcl-s  error int(10);

  //Estrcuturas Locales
  dcl-ds Fechahoy likeds(FechaDS);
  dcl-ds Ou_bnktrn likerec(RBNKTRN : *output);
  dcl-ds Ou_bnkcta  likerec(RBNKCTA : *all);
  dcl-ds reg_transaccion likeds(DS_RegTrn);  

  //*********************************************************  
  // Main                                                   *
  //*********************************************************

  Fechahoy.FechaAAAAMMDD = %dec(%date():*ISO);

  if not %open(BNKCTA);
     open BNKCTA;
  endif;  

  if not %open(BNKTRN);
     open BNKTRN;
  endif;

  for-each reg_transaccion in In_TraInf.lst_transa;
     clear Ou_bnkcta;
     clear Ou_bnktrn;

     if reg_transaccion.codTransacc <> *blanks;
        //Actualizar el saldo
        chain reg_transaccion.cuenta BNKCTA Ou_bnkcta;
        if %found();
           if reg_transaccion.tipo = TIPO_TRANSACCION.DEBITO;
              Ou_bnkcta.BKABAL = Ou_bnkcta.BKABAL -
                                 reg_transaccion.amoTransacc; 
           else;
              Ou_bnkcta.BKABAL = Ou_bnkcta.BKABAL +
                                 reg_transaccion.amoTransacc; 
           endif; 

           Ou_bnkcta.BKALSD = Fechahoy.dia;
           Ou_bnkcta.BKALSM = Fechahoy.mes;
           Ou_bnkcta.BKALSA = Fechahoy.anio;
           Ou_bnkcta.BKAUPD = %timestamp();
           Ou_bnkcta.BKAUPU = 'SAV_TRANSA'; 
           update RBNKCTA Ou_bnkcta; 

           //Grabar la transaccion.
           Ou_bnktrn.BKTCUE = reg_transaccion.cuenta;
           Ou_bnktrn.BKTTYP = reg_transaccion.codTransacc;
           if reg_transaccion.tipo = TIPO_TRANSACCION.DEBITO;
              Ou_bnktrn.BKTSIG = '-';
           else;
              Ou_bnktrn.BKTSIG = '+';  
           endif;
           Ou_bnktrn.BKTAMO = reg_transaccion.amoTransacc;
           Ou_bnktrn.BKTDSC = reg_transaccion.dscTransacc;
           Ou_bnktrn.BKTREF = In_TraInf.referencia;
           Ou_bnktrn.BKTDAT = Fechahoy.FechaAAAAMMDD;
           Ou_bnktrn.BKTHOR = %dec(%time():*HMS);
           Ou_bnktrn.BKTCRT = %timestamp();
           Ou_bnktrn.BKTUSR = 'SAV_TRANSA';
           write RBNKTRN Ou_bnktrn; 
        else;
          error = 22;
          leave;
        endif;
     else;
        leave;  
     endif;
  endfor;

  close bnkcta;
  close bnktrn;
  return error;
End-Proc;