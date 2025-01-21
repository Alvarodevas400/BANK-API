**FREE
Ctl-Opt bnddir('DSRVCTA000');

//*******************************************************
// Programa para probar servicio SRVCTA000              *
//*******************************************************

/Copy 'prototypes/cuentas/services/SRVCTA00P'

//Variables Internas
dcl-s error      int(10);
dcl-s In_Account zoned(11);
dcl-s Ou_Message char(200);

//Estructuras 
dcl-ds Ou_datCta likeds(DS_OutGetAccount);

//*******************************************************
// Main                                                 *
//*******************************************************

//1. Happy Path
In_Account = 23678905676;
error = Get_InfAcc(In_Account:Ou_datCta:Ou_Message);

//2. Cuenta con ceros
In_Account = 0;
error = Get_InfAcc(In_Account:Ou_datCta:Ou_Message);

*inlr= *on;