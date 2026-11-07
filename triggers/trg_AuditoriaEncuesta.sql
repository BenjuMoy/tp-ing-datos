
CREATE TRIGGER trg_AuditoriaEncuesta
ON Encuesta 
AFTER UPDATE 
AS
BEGIN
    INSERT INTO HistorialEncuesta (idEncuesta, fechaCambio, operacion, valorAnterior, valorNuevo )
    SELECT
        i.idEncuesta,
        SYSDATETIME(),
        'UPDATE',
        CONCAT('Intencion: ', od.nombre, ' - Probabilidad: ', d.probabilidadVoto),
        CONCAT('Intencion: ', oi.nombre, ' - Probabilidad: ', i.probabilidadVoto)


    FROM inserted i
    INNER JOIN deleted d ON i.idEncuesta = d.idEncuesta
    INNER JOIN OpcionVoto oi ON oi.idOpcionVoto = i.idOpcionVoto
    INNER JOIN OpcionVoto od ON od.idOpcionVoto = d.idOpcionVoto;
END;
GO
    


