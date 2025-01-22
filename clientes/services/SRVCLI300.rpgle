**FREE

Ctl-Opt nomain;
ctl-opt debug(*yes);
Ctl-Opt bnddir('DSRVCLI300');

//************************************************************
//  Servicio para actualizar un cliente                      *  
//************************************************************

//Copys

//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkmsp'
/Copy 'prototypes/Get_bnkclp'
/Copy 'prototypes/Get_bnkpap'

//Helpers
/Copy 'prototypes/Global_DS'

//Modulos
/Copy 'prototypes/clientes/module/upd_clienp'

//Programa de Servicio
/Copy 'prototypes/clientes/services/SRVCLI30P'

Dcl-Proc Act_Client        export;
  Dcl-Pi Act_Client        int(10);
         In_code          zoned(9);
         In_DatCli        likeds(DS_InpActCli);
         Ou_Message       char(200);
  End-Pi;

  //Variables internas
  dcl-s error int(10);

  //*********************************************************  
  //Main                                                    *
  //*********************************************************
  
  clear Ou_Message;
  error = Val_Entrada(In_code: In_DatCli);
  if error = 0;
     error = UPD_CLIENT(In_code:In_DatCli);
  endif;
  GET_BNKMSG(error:Ou_Message);
  return error;  

 //*********************************************************  
 //Rutina de Error                                         *
 //********************************************************* 
  begsr *PSSR;
     DUMP 'SRVCLI300';
  endsr;
End-Proc;

//*********************************************************  
//Validacion de campos de entrada                         *
//********************************************************* 
dcl-proc Val_Entrada;
    dcl-pi Val_Entrada  int(10);
        In_code         zoned(9);
        In_DatCli       likeds(DS_InpActCli);   
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

   error = GET_BNKCLI(In_code:Ou_Bnkcli:Ou_Message);

   if error = 0;
       if In_DatCli.primer_nombre = *blanks;
          error = 9;  
       endif;
   endif;

   if error = 0;
      if In_DatCli.primer_apellido = *blanks;
         error = 10;
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


