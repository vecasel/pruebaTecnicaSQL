USE [PRUEBA]
GO

/****** Object:  StoredProcedure [dbo].[spAsignarPermisoRegistro]    Script Date: 17/11/2024 16:54:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para asignar permisos a nivel de registro, por usuario o rol
CREATE PROCEDURE [dbo].[spAsignarPermisoRegistro] (
    @idRol BIGINT,                          -- Identificador del rol (si es NULL, se asigna a un usuario)
    @idUsuarioCompania BIGINT,              -- Identificador de la relación usuario-compañía
    @idPermiso BIGINT,                             -- Identificador del permiso
    @idEntidadCatalogo INT,                        -- Identificador del catálogo de entidades
    @idRegistro BIGINT,                            -- Identificador del registro específico
    @incluir BIT = 1                               -- Indica si se incluye (1) o excluye (0) el permiso
)
AS
BEGIN


	IF @idRol IS NULL AND @idUsuarioCompania IS NULL
    BEGIN
        RAISERROR('Se debe especificar un rol o un usuario-compañía.', 16, 1);
        RETURN;
    END
    

	-- Si @incluir es 0, eliminar el registro correspondiente
    IF @incluir = 0
    BEGIN
        -- Bloque para roles
        IF @idRol IS NOT NULL
        BEGIN
            DELETE FROM PermiRoleRecord
            WHERE role_id = @idRol 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idEntidadCatalogo 
              AND perrc_record = @idRegistro;
            RETURN;
        END;

        -- Bloque para usuarios
        IF @idUsuarioCompania IS NOT NULL
        BEGIN
            DELETE FROM PermiUserRecord
            WHERE usercompany_id = @idUsuarioCompania 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idEntidadCatalogo 
              AND peusr_record = @idRegistro;
            RETURN;
        END;
    END;

    -- Bloque para asignar permisos a roles
    IF @idRol IS NOT NULL
    BEGIN
        -- Validación: Comprobar si el permiso ya está asignado al rol para el registro específico
        IF EXISTS (
            SELECT 1 
            FROM PermiRoleRecord
            WHERE role_id = @idRol 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idEntidadCatalogo 
              AND perrc_record = @idRegistro
        )
        BEGIN
            RAISERROR('El permiso ya existe para este rol y registro.', 16, 1);
            RETURN;
        END;

        -- Inserción: Asignar el permiso al rol para el registro específico
        INSERT INTO PermiRoleRecord (role_id, permission_id, entitycatalog_id, perrc_record, perrc_include)
        VALUES (@idRol, @idPermiso, @idEntidadCatalogo, @idRegistro, @incluir);
    END;

    -- Bloque para asignar permisos a usuarios
    IF @idUsuarioCompania IS NOT NULL
    BEGIN
        -- Validación: Comprobar si el permiso ya está asignado al usuario para el registro específico
        IF EXISTS (
            SELECT 1 
            FROM PermiUserRecord
            WHERE usercompany_id = @idUsuarioCompania 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idEntidadCatalogo 
              AND peusr_record = @idRegistro
        )
        BEGIN
            RAISERROR('El permiso ya existe para este usuario y registro.', 16, 1);
            RETURN;
        END;

        -- Inserción: Asignar el permiso al usuario para el registro específico
        INSERT INTO PermiUserRecord (usercompany_id, permission_id, entitycatalog_id, peusr_record, peusr_include)
        VALUES (@idUsuarioCompania, @idPermiso, @idEntidadCatalogo, @idRegistro, @incluir);
    END;
END;
GO


