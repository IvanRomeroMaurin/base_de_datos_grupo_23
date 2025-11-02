-- =============================================
-- Procedimiento: sp_insertar_persona
-- Descripción: Inserta una nueva persona en la tabla persona, con validación de duplicado
-- =============================================
CREATE PROCEDURE sp_insertar_persona
    @dni NUMERIC(8),
    @nombre VARCHAR(200),
    @apellido VARCHAR(200),
    @correo_electronico VARCHAR(200),
    @telefono VARCHAR(50),
    @fecha_nacimiento DATE,
    @id_direccion INT,
    @estado BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el DNI ya existe
    IF EXISTS (SELECT 1 FROM persona WHERE dni = @dni)
    BEGIN
        PRINT 'Error: Ya existe una persona con ese DNI.';
        RETURN;
    END;

    -- Verificar si el correo ya está en uso
    IF EXISTS (SELECT 1 FROM persona WHERE correo_electronico = @correo_electronico)
    BEGIN
        PRINT 'Error: El correo electrónico ya está registrado.';
        RETURN;
    END;

    INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado)
    VALUES (@dni, @nombre, @apellido, @correo_electronico, @telefono, @fecha_nacimiento, @id_direccion, @estado);

    PRINT 'Persona insertada correctamente.';
END;
GO

-- =============================================
-- Procedimiento: sp_actualizar_persona
-- Descripción: Actualiza los datos principales de una persona por su DNI, validando existencia
-- =============================================
CREATE PROCEDURE sp_actualizar_persona
    @dni NUMERIC(8),
    @correo_electronico VARCHAR(200),
    @telefono VARCHAR(50),
    @id_direccion INT,
    @estado BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si existe la persona
    IF NOT EXISTS (SELECT 1 FROM persona WHERE dni = @dni)
    BEGIN
        PRINT 'Error: No existe una persona con ese DNI.';
        RETURN;
    END;

    UPDATE persona
    SET correo_electronico = @correo_electronico,
        telefono = @telefono,
        id_direccion = @id_direccion,
        estado = @estado
    WHERE dni = @dni;

    PRINT 'Persona actualizada correctamente.';
END;
GO

-- =============================================
-- Procedimiento: sp_eliminar_persona
-- Descripción: Elimina una persona según su DNI, con validación de existencia
-- =============================================
CREATE PROCEDURE sp_eliminar_persona
    @dni NUMERIC(8)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la persona existe
    IF NOT EXISTS (SELECT 1 FROM persona WHERE dni = @dni)
    BEGIN
        PRINT 'Error: No existe una persona con ese DNI.';
        RETURN;
    END;

    DELETE FROM persona WHERE dni = @dni;

    PRINT 'Persona eliminada correctamente.';
END;
GO


