create table Almacen(numero_almacen integer, ubicacion_almacen varchar2(40),constraint pk_na primary key(numero_almacen));

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
GUARDAR_CALIFICACIONES(VALOR,'BD2',6);
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


DECLARE 
CURSOR CUR_2 IS SELECT * FROM CALIFICACIONES FOR UPDATE;
BEGIN
  FOR REG IN CUR_2 LOOP
    IF REG.VALOR < 5 THEN
      UPDATE CALIFICACIONES SET VALOR = 5 WHERE CURRENT OF CUR_2;
     END IF;
  END LOOP;
END;
/
/*
Ejercicio: Usando otro cursor, aplicar el update con la siguiente logica:
Si la calificacion tiene .5, subirla al siguiente digito, si no dejarla en el mismo
digito entero
*/
DECLARE
CALIFICACION FLOAT;


CURSOR CHECAR_CALIF IS SELECT * FROM CALIFICACIONES FOR UPDATE;
BEGIN
  FOR CAL IN CHECAR_CALIF LOOP
     DECLARE ModCalif DECIMAL;
      ModCalif = MOD(CALIF.VALOR,1);
      IF CALIF.VALOR > 5.9 THEN
       IF  ModCalif > 0.49  THEN
         UPDATE FROM CALIFICACIONES SET VALOR = CALIF.VALOR + ModCalif;
       ELSE THEN
         UPDATE FROM CALIFICACIONES SET VALOR = CALIF.VALOR - ModCalif;
       END IF;
      END IF;
  END LOOP;
END;
/
--Ejercicio
create table Cliente(NoCliente integer NOT NULL Primary Key,
                    Nombre varchar2(30),
                    APaterno varchar2(20),
                    AMaterno varchar2(20),
                    SueldoBase float);
                    
create table Direccion(Id_Direccion integer NOT NULL Primary Key,
                      codigoPostal integer,
                      calle varchar2(40),
                      Estado varchar2(20),
                      Colonia varchar(40),
                      NumCliente integer,
                      constraint FK_Cliente Foreign Key(NumCliente) references Cliente(NoCliente));
 
CREATE SEQUENCE SEC_DIRECCIONES
START WITH 1
INCREMENT BY 1
NOMAXVALUE;                     
                      
create or replace procedure guardar_cliente(my_numero_cliente in integer,my_nombre_cliente in varchar2,my_APaterno in varchar2,my_AMaterno in varchar2, my_SueldoBase in float)
as
begin
insert into Cliente values (my_numero_cliente, my_nombre_cliente,my_APaterno,my_AMaterno,my_SueldoBase);
end;
/

create or replace procedure guardar_direccion(my_id_direccion OUT integer,my_CP in integer,my_calle in varchar2,my_estado in varchar2, my_colonia in varchar2, my_numero_cliente in integer)
as
begin
SELECT SEC_DIRECCIONES.NEXTVAL INTO MY_ID_DIRECCION FROM DUAL;  
insert into Direccion values (my_id_direccion, my_CP,my_calle,my_estado,my_colonia,my_numero_cliente);
end;
/
SELECT * FROM Cliente;
DECLARE 
VALOR INTEGER;
BEGIN
guardor_direccion(VALOR,57120,'Calle 26','Mexico','Campestre',0001);
END;
/
--VERIFICAMOS 
SELECT * FROM CALIFICACIONES;

