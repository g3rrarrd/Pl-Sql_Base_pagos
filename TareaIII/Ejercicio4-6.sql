--4. Crear un procedimiento almacenado que inserte registros en la tabla empleados, los 
--datos del empleado deben ser enviados como parámetros del procedimiento. Controlar 
--cualquier error que se produzca en el procedimiento y deshacer los cambios, si todo está 
--bien, entonces aprobar los cambios.

create or replace procedure PD_INSERTAR_DATOS_EMPLEADOS(datos_empleados employees%rowtype, mensaje out varchar)
is
    
begin
    insert into employees values(datos_empleados.employee_id, 
                                datos_empleados.first_name, 
                                datos_empleados.last_name, 
                                datos_empleados.email, 
                                datos_empleados.phone_number, 
                                datos_empleados.hire_date, 
                                datos_empleados.job_id, 
                                datos_empleados.salary, 
                                datos_empleados.commission_pct, 
                                datos_empleados.manager_id, 
                                datos_empleados.department_id);
    mensaje := 'Se ha insertado los valores de manera correcta';
    
    EXCEPTION
        WHEN OTHERS THEN
            mensaje := 'Ha ocurrido la excepcion: ' || sqlcode;
end;

declare 
    datos_emp employees%rowtype;
    mensaje varchar2(50 byte);
begin 
    datos_emp.employee_id := 130;
    datos_emp.first_name := 'Pedro';
    datos_emp.last_name := 'Garcia';
    datos_emp.email := 'Pgarc';
    datos_emp.phone_number := '12312-1231';
    datos_emp.hire_date := sysdate;
    datos_emp.job_id := 'IT_PROG';
    datos_emp.salary := 24000;
    datos_emp.commission_pct := null;
    datos_emp.manager_id := 103;
    datos_emp.department_id := 60;
    
    
    PD_INSERTAR_DATOS_EMPLEADOS(datos_emp, mensaje);
    
    if mensaje = 'Se ha insertado los valores de manera correcta' then
        dbms_output.put_line(mensaje);
        commit;
    else
        dbms_output.put_line(mensaje);
        rollback;
    end if;
    
end;


--5. Crear una función que obtenga el mayor salario que se paga en la empresa y retorne 
--este valor más los datos del empleado o empleados que ganan dicho salario. Los datos 
--de los empleados se deben retornar en un cursor mediante un parámetro de salida. 

create or replace function fn_obtener_salario_mayor(empleados_data out SYS_REFCURSOR)
return number
is
    salario number;
begin
    open empleados_data for select * from employees 
    where salary = (select max(salary) from employees);
    
    select max(salary) into salario from employees;
    
    return salario;
end;


declare 
    empleados_data SYS_REFCURSOR;
    
    type tabla is record (
    id_empleado NUMBER,
    nombre employees.first_name%type,
    apellido employees.last_name%type,
    correo employees.email%type,
    numero_celular employees.phone_number%type,
    fecha_contratacion employees.hire_date%type,
    id_trabajo employees.job_id%type,
    salario employees.salary%type,
    comision employees.COMMISSION_PCT%type,
    id_gerente employees.manager_id%type,
    id_dep employees.department_id%type
    );
    
    fila tabla;
    
    salario number;
begin

    salario := fn_obtener_salario_mayor(empleados_data);
    
    fetch empleados_data into fila;
    
    dbms_output.put_line('id empleado: ' || fila.id_empleado);
    dbms_output.put_line('Nombre empleado: ' || fila.nombre || ' ' || fila.apellido);
    dbms_output.put_line('Correo empleado: ' || fila.correo);
    dbms_output.put_line('Salario empleado: ' || salario);
    dbms_output.put_line('');

end;

--6. Crear un procedimiento almacenado que haga uso de la función creada en el inciso 
--anterior para imprimir el nombre completo del empleado o empleados, el ID del empleado, 
--el salario y el ID del departamento del empleado.

create or replace procedure pd_imprimir_datos_emp
is
    empleados_data SYS_REFCURSOR;
    
    type tabla is record (
    id_empleado NUMBER,
    nombre employees.first_name%type,
    apellido employees.last_name%type,
    correo employees.email%type,
    numero_celular employees.phone_number%type,
    fecha_contratacion employees.hire_date%type,
    id_trabajo employees.job_id%type,
    salario employees.salary%type,
    comision employees.COMMISSION_PCT%type,
    id_gerente employees.manager_id%type,
    id_dep employees.department_id%type
    );
    
    fila tabla;
    
    salario number;
begin
    salario := fn_obtener_salario_mayor(empleados_data);
    
    loop
        fetch empleados_data into fila;
        
        exit when empleados_data%notfound;
    
        dbms_output.put_line('id empleado: ' || fila.id_empleado);
        dbms_output.put_line('Nombre empleado: ' || fila.nombre || ' ' || fila.apellido);
        dbms_output.put_line('Correo empleado: ' || fila.correo);
        dbms_output.put_line('Salario empleado: ' || salario);
        dbms_output.put_line('');
    end loop;
    
end;

execute PD_IMPRIMIR_DATOS_EMP;