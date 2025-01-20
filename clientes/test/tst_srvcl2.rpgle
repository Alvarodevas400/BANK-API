**FREE
Ctl-Opt bnddir('DSRVCLI200');

//*******************************************************
// Programa para probar servicio SRVCLI200              *
//*******************************************************

/Copy 'prototypes/clientes/services/SRVCLI20P'

//Variables Internas
dcl-s error int(10);
dcl-s Ou_code zoned(9);
dcl-s Ou_Message char(200);

//Estructuras 
dcl-ds In_DatCli  likeds(DS_InpRegCli);

//*******************************************************
// Main                                                 *
//*******************************************************

// 1. Happy Path

    In_DatCli.primer_nombre     = 'Maritn';
    In_DatCli.segundo_nombre    = 'Segundo';
    In_DatCli.primer_apellido   = 'Griego';
    In_DatCli.segundo_apellido  = 'Ramirez';
    In_DatCli.tipo_id           = 'C';
    In_DatCli.identificacion    = '1234567790';
    In_DatCli.email             = 'test@gmail.com';
    In_DatCli.telefono          = '9999999990';
    In_DatCli.fecha_nacimiento   = 20000101;
    In_DatCli.estado_civil      = 'C';
    In_DatCli.ingresos_men      = 1000000;
    In_DatCli.ingresos_fue      = 'INDE';
  
    error =   Reg_Client(In_DatCli:Ou_Code:Ou_Message);

    // 2. Nombre Vacio

    In_DatCli.primer_nombre     = '';
    In_DatCli.segundo_nombre    = 'Segundo';
    In_DatCli.primer_apellido   = 'Griego';
    In_DatCli.segundo_apellido  = 'Mongol';
    In_DatCli.tipo_id           = 'C';
    In_DatCli.identificacion    = '4556456456';
    In_DatCli.email             = 'test@gmail.com';
    In_DatCli.telefono          = '9999999990';
    In_DatCli.fecha_nacimiento   = 20000101;
    In_DatCli.estado_civil      = 'C';
    In_DatCli.ingresos_men      = 1000000;
    In_DatCli.ingresos_fue      = 'INDE';
  
    error =   Reg_Client(In_DatCli:Ou_Code:Ou_Message);

    // 3. tipo de identificacion vacia

    In_DatCli.primer_nombre     = 'TEST';
    In_DatCli.segundo_nombre    = 'Segundo';
    In_DatCli.primer_apellido   = 'Griego';
    In_DatCli.segundo_apellido  = 'Mongol';
    In_DatCli.tipo_id           = '';
    In_DatCli.identificacion    = '5464646';
    In_DatCli.email             = 'test@gmail.com';
    In_DatCli.telefono          = '9999999990';
    In_DatCli.fecha_nacimiento   = 20000101;
    In_DatCli.estado_civil      = 'C';
    In_DatCli.ingresos_men      = 1000000;
    In_DatCli.ingresos_fue      = 'INDE';
  
    error =   Reg_Client(In_DatCli:Ou_Code:Ou_Message);

    // 4. Menor de edad

    In_DatCli.primer_nombre     = 'TEST4';
    In_DatCli.segundo_nombre    = 'Segundo';
    In_DatCli.primer_apellido   = 'Griego';
    In_DatCli.segundo_apellido  = 'Mongol';
    In_DatCli.tipo_id           = 'C';
    In_DatCli.identificacion    = '333345345';
    In_DatCli.email             = 'test@gmail.com';
    In_DatCli.telefono          = '9999999990';
    In_DatCli.fecha_nacimiento   = 20240101;
    In_DatCli.estado_civil      = 'C';
    In_DatCli.ingresos_men      = 1000000;
    In_DatCli.ingresos_fue      = 'INDE';
  
    error =   Reg_Client(In_DatCli:Ou_Code:Ou_Message);
    *inlr = *on;