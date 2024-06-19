--Trabajo Practico Final Administración de Base de Datos


use AdventureWorks
----Ejercicio 1 - Base Adventure Works	
--crear una función que dado un año, devuelva nombre y apellido de los empleados que ingresaron ese año.


GO
CREATE FUNCTION  dbo.IF_IngresoEmpleadosAnuales(@año INT)
RETURNS TABLE
AS
	RETURN
	(
		SELECT		FirstName
					,LastName
					,HireDate
		FROM		Person.Person p
		INNER JOIN	HumanResources.Employee e
		ON			e.BusinessEntityID= p.BusinessEntityID
		WHERE		YEAR(HireDate)=@año
	)
GO	

SELECT	* 
FROM	dbo.IF_IngresoEmpleadosAnuales(2002)

--Ejercicio 2 - Base Adventure Works
--Crear un procedimiento almacenado en el esquema dbo llamado ActualizarPrecio que recibe como parámetros el código y el precio del --producto que se desea actualizar. Luego, mostrar código, nombre y precio actualizado.
CREATE PROCEDURE dbo.ActualizaPrecio(@Producto INT,@Precio  MONEY)
AS
	UPDATE Production.Product
	SET ListPrice=@Precio
	WHERE ProductID=@Producto;

	SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE ProductID=@Producto;

EXECUTE dbo.ActualizaPrecio 707, 500;

GO

SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE ProductID=4;--4	Headset Ball Bearings	264,50


	SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE ProductID=1;-- 1	Adjustable Race	264,50

----------------------------------------------------------------
CREATE PROCEDURE dbo.ActualizarPrecio(@Producto INT,@Precio  MONEY)
AS
BEGIN
    UPDATE Production.Product
   SET ListPrice=@Precio
    WHERE ProductID = @Producto;
END;

	
--Ejercicio 3 - Base Adventure Works
--Obtener el promedio del listado de precios de todos los productos y guardarlo en una variable llamada @Promedio. Incrementar todos --los productos un 15% pero si el promedio no supera el precio mínimo de todos los productos (distinto de cero) revertir toda la --operación.

DECLARE @Promedio FLOAT

-- Calcular el promedio de los precios de todos los productos
SELECT @Promedio = AVG(Price) FROM Products

-- Incrementar todos los precios en un 15%
UPDATE Products
SET Price = Price * 1.15

-- Verificar si el nuevo promedio supera el precio mínimo de todos los productos
IF @Promedio > (SELECT MIN(Price) FROM Products WHERE Price <> 0)
BEGIN
    -- Aplicar los cambios
    COMMIT
    PRINT 'La operación se realizó con éxito.'
END
ELSE
BEGIN
    -- Revertir la operación
    ROLLBACK
    PRINT 'La operación fue revertida debido a que el nuevo promedio no supera el precio mínimo.'
END


--Ejercicio 4 
--Una empresa almacena los datos de sus empleados en una tabla denominada "empleados" y en otra tabla llamada "secciones", el código --de la sección y el sueldo máximo de cada una de ellas. Crear un disparador para que se ejecute cada vez que una instrucción --"insert" ingrese datos "empleados"; el mismo debe verificar que el sueldo del empleado no sea mayor al sueldo máximo establecido --para la sección, si lo es, debe mostrar un mensaje indicando tal situación y deshacer la transacción.

create table secciones(
  codigo int identity,
  nombre varchar(30),
  sueldomaximo decimal(8,2), 
  constraint PK_secciones primary key(codigo)
 );

 create table empleados(
  documento char(8) not null,
  nombre varchar(30) not null,
  domicilio varchar(30),
  codigoseccion int not null,
  sueldo decimal(8,2),
  constraint PK_empleados primary key(documento),
  constraint FK_empelados_seccion
   foreign key (codigoseccion) references secciones(codigo)
 );

 insert into secciones values('Administracion',1500);
 insert into secciones values('Sistemas',2000);
 insert into secciones values('Secretaria',1000);

 insert into empleados values('11111111','Carla Gomez','Rivadavia 1234',1,1100);
 insert into empleados values('23333333','Juan Garcia','Bulnes 238',1,1200);
 insert into empleados values('24444444','Pedro Perez','Cordoba 765',2,1800);
 insert into empleados values('25555555','Maria Duarte','Belgrano 345',3,1000);

