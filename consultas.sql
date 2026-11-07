USE UADEAnalytics
GO;

-- Consulta 1: Resumen de intención de voto y convicción por comuna
SELECT
    nombreComuna AS Comuna,
    intencionVoto,
    SUM(totalEncuestas) AS TotalVotos,
    CAST(SUM(totalEncuestas * promedioProbabilidad)/SUM(totalEncuestas) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio

FROM vw_ResumenIntencionVoto
GROUP BY idComuna, nombreComuna, intencionVoto
ORDER BY idComuna, totalVotos DESC;


--Consulta 2: Presupuesto y acciones de campaña vs. Votantes captados
SELECT 
    p.nombre AS Comuna,
    p.totalPresupuesto,
    p.TotalAcciones,
    COALESCE(SUM(v.totalEncuestas), 0) AS CantidadVotantesAlianza,
    COALESCE(CAST(SUM(v.totalEncuestas * v.promedioProbabilidad) / SUM(v.totalEncuestas) AS DECIMAL(5,2)), 0.00) AS GradoDeConviccionPromedio
    
FROM vw_ContrastarPresupuestoComuna p
LEFT JOIN vw_ResumenIntencionVoto v ON p.idComuna = v.idComuna AND v.intencionVoto = 'Alianza Innovadora'
GROUP BY p.idComuna, p.nombre, p.totalPresupuesto, p.TotalAcciones
ORDER BY p.totalPresupuesto DESC;


--Consulta 3: Intereses y prioridades por franja etaria
SELECT
    fa.descripcion AS FranjaEtaria,
    i.nombre AS InteresReclamado,
    i.categoria AS categoria,
    COUNT(ci.idCiudadano) AS CantidadSolicitantes,
    CAST(AVG(CAST(ciI.nivelPrioridad AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS PrioridadPromediada

FROM FranjaEtaria Fa
INNER JOIN Ciudadano ci ON Fa.idFranja = ci.idFranja
INNER JOIN CiudadanoInteres ciI ON ci.idCiudadano = ciI.idCiudadano
INNER JOIN Interes i ON ciI.idInteres = i.idInteres
GROUP BY fa.idFranja, fa.descripcion, i.idInteres ,i.nombre, i.categoria
ORDER BY fa.descripcion, COUNT(ci.idCiudadano) DESC


--Consulta 4: Perfil sociodemográfico de los votantes 
SELECT
    fa.descripcion,
    ci.genero,
    e.intencionVoto,
    COUNT(e.idEncuesta) AS CantidadVotantes,
    CAST(AVG(CAST(e.probabilidadVoto AS DECIMAL (5,2))) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio

FROM Ciudadano ci
INNER JOIN FranjaEtaria fa ON ci.idFranja = fa.idFranja
INNER JOIN Encuesta e ON e.idCiudadano = ci.idCiudadano
GROUP BY fa.idFranja, fa.descripcion, ci.genero, e.intencionVoto
ORDER BY fa.descripcion ASC, ci.genero ASC, e.intencionVoto ASC


--Consulta 5: Distribución del caudal de votos por partido y comuna
SELECT
    c.nombre AS Comuna,
    e.intencionVoto AS Partido,
    COUNT(e.idEncuesta) AS Votos,
    CAST(AVG (CAST (e.probabilidadVoto AS DECIMAL(5,2))) AS DECIMAL (5,2)) AS GradoDeConviccionPromedio
    

FROM Ciudadano ci
INNER JOIN Encuesta e ON ci.idCiudadano = e.idCiudadano
INNER JOIN Barrio b ON b.idBarrio = ci.idBarrio
INNER JOIN Comuna c ON c.idComuna = b.idComuna
GROUP BY c.idComuna, c.nombre, e.intencionVoto
ORDER BY c.idComuna ASC, votos DESC


--Consulta 6: Detección de foco de campaña 
SELECT
    c.nombre AS Comuna,
    COUNT(ci.idCiudadano) AS CantidadIndecisos,
    CAST(AVG(CAST(e.probabilidadVoto AS DECIMAL(5,2))) AS DECIMAL (5,2)) AS GradoDeConviccionPromedio

FROM Comuna c
INNER JOIN Barrio b ON c.idComuna = b.idComuna
INNER JOIN Ciudadano ci ON b.idBarrio = ci.idBarrio
INNER JOIN vw_UltimaEncuesta e ON e.idCiudadano = ci.idCiudadano
WHERE e.esIndeciso = 1 OR e.probabilidadVoto < 50
GROUP BY c.idComuna, c.nombre
ORDER BY CantidadIndecisos DESC;

--Consulta 7: Temáticas prioritarias del núcleo duro 
SELECT
    i.nombre AS Tema,
    i.categoria AS Categoria,
    COUNT(ci.idCiudadano) AS VotantesFieles

FROM vw_Encuesta e
INNER JOIN Ciudadano ci ON ci.idCiudadano = e.idCiudadano
INNER JOIN CiudadanoInteres ciI ON ciI.idCiudadano = ci.idCiudadano
INNER JOIN Interes i ON ciI.idInteres = i.idInteres
WHERE e.esPartidoPropio = 1 AND e.probabilidadVoto >= 80 AND ciI.nivelPrioridad >= 4 
GROUP BY i.nombre, i.categoria
ORDER BY VotantesFieles DESC


--Consulta 8: Intereses de la ciudadanía según su afinidad política
SELECT
    e.intencionVoto AS Partido,
    i.nombre AS TematicaMasReclamada,
    i.categoria AS Categoria,
    COUNT(ci.idCiudadano) AS CantidadCiudadanos,
   CAST(AVG(CAST(ciI.nivelPrioridad AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS PromedioNivelPrioridad

FROM Encuesta e
INNER JOIN Ciudadano ci ON e.idCiudadano = ci.idCiudadano
INNER JOIN CiudadanoInteres ciI ON ci.idCiudadano = ciI.idCiudadano
INNER JOIN Interes i ON ciI.idInteres = i.idInteres
GROUP BY e.intencionVoto, i.idInteres ,i.nombre, i.categoria
ORDER BY e.intencionVoto ASC, CantidadCiudadanos DESC;

 
--Consulta 9: Votantes a captar (Indecisos) por franja etaria
SELECT
    fa.descripcion AS FranjaEtaria,
    COUNT(ci.idCiudadano) AS VotantesACaptar,
    CAST(AVG(CAST(e.probabilidadVoto AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio

FROM FranjaEtaria fa
INNER JOIN Ciudadano ci ON fa.idFranja = ci.idFranja
INNER JOIN vw_UltimaEncuesta e ON ci.idCiudadano = e.idCiudadano
WHERE e.esIndeciso = 1 OR e.probabilidadVoto < 50
GROUP BY fa.idFranja, fa.descripcion
ORDER BY VotantesACaptar DESC;

 --Consulta 10: Ranking general de intereses ciudadanos
SELECT 
    i.nombre AS Tematica,
    i.categoria AS Categoria,
    COUNT(ci_int.idCiudadano) AS TotalInteresadosCiudad,
    CAST(AVG(CAST(ci_int.nivelPrioridad AS DECIMAL(5,2))) AS DECIMAL (5,2)) AS PromedioNivelPrioridad

FROM Interes i
JOIN CiudadanoInteres ci_int ON i.idInteres = ci_int.idInteres
GROUP BY i.idInteres, i.nombre, i.categoria
ORDER BY TotalInteresadosCiudad DESC, PromedioNivelPrioridad DESC;


