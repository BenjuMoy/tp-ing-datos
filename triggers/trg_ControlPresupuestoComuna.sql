
CREATE OR ALTER TRIGGER trg_ControlPresupuestoComuna
ON AccionCampania
AFTER INSERT, UPDATE
AS
BEGIN

    IF EXISTS(
        SELECT 1
        FROM AccionCampania ac
        WHERE ac.idComuna IN (SELECT DISTINCT idComuna FROM inserted)
        GROUP BY ac.idComuna
        HAVING SUM(ac.presupuestoAsignado) > 10000000.00 
    )
    BEGIN
        RAISERROR('Error: La suma total del presupuesto de las acciones asignadas a esta Comuna supera el límite máximo permitido.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO