**FREE
Ctl-Opt bnddir('DSRVTRN000');

//*******************************************************
// Programa para probar servicio SRVTRN000              *
//*******************************************************

/Copy 'prototypes/transaccion/services/SRVTRN00P'

//Variables Internas 
dcl-s error int(10);
dcl-s Ou_Message char(200);
dcl-s wrkdate date;

//Estructuras 
dcl-ds In_DevCta likeds(DS_InpLstTrn);
dcl-ds Ou_MovCta likeds(DS_OutLstTrn);


//*******************************************************
// Main                                                 *
//*******************************************************

//1. Happy Path
In_DevCta.cuenta = 23678943676;
In_DevCta.fechaDesde = 20241001;
In_DevCta.fechaHasta = 20241101;
In_DevCta.page = 1;
error = Lst_Trans(In_DevCta:Ou_MovCta:Ou_Message);

//2. Traer segunda pagina
clear Ou_MovCta;
In_DevCta.cuenta = 23678943676;
In_DevCta.fechaDesde = 20241001;
In_DevCta.fechaHasta = 20241101;
In_DevCta.page = 2;
error = Lst_Trans(In_DevCta:Ou_MovCta:Ou_Message);

//3. Fecha Desde mayor que la fecha Hasta
In_DevCta.cuenta = 23678943676;
In_DevCta.fechaDesde = 20241106;
In_DevCta.fechaHasta = 20241101;
In_DevCta.page = 2;
error = Lst_Trans(In_DevCta:Ou_MovCta:Ou_Message);

//4. Fecha Hasta sea mayor a fecha Actual
wrkdate = %date() + %days(1);
In_DevCta.cuenta = 23678943676;
In_DevCta.fechaDesde = 20241106;
In_DevCta.fechaHasta = %dec(wrkdate : *ISO);
In_DevCta.page = 2;
error = Lst_Trans(In_DevCta:Ou_MovCta:Ou_Message);

//5 No registros
In_DevCta.cuenta = 23678980343;
In_DevCta.fechaDesde = 20241006;
In_DevCta.fechaHasta = 20241101;
In_DevCta.page = 1;
error = Lst_Trans(In_DevCta:Ou_MovCta:Ou_Message);



*inlr = *on;


