
ccreate table Almacen(numero_almacen integer, ubicacion_almacen varchar2(40),constraint pk_na primary key(numero_almacen));

--select para verificar que se guardo 
select * from Almacen;
--
create table cliente(numero_cliente integer,numero_almacen integer,nombre_cliente varchar2(30),constraint PK_N_C Primary Key(numero_cliente),constraint FK1_n_a Foreign Key(numero_almacen) References Almacen(numero_almacen));
select * from cliente;

create table vendedor(numero_vendedor integer,nombre_vendedor varchar2(80),area_ventas varchar2(80),constraint PK_Vendedor Primary Key(numero_vendedor));
select * from vendedor;

create table ventas(id_ventas integer,numero_cliente integer,numero_vendedor integer, monto_ventas float,constraint PK_Ventas Primary Key(id_ventas),constraint FK1_N_C Foreign Key(numero_cliente) References cliente(numero_cliente),constraint FK2_n_v Foreign Key(numero_vendedor) references vendedor(numero_vendedor));
select * from ventas;

--procedimiento almacenado
create or replace procedure guardar_almacen(my_numero_almacen in integer, my_ubicacion_almacen in varchar2)
as
begin
insert into Almacen values (my_numero_almacen, my_ubicacion_almacen);
end;
/

create or replace procedure guardar_cliente(my_numero_cliente in integer,my_nombre_cliente in varchar2)
as
begin
insert into cliente values ();
end;
/

--Ejemplo de una tabla con PK artificial y su procedimiento almacenado 
CREATE TABLE CALIFICACIONES(ID_CALIFICACION INTEGER, MATERIA VARCHAR2(80), VALOR FLOAT, CONSTRAINT PK_ID_CAL PRIMARY KEY(ID_CALIFICACION));
SELECT * FROM CALIFICACIONES;
--SIGUE LA GENERACION DE LA SECUENCIA DEMONIACA
--SE LLAMARA IGUAL QUE LA TABLA ANTEPONIENDO LA ABREVIACION SEC (NO ES OBLIGATORIO PERO ES RECOMENDADO)
CREATE SEQUENCE SEC_CALIFICACIONES
START WITH 1
INCREMENT BY 1
NOMAXVALUE; --FIJA UN LIMITE MAXIMO DE REGISTROS

--AQUI VIENE EL PROCEDIMIENTO ALMACENADO XD
CREATE OR REPLACE PROCEDURE GUARDAR_CALIFICACIONES(MY_ID_CALIFICACION OUT INTEGER, MY_MATERIA IN VARCHAR2, MY_VALOR IN FLOAT)
AS
BEGIN
SELECT SEC_CALIFICACIONES.NEXTVAL INTO MY_ID_CALIFICACION FROM DUAL;  --EL MAS IMPORTANTE (EL DUAL ES UNA TABLA VIRTUAL QUE SE CREA PARA ALMACENAR LOS INDICES DE LA SECUENCIAS)
INSERT INTO CALIFICACIONES VALUES(MY_ID_CALIFICACION, MY_MATERIA,MY_VALOR);
END;
/
--probar el procedimiento
DECLARE 
VALOR INTEGER;
BEGIN
GUARDAR_CALIFICACIONES(VALOR,'ARQUITECTURA DE SISTEMAS GERENCIALES PARA LA TOMA DE DESICIONES',10);
END;
/
--VERIFICAMOS 
SELECT * FROM CALIFICACIONES;

DELETE FROM CALIFICACIONES WHERE ID_CALIFICACION=7;

SELECT COUNT(*) FROM CALIFICACIONES; -- RELACIONADO A UN CURSOR IMPLICITO
-- Ejemplo de cursor explicito  
DECLARE
CURSOR CUR_CALIF IS SELECT * FROM CALIFICACIONES;
BEGIN
  FOR REC IN CUR_CALIF LOOP                             --REC representa una fila de la BD
    DBMS_OUTPUT.PUT_LINE('CALIFICACION: '||REC.VALOR|| ' MATERIA: '||REC.MATERIA);
  END LOOP;
END;
/
SET SERVEROUTPUT ON;
