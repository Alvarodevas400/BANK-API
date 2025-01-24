**FREE

Ctl-Opt nomain;
Ctl-Opt debug(*yes);
Ctl-Opt bnddir('DSRVTRN000');     

//************************************************************
//  Servicio para obtener informacion de una cuenta          *  
//************************************************************

dcl-f trnwrk usage(*input) keyed;

//Copys
//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkmsp'
/Copy 'prototypes/Get_bnkctp'

//Modulo
/Copy 'prototypes/transaccion/modules/LST_TRNMOP'

//Helper
/Copy 'prototypes/helpers/Global_DS'

//Programa de Servicio
/Copy 'prototypes/transaccion/services/SRVTRN00P'

Dcl-Proc Lst_Trans      export;
  Dcl-Pi Lst_Trans      int(10);
        In_DevCta       likeds(DS_InpLstTrn);
        Ou_MovCta       likeds(DS_OutLstTrn);
        Ou_Message      char(200); 
  End-Pi;

  //Variables Internas
  dcl-s error           int(10);
  dcl-s ni              zoned(3) ;      

  //Estructura Local
  dcl-ds ReferenceDs qualified;
      ref1     zoned(8) pos(1);
      ref2     zoned(8) pos(9);
      fullRef  zoned(16) pos(1);
  end-ds;

  dcl-ds clatrn likerec(RTRNWRK : *key);
  dcl-ds reg_trnmov likeds(DS_TrnMove);

  //*********************************************************  
  //Main                                                    *
  //*********************************************************

  clear Ou_MovCta;
  clear Ou_Message;
  clear clatrn;
  ni = 1;

  if In_DevCta.page = 0;
     In_DevCta.page = 1;
  endif;

  error = Val_Entrada(In_DevCta);

  if error = 0 and In_DevCta.page = 1;
     error = Lst_TrnMov(In_DevCta);
  endif;  

  if error = 0;
     ReferenceDs.ref1 = In_DevCta.fechaDesde;
     ReferenceDs.ref2 = In_DevCta.fechaHasta;
     clatrn.TRWCUE = In_DevCta.cuenta;
     clatrn.TRWREF = ReferenceDs.fullRef;
     clatrn.TRWPAG = In_DevCta.page;

     setll %kds(clatrn) RTRNWRK;
     reade %kds(clatrn) RTRNWRK;

     dow not %eof;
         clear reg_trnmov;
         reg_trnmov.fechaTransac = TRWDAT;
         reg_trnmov.horaTransac = TRWHOR;
         reg_trnmov.valorTransac = TRWAMO;
         reg_trnmov.descrTransac = TRWDSC;
         reg_trnmov.SignoTransac = TRWSIG;
         Ou_MovCta.lst_trn(ni) = reg_trnmov;
         ni += 1;
         reade %kds(clatrn) RTRNWRK;
     enddo;
  endif;
  
  GET_BNKMSG(error:Ou_Message);  
  return error;
//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'SRVTRN000';
endsr;
End-Proc;

//*********************************************************  
//Validacion de campos de entrada                         *
//********************************************************* 
dcl-proc Val_Entrada;
    dcl-pi Val_Entrada int(10);
        In_DevCta likeds(DS_InpLstTrn);
    end-pi;

    //Variables Interna
    dcl-s error int(10);
    dcl-s Ou_Message char(200);
    
    //Estructura Locales
    dcl-ds FechaHoy likeds(FechaDS);
    dcl-ds Ou_Bnkcta likeds(DS_Bnkcta);

//*********************************************************  
//Inicio de procedimiento                                  *
//********************************************************* 
   if In_DevCta.cuenta = 0;
      error = 22;  
   endif;

   if error = 0;
      error = GET_BNKCTA(In_DevCta.cuenta:Ou_Bnkcta:Ou_Message);
   endif;

   if error = 0;
      if In_DevCta.fechaDesde > In_DevCta.fechaHasta;
         error = 27;
      endif;  
   endif;

   if error = 0;
      FechaHoy.FechaAAAAMMDD = %dec(%date():*ISO);
      if In_DevCta.fechaHasta > FechaHoy.FechaAAAAMMDD;
         error = 28;
      endif;  
   endif;

return error;  
end-proc;

