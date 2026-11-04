CREATE OR ALTER VIEW v_ContrastarPresupuestoComuna AS
SELECT 
    co.idComuna,
    co.nombre,
    COUNT(DISTINCT ci.idCiudadano) AS cantidadHabitantes,
    COUNT(a.idAccion) AS TotalAcciones,
    COALESCE(SUM(a.presupuestoAsignado),0.00) AS totalPresupuesto


FROM Comuna co
INNER JOIN Barrio ba ON co.idComuna = ba.idComuna
INNER JOIN Ciudadano ci ON ba.idBarrio = ci.idBarrio
LEFT JOIN AccionCampania a ON co.idComuna = a.idComuna
GROUP BY
    co.idComuna,
    co.nombre
