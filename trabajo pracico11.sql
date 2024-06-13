
-- Ejercicio 1 - Base Adventure Works
-- Crear una funci�n que dado un a�o, devuelva nombre y apellido de los empleados que ingresaron ese a�o.

use AdventureWorks

select		HireDate as [fecha de ingreso], p.FirstName as nombre, p.LastName as apellido
from		HumanResources.Employee e
inner join	Person.Person p
on			e.BusinessEntityID = p.BusinessEntityID
order by	1


-- Ejercicio 2 - Base Adventure Works

--Crear un procedimiento almacenado en el esquema dbo llamado ActualizarPrecio que recibe como   par�metros el c�digo y el precio del producto que se desea actualizar. Luego, mostrar c�digo,  nombre y precio actualizado.
	
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
-- Obtener el promedio del listado de precios de todos los productos y guardarlo en una variable llamada @Promedio. Incrementar todos los productos un 15% pero si el promedio no supera el precio m�nimo de todos los productos (distinto de cero) revertir toda la operaci�n.


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




















