USE [PRUEBA]
GO
/****** Object:  StoredProcedure [dbo].[spObtenerPermisosUsuario]    Script Date: 18/11/2024 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spObtenerPermisosUsuario] (
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
        EsRegistroEspecifico BIT,
		TipoUsuario NVARCHAR(20), 
        RegistroID BIGINT,
		Excluir BIT
    );

    -- Obtener permisos a nivel de entidad directamente asignados al usuario (PermiUser)
    INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico, TipoUsuario, RegistroID)
    SELECT 
        p.name AS NombrePermiso,
        p.can_create AS PuedeCrear,
        p.can_read AS PuedeLeer,
        p.can_update AS PuedeActualizar,
        p.can_delete AS PuedeEliminar,
        p.can_import AS PuedeImportar,
        p.can_export AS PuedeExportar,
        0 AS EsRegistroEspecifico,
		'user' AS TipoUsuario,
        NULL AS RegistroID
    FROM 
        PermiUser pu
        INNER JOIN Permission p ON pu.permission_id = p.id_permi
    WHERE 
        pu.usercompany_id IN (
            SELECT id_useco FROM UserCompany WHERE id_useco = @idUsuario and useco_active = 1
        )
        AND pu.entitycatalog_id = @idCatalogoEntidad
        AND pu.peusr_include = 1;

    -- Obtener permisos a nivel de entidad asignados al rol del usuario (PermiRole)
    INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico, TipoUsuario, RegistroID)
    SELECT 
        p.name AS NombrePermiso,
        p.can_create AS PuedeCrear,
        p.can_read AS PuedeLeer,
        p.can_update AS PuedeActualizar,
        p.can_delete AS PuedeEliminar,
        p.can_import AS PuedeImportar,
        p.can_export AS PuedeExportar,
        0 AS EsRegistroEspecifico,
		'rol' AS TipoUsuario,
        NULL AS RegistroID
    FROM 
        PermiRole pr
        INNER JOIN Permission p ON pr.permission_id = p.id_permi
    WHERE 
        pr.role_id IN (
            SELECT role_id FROM [Role] WHERE role_id = @idUsuario and role_active = 1
        )
        AND pr.entitycatalog_id = @idCatalogoEntidad
        AND pr.perol_include = 1;

    -- Permisos específicos de registro asignados al usuario (PermiUserRecord)
    IF @idCatalogoEntidad = 1 -- Sucursal (BranchOffice)
    BEGIN
        INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico, TipoUsuario, RegistroID, Excluir)
        SELECT 
            p.name AS NombrePermiso,
            p.can_create AS PuedeCrear,
            p.can_read AS PuedeLeer,
            p.can_update AS PuedeActualizar,
            p.can_delete AS PuedeEliminar,
            p.can_import AS PuedeImportar,
            p.can_export AS PuedeExportar,
            1 AS EsRegistroEspecifico,
			'user' AS TipoUsuario,
            bo.id_broff AS RegistroID,
			CASE 
				WHEN peusr_include = 1 THEN 0
				WHEN peusr_include = 0 THEN 1 
			END AS Excluir
        FROM 
            PermiUserRecord pur
            INNER JOIN Permission p ON pur.permission_id = p.id_permi
            INNER JOIN BranchOffice bo ON pur.peusr_record = bo.id_broff
        WHERE 
            pur.usercompany_id IN (
                SELECT id_useco FROM UserCompany WHERE id_useco = @idUsuario and useco_active = 1
            )
            AND pur.entitycatalog_id = @idCatalogoEntidad

        -- Permisos específicos de registro asignados al rol del usuario (PermiRoleRecord)
        INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico, TipoUsuario, RegistroID,Excluir)
        SELECT 
            p.name AS NombrePermiso,
            p.can_create AS PuedeCrear,
            p.can_read AS PuedeLeer,
            p.can_update AS PuedeActualizar,
            p.can_delete AS PuedeEliminar,
            p.can_import AS PuedeImportar,
            p.can_export AS PuedeExportar,
            1 AS EsRegistroEspecifico,
			'rol' AS TipoUsuario,
            bo.id_broff AS RegistroID,
			CASE 
				WHEN perrc_include = 1 THEN 0
				WHEN perrc_include = 0 THEN 1 
			END AS Excluir
        FROM 
            PermiRoleRecord prr
            INNER JOIN Permission p ON prr.permission_id = p.id_permi
            INNER JOIN BranchOffice bo ON prr.perrc_record = bo.id_broff
        WHERE 
            prr.role_id IN (
                SELECT role_id FROM [Role] WHERE role_id = @idUsuario and role_active = 1
            )
            AND prr.entitycatalog_id = @idCatalogoEntidad
    END
    ELSE IF @idCatalogoEntidad = 2 -- Centro de Costos (CostCenter)
    BEGIN
        INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico, TipoUsuario, RegistroID, Excluir)
        SELECT 
            p.name AS NombrePermiso,
            p.can_create AS PuedeCrear,
            p.can_read AS PuedeLeer,
            p.can_update AS PuedeActualizar,
            p.can_delete AS PuedeEliminar,
            p.can_import AS PuedeImportar,
            p.can_export AS PuedeExportar,
            1 AS EsRegistroEspecifico,
			'user' AS TipoUsuario,
            cc.id_cosce AS RegistroID,
			CASE 
				WHEN peusr_include = 1 THEN 0
				WHEN peusr_include = 0 THEN 1 
			END AS Excluir
        FROM 
            PermiUserRecord pur
            INNER JOIN Permission p ON pur.permission_id = p.id_permi
            INNER JOIN CostCenter cc ON pur.peusr_record = cc.id_cosce
        WHERE 
            pur.usercompany_id IN (
                SELECT id_useco FROM UserCompany WHERE id_useco = @idUsuario and useco_active = 1
            )
            AND pur.entitycatalog_id = 2

        -- Permisos específicos de registro asignados al rol del usuario (PermiRoleRecord)
        INSERT INTO @tablaPermisos (NombrePermiso, PuedeCrear, PuedeLeer, PuedeActualizar, PuedeEliminar, PuedeImportar, PuedeExportar, EsRegistroEspecifico, TipoUsuario, RegistroID, Excluir)
        SELECT 
            p.name AS NombrePermiso,
            p.can_create AS PuedeCrear,
            p.can_read AS PuedeLeer,
            p.can_update AS PuedeActualizar,
            p.can_delete AS PuedeEliminar,
            p.can_import AS PuedeImportar,
            p.can_export AS PuedeExportar,
            1 AS EsRegistroEspecifico,
			'rol' AS TipoUsuario,
            cc.id_cosce AS RegistroID,
			CASE 
				WHEN perrc_include = 1 THEN 0
				WHEN perrc_include = 0 THEN 1 
			END AS Excluir
        FROM 
            PermiRoleRecord prr
            INNER JOIN Permission p ON prr.permission_id = p.id_permi
            INNER JOIN CostCenter cc ON prr.perrc_record = cc.id_cosce
        WHERE 
            prr.role_id IN (
                SELECT role_id FROM [Role] WHERE role_id = @idUsuario and role_active = 1
            )
            AND prr.entitycatalog_id = @idCatalogoEntidad
    END

    -- Devuelve los permisos recopilados
    SELECT * FROM @tablaPermisos;
END;
