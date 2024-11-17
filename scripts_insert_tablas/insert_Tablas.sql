
-- Insertar múltiples registros en la Tabla Company
INSERT INTO Company (compa_name, compa_tradename, compa_doctype, compa_docnum, compa_address, compa_city, compa_state, compa_country, compa_industry, compa_phone, compa_email, compa_website, compa_logo, compa_active)
VALUES 
('Empresa 1', 'Empresa 1', 'CC', '123546', 'Calle 123', 'Ciudad 1', 'Estado 1', 'País 1', 'Tech', '+57300000000', 'ejemplo@ejemplo.com', NULL, NULL, 1),
('Empresa 2', 'Empresa Dos', 'NI', '654321', 'Avenida 456', 'Ciudad 2', 'Estado 2', 'País 2', 'Finance', '+57311111111', 'contacto@empresa2.com', 'www.empresa2.com', NULL, 1),
('Empresa 3', 'Empresa Tres', 'NI', '789012', 'Carrera 789', 'Ciudad 3', 'Estado 3', 'País 3', 'Healthcare', '+57322222222', 'soporte@empresa3.com', 'www.empresa3.com', NULL, 0),
('Empresa 4', 'Empresa Cuatro', 'CC', '345678', 'Diagonal 987', 'Ciudad 4', 'Estado 4', 'País 4', 'Education', '+57333333333', 'info@empresa4.com', NULL, NULL, 1),
('Empresa 5', 'Empresa Cinco', 'NI', '901234', 'Transversal 654', 'Ciudad 5', 'Estado 5', 'País 5', 'Retail', '+57344444444', 'ventas@empresa5.com', 'www.empresa5.com', NULL, 1);


-- Insertar múltiples registros en la Tabla BranchOffice
INSERT INTO BranchOffice (company_id, broff_name, broff_code, broff_address, broff_city, broff_state, broff_country, broff_phone, broff_email, broff_active)
VALUES 
(1, 'Occidente', 'BROFF-1', 'Calle 456', 'Ciudad 1', 'Estado 1', 'País 1', '+573999999999', 'occidente@occidente.com', 1),
(3, 'Oriente', 'BROFF-2', 'Avenida 789', 'Ciudad 2', 'Estado 2', 'País 2', '+573888888888', 'oriente@oriente.com', 1),
(4, 'Norte', 'BROFF-3', 'Carrera 123', 'Ciudad 3', 'Estado 3', 'País 3', '+573777777777', 'norte@norte.com', 1),
(5, 'Sur', 'BROFF-4', 'Diagonal 321', 'Ciudad 4', 'Estado 4', 'País 4', '+573666666666', 'sur@sur.com', 0),
(6, 'Centro', 'BROFF-5', 'Transversal 654', 'Ciudad 5', 'Estado 5', 'País 5', '+573555555555', 'centro@centro.com', 1);


-- Insertar múltiples registros en la Tabla Role
INSERT INTO Role (company_id, role_name, role_code, role_description, role_active)
VALUES 
(1, 'Admin', 'ADM', 'Permisos Totales', 1),
(1, 'Supervisor', 'SUP', 'Permisos Supervisión Operación', 1),
(1, 'Operador', 'OPR', 'Permisos de Operación', 1),
(1, 'Consultor', 'CON', 'Permisos de Consulta', 1),
(6, 'Administrador', 'ADM2', 'Permisos Totales en Empresa 2', 1),
(6, 'Analista', 'ANL', 'Permisos para Análisis de Datos', 1),
(6, 'Auditor', 'AUD', 'Permisos de Auditoría', 1),
(3, 'Gerente', 'GER', 'Permisos de Gestión General', 1),
(3, 'Soporte', 'SOP', 'Permisos para Soporte Técnico', 1),
(3, 'Técnico', 'TEC', 'Permisos Técnicos Limitados', 1),
(4, 'Lider', 'LID', 'Permisos de Liderazgo', 1),
(5, 'Marketing', 'MKT', 'Permisos para Marketing Digital', 1);


-- Insertar múltiples registros en la Tabla User
INSERT INTO [User] (user_username, user_password, user_email, user_phone, user_is_admin, user_is_active)
VALUES 
('user1', '123456', 'user1@user1.com', '+573888888888', 0, 1),
('adm', '987654', 'adm@adm.com', '+573777777777', 1, 1),
('user2', 'password2', 'user2@user2.com', '+573666666666', 0, 1),
('user3', 'password3', 'user3@user3.com', '+573555555555', 0, 0),
('user4', 'password4', 'user4@user4.com', '+573444444444', 0, 1),
('admin1', 'adminpass1', 'admin1@admin.com', '+573333333333', 1, 1),
('admin2', 'adminpass2', 'admin2@admin.com', '+573222222222', 1, 1),
('support1', 'supportpass1', 'support1@support.com', '+573111111111', 0, 1),
('support2', 'supportpass2', 'support2@support.com', '+573999999999', 0, 0),
('guest1', 'guestpass1', 'guest1@guest.com', '+573000000000', 0, 1),
('guest2', 'guestpass2', 'guest2@guest.com', '+573111111110', 0, 1);