--- Cree un disparador para que se ejecute cada vez que una instrucción "insert" ingrese datos "empleados"; 
--el mismo debe verificar que el sueldo del empleado no sea mayor al sueldo máximo establecido para la sección, 
--si lo es, debe mostrar un mensaje indicando tal situación y deshacer la transacción.
CREATE TRIGGER tr_control_sueldo_empleado
ON INSERT
FOR EACH ROW
AS
BEGIN
    DECLARE @sueldoMaximoSeccion DECIMAL(8,2);

    -- Se obtiene el sueldo máximo de la sección del empleado que se está insertando.
    SELECT @sueldoMaximoSeccion = sueldomaximo
    FROM secciones
    WHERE codigo = NEW.codigoseccion;

    -- Se verifica si el sueldo del empleado supera el máximo permitido.
    IF @sueldoMaximoSeccion < NEW.sueldo
    BEGIN
        -- Si el sueldo es mayor, se muestra un mensaje y se revierte la transacción.
        RAISERROR('Sueldo del empleado supera el máximo permitido para la sección.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

--Ejercicio 5
--Realizar una división por cero y atrapar el error. Se debe revertir la transacción.
BEGIN TRANSACTION
		SELECT 4/0;	
		IF @@ERROR<>0
		BEGIN 
			ROLLBACK TRANSACTION;
			print 'No se puede dividir por cero'
			RETURN; 
		END

COMMIT TRANSACTION
GO

-- No seria error---
BEGIN TRANSACTION
		SELECT 4/2;	
		IF @@ERROR<>0
		BEGIN 
			ROLLBACK TRANSACTION;
			print 'No se puede dividir por cero'
			RETURN; 
		END

COMMIT TRANSACTION
GO

--Ejercicio 6
--Crear una base de datos llamada “Datos” que contenga dos archivos de datos: Dato_a  tipo MDF con un tamaño inicial de 2048kb y un crecimiento de  1024kb.
--El registro de transacción debe iniciar con un tamaño de 1024kb e incrementar  en  1024kb.
--Todos estos deben estar ubicados en la carpeta donde residen los archivos de datos. Los archivos deben pertenecer al grupo de --archivo primario. 

CREATE DATABASE [Datos]
ON PRIMARY 
   (NAME = 'Dato_a',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\Datos_a.mdf',
    SIZE = 2048KB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1024KB
    )
LOG ON 
    (NAME = 'Datos_log',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\Datos_log.ldf',
    SIZE = 1024KB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1024KB
    );
GO
-- Cambiar el grupo de archivos a PRIMARY si es necesario
ALTER DATABASE Datos
MODIFY FILEGROUP PRIMARY;
GO
---Permiso
USE master;
GO
ALTER ROLE dbcreator ADD MEMBER TuUsuario;
GO

--Ejercicio 7
--Crear una base de datos llamada “BaseL2” que contenga dos archivos de datos: BaseL2_a  	tipo MDF con un tamaño inicial de 4096kb y un crecimiento de  1024kb.
--BaseL2_b tipo NDF con un tamaño inicial de 2048kb y un crecimiento de 1024kb.
--El registro de transacción debe iniciar con un tamaño de 1024kb e incrementar  en  1024kb. 

--Todos estos deben estar ubicados en la carpeta donde residen los archivos de datos. El primer archivo debe pertenecer al grupo de archivo primario autogenerado por SQL Server y el segundo a un grupo de archivo llamado SECONDARY.

-- Crear la base de datos BaseL2
CREATE DATABASE BaseL2
ON PRIMARY 
    (NAME = BaseL2_a,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\BaseL2_a.mdf', -- Especifica la ruta correcta
    SIZE = 4096KB,
    FILEGROWTH = 1024KB
    ),
FILEGROUP SECONDARY (
    NAME = BaseL2_b,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\BaseL2_b.ndf', -- Especifica la ruta correcta
    SIZE = 2048KB,
    FILEGROWTH = 1024KB
)
LOG ON (
    NAME = BaseL2_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\BaseL2_log.ldf', -- Especifica la ruta correcta
    SIZE = 1024KB,
    FILEGROWTH = 1024KB
);
GO


--Ejercicio 8
--Normalizar las siguientes tablas:
--Normalizar implica estructurar una base de datos de manera que reduzca la redundancia y mejore la integridad de los datos.

-- Detalle_Prestamo = # cod_libro + # cod_prestamo + fecha_dev + precio unitario + precio por cantidad + precio total.
-- Biblioteca = #cod_libro + #cod_lector + titulo + autor+edictorial+ nombre_lector+tel_lector+cod_prestamo+fecha_prestamo.


--1FN
--Primera Forma Normal (1NF)
--Una tabla está en 1NF si todos sus valores son atómicos, es decir, no hay grupos de columnas
--que puedan ser divididos en partes más pequeñas que aún tengan significado.

-- Detalle_Prestamo = # cod_libro + # cod_prestamo + fecha_dev 

-- Biblioteca = #cod_libro + #cod_lector + titulo + autor+edictorial+ nombre_lector+tel_lector+@#cod_prestamo

--2FN
--Segunda Forma Normal (2NF)
--Una tabla está en 2NF si está en 1NF y todas sus columnas no clave dependen(la dependencia) 
---completamente de la clave primaria.

-- Detalle_Prestamo = # cod_libro + # cod_prestamo + fecha_dev 

-- Biblioteca = #cod_libro + #cod_lector + titulo + autor+edictorial+ nombre_lector+tel_lector+@#cod_prestamo

--3FN
--Tercera Forma Normal (3NF)
--Asegurarnos de que no hay dependencias transitivas, es decir, eliminar atributos que dependen de otros atributos no clave.


--Detalle_Prestamo=#cod_prestamo+#cod_libro+#cod_lector+fecha_dev 
--Prestamo=@#cod_prestamo+#cod_libro+#cod_lector+fecha_prestamo
--Libro=@#cod_libro+titulo+autor+edictorial
--Lector=@#cod_lector+nombre_lector+tel_lector

--Ejercicio 9
--a- Crear una  función de partición llamada PF_Sexo para cada sexo ‘M’ y ‘F’.

-- Crear la función de partición PF_Sexo
CREATE PARTITION FUNCTION PF_Sexo (CHAR(1))
AS RANGE LEFT FOR VALUES ('F', 'M');
GO

-- Crear el esquema de partición PFS_Sexo
CREATE PARTITION SCHEME PFS_Sexo
AS PARTITION PF_Sexo
TO (FG_F, FG_M);
GO
-- Crear grupos de archivos (si no existen)
ALTER DATABASE BaseL2
ADD FILEGROUP FG_F;
GO

ALTER DATABASE BaseL2
ADD FILEGROUP FG_M;
GO

-- Agregar archivos a los grupos de archivos
ALTER DATABASE BaseL2
ADD FILE 
(
    NAME = BaseL2_F,
    FILENAME = 'C:\ruta_a_la_carpeta\BaseL2_F.ndf', -- Especifica la ruta correcta
    SIZE = 2048KB,
    FILEGROWTH = 1024KB
) TO FILEGROUP FG_F;
GO

ALTER DATABASE BaseL2
ADD FILE 
(
    NAME = BaseL2_M,
    FILENAME = 'C:\ruta_a_la_carpeta\BaseL2_M.ndf', -- Especifica la ruta correcta
    SIZE = 2048KB,
    FILEGROWTH = 1024KB
) TO FILEGROUP FG_M;
GO




--b- Crear un esquema de partición para que los datos de sexo ‘F’ los guarde dentro del grupo de archivo fg1 y ‘M’ dentro de fg2.
-- Crear grupos de archivos (si no existen)

-- Crear el esquema de partición PFS_Sexo
CREATE PARTITION SCHEME PFS_Sexo
AS PARTITION PF_Sexo
TO (fg1, fg2);
GO
ALTER DATABASE BaseL2
ADD FILEGROUP fg1;
GO

ALTER DATABASE BaseL2
ADD FILEGROUP fg2;
GO

-- Agregar archivos a los grupos de archivos
ALTER DATABASE BaseL2
ADD FILE 
(
    NAME = BaseL2_F,
    FILENAME = 'C:\ruta_a_la_carpeta\BaseL2_F.ndf', -- Especifica la ruta correcta
    SIZE = 2048KB,
    FILEGROWTH = 1024KB
) TO FILEGROUP fg1;
GO

ALTER DATABASE BaseL2
ADD FILE 
(
    NAME = BaseL2_M,
    FILENAME = 'C:\ruta_a_la_carpeta\BaseL2_M.ndf', -- Especifica la ruta correcta
    SIZE = 2048KB,
    FILEGROWTH = 1024KB
) TO FILEGROUP fg2;
GO


------------------------------------------------------------------------------


--c- Crear una tabla llamada “personas2” con los siguientes atributos: nombre y sexo bajo el esquema de partición generado en el punto anterior.
--Paso 1: Crear la función de partición
CREATE PARTITION FUNCTION pf_Sexo (CHAR(1))
AS RANGE LEFT FOR VALUES ('F', 'M');
GO
--Paso 2: Crear el esquema de partición
CREATE PARTITION SCHEME ps_Sexo
AS PARTITION pf_Sexo
ALL TO ([PRIMARY]);
GO
--Paso 3: Crear la tabla con el esquema de partición
CREATE TABLE dbo.personas2 (
    ID INT,
	nombre NVARCHAR(100),
    sexo CHAR(1),
	
) ON ps_Sexo(Sexo);
GO

--d- Insertar 4 personas, dos de cada sexo.

-- Insertar cuatro personas, dos de cada sexo
INSERT INTO dbo.Personas2 (ID, Nombre, Sexo) VALUES
(1, 'Juan Perez', 'M'),
(2, 'Ana Gomez', 'F'),
(3, 'Carlos Ruiz', 'M'),
(4, 'María López', 'F');
GO

--e- Verificar la correcta inserción de los registros en cada una de las particiones.
-- Seleccionar todos los registros de la tabla Personas2
SELECT * FROM dbo.Personas2;
GO
-- Seleccionar por sexo los registros de la tabla Personas2
SELECT * FROM dbo.personas2 WHERE sexo = 'F';
SELECT * FROM dbo.personas2 WHERE sexo = 'M';

--Ejercicio 10 
--a - Crear un login llamado "ventas" con contraseña "ventas1234"--------------------
USE master;
GO

CREATE LOGIN ventas WITH PASSWORD = 'ventas1234';
GO

SELECT name, type_desc, is_disabled, default_database_name, create_date 
FROM sys.server_principals 
WHERE name = 'ventas';
ALTER LOGIN ventas WITH PASSWORD = 'nueva_contraseña';

----------------------------------------------------
CREATE LOGIN [sql_test] WITH PASSWORD=N'test',
DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

GO

select name, password from sys.syslogins


--b - Crear un usuario llamado "juan_perez" basado en el login "ventas" sobre la base pubs-------------

-- Conectar a la base de datos 'pubs'
USE pubs;
GO
-- Crear el usuario 'juan_perez' basado en el login 'ventas'
CREATE USER juan_perez FOR LOGIN ventas;
GO
--Para ver si el usuario juan_perez existe en la base de datos pubs:

SELECT name 
FROM sys.database_principals 
WHERE name = 'juan_perez';
GO
-- Para ver los detalles del usuario juan_perez, incluyendo el login al que está asociado:
SELECT dp.name AS UserName,
       dp.type_desc AS UserType,
       sp.name AS AssociatedLogin
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp
ON dp.sid = sp.sid
WHERE dp.name = 'juan_perez';
GO
--Para listar todos los logins en el servidor:
SELECT name, type_desc, is_disabled 
FROM sys.server_principals 
WHERE type_desc IN ('SQL_LOGIN', 'WINDOWS_LOGIN');
GO
--Para listar todos los usuarios en la base de datos pubs
USE pubs;
GO

SELECT name, type_desc 
FROM sys.database_principals;
GO


--c - Asociar el login "ventas" al usuario "juan_perez"-------------

--Verificar que el login ventas existe:
SELECT name 
FROM sys.server_principals 
WHERE name = 'ventas';
GO
--Eliminar el usuario juan_perez si ya existe, para evitar conflictos:
USE pubs;
GO

DROP USER IF EXISTS juan_perez;
GO
--Crear el usuario juan_perez y asociarlo al login ventas:
USE pubs;
GO

CREATE USER juan_perez FOR LOGIN ventas;
GO
--el login ventas está asociado al usuario juan_perez en la base de datos pubs. 
-- Conectar a la base de datos 'pubs'
USE pubs;
GO

-- Verificar que el login 'ventas' existe
SELECT name 
FROM sys.server_principals 
WHERE name = 'ventas';
GO

-- Eliminar el usuario 'juan_perez' si ya existe
DROP USER IF EXISTS juan_perez;
GO

-- Crear el usuario 'juan_perez' y asociarlo al login 'ventas'
CREATE USER juan_perez FOR LOGIN ventas;
GO
--el login ventas está asociado al usuario juan_perez en la base de datos pubs. 

--verificar la asociación con la siguiente consulta:
USE pubs;
GO

SELECT dp.name AS UserName,
       dp.type_desc AS UserType,
       sp.name AS AssociatedLogin
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp
ON dp.sid = sp.sid
WHERE dp.name = 'juan_perez';
GO

-- Conectar a la base de datos 'pubs'
USE pubs;
GO

-- Verificar que el login 'ventas' existe
SELECT name 
FROM sys.server_principals 
WHERE name = 'ventas';
GO

-- Eliminar el usuario 'juan_perez' si ya existe
DROP USER IF EXISTS juan_perez;
GO

-- Crear el usuario 'juan_perez' y asociarlo al login 'ventas'
CREATE USER juan_perez FOR LOGIN ventas;
GO


--d - Conceder al usuario "juan_perez" permisos de SELECT, INSERT y UPDATE en la tabla "sales"--------------------
-- Conectar a la base de datos 'pubs'
USE pubs;
GO

-- Conceder permisos de SELECT, INSERT y UPDATE en la tabla 'sales' al usuario 'juan_perez'
GRANT SELECT ON sales TO juan_perez;
GRANT INSERT ON sales TO juan_perez;
GRANT UPDATE ON sales TO juan_perez;
GO
--Para verificar que los permisos han sido correctamente concedidos
USE pubs;
GO

-- Verificar los permisos concedidos a 'juan_perez' en la tabla 'sales'
SELECT 
    prin.name AS PrincipalName,
    perm.permission_name AS PermissionName,
    perm.state_desc AS StateDesc,
    obj.name AS ObjectName
FROM 
    sys.database_principals prin
JOIN 
    sys.database_permissions perm ON prin.principal_id = perm.grantee_principal_id
JOIN 
    sys.objects obj ON perm.major_id = obj.object_id
WHERE 
    prin.name = 'juan_perez' AND obj.name = 'sales';
GO

--e - Restringir el acceso a solo dos campos de la tabla "sales"--------------

--Crear una vista que incluya solo los campos permitidos stor_id y ord_num.
-- Conectar a la base de datos 'pubs'
USE pubs;
GO
-- Crear una vista que incluya solo los campos 'stor_id' y 'ord_num' de la tabla 'sales'
CREATE VIEW sales_view AS
SELECT stor_id, ord_num
FROM sales;
GO

-- Conceder permisos de SELECT, INSERT y UPDATE en la vista 'sales_view' al usuario 'juan_perez'
GRANT SELECT ON sales_view TO juan_perez;
GRANT INSERT ON sales_view TO juan_perez;
GRANT UPDATE ON sales_view TO juan_perez;
GO

-- Revocar permisos directos en la tabla 'sales' si ya fueron concedidos
REVOKE SELECT, INSERT, UPDATE ON sales FROM juan_perez;
GO

--Verificar los permisos en la vista sales_view:
USE pubs;
GO

SELECT 
    prin.name AS PrincipalName,
    perm.permission_name AS PermissionName,
    perm.state_desc AS StateDesc,
    obj.name AS ObjectName
FROM 
    sys.database_principals prin
JOIN 
    sys.database_permissions perm ON prin.principal_id = perm.grantee_principal_id
JOIN 
    sys.objects obj ON perm.major_id = obj.object_id
WHERE 
    prin.name = 'juan_perez' AND obj.name = 'sales_view';
GO
--Verificar que no tiene permisos directos en la tabla sales:
USE pubs;
GO

SELECT 
    prin.name AS PrincipalName,
    perm.permission_name AS PermissionName,
    perm.state_desc AS StateDesc,
    obj.name AS ObjectName
FROM 
    sys.database_principals prin
JOIN 
    sys.database_permissions perm ON prin.principal_id = perm.grantee_principal_id
JOIN 
    sys.objects obj ON perm.major_id = obj.object_id
WHERE 
    prin.name = 'juan_perez' AND obj.name = 'sales';
GO


--Ejercicio 11 
--¿Qué paso NO es necesario al crear una tarea automatizada (job) en SQL Server Management Studio (SSMS)?
--a) Seleccionar la instancia de SQL Server donde se creará la tarea. 
--b) Escribir una descripción detallada para la tarea. 
--c) Configurar la frecuencia de ejecución de la tarea. 
--d) Asignar un usuario específico para ejecutar la tarea. 
--e) Añadir pasos al job para definir qué acciones realizará.
--f) Todas las anteriores afirmaciones son correctas
--g) Ninguna de las anteriores afirmaciones son correctas


