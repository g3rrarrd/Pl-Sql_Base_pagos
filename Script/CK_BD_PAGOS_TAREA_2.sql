create or replace procedure sp_monto_pago_mes(mensaje out varchar2, datos_meses out sys_refcursor)
is
    
begin
    open datos_meses for
    select  to_char(fecha_pago,'yyyy-month') mes,
            sum(monto) monto_mes
    from pago
    group by to_char(fecha_pago,'yyyy-month');
    
    mensaje := 'Se ha retornado con exito';
    
    EXCEPTION
        when others then
            mensaje := 'Ha ocurrido un erro: ' || sqlcode;
end;

declare
    cursor_dato sys_refcursor;
    mensaje varchar2(100);

    type datos_meses is record (
        mes varchar2(30),
        monto number(10,2)
    );
    datos_meses_monto datos_meses;
begin
    sp_monto_pago_mes(mensaje, cursor_dato);

    if mensaje = 'Se ha retornado con exito' then    
        loop 
            fetch cursor_dato into datos_meses_monto;
            exit when cursor_dato%notfound;
            
            dbms_output.put_line('Mes: ' || datos_meses_monto.mes || ' Monto de pago: ' || datos_meses_monto.monto);
    
        end loop;
        dbms_output.put_line('');
        dbms_output.put_line(mensaje);
    else 
        dbms_output.put_line(mensaje);
    end if;
end;