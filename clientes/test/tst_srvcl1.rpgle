**FREE
Ctl-Opt bnddir('DSRVCLI100');

//*******************************************************
// Programa para probar servicio SRVCLI100              *
//*******************************************************

/Copy 'prototypes/clientes/services/SRVCLI10P'

//Variables Internas
dcl-s error int(10);
dcl-s in_idType char(1);
dcl-s in_identificacion char(30);
dcl-s Ou_Message char(200);

//Estructuras 
dcl-ds Ou_datCli likeds(DS_OutGetCliId);

//*******************************************************
// Main                                                 *
//*******************************************************

// 1. Happy Path
    in_idType = 'P';
    in_identificacion = '10493218';

    error = Get_CliById(in_idType:in_identificacion:
                        Ou_datCli:Ou_Message);

// 2. Tipo identificacion en blanco 
    in_idType = '';
    in_identificacion = '10493218';

    error = Get_CliById(in_idType:in_identificacion:
                        Ou_datCli:Ou_Message);

// 3. Tipo identificacion invalida
    in_idType = 'X';
    in_identificacion = '10493218';

    error = Get_CliById(in_idType:in_identificacion:
                        Ou_datCli:Ou_Message);

// 4. Identificacion en blanco
    in_idType = 'C';
    in_identificacion = '';

    error = Get_CliById(in_idType:in_identificacion:
                        Ou_datCli:Ou_Message);

// 5. Cliente no existe
    in_idType = 'C';
    in_identificacion = '99999999';

    error = Get_CliById(in_idType:in_identificacion:
                        Ou_datCli:Ou_Message);

*inlr = *on;



