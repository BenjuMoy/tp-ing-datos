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
LEFT JOIN vw_ResumenIntencionVoto v ON p.idComuna = v.idComuna AND v.esPartidoPropio = 1
GROUP BY p.idComuna, p.nombre, p.totalPresupuesto, p.TotalAcciones
ORDER BY p.totalPresupuesto DESC;

/*Consulta3*/

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


/*Consulta 4*/
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


/*Consulta 5*/
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


--Consulta 6
SELECT
    c.nombre,
    COUNT(ci.idCiudadano) AS CantidadIndecisos,
    CAST(AVG(CAST(e.probabilidadVoto AS DECIMAL(5,2))) AS DECIMAL (5,2)) AS GradoDeConviccionPromedio

FROM Comuna c
INNER JOIN Barrio b ON c.idComuna = b.idComuna
INNER JOIN Ciudadano ci ON b.idBarrio = ci.idBarrio
<<<<<<< HEAD
INNER JOIN vw_Encuesta e ON e.idCiudadano = ci.idCiudadano
WHERE e.esIndeciso = 1
=======
INNER JOIN vw_UltimaEncuesta e ON e.idCiudadano = ci.idCiudadano
WHERE e.esPartido = 0 OR e.probabilidadVoto<50
>>>>>>> parent of 40bf75c (solucionado punto 8)
GROUP BY c.idComuna, c.nombre
ORDER BY CantidadIndecisos DESC

--Consulta 7
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


--Consulta 8
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

 
--Consulta 9
SELECT
    fa.descripcion AS FranjaEtaria,
    COUNT(ci.idCiudadano) AS VotantesACaptar,
    CAST(AVG(CAST(e.probabilidadVoto AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio


FROM FranjaEtaria fa
INNER JOIN Ciudadano ci ON fa.idFranja = ci.idFranja
<<<<<<< HEAD
INNER JOIN vw_Encuesta e ON ci.idCiudadano = e.idCiudadano
WHERE e.esIndeciso = 1
=======
INNER JOIN vw_UltimaEncuesta e ON ci.idCiudadano = e.idCiudadano
WHERE e.intencionVoto = 'Indeciso' OR e.probabilidadVoto < 50
>>>>>>> parent of 40bf75c (solucionado punto 8)
GROUP BY fa.idFranja, fa.descripcion
ORDER BY VotantesACaptar DESC;

 --Consulta 10
SELECT 
    i.nombre AS Tematica,
    i.categoria AS Categoria,
    COUNT(ci_int.idCiudadano) AS TotalInteresadosCiudad,
    AVG(CAST(ci_int.nivelPrioridad AS DECIMAL(5,2))) AS PromedioNivelPrioridad

FROM Interes i
JOIN CiudadanoInteres ci_int ON i.idInteres = ci_int.idInteres
GROUP BY i.idInteres, i.nombre, i.categoria
ORDER BY TotalInteresadosCiudad DESC, PromedioNivelPrioridad DESC;


--Consulta 11 (RF7): distribucion de intereses por comuna y barrio
SELECT
    c.nombre AS Comuna,
    b.nombre AS Barrio,
    i.nombre AS Interes,
    i.categoria AS Categoria,
    COUNT(ciI.idCiudadano) AS CantidadInteresados,
    CAST(AVG(CAST(ciI.nivelPrioridad AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS PrioridadPromedio

FROM Comuna c
INNER JOIN Barrio b ON b.idComuna = c.idComuna
INNER JOIN Ciudadano ci ON ci.idBarrio = b.idBarrio
INNER JOIN CiudadanoInteres ciI ON ciI.idCiudadano = ci.idCiudadano
INNER JOIN Interes i ON i.idInteres = ciI.idInteres
GROUP BY c.idComuna, c.nombre, b.idBarrio, b.nombre, i.idInteres, i.nombre, i.categoria
ORDER BY c.idComuna, b.nombre, CantidadInteresados DESC;


--Consulta 12 (RF8): acciones de campania y presupuesto por comuna e interes objetivo
SELECT
    c.nombre AS Comuna,
    i.nombre AS InteresObjetivo,
    i.categoria AS Categoria,
    COUNT(a.idAccion) AS CantidadAcciones,
    SUM(a.presupuestoAsignado) AS PresupuestoTotal

FROM AccionCampania a
INNER JOIN Comuna c ON c.idComuna = a.idComuna
INNER JOIN Interes i ON i.idInteres = a.idInteresObjetivo
GROUP BY c.idComuna, c.nombre, i.idInteres, i.nombre, i.categoria
ORDER BY c.idComuna, PresupuestoTotal DESC;


--Consulta 13 (RNF4): intencion de voto por semana dentro de un rango de fechas
DECLARE @desde DATE = '2026-10-01';
DECLARE @hasta DATE = '2026-10-31';

SELECT
    DATEADD(DAY, 1 - DATEPART(WEEKDAY, e.fechaEncuesta), e.fechaEncuesta) AS InicioSemana,
    e.intencionVoto AS Partido,
    COUNT(e.idEncuesta) AS CantidadEncuestas,
    CAST(AVG(e.probabilidadVoto) AS DECIMAL(5,2)) AS GradoDeConviccionPromedio

FROM Encuesta e
WHERE e.fechaEncuesta BETWEEN @desde AND @hasta
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, e.fechaEncuesta), e.fechaEncuesta), e.intencionVoto
ORDER BY InicioSemana, CantidadEncuestas DESC;
