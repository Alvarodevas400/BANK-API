**FREE
Ctl-Opt nomain;

 //*******************************************************
 // Prototipo para obtener un Secuencial                 *
 //*******************************************************
dcl-f bnkcli usage(*input) keyed;

//Copys
/Copy 'prototypes/helpers/Get_secnup'
Dcl-Proc GET_SECNUM      export;
  Dcl-Pi GET_SECNUM      int(10);
         In_TypeSec      char(2) value;
         Ou_Secue        zoned(9);
  End-Pi;

//Variables Internas
  dcl-s error int(10);

//*******************************************************
// Inicio de procedimiento                              *
//*******************************************************


if In_TypeSec <> *blank;
   select In_TypeSec;
     when-is 'CL';
        setll *hival bnkcli;
        readp bnkcli;
        if not %eof;
           Ou_Secue = BKCCOD + 1; 
        else;
           Ou_Secue = 1; 
        endif;
    other;
        error = 19;    
   endsl; 
else;
    error = 19;
endif;
return error;  
End-Proc;
