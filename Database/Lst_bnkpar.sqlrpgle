**FREE
Ctl-Opt nomain;

//*******************************************
//    Modulo para obtener un listado registros 
//    del BNKPARM
//*******************************************

/Copy 'prototypes/Get_bnkpap.rpgle'
/Copy 'prototypes/Lst_bnkpap.rpgle'

Dcl-Proc LST_BNKPAR export;
  Dcl-Pi LST_BNKPAR     int(10);
         In_table       char(2);    
         In_code        char(4);
         Ou_lstBnkparm  likeds(DS_Bnkparm) dim(30);
         Ou_Message     char(200);
  End-Pi;

  //Variable
  dcl-s error int(10);

//*******************************************
// Inicio de procedimiento
//*******************************************

clear Ou_lstBnkparm;
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
   Select * from bnkparm where BKPTAB = :In_table;

//Abrir cursor
EXEC SQL
  OPEN C1;

if sqlcode = 0;
   //Cargar la data en el arreglo
   Exec Sql  
     Fetch C1 For 30 rows into :Ou_lstBnkparm;   
endif;

if sqlcode <> 0 and sqlcode <> 100;
   Ou_Message = 'Modulo: Lst_Bnkparm Obtuvo el error SQL: ' +
                %char(sqlcode); 
   error = 999999;             
else;
   if sqlcode = 100;
      error = 4; 
   endif; 
endif;

//Cerrar cursor
Exec Sql 
  Close C1;

return error;  
End-Proc;
