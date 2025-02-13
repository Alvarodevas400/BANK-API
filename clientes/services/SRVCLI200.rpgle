**FREE
Ctl-Opt nomain;
Ctl-Opt bnddir('DSRVCLI200');
Ctl-Opt debug(*yes);

//************************************************************
//  Servicio para crear un cliente                           *  
//************************************************************

//Copys

//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkmsp'
/Copy 'prototypes/Get_bnkclp'
/Copy 'prototypes/Get_bnkc2p'
/Copy 'prototypes/Get_bnkpap'

//Helpers
/Copy 'prototypes/Global_DS'

//Modulos
/Copy 'prototypes/clientes/module/sav_clienp'

//Programa de Servicio
/Copy 'prototypes/clientes/services/SRVCLI20P'

Dcl-Proc Reg_Client     export;
  Dcl-Pi Reg_Client     int(10);
        In_DatCli       likeds(DS_InpRegCli);
        Ou_code         zoned(9);
        Ou_Message      char(200);
  End-Pi;

  //Variables Internas
  dcl-s error int(10);  

  //*********************************************************  
  //Main                                                    *
  //*********************************************************

  clear Ou_code;
  clear Ou_Message;
  error = Val_Entrada(In_DatCli);  

  if error = 0;
     error = SAV_CLIENT(In_DatCli:Ou_code);
  endif;

  GET_BNKMSG(error:Ou_Message);  
return error;

//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'SRVCLI200';
endsr;

End-Proc;
//*********************************************************  
//Validacion de campos de entrada                         *
//********************************************************* 
dcl-proc Val_Entrada;
    dcl-pi Val_Entrada  int(10);
        In_DatCli       likeds(DS_InpRegCli);   
    end-pi;

    //Variables Interna
    dcl-s error int(10);
    dcl-s diffFecha zoned(3);
    dcl-s Ou_Message char(200);
    dcl-s In_table char(2);
    dcl-s In_codeparm char(4);

    //Estructuras Internas
    dcl-ds Ou_Bnkcli likeds(DS_Bnkcli);
    dcl-ds Ou_bnkparm likeds(DS_Bnkparm);
    dcl-ds FechaHoy likeds(FechaDS);  
    dcl-ds FechaWrk likeds(FechaDs);

//*********************************************************  
//Inicio de procedimiento                                  *
//********************************************************* 
  
   if In_DatCli.primer_nombre = *blanks;
      error = 9;  
   endif;

   if error = 0;
      if In_DatCli.primer_apellido = *blanks;
         error = 10;
      endif;  
   endif;

   if error = 0;
      if  In_DatCli.tipo_id <> *blanks  and 
          In_DatCli.tipo_id <> 'C'      and 
          In_DatCli.tipo_id <> 'P';
          error = 7;
       endif;
   endif;

   if error = 0;
      if In_DatCli.tipo_id = *blanks;
         error = 8;
      endif;
   endif;

   if error = 0;
      if In_DatCli.identificacion = *blanks;
         error = 8;
      endif;
   endif;
 
   if error = 0;
      error = GET_BNKCL2(In_DatCli.tipo_id:In_DatCli.identificacion:
                         Ou_Bnkcli:Ou_Message); 
      if error = 0;
         error = 18; 
      else;
        error = 0;
      endif;
   endif;

   if error = 0 and In_DatCli.email = *blanks;
      error = 11;
   endif;

    if error = 0 and In_DatCli.telefono = *blanks;
      error = 12;
   endif;

   if error = 0;
      if In_DatCli.fecha_nacimiento = 0;  
         error = 13;
      else;
        FechaHoy.FechaAAAAMMDD = %dec(%Date() :*ISO); //YYYYMMDD
        FechaWrk.FechaAAAAMMDD = In_DatCli.fecha_nacimiento;
        diffFecha = FechaHoy.anio - FechaWrk.anio;
        if diffFecha < 18;
           error = 13; 
        endif;
      endif;  
   endif;

   if error = 0; 
      if In_DatCli.estado_civil <> *blanks;
         In_table = 'EC';
         In_codeparm = In_DatCli.estado_civil;
         error = GET_BNKPAR(In_table:In_codeparm:Ou_bnkparm:Ou_Message);
         if error = 4;
            error = 15;
         endif;
      else;
        error = 14;  
      endif;
   endif;

   if error = 0; 
      if In_DatCli.ingresos_fue <> *blanks;
         In_table = 'FI';
         In_codeparm = In_DatCli.ingresos_fue;
         error = GET_BNKPAR(In_table:In_codeparm:Ou_bnkparm:Ou_Message);
         if error = 4;
            error = 17;
         endif;
      else;
        error = 16;  
      endif;
   endif;
return error;  
end-proc;
