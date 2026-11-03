
CREATE TRIGGER trg_ControlPresupuestoComuna
ON AccionCampania
AFTER INSERT, UPDATE
AS
BEGIN

    IF EXISTS(
        SELECT 1
        FROM inserted i
        JOIN AccionCampania ac ON i.idComuna = ac.idComuna
        GROUP BY i.idComuna
        HAVING SUM(ac.presupuestoAsignado) > 10000000.00 
    )
    BEGIN
        RAISERROR('Error: La suma total del presupuesto de las acciones asignadas a esta Comuna supera el límite máximo permitido.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO