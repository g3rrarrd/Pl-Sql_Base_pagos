create or replace PROCEDURE sp_id_nombre_cliente(cursor_cliente out SYS_REFCURSOR, mensaje out varchar2)
is

begin 
    open cursor_cliente for
    select  id_cliente,  
            nombre || ' ' || apellido nombre
    from cliente;
    
    mensaje := 'Se obtuvieron los datos con exito';

    Exception 
        when others then 
            mensaje := 'Ha ocurrido un error: ' || sqlcode;

end;



declare
    mensaje varchar2(100);
    cursor_data SYS_REFCURSOR;
    
    type datos_cli is record (
        id_cli cliente.id_cliente%type,
        nombre varchar2(100)
    );
    
    datos_cli_obt datos_cli;
begin

    sp_id_nombre_cliente(cursor_data ,mensaje);
    
    if mensaje = 'Se obtuvieron los datos con exito' then
        loop
            fetch cursor_data into datos_cli_obt;
            
            exit when cursor_data%notfound;
            
            dbms_output.put_line('ID cliente: ' || datos_cli_obt.id_cli || ' Nombre: ' || datos_cli_obt.nombre);
        end loop;
            dbms_output.put_line('');
            dbms_output.put_line(mensaje);
    else
            dbms_output.put_line(mensaje);
    end if;
end;

set serveroutput on;