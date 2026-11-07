CREATE OR ALTER TRIGGER trg_AuditoriaEncuesta
ON Encuesta 
AFTER UPDATE 
AS
BEGIN
    INSERT INTO HistorialEncuesta (idEncuesta, fechaCambio, operacion, valorAnterior, valorNuevo )
    SELECT
        i.idEncuesta,
        SYSDATETIME(),
        'UPDATE',
        CONCAT('Intencion: ', d.intencionVoto, ' - Probabilidad: ', d.probabilidadVoto),
        CONCAT('Intencion: ', i.intencionVoto, ' - Probabilidad: ', i.probabilidadVoto)


    FROM inserted i
    INNER JOIN deleted d ON i.idEncuesta = d.idEncuesta;
END;
GO
    


