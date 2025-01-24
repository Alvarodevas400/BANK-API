**FREE
Ctl-Opt nomain;

//************************************************************
//  Modulo para reversar transacciones                       *   
//************************************************************
dcl-f BNKCTA usage(*update) usropn keyed;
dcl-f BNKTRNL0 usage(*output:*input) keyed usropn;

//Copy 

//Helper
/Copy 'prototypes/GLOBAL_DS'

//Modulo
/Copy 'prototypes/transaccion/modules/REV_TRANSP'

//Programa de Servicio
/Copy 'prototypes/transaccion/services/SRVTRN10P'

Dcl-Proc REV_TRAN       export;
  Dcl-Pi REV_TRAN       int(10);
      In_TraInf         likeds(DS_InpRegTrn);  
  End-Pi;

  //Variables Internas
  dcl-s  error int(10);
  dcl-s registros zoned(4);

  //Estrcuturas Locales
  dcl-ds Fechahoy likeds(FechaDS);
  dcl-ds Ou_bnktrn likerec(RBNKTRN : *all);
  dcl-ds clatrn likerec(RBNKTRN : *key);

  //*********************************************************  
  // Main                                                   *
  //*********************************************************

  Fechahoy.FechaAAAAMMDD = %dec(%date():*ISO);
  registros = 1; 

  if not %open(BNKCTA);
     open BNKCTA;
  endif;  

  if not %open(BNKTRNL0);
     open BNKTRNL0;
  endif;

  //Validar la existencia de la transaccion original
  clatrn.BKTREF = In_TraInf.referencia;
  clatrn.BKTREV = '';

  setll %kds(clatrn) BNKTRNL0;
  reade %kds(clatrn) BNKTRNL0 Ou_bnktrn;

  dow not %eof;
      Ou_bnktrn.BKTREV = 'R';
      Ou_bnktrn.BKTDSC = 'REVERSO - ' + %trim(Ou_bnktrn.BKTDSC);
      if Ou_bnktrn.BKTSIG = '+';
         Ou_bnktrn.BKTSIG = '-';
      else;
         Ou_bnktrn.BKTSIG = '+';
      endif;
      Ou_bnktrn.BKTDAT = Fechahoy.FechaAAAAMMDD;
      Ou_bnktrn.BKTHOR = %dec(%time():*HMS);
      Ou_bnktrn.BKTCRT = %timestamp();
      Ou_bnktrn.BKTUSR = 'REV_TRANSA';
      write RBNKTRN Ou_bnktrn;

      //Actualizar el saldo
        chain Ou_bnktrn.BKTCUE BNKCTA;
        if %found();

           if (Ou_bnktrn.BKTSIG = '-');
              BKABAL += Ou_bnktrn.BKTAMO; 
           else;
              BKABAL -= Ou_bnktrn.BKTAMO;
           endif; 

           BKALSD = Fechahoy.dia;
           BKALSM = Fechahoy.mes;
           BKALSA = Fechahoy.anio;
           BKAUPD = %timestamp();
           BKAUPU = 'REV_TRANSA'; 
           update RBNKCTA; 
         endif;
         reade %kds(clatrn) BNKTRNL0 Ou_bnktrn;
         registros += 1;
  enddo;

   if registros =1;
      error = 38;
   endif;
   
  close bnkcta;
  close bnktrnl0;
  
  return error;
End-Proc;