USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarCiudadanoInteres
    @idCiudadano INT,
    @idInteres INT,
    @nivelPrioridad INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Ciudadano WHERE idCiudadano = @idCiudadano)
        BEGIN
            PRINT 'Error: El ciudadano indicado no existe';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Interes WHERE idInteres = @idInteres)
        BEGIN
            PRINT 'Error: El interes indicado no existe';
            RETURN;
        END;

        IF @nivelPrioridad < 1 OR @nivelPrioridad > 5
        BEGIN
            PRINT 'Error: El nivel de prioridad debe estar entre 1 y 5';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM CiudadanoInteres
                   WHERE idCiudadano = @idCiudadano AND idInteres = @idInteres)
        BEGIN
            PRINT 'Error: Este ciudadano ya tiene registrado ese interes';
            RETURN;
        END;

        INSERT INTO CiudadanoInteres(idCiudadano, idInteres, nivelPrioridad)
        VALUES(@idCiudadano, @idInteres, @nivelPrioridad);

        PRINT 'Interes del ciudadano insertado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el interes del ciudadano';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;