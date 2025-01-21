**FREE
Ctl-Opt nomain;

//************************************************************
//  Modulo para obtener informacion de una cuenta            *   
//************************************************************

//Acceso a Base de Datos
 /Copy 'prototypes/Get_bnkctp'

//Modulo
/Copy 'prototypes/cuentas/modules/Get_AccInp'

//Helper
/Copy 'prototypes/Get_pardsp'
/Copy 'prototypes/Global_DS'

//Programa de Servicio
/Copy 'prototypes/cuentas/services/SRVCTA00P'

Dcl-Proc GET_ACCINF export;
  Dcl-Pi GET_ACCINF int(10);
        In_Account  zoned(11);
        Ou_datCta   likeds(DS_OutGetAccount);
  End-Pi;

  //Variables Internas
  dcl-s error int(10);  
  dcl-s Ou_Message char(200);
  dcl-s In_table char(2);
  dcl-s In_codeparm char(4);
  dcl-s Ou_descripcion char(100);

  //Estructuras internas
  dcl-ds Ou_Bnkcta likeds(DS_Bnkcta);
  dcl-ds FechaWrk  likeds(FechaDs);
    
  //*********************************************************  
  //Main                                                    *
  //*********************************************************  

  clear Ou_datCta;  

  error = GET_BNKCTA(In_account:Ou_Bnkcta:Ou_Message);  
  
  if error = 0;
     
     In_table = 'TA'; //Tipo de Cuentas
     In_codeparm = Ou_Bnkcta.BKATYP;   
     error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);
     if error = 0;
        Ou_datCta.tipo = Ou_descripcion;
     endif;

     In_table = 'AG'; //Agencia
     In_codeparm = Ou_Bnkcta.BKABRN;   
     error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);
     if error = 0;
        Ou_datCta.agencia = Ou_descripcion;
     endif;

     In_table = 'OF'; //Oficial
     In_codeparm = Ou_Bnkcta.BKAOFC;   
     error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);
     if error = 0;
        Ou_datCta.oficial = Ou_descripcion;
     endif;

     Ou_datCta.estado           = Ou_Bnkcta.BKASTS;
     Ou_datCta.moneda           = Ou_Bnkcta.BKACCY;
     Ou_datCta.disponible       = Ou_Bnkcta.BKABAL;
     Ou_datCta.codigo_cliente   = Ou_Bnkcta.BKACOD;

     //Fecha Apertura
     clear FechaWrk;
     FechaWrk.dia               = Ou_Bnkcta.BKAOPD;
     FechaWrk.mes               = Ou_Bnkcta.BKAOPM; 
     FechaWrk.anio              = Ou_Bnkcta.BKAOPA;  
     Ou_datCta.fecha_apertura   = FechaWrk.FechaAAAAMMDD; 

    //Fecha Cierre
     clear FechaWrk;
     FechaWrk.dia               = Ou_Bnkcta.BKACPD;
     FechaWrk.mes               = Ou_Bnkcta.BKACPM; 
     FechaWrk.anio              = Ou_Bnkcta.BKACPA;  
     Ou_datCta.fecha_cierre     = FechaWrk.FechaAAAAMMDD; 

     //Fecha Ultima Transaccion
     clear FechaWrk;
     FechaWrk.dia               = Ou_Bnkcta.BKALSD;
     FechaWrk.mes               = Ou_Bnkcta.BKALSM; 
     FechaWrk.anio              = Ou_Bnkcta.BKALSA;  
     Ou_datCta.fecha_ult_mov    = FechaWrk.FechaAAAAMMDD;
  endif;
 return error; 
End-Proc;