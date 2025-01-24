**FREE
ctl-Opt nomain; 

//************************************************************
//  Modulo para obtener los movimientos de las cuentas       *   
//************************************************************
//Archivos

//Copy
/Copy 'prototypes/transaccion/modules/Lst_trnmop'

//Programa de Servicio
/Copy 'prototypes/transaccion/services/SRVTRN00P'

dcl-proc Lst_TrnMov     export;
    dcl-pi Lst_TrnMov   int(10);
        In_DevCta       likeds(DS_InpLstTrn);
    end-pi;
    
    //Variables Internas
    dcl-s error int(10);
    dcl-s register zoned(3);
    dcl-s tmpPage zoned(3);

    //Estructuras Internas
    dcl-ds Data likeds(DS_Bnktrn);

    dcl-ds ReferenceDs qualified;
        ref1    zoned(8)    pos(1);
        ref2    zoned(8)    pos(9);
        fullRef zoned(16)   pos(1);
    end-ds;

  //*********************************************************  
  //Main                                                    *
  //*********************************************************

   clear error;

    register = 1;
    tmpPage = 1;

   ReferenceDs.ref1 = In_DevCta.fechaDesde;
   ReferenceDs.ref2 = In_DevCta.fechaHasta;

   EXEC SQL 
    DELETE FROM TRNWRK WHERE TRWCUE = :In_DevCta.cuenta and 
                             TRWREF = :ReferenceDs.fullRef;

   EXEC SQL
     DECLARE C1 CURSOR FOR
        SELECT * FROM BNKTRN WHERE BKTCUE = :In_DevCta.cuenta and
                                   BKTDAT BETWEEN :In_DevCta.fechaDesde And 
                                                  :In_DevCta.fechaHasta;    
   EXEC SQL
     OPEN C1;
   
   EXEC SQL
     FETCH NEXT FROM C1 INTO :Data;
   
   dow sqlcode = 0;

    //Insertar transacciones en tabla temporal 
     EXEC SQL 
        INSERT INTO TRNWRK(TRWCUE, TRWREF, TRWPAG, TRWREG, 
                           TRWSIG, TRWAMO, TRWDSC,
                           TRWDAT, TRWHOR
                           )
                VALUES(:Data.BKTCUE, :ReferenceDs.fullRef, :tmpPage, :register,
                       :Data.BKTSIG, :Data.BKTAMO, :Data.BKTDSC,
                       :Data.BKTDAT, :Data.BKTHOR);

     EXEC SQL
     FETCH NEXT FROM C1 INTO :Data;

     if %rem(register:20) = 0;
        tmpPage += 1;
     endif;

    register += 1;
   enddo;
   
   EXEC SQL
     CLOSE C1;

   if register = 1;
      error = 29;
   endif;  

return error;  
end-proc;


