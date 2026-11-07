USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarFranjaEtaria
    @idFranja INT,
    @descripcion VARCHAR(40)
AS
BEGIN
    BEGIN TRY

        IF @descripcion = ''
        BEGIN
            PRINT 'Error: La descripcion no puede estar vacia';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
        BEGIN
            PRINT 'Error: Ya existe una franja con ese ID';
            RETURN;
        END;

        INSERT INTO FranjaEtaria (idFranja, descripcion)
        VALUES (@idFranja, @descripcion);

        PRINT 'Franja etaria insertada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la franja etaria';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
GO