**FREE
Ctl-Opt bnddir('DSRVCLI000');

//*******************************************************
// Programa para probar servicio SRVCLI000              *
//*******************************************************

/Copy 'prototypes/clientes/services/SRVCLI00P'

//Variables Internas
dcl-s error int(10);
dcl-s codCliente zoned(9);
dcl-s Ou_Message char(200);

//Estructuras 
dcl-ds Ou_datCli likeds(DS_OutGetCliente);

//*******************************************************
// Main                                                 *
//*******************************************************

//1. Happy Path
codCliente = 10;
error = Get_clienteByCode(codCliente: Ou_datCli: Ou_Message);

//2. Cliente no existe
codCliente = 999999;
error = Get_clienteByCode(codCliente: Ou_datCli: Ou_Message);
*inlr = *on;



