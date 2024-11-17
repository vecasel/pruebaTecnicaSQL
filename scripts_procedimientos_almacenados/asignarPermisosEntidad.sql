USE [PRUEBA]
GO

/****** Object:  StoredProcedure [dbo].[spAsignarPermisoEntidad]    Script Date: 17/11/2024 16:53:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para asignar permisos a nivel de entidad, por usuario o rol
CREATE PROCEDURE [dbo].[spAsignarPermisoEntidad] (
    @idRol BIGINT = NULL,                          -- Identificador del rol (si es NULL, se asigna a un usuario)
    @idUsuarioCompania BIGINT = NULL,              -- Identificador de la relación usuario-compañía
    @idPermiso BIGINT,                             -- Identificador del permiso
    @idCatalogoEntidad INT,                        -- Identificador del catálogo de entidades
    @incluir BIT = 1                               -- Indica si se incluye (1) o excluye (0) el permiso
)
AS
BEGIN
   

   -- Verificar que el parámetro 'role_id' o 'usercompany_id' no estén ambos a NULL
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
            DELETE FROM PermiRole
            WHERE role_id = @idRol 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idCatalogoEntidad;
            RETURN;
        END;

        -- Bloque para usuarios
        IF @idUsuarioCompania IS NOT NULL
        BEGIN
            DELETE FROM PermiUser
            WHERE usercompany_id = @idUsuarioCompania 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idCatalogoEntidad;
            RETURN;
        END;
    END;

    -- Bloque para asignar permisos a roles
    IF @idRol IS NOT NULL
    BEGIN
        -- Comprobar si el permiso ya está asignado al rol para esta entidad
        IF EXISTS (
            SELECT 1 
            FROM PermiRole
            WHERE role_id = @idRol 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idCatalogoEntidad
        )
        BEGIN
            RAISERROR('El permiso ya existe para este rol y entidad.', 16, 1);
            RETURN;
        END;

        -- Insertar el nuevo permiso para el rol
        INSERT INTO PermiRole (role_id, permission_id, entitycatalog_id, perol_include)
        VALUES (@idRol, @idPermiso, @idCatalogoEntidad, @incluir);
    END;

    -- Bloque para asignar permisos a usuarios
    IF @idUsuarioCompania IS NOT NULL
    BEGIN
        -- Comprobar si el permiso ya está asignado al usuario para esta entidad
        IF EXISTS (
            SELECT 1 
            FROM PermiUser
            WHERE usercompany_id = @idUsuarioCompania 
              AND permission_id = @idPermiso 
              AND entitycatalog_id = @idCatalogoEntidad
        )
        BEGIN
            RAISERROR('El permiso ya existe para este usuario y entidad.', 16, 1);
            RETURN;
        END;

        -- Insertar el nuevo permiso para el usuario
        INSERT INTO PermiUser (usercompany_id, permission_id, entitycatalog_id, peusr_include)
        VALUES (@idUsuarioCompania, @idPermiso, @idCatalogoEntidad, @incluir);
    END;
END;

GO


