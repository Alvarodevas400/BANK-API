**FREE
Ctl-Opt nomain;

//**********************************************
//    Modulo para obtener un listado de cuentas*  
//    de un cliente                            * 
//**********************************************

/Copy 'prototypes/Get_bnkctp'
/Copy 'prototypes/Lst_bnkctp'

Dcl-Proc LST_BNKCTA     export;
  Dcl-Pi LST_BNKCTA     int(10);
         In_code        zoned(9);
         Ou_lstBnkcta   likeds(DS_Bnkcta) dim(10);
         Ou_Message     char(200);
  End-Pi;

  //Variable
  dcl-s error int(10);

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_lstBnkcta;
clear Ou_Message;

//Set Control de compromiso
Exec Sql
   Set option commit = *none; 

//Cerrar Cursor
Exec Sql 
    Close C1;

//Declaracion del cursor
EXEC SQL
  DECLARE C1 CURSOR FOR
   Select * from bnkcta where BKACOD = :In_code;

//Abrir cursor
EXEC SQL
  OPEN C1;

if sqlcode = 0;
   //Cargar la data en el arreglo
   Exec Sql  
     Fetch C1 For 10 rows into :Ou_lstBnkcta;   
endif;

if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Lst_Bnkcta Obtuvo el error SQL: ' +
                %char(sqlcode); 
   error = 999999;             
else;
   if sqlcode = 100;
      error = 21; 
   endif; 
endif;

//Cerrar cursor
Exec Sql 
  Close C1;

return error;  
End-Proc;
