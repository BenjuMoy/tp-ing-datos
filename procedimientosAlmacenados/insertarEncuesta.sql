USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarEncuesta
    @idEncuesta INT,
    @idCiudadano INT,
    @fechaEncuesta DATE,
    @intencionVoto VARCHAR(80),
    @probabilidadVoto DECIMAL(5,2)
AS
BEGIN
    BEGIN TRY

        IF @intencionVoto = ''
        BEGIN
            PRINT 'Error: la intencion de voto no puede estar vacia';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Encuesta WHERE idEncuesta = @idEncuesta)
        BEGIN
            PRINT 'error: ya existe una encuesta con ese ID';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Ciudadano WHERE idCiudadano = @idCiudadano)
        BEGIN
            PRINT 'error: el ciudadano indicado no existe';
            RETURN;
        END;

        IF @probabilidadVoto < 0 OR @probabilidadVoto > 100
        BEGIN
            PRINT 'error: la probabilidad debe estar entre 0 y 100';
            RETURN;
        END;

        INSERT INTO Encuesta(idEncuesta, idCiudadano, fechaEncuesta, intencionVoto, probabilidadVoto)
        VALUES(@idEncuesta, @idCiudadano, @fechaEncuesta, @intencionVoto, @probabilidadVoto);

        PRINT 'Encuesta insertada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la encuesta';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;