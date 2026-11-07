CREATE OR ALTER VIEW vw_ResumenIntencionVoto AS
SELECT
    co.idComuna,
    co.nombre AS nombreComuna,
    f.descripcion AS FranjaEtaria,
    e.intencionVoto,
    e.esPartidoPropio,
    COUNT (e.idEncuesta) AS totalEncuestas,
    AVG(e.probabilidadVoto) AS promedioProbabilidad

FROM vw_Encuesta e
INNER JOIN Ciudadano ci ON e.idCiudadano = ci.idCiudadano
INNER JOIN Barrio ba ON ba.idBarrio = ci.idBarrio
INNER JOIN Comuna co ON ba.idComuna = co.idComuna
INNER JOIN FranjaEtaria f on f.idFranja = ci.idFranja
GROUP BY co.idComuna,co.nombre,f.descripcion,e.intencionVoto,e.esPartidoPropio
