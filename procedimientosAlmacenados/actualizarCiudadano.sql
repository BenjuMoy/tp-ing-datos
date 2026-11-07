USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCiudadano
    @idCiudadano INT,
    @dni VARCHAR(12),
    @nombreCompleto VARCHAR(120),
    @genero VARCHAR(30),
    @fechaNacimiento DATE,
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

        IF @fechaNacimiento IS NULL OR @fechaNacimiento > CAST(GETDATE() AS DATE)
        BEGIN
            PRINT 'error: la fecha de nacimiento no es valida';
            RETURN;
        END;

        -- La edad tiene que caer en alguna franja etaria cargada
        DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
        DECLARE @edad INT = DATEDIFF(YEAR, @fechaNacimiento, @hoy)
            - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @fechaNacimiento, @hoy), @fechaNacimiento) > @hoy THEN 1 ELSE 0 END;

        IF NOT EXISTS (SELECT 1 FROM FranjaEtaria
                       WHERE @edad >= edadMinima AND (edadMaxima IS NULL OR @edad <= edadMaxima))
        BEGIN
            PRINT 'error: la edad del ciudadano no corresponde a ninguna franja etaria';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Barrio WHERE idBarrio = @idBarrio)
        BEGIN
            PRINT 'error: el barrio indicado no existe';
            RETURN;
        END;

        UPDATE Ciudadano
        SET dni = @dni, nombreCompleto = @nombreCompleto, genero = @genero, fechaNacimiento = @fechaNacimiento, idBarrio = @idBarrio
        WHERE idCiudadano = @idCiudadano;

        PRINT 'ciudadano actualizado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar el ciudadano';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
