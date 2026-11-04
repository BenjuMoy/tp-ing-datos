/*Consulta 1*/
SELECT
    nombreComuna AS Comuna,
    intencionVoto,
    SUM(totalEncuestas) AS TotalVotos,
    CAST(SUM(totalEncuestas * promedioProbabilidad)/SUM(totalEncuestas) AS DECIMAL(5,2)) AS ProbabilidadPonderada

FROM vw_ResumenIntencionVoto
GROUP BY idComuna, nombreComuna, intencionVoto
ORDER BY idComuna, totalVotos DESC;


/*Consulta2*/
SELECT 
    p.nombre AS Comuna,
    p.totalPresupuesto,
    p.TotalAcciones,
    COALESCE(SUM(v.totalEncuestas), 0) AS CantidadVotantesAlianza,
    COALESCE(CAST(SUM(v.totalEncuestas * v.promedioProbabilidad) / SUM(v.totalEncuestas) AS DECIMAL(5,2)), 0.00) AS ProbabilidadPonderadaAlianza
    
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