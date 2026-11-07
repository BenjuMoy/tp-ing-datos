USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarCategoria
    @idCategoria INT,
    @nombre VARCHAR(50)
AS
BEGIN
    BEGIN TRY

        IF @nombre IS NULL OR @nombre = ''
        BEGIN
            PRINT 'Error: el nombre de la categoria no puede estar vacio';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Categoria WHERE idCategoria = @idCategoria)
        BEGIN
            PRINT 'Error: ya existe una categoria con ese ID';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Categoria WHERE nombre = @nombre)
        BEGIN
            PRINT 'Error: ya existe una categoria con ese nombre';
            RETURN;
        END;

        INSERT INTO Categoria (idCategoria, nombre)
        VALUES (@idCategoria, @nombre);

        PRINT 'Categoria insertada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la categoria';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
GO
