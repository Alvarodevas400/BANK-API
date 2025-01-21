
         //************************************************** 
         // Prototipo para obtener la inf de una cuenta     *
         //**************************************************

         dcl-pr Get_ACCINF int(10);
                In_Account  zoned(11);
                Ou_datCta   likeds(DS_OutGetAccount);
         end-pr;
         