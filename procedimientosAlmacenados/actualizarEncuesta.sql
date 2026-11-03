USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarEncuesta
    @idEncuesta INT,
    @idCiudadano INT,
    @fechaEncuesta DATE,
    @intencionVoto VARCHAR(80),
    @probabilidadVoto DECIMAL(5,2)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Encuesta WHERE idEncuesta = @idEncuesta)
        BEGIN
            PRINT 'error: la encuesta indicada no existe';
            RETURN;
        END;

        IF @intencionVoto IS NULL OR @intencionVoto = ''
        BEGIN
            PRINT 'error: la intencion de voto no puede estar vacia';
            RETURN;
        END;

        IF @probabilidadVoto < 0 OR @probabilidadVoto > 100
        BEGIN
            PRINT 'error: la probabilidad debe estar entre 0 y 100';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Ciudadano WHERE idCiudadano = @idCiudadano)
        BEGIN
            PRINT 'error: el ciudadano indicado no existe';
            RETURN;
        END;

        UPDATE Encuesta
        SET idCiudadano = @idCiudadano,fechaEncuesta = @fechaEncuesta,intencionVoto = @intencionVoto,probabilidadVoto = @probabilidadVoto
        WHERE idEncuesta = @idEncuesta;

        PRINT 'encuesta actualizada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la encuesta';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;