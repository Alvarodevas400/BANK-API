         //**************************************************** 
         // Prototipo Obtener una lista de movimientos       *
         //****************************************************

         dcl-ds DS_Bnktrn Extname('BNKTRN') qualified end-ds;

         //**************************************************** 
         // Definicion de prototipo                           *
         //****************************************************

         dcl-pr Lst_TrnMov    Int(10);
              In_DevCta       likeds(DS_InpLstTrn);
         end-pr;
         

