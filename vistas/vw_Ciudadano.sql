-- Ciudadano con su edad y franja etaria calculadas a la fecha de hoy.
-- Los reportes que agrupan por franja usan esta vista en lugar de la tabla Ciudadano.
-- Debe crearse antes que vw_ResumenIntencionVoto y las consultas.
CREATE OR ALTER VIEW vw_Ciudadano AS
SELECT
    c.idCiudadano,
    c.dni,
    c.nombreCompleto,
    c.genero,
    c.fechaNacimiento,
    c.idBarrio,
    x.edad,
    f.idFranja
FROM Ciudadano c
CROSS APPLY (
    -- Edad exacta: anios de diferencia, menos 1 si todavia no cumplio este anio
    SELECT DATEDIFF(YEAR, c.fechaNacimiento, CAST(GETDATE() AS DATE))
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.fechaNacimiento, CAST(GETDATE() AS DATE)), c.fechaNacimiento)
                     > CAST(GETDATE() AS DATE)
                THEN 1 ELSE 0 END AS edad
) x
LEFT JOIN FranjaEtaria f
    ON x.edad >= f.edadMinima
   AND (f.edadMaxima IS NULL OR x.edad <= f.edadMaxima)
