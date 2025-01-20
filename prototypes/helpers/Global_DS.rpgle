
        //*************************************************
        // Estrcuturas Globales                           *  
        //*************************************************

        dcl-ds FechaDS qualified;
            anio               zoned(4) pos(1);
            mes                zoned(2) pos(5);
            dia                zoned(2) pos(7);
            FechaAAAAMMDD      zoned(8) pos(1);
            cFechaAAAAMMDD     char(8)  pos(1);           
        end-ds;

        