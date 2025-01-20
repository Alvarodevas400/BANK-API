**FREE
Ctl-Opt nomain;

//*******************************************************
// Modulo para obtener la descripcion de un parametro   *
//*******************************************************

/Copy 'prototypes/get_bnkpap'
/Copy 'prototypes/helpers/get_pardsp'

Dcl-Proc GET_PARDSC export;
  Dcl-Pi GET_PARDSC int(10);
         In_table        char(2);
         In_code         char(4);
         Ou_descripcion  char(100);
  End-Pi;

  //Variable
  dcl-s error       int(10);
  dcl-s Ou_Message  char(200);  

  //Estructuras
  dcl-ds Ou_bnkparm likeds(DS_bnkparm);

//*******************************************************
// Inicio de procedimiento                              *
//*******************************************************

  clear Ou_Message;
  clear Ou_descripcion;

  error = GET_BNKPAR(In_table:In_code:Ou_bnkparm:Ou_Message);  

  if error = 0;
     Ou_descripcion = %trim(Ou_bnkparm.BKPDSC);   
  endif;  
  return error;  
End-Proc;
