**FREE
Ctl-Opt nomain;

//************************************************************
//  Modulo para grabar cliente                               *   
//************************************************************
//Archivo
dcl-f bnkcli usage(*output) usropn;

//Programa de servicio
/Copy 'prototypes/clientes/services/SRVCLI20P'

//Modulos
/Copy 'prototypes/sav_clienp'

//Helpers
/Copy 'prototypes/Get_secnup'
/Copy 'prototypes/Global_DS'

//Estructuras Globales
dcl-ds pgm_stat PSDS;
       currentUser Char(10) pos(358); 
end-ds;

Dcl-Proc SAV_CLIENT export;
  Dcl-Pi SAV_CLIENT     int(10);
         In_DatCli likeds(DS_InpRegCli);
         Ou_code   zoned(9);
  End-Pi;

  //Variables Internas
  dcl-s error int(10);
  dcl-s codClient zoned(9);
  
  //Estructura Locales
  dcl-ds OuData_Bnkcli likerec(RBNKCLI:*output);
  dcl-ds FechaWrk likeds(FechaDS);
//************************************************************
//  Main                                                     *   
//************************************************************

clear Ou_code;
clear OuData_Bnkcli;

error = GET_SECNUM('CL':codClient);

if error = 0 and codClient > 0; 
   OuData_Bnkcli.BKCCOD = codClient; 
   OuData_Bnkcli.BKCFIN = %trim(In_DatCli.primer_nombre);
   OuData_Bnkcli.BKCMDN = %trim(In_DatCli.segundo_nombre);
   OuData_Bnkcli.BKCFLN = %trim(In_DatCli.primer_apellido);
   OuData_Bnkcli.BKCSLN = %trim(In_DatCli.segundo_apellido);
   OuData_Bnkcli.BKCTID = %trim(In_DatCli.tipo_id);
   OuData_Bnkcli.BKCIDN = %trim(In_DatCli.identificacion);
   FechaWrk.FechaAAAAMMDD = In_DatCli.fecha_nacimiento; 
   OuData_Bnkcli.BKCBYY = FechaWrk.anio;
   OuData_Bnkcli.BKCBMM = FechaWrk.mes;
   OuData_Bnkcli.BKCBDD = FechaWrk.dia;
   OuData_Bnkcli.BKCMST = In_DatCli.estado_civil;
   OuData_Bnkcli.BKCEMA = %trim(In_DatCli.email);
   OuData_Bnkcli.BKCPHN = %trim(In_DatCli.telefono);
   OuData_Bnkcli.BKCSTS = 'A';
   OuData_Bnkcli.BKCIST = %timestamp();
   OuData_Bnkcli.BKCINC = In_DatCli.ingresos_men;
   OuData_Bnkcli.BKCTIN = %trim(In_DatCli.ingresos_fue);
   OuData_Bnkcli.BKCUSR = currentUser;
   
   if not %open(bnkcli);
      open bnkcli;  
   endif;

   write RBNKCLI OuData_Bnkcli;
   close bnkcli; 
   Ou_code = codClient;
endif;

return error;
//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'SAV_CLIENT';
endsr;

End-Proc;