-- Insertar múltiples registros en la Tabla UserCompany
INSERT INTO UserCompany (user_id, company_id, useco_active)
VALUES 
(10, 1, 1),  -- Usuario 'user1' asignado a 'Empresa 1'
(11, 1, 1),  -- Usuario 'adm' asignado a 'Empresa 1'
(1, 6, 1),  -- Usuario 'user2' asignado a 'Empresa 2'
(2, 6, 0),  -- Usuario 'user3' asignado a 'Empresa 2' (inactivo)
(3, 3, 1),  -- Usuario 'user4' asignado a 'Empresa 3'
(4, 3, 1),  -- Usuario 'admin1' asignado a 'Empresa 3'
(5, 4, 1),  -- Usuario 'admin2' asignado a 'Empresa 4'
(6, 4, 1),  -- Usuario 'support1' asignado a 'Empresa 4'
(7, 5, 0),  -- Usuario 'support2' asignado a 'Empresa 5' (inactivo)
(8, 5, 1), -- Usuario 'guest1' asignado a 'Empresa 5'
(9, 5, 1); -- Usuario 'guest2' asignado a 'Empresa 5'


--Insertar Datos en la Tabla CostCenter
INSERT INTO CostCenter (company_id, cosce_parent_id, cosce_code, cosce_name, cosce_description, cosce_budget, cosce_level, cosce_active)
VALUES 
(1, NULL, 'C1', 'Centro Principal', 'Centro general', 9876546.00, 1, 1),
(1, 1, 'C1-CC1', 'Centro Tecnología', 'Centro para tecnologia', 87845.00, 2, 1),
(1, 1, 'C1-CC2', 'Centro Gestión Humana', 'Centro para GH', 65412.00, 2, 1),
(1, 1, 'C1-CC3', 'Centro Comercial', 'Centro para Comercial', 48798.00, 2, 1);

--Insertar Datos en la Tabla EntityCatalog
INSERT INTO EntityCatalog (entit_name, entit_descrip, entit_active, entit_config)
VALUES 
('Sucursal', 'Representa una sucursal', 1, NULL),
('Centro de Costo', 'Representa un centro de costo', 1, NULL),
('Empresa', 'Representa una Empresa', 1, NULL);


--Insertar Datos en la Tabla PermiRole
INSERT INTO PermiRole (role_id, permission_id, entitycatalog_id, perol_include)
VALUES 
(11, 64, 1, 1),  -- "Admin" con "Permiso para crear, leer, actualizar, eliminar, importar, exportar" en "Sucursal"
(12, 8, 1, 1),  -- "Supervisor" con "Permiso para crear, leer, actualizar" en "Sucursal"
(3, 64, 2, 1),  -- "Administrador" con "Permiso para crear, leer, actualizar, eliminar, importar, exportar" en "Centro de Costo"
(7, 7, 3, 1);  -- "Soporte" con "Permiso para leer, actualizar" en "Empresa"

--Insertar Datos en la Tabla PermiUser
INSERT INTO PermiUser (usercompany_id, permission_id, entitycatalog_id, peusr_include)
VALUES 
(1, 27, 1, 1), -- "user1" con "Permiso para leer, eliminar, importar" en "Sucursal"
(6, 63, 1, 1);  -- "admin1" con "Permiso para leer, actualizar, eliminar, importar, exportar" en "Sucursal"

--Insertar Datos en la Tabla PermiRoleRecord
INSERT INTO PermiRoleRecord (role_id, permission_id, entitycatalog_id, perrc_record, perrc_include)
VALUES 
(11, 64, 3, 6, 1),  -- "Admin" con "Permiso para crear, leer, actualizar, eliminar, importar, exportar" para "Empresa" con ID 6
(5, 20, 2, 2, 1);  -- "Auditor" con "Permiso para crear, leer, importar" para "Centro de Costo" con ID 2

--Insertar Datos en la Tabla PermiUserRecord
INSERT INTO PermiUserRecord (usercompany_id, permission_id, entitycatalog_id, peusr_record, peusr_include)
VALUES 
(1, 27, 3, 5, 1),  -- "user1" con "Permiso para leer, eliminar, importar" para "Empresa" con ID 5
(6, 63, 1, 1, 1);  -- "admin1" con "Permiso para leer, actualizar, eliminar, importar, exportar" para "Sucursal" con ID 1