-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-29 18:28:04.306

-- foreign keys
ALTER TABLE G9_Billetera
    DROP CONSTRAINT fk_Billetera_Moneda;

ALTER TABLE G9_Billetera
    DROP CONSTRAINT fk_Billetera_Usuario;

ALTER TABLE G9_ComposicionOrden
    DROP CONSTRAINT fk_CompOp_Op_d;

ALTER TABLE G9_ComposicionOrden
    DROP CONSTRAINT fk_CompOp_Op_o;

ALTER TABLE G9_Movimiento
    DROP CONSTRAINT fk_Movimiento_Billetera;

ALTER TABLE G9_Orden
    DROP CONSTRAINT fk_Operacion_Mercado;

ALTER TABLE G9_Orden
    DROP CONSTRAINT fk_Operacion_Usuario;

ALTER TABLE G9_RelMoneda
    DROP CONSTRAINT fk_RelMoneda_Moneda;

ALTER TABLE G9_RelMoneda
    DROP CONSTRAINT fk_RelMoneda_Monedaf;

ALTER TABLE G9_Usuario
    DROP CONSTRAINT fk_Usuario_Pais;

ALTER TABLE G9_Mercado
    DROP CONSTRAINT fk_mercado_moneda_d;

ALTER TABLE G9_Mercado
    DROP CONSTRAINT fk_mercado_moneda_o;

-- tables
DROP TABLE G9_Billetera;

DROP TABLE G9_ComposicionOrden;

DROP TABLE G9_Mercado;

DROP TABLE G9_Moneda;

DROP TABLE G9_Movimiento;

DROP TABLE G9_Orden;

DROP TABLE G9_Pais;

DROP TABLE G9_RelMoneda;

DROP TABLE G9_Usuario;

-- End of file.

