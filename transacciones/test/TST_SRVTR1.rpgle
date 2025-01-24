**FREE
Ctl-Opt bnddir('DSRVTRN100');

//*******************************************************
// Programa para probar servicio SRVTRN100              *
//*******************************************************

/Copy 'prototypes/transaccion/services/SRVTRN10P'

//Variables Internas 
dcl-s error int(10);
dcl-s Ou_Message char(200);
dcl-s timestampField timestamp;
dcl-s reference char(20);
dcl-s referenceAnt char(20);

//Estructuras 
dcl-ds In_TraInf        likeds(DS_InpRegTrn);
dcl-ds Ou_Response      likeds(DS_OutRegTrn);
dcl-ds reg_transaccion  likeds(DS_RegTrn);

//*******************************************************
// Main                                                 *
//*******************************************************
 
//1. Happy Path Credito
// exsr GenerarReferencia;
// In_TraInf.referencia = reference;
// In_TraInf.typTransac = 'C';
// reg_transaccion.secuencia = 1;
// reg_transaccion.cuenta = 23678937010;
// reg_transaccion.tipo = 'CR';
// reg_transaccion.amoTransacc = 10000;
// reg_transaccion.codTransacc = 'TRX';
// reg_transaccion.dscTransacc = 'PRUEBA CREDITO - 23678937010';
// reg_transaccion.ccyTransacc = 'COP';
// In_TraInf.lst_transa(1) = reg_transaccion;
// error = PROC_TRAN(In_TraInf:Ou_Response:Ou_Message);

//2. Happy Path Debito
// exsr GenerarReferencia;
// In_TraInf.referencia = reference;
// In_TraInf.typTransac = 'C';
// reg_transaccion.secuencia = 1;
// reg_transaccion.cuenta = 23678937010;
// reg_transaccion.tipo = 'DB';
// reg_transaccion.amoTransacc = 5000;
// reg_transaccion.codTransacc = 'TRX';
// reg_transaccion.dscTransacc = 'PRUEBA DEBITO - 23678937010';
// reg_transaccion.ccyTransacc = 'COP';
// In_TraInf.lst_transa(1) = reg_transaccion;
// error = PROC_TRAN(In_TraInf:Ou_Response:Ou_Message);


//3 Transferencia entre cuentas
exsr GenerarReferencia;
In_TraInf.referencia = reference;
In_TraInf.typTransac = 'C';
reg_transaccion.secuencia = 1;
reg_transaccion.cuenta = 23678937010;
reg_transaccion.tipo = 'DB';
reg_transaccion.amoTransacc = 7000;
reg_transaccion.codTransacc = 'TRX';
reg_transaccion.dscTransacc = 'PRUEBA TRANSFERENCIA - 23678924565';
reg_transaccion.ccyTransacc = 'COP';
In_TraInf.lst_transa(1) = reg_transaccion;
clear reg_transaccion;
reg_transaccion.secuencia = 2;
reg_transaccion.cuenta = 23678924565;
reg_transaccion.tipo = 'CR';
reg_transaccion.amoTransacc = 7000;
reg_transaccion.codTransacc = 'TRX';
reg_transaccion.dscTransacc = 'PRUEBA TRANSFERENCIA - 23678937010';
reg_transaccion.ccyTransacc = 'COP';
In_TraInf.lst_transa(2) = reg_transaccion;
error = PROC_TRAN(In_TraInf:Ou_Response:Ou_Message);


*inlr = *on;
//*******************************************************
// RUTINA para generar Referencias                      *
//*******************************************************
    begsr GenerarReferencia;
        clear reference;
        timestampField= %timestamp();
        reference = 'REF-' + %Char(%date():*ISO) +
                %char(%subst(%char(timestampField):21:4));
    endsr;


