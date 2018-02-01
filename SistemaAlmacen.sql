create database Moises
use database Moises
create table Almacen(numero_almacen integer, ubicacion_almacen varchar2(40),constraint pk_na primary key(numero_almacen));

--procedimiento almacenado
create or replace procedure guardar_almacen(my_numero_almacen in integer, my_ubicacion_almacen in varchar2)
as
begin
insert into Almacen values (my_numero_almacen, my_ubicacion);
end;
/
--select para verificar que se guardo 
select * from Almacen;
--
--probar el procedimiento con netbeans
