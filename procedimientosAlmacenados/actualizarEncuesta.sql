USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarEncuesta
    @idEncuesta INT,
    @idCiudadano INT,
    @fechaEncuesta DATE,
    @idOpcionVoto INT,
    @probabilidadVoto DECIMAL(5,2)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Encuesta WHERE idEncuesta = @idEncuesta)
        BEGIN
            PRINT 'error: la encuesta indicada no existe';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM OpcionVoto WHERE idOpcionVoto = @idOpcionVoto)
        BEGIN
            PRINT 'error: la opcion de voto indicada no existe';
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
        SET idCiudadano = @idCiudadano,fechaEncuesta = @fechaEncuesta,idOpcionVoto = @idOpcionVoto,probabilidadVoto = @probabilidadVoto
        WHERE idEncuesta = @idEncuesta;

        PRINT 'encuesta actualizada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la encuesta';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;