--b) Escribir una descripción detallada para la tarea.-----

--Ejercicio 12
--¿Cuál de las siguientes afirmaciones sobre las copias de seguridad completas (full backup) y las copias de seguridad diferenciales (differential backup) en SQL Server es incorrecta?
--a) Una copia de seguridad completa captura todos los archivos de datos activos en el momento de la copia de seguridad. 
--b) Una copia de seguridad diferencial solo guarda los datos que han cambiado desde la última copia de seguridad completa. 
--c) Después de realizar una copia de seguridad completa inicial, cada copia de seguridad diferencial posterior solo necesita almacenamiento adicional igual al espacio utilizado por los datos modificados desde la última copia de seguridad completa. 
--d) Para restaurar los datos después de una falla, primero se necesita aplicar una copia de seguridad completa seguida de las copias de seguridad diferenciales en el orden inverso al de su realización.
--f) Todas las anteriores afirmaciones son correctas
--g) Ninguna de las anteriores afirmaciones son correctas


--La afirmación incorrecta sobre las copias de seguridad completas (full backup) y las copias de seguridad diferenciales (differential backup) en SQL Server es:

--d) Para restaurar los datos después de una falla, primero se necesita aplicar una copia de seguridad completa seguida de las copias de seguridad diferenciales en el orden inverso al de su realización.

