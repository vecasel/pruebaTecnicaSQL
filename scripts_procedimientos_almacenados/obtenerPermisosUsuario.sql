USE [PRUEBA]
GO

/****** Object:  StoredProcedure [dbo].[spObtenerPermisosUsuario]    Script Date: 17/11/2024 16:54:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para obtener los permisos asignados a un usuario
CREATE PROCEDURE [dbo].[spObtenerPermisosUsuario] (
    @idCatalogoEntidad INT, -- Identificador del catálogo de entidades
    @idUsuario BIGINT       -- Identificador del usuario
)
AS
BEGIN
    -- Declarar una tabla temporal para almacenar los resultados
    DECLARE @tablaPermisos TABLE (
        NombrePermiso NVARCHAR(255),
        PuedeCrear BIT,
        PuedeLeer BIT,
        PuedeActualizar BIT,
        PuedeEliminar BIT,
        PuedeImportar BIT,
        PuedeExportar BIT,
        EsRegistroEspecifico BIT
    );

    -- 1. Obtener permisos a nivel de entidad directamente asignados al usuario (PermiUser)
    INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico)
    SELECT 
        p.name AS NombrePermiso,
        p.can_create AS PuedeCrear,
        p.can_read AS PuedeLeer,
        p.can_update AS PuedeActualizar,
        p.can_delete AS PuedeEliminar,
        p.can_import AS PuedeImportar,
        p.can_export AS PuedeExportar,
        0 AS EsRegistroEspecifico -- A nivel de entidad, no se aplica a registros específicos
    FROM 
        PermiUser pu
        INNER JOIN Permission p ON pu.permission_id = p.id_permi
    WHERE 
        pu.usercompany_id IN (
            SELECT id_useco FROM UserCompany WHERE user_id = @idUsuario
        )
        AND pu.entitycatalog_id = @idCatalogoEntidad
        AND pu.peusr_include = 1; -- Solo permisos incluidos

    -- 2. Obtener permisos a nivel de entidad asignados al rol del usuario (PermiRole)
    INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico)
    SELECT 
        p.name AS NombrePermiso,
        p.can_create AS PuedeCrear,
        p.can_read AS PuedeLeer,
        p.can_update AS PuedeActualizar,
        p.can_delete AS PuedeEliminar,
        p.can_import AS PuedeImportar,
        p.can_export AS PuedeExportar,
        0 AS EsRegistroEspecifico -- A nivel de entidad, no se aplica a registros específicos
    FROM 
        PermiRole pr
        INNER JOIN Permission p ON pr.permission_id = p.id_permi
    WHERE 
        pr.role_id IN (
            SELECT role_id FROM UserCompany WHERE user_id = @idUsuario
        )
        AND pr.entitycatalog_id = @idCatalogoEntidad
        AND pr.perol_include = 1; -- Solo permisos incluidos

    -- 3. Obtener permisos específicos de registro asignados al usuario (PermiUserRecord)
    INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico)
    SELECT 
        p.name AS NombrePermiso,
        p.can_create AS PuedeCrear,
        p.can_read AS PuedeLeer,
        p.can_update AS PuedeActualizar,
        p.can_delete AS PuedeEliminar,
        p.can_import AS PuedeImportar,
        p.can_export AS PuedeExportar,
        1 AS EsRegistroEspecifico -- Aplica a registros específicos
    FROM 
        PermiUserRecord pur
        INNER JOIN Permission p ON pur.permission_id = p.id_permi
    WHERE 
        pur.usercompany_id IN (
            SELECT id_useco FROM UserCompany WHERE user_id = @idUsuario
        )
        AND pur.entitycatalog_id = @idCatalogoEntidad
        AND pur.peusr_record IS NOT NULL
        AND pur.peusr_include = 1; -- Solo permisos incluidos

    -- 4. Obtener permisos específicos de registro asignados al rol del usuario (PermiRoleRecord)
    INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico)
    SELECT 
        p.name AS NombrePermiso,
        p.can_create AS PuedeCrear,
        p.can_read AS PuedeLeer,
        p.can_update AS PuedeActualizar,
        p.can_delete AS PuedeEliminar,
        p.can_import AS PuedeImportar,
        p.can_export AS PuedeExportar,
        1 AS EsRegistroEspecifico -- Aplica a registros específicos
    FROM 
        PermiRoleRecord prr
        INNER JOIN Permission p ON prr.permission_id = p.id_permi
    WHERE 
        prr.role_id IN (
            SELECT role_id FROM UserCompany WHERE user_id = @idUsuario
        )
        AND prr.entitycatalog_id = @idCatalogoEntidad
        AND prr.perrc_record IS NOT NULL
        AND prr.perrc_include = 1; -- Solo permisos incluidos

    -- Devolver los permisos recopilados
    SELECT * FROM @tablaPermisos;
END;
GO


