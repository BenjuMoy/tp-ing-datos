USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarOpcionVoto
    @idOpcionVoto INT,
    @nombre VARCHAR(80),
    @esPartido BIT,
    @esPartidoPropio BIT = 0
AS
BEGIN
    BEGIN TRY

        IF @nombre IS NULL OR @nombre = ''
        BEGIN
            PRINT 'Error: el nombre de la opcion de voto no puede estar vacio';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM OpcionVoto WHERE idOpcionVoto = @idOpcionVoto)
        BEGIN
            PRINT 'Error: ya existe una opcion de voto con ese ID';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM OpcionVoto WHERE nombre = @nombre)
        BEGIN
            PRINT 'Error: ya existe una opcion de voto con ese nombre';
            RETURN;
        END;

        IF @esPartidoPropio = 1 AND @esPartido = 0
        BEGIN
            PRINT 'Error: el partido propio tiene que ser un partido';
            RETURN;
        END;

        IF @esPartidoPropio = 1 AND EXISTS (SELECT 1 FROM OpcionVoto WHERE esPartidoPropio = 1)
        BEGIN
            PRINT 'Error: ya hay un partido propio definido';
            RETURN;
        END;

        INSERT INTO OpcionVoto (idOpcionVoto, nombre, esPartido, esPartidoPropio)
        VALUES (@idOpcionVoto, @nombre, @esPartido, @esPartidoPropio);

        PRINT 'Opcion de voto insertada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la opcion de voto';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
GO