--La restauración se realiza aplicando primero la copia de seguridad completa y luego las copias de seguridad diferenciales en el orden en que fueron-------------

--Ejercicio 13
--¿Cuál de las siguientes afirmaciones sobre el panel Procesos en el Monitor de Actividad de SQL Server es incorrecta?
--a) Muestra todos los procesos actualmente activos en SQL Server, incluyendo conexiones de administradores y usuarios. 
--b) Permite filtrar los procesos por tipo de proceso (por ejemplo, solicitudes de consulta, procesos de sistema). 
--c) Proporciona información detallada sobre cada proceso, incluyendo el ID de proceso, el estado, y el tiempo de CPU. 
--d) No permite terminar procesos manualmente para liberar recursos.
--f) Todas las anteriores afirmaciones son correctas
--g) Ninguna de las anteriores afirmaciones son correctas


--d) No permite terminar procesos manualmente para liberar recursos.

-- El Monitor de Actividad de SQL Server sí permite terminar procesos manualmente para liberar recursos. Por lo tanto, la afirmación d) es incorrecta.-----

 --realizadas, no en el orden inverso.

--Ejercicio 14
--¿Cuál de las siguientes afirmaciones sobre la replicación en SQL Server es correcta?
--a) La replicación permite distribuir automáticamente los datos de una base de datos principal a una o más bases de datos secundarias. 
--b) Solo existe un tipo de replicación en SQL Server: la replicación sincrónica. 
--c) La replicación asincrónica puede resultar en datos desactualizados en la base de datos secundaria. 
--d) La replicación log-based requiere que ambas bases de datos, principal y secundaria estén en la misma instancia de SQL Server.
--f) Todas las anteriores afirmaciones son correctas
--g) Ninguna de las anteriores afirmaciones son correctas


--Correcta. La replicación en SQL Server permite distribuir datos automáticamente desde una base de datos principal a una o más bases de datos secundarias, lo cual es su función principal.
----Por lo tanto, la opción correcta es la a), ya que describe correctamente una función fundamental de la replicación en SQL Server.-----