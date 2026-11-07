USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCiudadano
    @idCiudadano INT,
    @dni VARCHAR(12),
    @nombreCompleto VARCHAR(120),
    @genero VARCHAR(30),
    @idFranja INT,
    @idBarrio INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Ciudadano WHERE idCiudadano = @idCiudadano)
        BEGIN
            PRINT 'error: el ciudadano indicado no existe';
            RETURN;
        END;

        IF @dni IS NULL OR @dni = '' OR @nombreCompleto IS NULL OR @nombreCompleto = '' OR @genero IS NULL OR @genero = ''
        BEGIN
            PRINT 'error: los datos del ciudadano no pueden estar vacios';
            RETURN;
        END;

        IF EXISTS (
            SELECT 1 FROM Ciudadano
            WHERE dni = @dni AND idCiudadano <> @idCiudadano
        )
        BEGIN
            PRINT 'error: ya existe un ciudadano con ese DNI';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
        BEGIN
            PRINT 'error: la franja etaria indicada no existe';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Barrio WHERE idBarrio = @idBarrio)
        BEGIN
            PRINT 'error: el barrio indicado no existe';
            RETURN;
        END;

        UPDATE Ciudadano
        SET dni = @dni, nombreCompleto = @nombreCompleto,genero = @genero,idFranja = @idFranja,idBarrio = @idBarrio
        WHERE idCiudadano = @idCiudadano;

        PRINT 'ciudadano actualizado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar el ciudadano';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;