
create database triggers
go
use triggers

-- Ejercicio A
 /*Una empresa almacena los datos de sus empleados en una tabla denominada "empleados" y en otra tabla llamada "secciones", el código de la sección y el sueldo máximo de cada una de ellas.
 */

create table secciones(codigo int identity, nombre varchar(30),sueldomaximo decimal(8,2), 
constraint PK_secciones primary key(codigo));

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



/* Ejercicio B
 Un comercio que vende artículos de informática almacena los datos de sus artículos en una tabla denominada "articulos".
 */

create table articulos(
codigo int identity,
  tipo varchar(30),
descripcion varchar(40),
  precio decimal(8,2),
  stock int,
constraint PK_articulos primary key (codigo)
 );

insert into articulos values ('impresora','EpsonStylus C45',400,100);
insert into articulos values ('impresora','Brother',500,200);
insert into articulos values ('impresora','Canon Color 600',400,0);
insert into articulos values ('monitor','Samsung 23',900,0);
insert into articulos values ('monitor','Samsung 19',1200,0);
insert into articulos values ('monitor','xxx 15',1500,0);
insert into articulos values ('monitor','yyy 17',1600,0);
insert into articulos values ('monitor','zzz 15',1300,0);



 /*Ejercicio C
 Un club almacena los datos de sus socios en una tabla denominada "socios", las inscripciones en "inscriptos" y en otra tabla "morosos" guarda los documentos de los socios que deben matrículas.
 */

create table socios(
  documento char(8) not null,
  nombre varchar(30),
  domicilio varchar(30),
constraint PK_socios primary key(documento)
 );

create table inscriptos(
  numero int identity,
  documento char(8) not null,
  deporte varchar(20),
  matricula char(1),
constraint FK_inscriptos_documento
foreign key (documento)
references socios(documento),
constraint CK_inscriptos_matricula check (matricula in ('s','n')),
constraint PK_inscriptos primary key(documento,deporte)
 );

create table morosos(
  documento char(8) not null
 );

insert into socios values('22222222','Ana Acosta','Avellaneda 800');
insert into socios values('23333333','Bernardo Bustos','Bulnes 345');
insert into socios values('24444444','Carlos Caseros','Colon 382');
insert into socios values('25555555','Mariana Morales','Maipu 234');

insert into inscriptos values('22222222','tenis','s');
insert into inscriptos values('22222222','natacion','n');
insert into inscriptos values('23333333','tenis','n');
insert into inscriptos values('24444444','futbol','s');
insert into inscriptos values('24444444','natacion','s');

insert into morosos values('22222222');
insert into morosos values('23333333');
