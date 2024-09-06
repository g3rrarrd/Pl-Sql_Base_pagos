create or replace procedure sp_cantidad_pagos_mes (mensaje out varchar2, meses_pagos out sys_refcursor)
is
    
begin
    
        open meses_pagos for
        select  to_char(fecha_pago, 'yyyy-month') mes, 
                count(1) pagos
        from pago 
        group by to_char(fecha_pago, 'yyyy-month');
        mensaje := 'Se retorno con exito';
    
    
    EXCEPTION
        when others then
            mensaje := 'Ha ocurrido un error: ' || sqlcode;
end;


declare
    mensaje varchar(100);
    meses_datos SYS_REFCURSOR;
    
    type datos is record (
        mes varchar2(30),
        pagos number(3)
    );
    
    datos_filas datos;
    
begin
     sp_cantidad_pagos_mes(mensaje, meses_datos);
     if(mensaje = 'Se retorno con exito') then
        loop
            FETCH meses_datos into datos_filas;
            exit when meses_datos%notfound;
            
            dbms_output.put_line('mes: ' || datos_filas.mes || ' psgos: ' || datos_filas.pagos);
        end loop;
    else
        dbms_output.put_line(mensaje);
    end if;
end;

