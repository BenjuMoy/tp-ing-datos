-- Encuesta con las definiciones de negocio que usan los reportes.
-- Cada criterio se define solo aca; si cambia, se cambia en un unico lugar.
-- Debe crearse antes que vw_ResumenIntencionVoto y las consultas.
CREATE OR ALTER VIEW vw_Encuesta AS
SELECT
    e.idEncuesta,
    e.idCiudadano,
    e.fechaEncuesta,
    e.intencionVoto,
    e.probabilidadVoto,
    -- Indeciso: no eligio ningun partido
    CAST(CASE WHEN e.intencionVoto IN ('Indeciso', 'Voto en Blanco') THEN 1 ELSE 0 END AS BIT) AS esIndeciso,
    -- Partido para el que trabaja la campania
    CAST(CASE WHEN e.intencionVoto = 'Alianza Innovadora' THEN 1 ELSE 0 END AS BIT) AS esPartidoPropio
FROM Encuesta e
