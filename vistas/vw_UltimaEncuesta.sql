CREATE OR ALTER VIEW vw_UltimaEncuesta AS
SELECT
    t.idEncuesta,
    t.idCiudadano,
    t.fechaEncuesta,
    t.intencionVoto,
    t.probabilidadVoto,
  
    CAST(CASE WHEN t.intencionVoto IN ('Indeciso', 'Voto en Blanco') THEN 1 ELSE 0 END AS BIT) AS esIndeciso,
    CAST(CASE WHEN t.intencionVoto = 'Alianza Innovadora' THEN 1 ELSE 0 END AS BIT) AS esPartidoPropio
FROM (
    SELECT
        e.*,
        ROW_NUMBER() OVER ( 
            PARTITION BY e.idCiudadano 
            ORDER BY e.fechaEncuesta DESC, e.idEncuesta DESC
        ) AS nro
    FROM Encuesta e
) t
WHERE t.nro = 1;