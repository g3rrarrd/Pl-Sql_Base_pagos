--7. Crear un paquete llamado INF_EMPRESA que debe contener lo siguiente: 
--• Un procedimiento que inserte registros en la tabla locations y countries y en caso 
--de existir algún error al guardar los datos en una de las dos tablas, todos los 
--cambios deben ser deshechos o anulados. 
--• Una función que busque el total de empleados que ganan un salario entre 9000 y 
--20000, este valor debe ser retornado en un mensaje que diga lo siguiente: “La 
--cantidad de empleados con un salario entre 9000 y 20000 es: x” donde x 
--representa la cantidad de empleados que cumplen con este criterio.

--Encabezado del paquete--
create or replace package PK_INF_EMPRESA 
is
    
    procedure pc_ingresar_datos_c_l(countries_data countries%rowtype, location_data locations%rowtype, mensaje out varchar2);
    
    function fn_total_emp return varchar2;
    
    function fn_validacion(countries_data countries%rowtype, location_data locations%rowtype) return number;
end;


--Cuerpo del paquete--
create or replace package body PK_INF_EMPRESA
is

    function fn_validacion(countries_data countries%rowtype, location_data locations%rowtype)
    return number
    is

    begin
        if(countries_data.country_id is not null and 
        countries_data.country_name is not null and 
        countries_data.region_id is not null) then
        
            if (location_data.location_id > 0 and 
            location_data.street_address is not null and
            location_data.POSTAL_CODE is not null and 
            location_data.city is not null and
            location_data.state_province is not null and
            location_data.country_id is not null) then
            
                return 1;
                
            else 
                return 0;
                
            end if;
        
        else
            return 0;
            
        end if;
        
    end;
    
    procedure pc_ingresar_datos_c_l(countries_data countries%rowtype, location_data locations%rowtype, mensaje out varchar2)
    is
          
    begin
        if (fn_validacion(countries_data, location_data) = 1) then
            insert into countries values (countries_data.country_id, countries_data.country_name, countries_data.region_id);
            insert into locations values (location_data.location_id, location_data.street_address, location_data.postal_code, location_data.city, location_data.state_province, location_data.country_id);
            commit;
            mensaje := 'Se han ingresado los datos con exito';
        end if;
        
        EXCEPTION
            when others then
                rollback;
                mensaje := 'Ha ocurrido una excepcion ' || sqlcode;
    end;

    function fn_total_emp
    return varchar2
    is
        cantidad_emp number;
        mensaje varchar2(200 byte);
    begin
        select count(1) cant_emp into cantidad_emp from employees where salary > 9000 and salary < 20000;
        mensaje := 'La cantidad de empleados con un salario entre 9000 y 20000 es: ' || cantidad_emp;
        return mensaje;
    end;

end;



-- Prueba del paquete --
declare 
    countries_data countries%rowtype;
    locations_data locations%rowtype;
    mensaje varchar2(100);
begin
    countries_data.country_id := '';
    countries_data.country_name := 'Honduras';
    countries_data.region_id := 1;
    
    locations_data.location_id := 1200;
    locations_data.street_address := 'Boulevard morazan';
    locations_data.postal_code := 1211;
    locations_data.city := 'Siguateque';
    locations_data.state_province := 'Comayagua';
    locations_data.country_id := 'HN';
    PK_INF_EMPRESA.pc_ingresar_datos_c_l(countries_data, locations_data, mensaje);
    dbms_output.put_line(mensaje);
    dbms_output.put_line('');
    
    mensaje := PK_INF_EMPRESA.fn_total_emp;
    dbms_output.put_line(mensaje);
    
end;


