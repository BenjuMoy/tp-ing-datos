USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarFranjaEtaria
    @idFranja INT,
    @descripcion VARCHAR(40),
    @edadMinima INT,
    @edadMaxima INT = NULL   -- NULL = sin tope
AS
BEGIN
    BEGIN TRY

        IF @descripcion IS NULL OR @descripcion = ''
        BEGIN
            PRINT 'Error: La descripcion no puede estar vacia';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
        BEGIN
            PRINT 'Error: Ya existe una franja con ese ID';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM FranjaEtaria WHERE descripcion = @descripcion)
        BEGIN
            PRINT 'Error: Ya existe una franja con esa descripcion';
            RETURN;
        END;

        IF @edadMinima IS NULL OR @edadMinima < 16 OR (@edadMaxima IS NOT NULL AND @edadMaxima < @edadMinima)
        BEGIN
            PRINT 'Error: El rango de edades no es valido';
            RETURN;
        END;

        -- Dos rangos se pisan si cada uno empieza antes de que termine el otro
        IF EXISTS (SELECT 1 FROM FranjaEtaria
                   WHERE (edadMaxima IS NULL OR @edadMinima <= edadMaxima)
                     AND (@edadMaxima IS NULL OR edadMinima <= @edadMaxima))
        BEGIN
            PRINT 'Error: El rango de edades se superpone con otra franja';
            RETURN;
        END;

        INSERT INTO FranjaEtaria (idFranja, descripcion, edadMinima, edadMaxima)
        VALUES (@idFranja, @descripcion, @edadMinima, @edadMaxima);

        PRINT 'Franja etaria insertada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la franja etaria';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
GO
