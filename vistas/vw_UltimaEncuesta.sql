-- Una sola fila por ciudadano: su encuesta mas reciente.
-- Se usa en los reportes para contar votantes (y no encuestas).
-- Debe crearse antes que las demas vistas, la funcion y las consultas.
CREATE OR ALTER VIEW vw_UltimaEncuesta AS
SELECT
    t.idEncuesta,
    t.idCiudadano,
    t.fechaEncuesta,
    t.idOpcionVoto,
    o.nombre AS intencionVoto,
    o.esPartido,
    o.esPartidoPropio,
    -- Definicion unica de "indeciso" para todos los reportes: no eligio ningun partido
    -- (Indeciso o Voto en Blanco). Si cambia el criterio, se cambia solo aca.
    CAST(CASE WHEN o.esPartido = 0 THEN 1 ELSE 0 END AS BIT) AS esIndeciso,
    t.probabilidadVoto
FROM (
    SELECT
        e.*,
        ROW_NUMBER() OVER (
            PARTITION BY e.idCiudadano
            ORDER BY e.fechaEncuesta DESC, e.idEncuesta DESC  -- desempate: la ultima cargada
        ) AS nro
    FROM Encuesta e
) t
INNER JOIN OpcionVoto o ON o.idOpcionVoto = t.idOpcionVoto
WHERE t.nro = 1
