**FREE
Ctl-Opt nomain;

//*******************************************
//  Modulo para crear una cuenta            *   
//*******************************************
dcl-f bnkcta usage(*output) usropn;

//Acceso a Base de Datos
 

//Modulo
/Copy 'prototypes/cuentas/modules/crt_cuentp'

//Helper
/Copy 'prototypes/helpers/Global_DS'

//Programa de Servicio
/Copy 'prototypes/cuentas/services/SRVCTA20P'

Dcl-Proc Crt_Cuenta export;
  Dcl-Pi Crt_Cuenta int(10);
        In_InfCta   likeds(DS_InpSavAccount);  
        Ou_Cuenta   zoned(11);
  End-Pi;

  //Variables Internas
  dcl-s error int(10); 
  dcl-s intAgencia  zoned(4); 
 
  //Estructuras internas
  dcl-ds Ou_Bnkcta likerec(RBNKCTA : *ALL);
  dcl-ds FechaWrk  likeds(FechaDs);
    
  //*********************************************************  
  //Main                                                    *
  //*********************************************************  

  clear Ou_Cuenta;  
  clear Ou_Bnkcta;
  clear FechaWrk;

  FechaWrk.FechaAAAAMMDD = %dec(%date(): *ISO); 

  intAgencia = %dec(In_InfCta.agencia:4:0);

  Ou_Bnkcta.BKACUE = GEN_NROACC(intAgencia);
  Ou_Bnkcta.BKACOD = In_InfCta.code;
  Ou_Bnkcta.BKATYP = In_InfCta.tipo;
  Ou_Bnkcta.BKACCY = In_InfCta.moneda;
  Ou_Bnkcta.BKASTS = 'A';
  Ou_Bnkcta.BKABRN = In_InfCta.agencia;
  Ou_Bnkcta.BKAOFC = In_InfCta.oficial;
  Ou_Bnkcta.BKAOPD = FechaWrk.dia;
  Ou_Bnkcta.BKAOPM = FechaWrk.mes;
  Ou_Bnkcta.BKAOPA = FechaWrk.anio;
  Ou_Bnkcta.BKACRT = %timestamp();
  Ou_Bnkcta.BKAUSR = 'ALVARODEV';
  
  if not %open(bnkcta);
     open bnkcta;
  endif;
  write RBNKCTA Ou_Bnkcta;
  close bnkcta;
  Ou_Cuenta =  Ou_Bnkcta.BKACUE;
 return error; 
End-Proc;
//*********************************************************  
//Genera numero de Cuenta                                 *
//********************************************************* 
dcl-proc GEN_NROACC;
    dcl-pi GEN_NROACC zoned(11);
        In_agencia    zoned(4); 
    end-pi;

   //Formato de Cuenta
   // 0000 - Agencia
   //   00 - Minutos
   //   00 - Segunos 
   //  000 - Milisegundos   

   //Variables
   dcl-s timeStampField timestamp;
   dcl-s numTimestamp char(11);

//***************************************************
// Inicio del procedimiento                        *
//***************************************************
  
   timeStampField = %timestamp();
   numTimestamp   = %editc(In_agencia :'X') +           //Agencia
                    %subst(%char(timeStampField):15:2) +     
                    %subst(%char(timeStampField):18:2) +
                    %subst(%char(timeStampField):21:3); 
   return %dec(numTimestamp: 11:0);
end-proc;
 