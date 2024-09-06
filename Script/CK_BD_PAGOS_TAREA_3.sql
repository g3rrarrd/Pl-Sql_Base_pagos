create or replace procedure sp_nombre_id_dep(mensaje out varchar2, datos_dep out SYS_REFCURSOR)
is

begin 
    
    open datos_dep for
    select id_departamento, departamento from departamento;

    mensaje := 'Se ha obtenido los datos';
    
    EXCEPTION   
        when others then
            mensaje := 'Ha ocurrido un error: ' || sqlcode;
    
end;

desc departamento;

declare

    datos_cur SYS_REFCURSOR;
    mensaje varchar2(100);
    
    type fila_dep is record (
        id_dep departamento.id_departamento%type,
        departameto departamento.departamento%type
    );
    
    datos_dep fila_dep;

begin
    sp_nombre_id_dep(mensaje, datos_cur);
    
    if mensaje = 'Se ha obtenido los datos' then
        loop
            fetch datos_cur into datos_dep;    
            exit when datos_cur%notfound;
            
            dbms_output.put_line('Codigo_departamento: ' || datos_dep.id_dep || ' Departamento: ' || datos_dep.departameto);
            
        end loop;
        dbms_output.put_line('');
        dbms_output.put_line(mensaje);
    else 
            dbms_output.put_line(mensaje);
    end if;
end;
