/*Consulta 1*/
SELECT
    nombreComuna AS Comuna,
    intencionVoto,
    SUM(totalEncuestas) AS TotalVotos,
    CAST(SUM(totalEncuestas * promedioProbabilidad)/SUM(totalEncuestas) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio

FROM vw_ResumenIntencionVoto
GROUP BY idComuna, nombreComuna, intencionVoto
ORDER BY idComuna, totalVotos DESC;


/*Consulta2*/
SELECT 
    p.nombre AS Comuna,
    p.totalPresupuesto,
    p.TotalAcciones,
    COALESCE(SUM(v.totalEncuestas), 0) AS CantidadVotantesAlianza,
    COALESCE(CAST(SUM(v.totalEncuestas * v.promedioProbabilidad) / SUM(v.totalEncuestas) AS DECIMAL(5,2)), 0.00) AS GradoDeConviccionPromedio
    
FROM v_ContrastarPresupuestoComuna p
LEFT JOIN vw_ResumenIntencionVoto v 
    ON p.idComuna = v.idComuna 
   AND v.intencionVoto = 'Alianza Innovadora'
GROUP BY 
    p.idComuna, 
    p.nombre, 
    p.totalPresupuesto, 
    p.TotalAcciones
ORDER BY p.totalPresupuesto DESC;

/*Consulta3*/

SELECT
    fa.descripcion AS FranjaEtaria,
    i.nombre AS InteresReclamado,
    i.categoria AS categoria,
    COUNT(ci.idCiudadano) CantidadSolicitantes,
    CAST(AVG(CAST(ciI.nivelPrioridad AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS PrioridadPromediada

FROM FranjaEtaria Fa
INNER JOIN Ciudadano ci ON Fa.idFranja = ci.idFranja
INNER JOIN CiudadanoInteres ciI ON ci.idCiudadano = ciI.idCiudadano
INNER JOIN Interes i ON ciI.idInteres = i.idInteres
GROUP BY fa.descripcion, i.nombre, i.categoria
ORDER BY fa.descripcion, COUNT(ci.idCiudadano) DESC


/*Consulta 4*/
SELECT
    fa.descripcion,
    ci.genero,
    e.intencionVoto,
    COUNT(e.idEncuesta) AS CantidadVotantes,
    CAST(AVG(e.probabilidadVoto) AS DECIMAL (5,2))AS GradoDeConviccionPromedio

FROM Ciudadano ci
INNER JOIN FranjaEtaria fa ON ci.idFranja = fa.idFranja
INNER JOIN Encuesta e ON e.idCiudadano = ci.idCiudadano
GROUP BY fa.descripcion, ci.genero, e.intencionVoto
ORDER BY fa.descripcion, ci.genero, e.intencionVoto ASC


/*Consulta 5*/
SELECT
    c.nombre AS Comuna,
    e.intencionVoto AS Partido,
    COUNT(e.idEncuesta) AS Votos,
    CAST(AVG(e.probabilidadVoto)AS DECIMAL(5,2)) AS GradoDeConviccionPromedio
    

FROM Ciudadano ci
INNER JOIN Encuesta e ON ci.idCiudadano = e.idCiudadano
INNER JOIN Barrio b ON b.idBarrio = ci.idBarrio
INNER JOIN Comuna c ON c.idComuna = b.idComuna
GROUP BY c.idComuna, c.nombre, e.intencionVoto
ORDER BY c.idComuna ASC, votos DESC


--Consulta 6
SELECT
    c.nombre,
    COUNT(ci.idCiudadano) AS CantidadIndecisos,
    CAST(AVG(e.probabilidadVoto) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio

FROM Comuna C
INNER JOIN Barrio b ON c.idComuna = b.idComuna
INNER JOIN Ciudadano ci ON b.idBarrio = ci.idBarrio
INNER JOIN Encuesta e ON e.idCiudadano = ci.idCiudadano
WHERE e.intencionVoto IN ('Indeciso', 'Voto en Blanco') OR e.probabilidadVoto<50
GROUP BY c.idComuna, c.nombre
ORDER BY CantidadIndecisos DESC

--Consulta 7
SELECT
    i.nombre AS Tema,
    i.categoria AS Categoria,
    COUNT(ci.idCiudadano) AS VotantesFieles

FROM Encuesta e
INNER JOIN Ciudadano ci ON Ci.idCiudadano = e.idCiudadano
INNER JOIN CiudadanoInteres ciI ON ciI.idCiudadano = ci.idCiudadano
INNER JOIN Interes i ON ciI.idInteres = i.idInteres
WHERE e.intencionVoto = 'Alianza Innovadora' AND e.probabilidadVoto >= 80 AND ciI.nivelPrioridad >= 4 
GROUP BY i.nombre, i.categoria
ORDER BY VotantesFieles DESC


