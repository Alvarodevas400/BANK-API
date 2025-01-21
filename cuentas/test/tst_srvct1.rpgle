**FREE
Ctl-Opt bnddir('DSRVCTA100');

//*******************************************************
// Programa para probar servicio SRVCTA100              *
//*******************************************************

/Copy 'prototypes/cuentas/services/SRVCTA10P'

//Variables Internas
dcl-s error      int(10);
dcl-s In_code    zoned(9);
dcl-s Ou_Message char(200);

//Estructuras 
dcl-ds Ou_datCta likeds(DS_OutLstAccount);

//*******************************************************
// Main                                                 *
//*******************************************************

//1. Happy Path
In_code = 11;
error = Lst_AllAcc(In_Code:Ou_datCta:Ou_Message);

//2. In_code con ceros
In_code = 0;
error = Lst_AllAcc(In_Code:Ou_datCta:Ou_Message);

*inlr= *on;