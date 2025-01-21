**FREE
Ctl-Opt nomain;

//************************************************************
//  Modulo para obtener las cuentas de un cliente            *   
//************************************************************

//Acceso a Base de Datos
 /Copy 'prototypes/Lst_bnkctp'
 /Copy 'prototypes/Get_bnkctp'

//Modulo
/Copy 'prototypes/cuentas/modules/Lst_Cuentp'

//Helper
/Copy 'prototypes/Get_pardsp'

//Programa de Servicio
/Copy 'prototypes/cuentas/services/SRVCTA10P'

Dcl-Proc LST_CUENTA     export;
  Dcl-Pi LST_CUENTA     int(10);
        In_code         zoned(9);
        Ou_lstCuentas   likeds(DS_OutLstAccount);
  End-Pi;

  //Variables Internas
  dcl-s error int(10);  
  dcl-s Ou_Message char(200);
  dcl-s In_table char(2);
  dcl-s In_codeparm char(4);
  dcl-s Ou_descripcion char(100);
  dcl-s ni zoned(2); 

  //Estructuras internas
  dcl-ds Ou_lstBnkcta likeds(DS_Bnkcta) dim(10);
  dcl-ds reg_Cuenta likeds(Ds_Cuenta);
    
  //*********************************************************  
  //Main                                                    *
  //*********************************************************  

  clear Ou_lstCuentas;
  clear reg_Cuenta;
  ni = 1;
  
  error = LST_BNKCTA(In_code:Ou_lstBnkcta:Ou_Message);

  if error = 0;
     dow (Ou_lstBnkcta(ni).BKACUE <> 0 and ni<=10);
         reg_Cuenta.cuenta = Ou_lstBnkcta(ni).BKACUE;
         reg_Cuenta.moneda = Ou_lstBnkcta(ni).BKACCY;
         reg_Cuenta.disponible = Ou_lstBnkcta(ni).BKABAL;
         reg_Cuenta.estado = Ou_lstBnkcta(ni).BKASTS;
         
         In_table = 'TA'; //Tipo de Cuentas
         In_codeparm = Ou_lstBnkcta(ni).BKATYP;   
         error = GET_PARDSC(In_table:In_codeparm:Ou_descripcion);
         if error = 0;
            reg_Cuenta.tipo = Ou_descripcion;
         endif;
         Ou_lstCuentas.lst_cuentas(ni) = reg_Cuenta;
         clear reg_Cuenta;
         ni += 1;
     enddo;
  endif;
 return error; 
End-Proc;