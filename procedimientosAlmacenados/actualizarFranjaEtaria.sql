USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarFranjaEtaria
    @idFranja INT,
    @descripcion VARCHAR(40),
    @edadMinima INT,
    @edadMaxima INT = NULL   -- NULL = sin tope
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
        BEGIN
            PRINT 'error: la franja etaria indicada no existe';
            RETURN;
        END;

        IF @descripcion IS NULL OR @descripcion = ''
        BEGIN
            PRINT 'error: la descripcion no puede estar vacia';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM FranjaEtaria WHERE descripcion = @descripcion AND idFranja <> @idFranja)
        BEGIN
            PRINT 'error: ya existe una franja con esa descripcion';
            RETURN;
        END;

        IF @edadMinima IS NULL OR @edadMinima < 16 OR (@edadMaxima IS NOT NULL AND @edadMaxima < @edadMinima)
        BEGIN
            PRINT 'error: el rango de edades no es valido';
            RETURN;
        END;

        -- Dos rangos se pisan si cada uno empieza antes de que termine el otro
        IF EXISTS (SELECT 1 FROM FranjaEtaria
                   WHERE idFranja <> @idFranja
                     AND (edadMaxima IS NULL OR @edadMinima <= edadMaxima)
                     AND (@edadMaxima IS NULL OR edadMinima <= @edadMaxima))
        BEGIN
            PRINT 'error: el rango de edades se superpone con otra franja';
            RETURN;
        END;

        UPDATE FranjaEtaria
        SET descripcion = @descripcion, edadMinima = @edadMinima, edadMaxima = @edadMaxima
        WHERE idFranja = @idFranja;

        PRINT 'franja etaria actualizada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la franja etaria';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
