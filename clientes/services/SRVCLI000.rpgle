**FREE
Ctl-Opt nomain;
Ctl-opt debug(*yes);
ctl-opt bnddir('DSRVCLI000'); 

//************************************************************
//  Servicio para obtener informacion de un cliente usando su* 
//  su codigo                                                *   
//************************************************************

//Copys

//Acceso a Base de Datos
/Copy 'prototypes/Get_bnkclp'
/Copy 'prototypes/Get_bnkpap'
/Copy 'prototypes/Get_bnkmsp'

//Helpers
/Copy 'prototypes/helpers/Get_pardsp'

//Programa de Servicio
/Copy 'prototypes/clientes/services/SRVCLI00P'

Dcl-Proc Get_clienteByCode export;
  Dcl-Pi Get_clienteByCode int(10);
        In_code     zoned(9);
        Ou_datCli   likeds(DS_OutGetCliente);
        Ou_Message  char(200);
  End-Pi;

  //Variables Internas
  dcl-s error       int(10);
  dcl-s In_table    char(2);
  dcl-s In_codeparm char(4);
  dcl-s Ou_descripcion char(100);  

  //Estructuras Internas
  dcl-ds Ou_Result likeds(DS_Bnkcli);
  dcl-ds FechaDs qualified;
    FechaISO   zoned(8) pos(1); //YYYYMMDD
    AnioISO    zoned(4) pos(1);
    MesISO     zoned(2) pos(5);
    DiaISO     zoned(2) pos(7); 
  end-ds;     
  //*********************************************************  
  //Main                                                    *
  //********************************************************* 
  
  clear Ou_datCli;
  clear Ou_Message;
  clear FechaDs;
  
  error = Val_Entrada(In_code);
  
  if error = 0;
     error = GET_BNKCLI(In_code:Ou_Result:Ou_Message);
     if error = 0;
        Ou_datCli.primer_nombre = Ou_Result.BKCFIN;
        Ou_datCli.segundo_nombre = Ou_Result.BKCMDN;
        Ou_datCli.primer_apellido = Ou_Result.BKCFLN;
        Ou_datCli.segundo_apellido =Ou_Result.BKCSLN;
        Ou_datCli.tipo_id = Ou_Result.BKCTID;
        Ou_datCli.identificacion =Ou_Result.BKCIDN;
        Ou_datCli.email =Ou_Result.BKCEMA;
        Ou_datCli.telefono =Ou_Result.BKCPHN;
        FechaDs.DiaISO = Ou_Result.BKCBDD;
        FechaDs.MesISO = Ou_Result.BKCBMM;
        FechaDs.AnioISO = Ou_Result.BKCBYY;
        Ou_datCli.fecha_nacimiento = FechaDs.FechaISO;
        Ou_datCli.ingresos_men = Ou_Result.BKCINC;
        Ou_datCli.ocupacion = Ou_Result.BKCBUS;

        //Descripcion Estado Civil
        In_table = 'EC';
        In_codeparm = %trim(Ou_Result.BKCMST);
        error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);

        if error = 0;
           Ou_datCli.estado_civil = Ou_descripcion;
        endif;

        //Descripcion Estado del cliente 
        In_table     = 'CE';
        In_codeparm  = %trim(Ou_Result.BKCSTS);
        error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);

        if error = 0;
           Ou_datCli.estado = Ou_descripcion;
        endif;

         //Descripcion fuente de ingreso
        In_table     = 'FI';
        In_codeparm  = %trim(Ou_Result.BKCTIN);
        error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);
        if error = 0;
           Ou_datCli.ingresos_fue = Ou_descripcion;
        endif;

        Ou_datCli.creado_en = %Char(Ou_Result.BKCIST);
     endif;     
  endif;
GET_BNKMSG(error:Ou_Message);   
return error;  

//*********************************************************  
//Rutina de Error                                         *
//********************************************************* 
begsr *PSSR;
   DUMP 'SRVCLI000';
endsr;
End-Proc;
//*********************************************************  
//Validacion de campos de entrada                         *
//********************************************************* 
dcl-proc Val_Entrada;
    dcl-pi Val_Entrada int(10);
        In_code zoned(9);
    end-pi;

    //Variables Interna
    dcl-s error int(10);

//*********************************************************  
//Inicio de procedimiento                                  *
//********************************************************* 
    if In_code = 0;
       error = 5; 
    endif;

return error;  
end-proc;



