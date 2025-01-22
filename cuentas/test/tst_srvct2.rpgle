**FREE
Ctl-Opt bnddir('DSRVCTA200');

//*******************************************************
// Programa para probar servicio SRVCTA200              *
//*******************************************************

/Copy 'prototypes/cuentas/services/SRVCTA20P'

//Variables Internas
dcl-s error         int(10);
dcl-s Ou_cuenta     zoned(11);
dcl-s Ou_Message    char(200);

//Estructuras 
dcl-ds In_infCta likeds(Ds_InpSavAccount);


//*******************************************************
// Main                                                 *
//*******************************************************

//1. Happy Path
In_infCta.code = 18;
In_infCta.tipo = 'AHOR';
In_infCta.moneda = 'COP';
In_infCta.agencia = '0010';
In_infCta.oficial = '1001';
error = Sav_Cuenta(In_infCta:Ou_Cuenta:Ou_Message);

//2. Tipo de cuenta invalida 
In_infCta.code = 18;
In_infCta.tipo = 'FRDA';
In_infCta.moneda = 'COP';
In_infCta.agencia = '0010';
In_infCta.oficial = '1001';
error = Sav_Cuenta(In_infCta:Ou_Cuenta:Ou_Message);


//3. Moneda invalida 
In_infCta.code = 18;
In_infCta.tipo = 'AHOR';
In_infCta.moneda = 'USD';
In_infCta.agencia = '0010';
In_infCta.oficial = '1001';
error = Sav_Cuenta(In_infCta:Ou_Cuenta:Ou_Message);


*inlr= *on;