CREATE OR ALTER VIEW v_ContrastarPresupuestoComuna AS
SELECT
    co.idComuna,
    co.nombre,
    COALESCE(h.cantidadHabitantes, 0) AS cantidadHabitantes,
    COALESCE(a.TotalAcciones, 0) AS TotalAcciones,
    COALESCE(a.totalPresupuesto, 0.00) AS totalPresupuesto

FROM Comuna co
-- Habitantes y acciones se agregan por separado para no multiplicar filas entre si
LEFT JOIN (
    SELECT ba.idComuna, COUNT(ci.idCiudadano) AS cantidadHabitantes
    FROM Barrio ba
    INNER JOIN Ciudadano ci ON ba.idBarrio = ci.idBarrio
    GROUP BY ba.idComuna
) h ON co.idComuna = h.idComuna
LEFT JOIN (
    SELECT idComuna, COUNT(idAccion) AS TotalAcciones, SUM(presupuestoAsignado) AS totalPresupuesto
    FROM AccionCampania
    GROUP BY idComuna
) a ON co.idComuna = a.idComuna
