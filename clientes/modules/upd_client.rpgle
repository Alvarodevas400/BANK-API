**FREE
Ctl-Opt nomain;

//************************************************************
//  Modulo para actualizar un cliente                        *   
//************************************************************
//Archivo
dcl-f bnkcli usage(*update:*input) keyed usropn;

//Programa de servicio
/Copy 'prototypes/clientes/services/SRVCLI30P'

//Modulos
/Copy 'prototypes/upd_clienp'

//Helpers
/Copy 'prototypes/Global_DS'

//Estructuras Globales
dcl-ds pgm_stat PSDS;
       currentUser Char(10) pos(358); 
end-ds;

Dcl-Proc UPD_CLIENT     export;
  Dcl-Pi UPD_CLIENT     int(10);
         In_code        zoned(9);
         In_DatCli      likeds(DS_InpActCli);
  End-Pi;

  //Variables Internas
  dcl-s error int(10);
  
  //Estructura Locales
  dcl-ds OuData_Bnkcli likerec(RBNKCLI:*ALL);
  dcl-ds FechaWrk likeds(FechaDS);
  dcl-ds claBnkcli likerec(RBNKCLI:*key);

//************************************************************
//  Main                                                     *   
//************************************************************

clear OuData_Bnkcli;

claBnkcli.BKCCOD = In_code;

if not %open(bnkcli);
   open bnkcli;
endif;

chain %kds(claBnkcli) bnkcli OuData_Bnkcli;

if %found;
   OuData_Bnkcli.BKCFIN = %trim(In_DatCli.primer_nombre);
   OuData_Bnkcli.BKCMDN = %trim(In_DatCli.segundo_nombre);
   OuData_Bnkcli.BKCFLN = %trim(In_DatCli.primer_apellido);
   OuData_Bnkcli.BKCSLN = %trim(In_DatCli.segundo_apellido);
   FechaWrk.FechaAAAAMMDD = In_DatCli.fecha_nacimiento; 
   OuData_Bnkcli.BKCBYY = FechaWrk.anio;
   OuData_Bnkcli.BKCBMM = FechaWrk.mes;
   OuData_Bnkcli.BKCBDD = FechaWrk.dia;
   OuData_Bnkcli.BKCMST = In_DatCli.estado_civil;
   OuData_Bnkcli.BKCEMA = %trim(In_DatCli.email);
   OuData_Bnkcli.BKCPHN = %trim(In_DatCli.telefono);
   OuData_Bnkcli.BKCINC = In_DatCli.ingresos_men;
   OuData_Bnkcli.BKCTIN = %trim(In_DatCli.ingresos_fue);
   //Auditoria
   OuData_Bnkcli.BKCUPD = %timestamp();
   OuData_Bnkcli.BKCUPU = currentUser; 
   update RBNKCLI OuData_Bnkcli;
else;
  error = 1;
endif;
close bnkcli; 
return error;

//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'UPD_CLIENT';
endsr;

End-Proc;

