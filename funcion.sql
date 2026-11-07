USE UADEAnalytics; 
GO;
 
CREATE OR ALTER FUNCTION dbo.fn_CiudadanosObjetivo 
( 
   @idComuna INT, 
   @idInteres INT, 
   @prioridadMinima INT, 
   @probabilidadMinima DECIMAL(5,2) 
) 
RETURNS TABLE 
AS 
RETURN 
( 
   SELECT 
       c.idCiudadano, 
       c.nombreCompleto, 
       c.genero, 
       b.nombre AS barrio, 
       co.nombre AS comuna, 
       i.nombre AS interes, 
       ci.nivelPrioridad, 
       e.intencionVoto, 
       e.probabilidadVoto 
   FROM Ciudadano c 
   INNER JOIN Barrio b 
          ON b.idBarrio = c.idBarrio 
   INNER JOIN Comuna co 
       ON co.idComuna = b.idComuna 
   INNER JOIN CiudadanoInteres ci 
       ON ci.idCiudadano = c.idCiudadano 
   INNER JOIN Interes i 
       ON i.idInteres = ci.idInteres 
   INNER JOIN Encuesta e 
       ON e.idCiudadano = c.idCiudadano 
   WHERE co.idComuna = @idComuna 
     AND i.idInteres = @idInteres 
     AND ci.nivelPrioridad >= @prioridadMinima 
     AND e.probabilidadVoto >= @probabilidadMinima 
); 

GO;