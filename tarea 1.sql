
-- queries simples y condicionadas
use AdventureWorks

-- 1. mostrar los empleados que tienen mas de 90 horas de vacaciones 

SELECT COUNT(VacationHours) AS 'empleados con mas de 90 horas de vacaciones' 
FROM HumanResources.Employee
WHERE VacationHours >= 90

-- 2. mostrar el nombre, precio y precio con iva de los productos fabricados

SELECT name as nombres
	   ,ListPrice as 'precio de lista'
	   ,ListPrice * 1.21 as 'precio de lista con IVA'
FROM Production.Product

-- 3. mostrar los diferentes titulos de trabajo que existen

SELECT JobTitle as 'titulos de trabajos'
FROM HumanResources.Employee

-- 4. mostrar todos los posibles colores de productos 

SELECT	name productos
		,color as 'colores de productos'
FROM Production.Product

--5. mostrar todos los tipos de pesonas que existen 

SELECT PersonType as 'tipos de personas'
FROM Person.Person

-- 6. mostrar el nombre concatenado con el apellido de las personas cuyo apellido sea johnson
SELECT	FirstName as nombre
		,LastName  as apellido
FROM  Person.Person
WHERE LastName like '%johnson%'

--7. mostrar todos los productos cuyo precio sea inferior a 150$ de color rojo o cuyo precio sea mayor a 500$ de color negro

SELECT	Name as nombre
		,ListPrice as precio
		,color
FROM  Production.Product
-- WHERE ListPrice < 150 and color in ('red')
 where ListPrice > 500 and color in ('black')
--and ListPrice > 500  and color in ('red','black') 


-- 8. mostrar el codigo, fecha de ingreso y horas de vacaciones de los empleados ingresaron a partir del año 2000 

SELECT LoginID as ID 
		,HireDate as ingreso
		,VacationHours as 'vacaciones de los empleados'
FROM HumanResources.Employee
WHERE YEAR(HireDate) = 2002 


--9. mostrar el nombre,nmero de producto, precio de lista y el precio de lista incrementado en un 10% de los productos cuya fecha de fin de venta sea anerior al dia de hoy










