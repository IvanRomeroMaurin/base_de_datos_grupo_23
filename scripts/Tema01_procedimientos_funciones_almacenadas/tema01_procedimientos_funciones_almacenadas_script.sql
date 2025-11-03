-- Procedimiento: sp_insertar_persona
-- Descripción: Inserta una nueva persona en la tabla persona, con validación de duplicado
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

-- Procedimiento: sp_actualizar_persona
-- Descripción: Actualiza los datos principales de una persona por su DNI, validando existencia
CREATE PROCEDURE sp_actualizar_persona
    @dni NUMERIC(8),
    @correo_electronico VARCHAR(200),
    @telefono VARCHAR(50),
    @id_direccion INT,
    @estado BIT
AS
BEGIN

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

-- Procedimiento: sp_eliminar_persona
-- Descripción: Elimina una persona según su DNI, con validación de existencia
CREATE PROCEDURE sp_eliminar_persona
    @dni NUMERIC(8)
AS
BEGIN

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

-- Ver antes (muestra subset a actualizar)
    SELECT dni, correo_electronico, telefono, id_direccion, estado
    FROM persona
    WHERE dni IN (15271231,17169848,19068465,22865699,25035547,29104012,32358784,35071094,37240942,41038176);

    PRINT '--- Ejecutando UPDATES...';

-- Update de algunos registros de la tabla persona utilizando el procedimiento sp_actualizar_persona
EXEC sp_actualizar_persona @dni=15271231, @correo_electronico='juan.perez01@update.com',  @telefono='3717770001', @id_direccion=101, @estado=1;
EXEC sp_actualizar_persona @dni=17169848, @correo_electronico='gabriel.torres08@update.com', @telefono='3717770008', @id_direccion=108, @estado=0;
EXEC sp_actualizar_persona @dni=19068465, @correo_electronico='hernan.cruz15@update.com',   @telefono='3717770015', @id_direccion=115, @estado=1;
EXEC sp_actualizar_persona @dni=22865699, @correo_electronico='ignacio.correa29@update.com',@telefono='3717770029', @id_direccion=129, @estado=1;
EXEC sp_actualizar_persona @dni=25035547, @correo_electronico='nicolas.pereyra37@update.com',@telefono='3717770037',@id_direccion=137, @estado=1;
EXEC sp_actualizar_persona @dni=29104012, @correo_electronico='mario.mendez52@update.com',  @telefono='3717770052', @id_direccion=152, @estado=0;
EXEC sp_actualizar_persona @dni=32358784, @correo_electronico='alejandro.navarro64@upd.com',@telefono='3717770064', @id_direccion=164, @estado=1;
EXEC sp_actualizar_persona @dni=35071094, @correo_electronico='rodrigo.bustos74@upd.com',   @telefono='3717770074', @id_direccion=174, @estado=1;
EXEC sp_actualizar_persona @dni=37240942, @correo_electronico='cristian.leon82@upd.com',    @telefono='3717770082', @id_direccion=182, @estado=0;
EXEC sp_actualizar_persona @dni=41038176, @correo_electronico='franco.dominguez96@upd.com', @telefono='3717770096', @id_direccion=196, @estado=1;

-- Verificacion de updates
PRINT '--- Verificación de UPDATES:';
    SELECT dni, correo_electronico, telefono, id_direccion, estado
    FROM persona
    WHERE dni IN (15271231,17169848,19068465,22865699,25035547,29104012,32358784,35071094,37240942,41038176);


-- Ver antes (subset a eliminar)
SELECT dni, nombre, apellido
FROM persona
WHERE dni IN (17712310,21509544,24493085,28561550,33443708,36156018,39410790,41851869);
PRINT '--- Ejecutando DELETES...';

-- Delete de algunos registros de la tabla persona utilizando el procedimiento sp_eliminar_persona
EXEC sp_eliminar_persona @dni=17712310;
EXEC sp_eliminar_persona @dni=21509544;
EXEC sp_eliminar_persona @dni=24493085;
EXEC sp_eliminar_persona @dni=28561550;
EXEC sp_eliminar_persona @dni=33443708;
EXEC sp_eliminar_persona @dni=36156018;
EXEC sp_eliminar_persona @dni=39410790;
EXEC sp_eliminar_persona @dni=41851869;

-- Verificar Deletes
PRINT '--- Verificación de DELETES (no deberían existir filas):';
    SELECT dni, nombre, apellido
    FROM persona
    WHERE dni IN (17712310,21509544,24493085,28561550,33443708,36156018,39410790,41851869);


-- Funcion almacenada para calcular la edad exacta de una persona(pasamos por parametro su dni)
CREATE FUNCTION fn_calcular_edad_por_dni
(
    @dni NUMERIC(8)
)
RETURNS INT
AS
BEGIN
    DECLARE @fecha_nac DATE;

    -- Obtenemos la fecha de nacimiento de la persona
    SELECT @fecha_nac = fecha_nacimiento
    FROM persona
    WHERE dni = @dni;

    IF @fecha_nac IS NULL
        RETURN NULL;

    DECLARE @edad INT = DATEDIFF(YEAR, @fecha_nac, GETDATE());

    -- Ajuste si aún no cumplió años este año
    IF DATEADD(YEAR, @edad, @fecha_nac) > GETDATE()
        SET @edad = @edad - 1;

    RETURN @edad;
END;
GO

-- Uso de la funcion anterior SELECT dbo.fn_calcular_edad_por_dni(15271231) AS edad_actual;
SELECT dbo.fn_calcular_edad_por_dni(15271231) AS edad_actual;


