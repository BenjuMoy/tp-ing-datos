
CREATE OR ALTER VIEW vw_Encuesta AS
SELECT
    e.idEncuesta,
    e.idCiudadano,
    e.fechaEncuesta,
    e.intencionVoto,
    e.probabilidadVoto,

    CAST(CASE WHEN e.intencionVoto IN ('Indeciso', 'Voto en Blanco') THEN 1 ELSE 0 END AS BIT) AS esIndeciso,
    CAST(CASE WHEN e.intencionVoto = 'Alianza Innovadora' THEN 1 ELSE 0 END AS BIT) AS esPartidoPropio
FROM Encuesta e
