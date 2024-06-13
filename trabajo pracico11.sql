
-- Ejercicio 1 - Base Adventure Works
-- Crear una función que dado un año, devuelva nombre y apellido de los empleados que ingresaron ese año.

use AdventureWorks

select		HireDate as [fecha de ingreso], p.FirstName as nombre, p.LastName as apellido
from		HumanResources.Employee e
inner join	Person.Person p
on			e.BusinessEntityID = p.BusinessEntityID
order by	1


-- Ejercicio 2 - Base Adventure Works

--Crear un procedimiento almacenado en el esquema dbo llamado ActualizarPrecio que recibe como   parámetros el código y el precio del producto que se desea actualizar. Luego, mostrar código,  nombre y precio actualizado.
	
CREATE PROCEDURE dbo.ActualizarPrecio (@Codigo INT, @Precio MONEY)
AS
BEGIN
    UPDATE Production.Product
    SET ListPrice = @Precio
    WHERE ProductID = @Codigo;

    SELECT ProductID, Name, ListPrice
    FROM Production.Product
    WHERE ProductID = @Codigo;
END;

EXEC dbo.ActualizarPrecio 350, 2500;
GO

drop proc ActualizarPrecio

-- Ejercicio 3 - Base Adventure Works
-- Obtener el promedio del listado de precios de todos los productos y guardarlo en una variable llamada @Promedio. Incrementar todos los productos un 15% pero si el promedio no supera el precio mínimo de todos los productos (distinto de cero) revertir toda la operación.


CREATE PROCEDURE dbo.productos (@Promedio MONEY);

SELECT Promedio = AVG(ListPrice)
FROM Production.Product
WHERE ListPrice > 0;

UPDATE Production.Product
SET ListPrice = ListPrice * 1.15;

IF @Promedio < (SELECT MIN(ListPrice) FROM Production.Product WHERE ListPrice > 0)
BEGIN
    UPDATE Production.Product
    SET ListPrice = ListPrice / 1.15;
END




















