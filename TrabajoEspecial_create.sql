-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-29 18:28:04.306

-- tables
-- Table: G9_Billetera
CREATE TABLE G9_Billetera (
    id_usuario int  NOT NULL,
    moneda varchar(10)  NOT NULL,
    saldo decimal(20,10)  NOT NULL,
    CONSTRAINT G9_Billetera_pk PRIMARY KEY (id_usuario,moneda)
);

-- Table: G9_ComposicionOrden
CREATE TABLE G9_ComposicionOrden (
    id_o int8  NOT NULL,
    id_d int8  NOT NULL,
    cantidad numeric(20,10)  NOT NULL,
    CONSTRAINT G9_ComposicionOrden_pk PRIMARY KEY (id_o,id_d)
);

-- Table: G9_Mercado
CREATE TABLE G9_Mercado (
    nombre varchar(20)  NOT NULL,
    moneda_o varchar(10)  NOT NULL,
    moneda_d varchar(10)  NOT NULL,
    precio_mercado numeric(20,10)  NOT NULL,
    CONSTRAINT G9_Mercado_pk PRIMARY KEY (nombre)
);

-- Table: G9_Moneda
CREATE TABLE G9_Moneda (
    moneda varchar(10)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    descripcion varchar(2048)  NOT NULL,
    alta timestamp  NOT NULL,
    estado char(1)  NOT NULL,
    fiat char(1)  NOT NULL,
    CONSTRAINT G9_Moneda_pk PRIMARY KEY (moneda)
);

-- Table: G9_Movimiento
CREATE TABLE G9_Movimiento (
    id_usuario int  NOT NULL,
    moneda varchar(10)  NOT NULL,
    fecha timestamp  NOT NULL,
    tipo char(1)  NOT NULL,
    comision decimal(20,10)  NOT NULL,
    valor decimal(20,10)  NOT NULL,
    bloque int  NULL,
    direccion varchar(100)  NULL,
    CONSTRAINT G9_Movimiento_pk PRIMARY KEY (id_usuario,moneda,fecha)
);

-- Table: G9_Orden
CREATE TABLE G9_Orden (
    id bigserial  NOT NULL,
    mercado varchar(20)  NOT NULL,
    id_usuario int  NOT NULL,
    tipo char(10)  NOT NULL,
    fecha_creacion timestamp  NOT NULL,
    fecha_ejec timestamp  NULL,
    valor decimal(20,10)  NOT NULL,
    cantidad decimal(20,10)  NOT NULL,
    estado char(10)  NOT NULL,
    CONSTRAINT G9_Orden_pk PRIMARY KEY (id)
);

-- Table: G9_Pais
CREATE TABLE G9_Pais (
    id_pais int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    cod_telef int  NOT NULL,
    CONSTRAINT G9_Pais_pk PRIMARY KEY (id_pais)
);

-- Table: G9_RelMoneda
CREATE TABLE G9_RelMoneda (
    moneda varchar(10)  NOT NULL,
    monedaf varchar(10)  NOT NULL,
    fecha timestamp  NOT NULL,
    valor numeric(20,10)  NOT NULL,
    CONSTRAINT G9_RelMoneda_pk PRIMARY KEY (moneda,monedaf,fecha)
);

-- Table: G9_Usuario
CREATE TABLE G9_Usuario (
    id_usuario int  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_alta date  NOT NULL,
    estado char(10)  NOT NULL,
    email varchar(120)  NOT NULL,
    password varchar(120)  NOT NULL,
    telefono int  NOT NULL,
    id_pais int  NOT NULL,
    CONSTRAINT G9_Usuario_pk PRIMARY KEY (id_usuario)
);

-- foreign keys
-- Reference: fk_Billetera_Moneda (table: G9_Billetera)
ALTER TABLE G9_Billetera ADD CONSTRAINT fk_Billetera_Moneda
    FOREIGN KEY (moneda)
    REFERENCES G9_Moneda (moneda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Billetera_Usuario (table: G9_Billetera)
ALTER TABLE G9_Billetera ADD CONSTRAINT fk_Billetera_Usuario
    FOREIGN KEY (id_usuario)
    REFERENCES G9_Usuario (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_CompOp_Op_d (table: G9_ComposicionOrden)
ALTER TABLE G9_ComposicionOrden ADD CONSTRAINT fk_CompOp_Op_d
    FOREIGN KEY (id_d)
    REFERENCES G9_Orden (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_CompOp_Op_o (table: G9_ComposicionOrden)
ALTER TABLE G9_ComposicionOrden ADD CONSTRAINT fk_CompOp_Op_o
    FOREIGN KEY (id_o)
    REFERENCES G9_Orden (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Movimiento_Billetera (table: G9_Movimiento)
ALTER TABLE G9_Movimiento ADD CONSTRAINT fk_Movimiento_Billetera
    FOREIGN KEY (id_usuario, moneda)
    REFERENCES G9_Billetera (id_usuario, moneda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Operacion_Mercado (table: G9_Orden)
ALTER TABLE G9_Orden ADD CONSTRAINT fk_Operacion_Mercado
    FOREIGN KEY (mercado)
    REFERENCES G9_Mercado (nombre)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Operacion_Usuario (table: G9_Orden)
ALTER TABLE G9_Orden ADD CONSTRAINT fk_Operacion_Usuario
    FOREIGN KEY (id_usuario)
    REFERENCES G9_Usuario (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_RelMoneda_Moneda (table: G9_RelMoneda)
ALTER TABLE G9_RelMoneda ADD CONSTRAINT fk_RelMoneda_Moneda
    FOREIGN KEY (monedaf)
    REFERENCES G9_Moneda (moneda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_RelMoneda_Monedaf (table: G9_RelMoneda)
ALTER TABLE G9_RelMoneda ADD CONSTRAINT fk_RelMoneda_Monedaf
    FOREIGN KEY (moneda)
    REFERENCES G9_Moneda (moneda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Usuario_Pais (table: G9_Usuario)
ALTER TABLE G9_Usuario ADD CONSTRAINT fk_Usuario_Pais
    FOREIGN KEY (id_pais)
    REFERENCES G9_Pais (id_pais)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_mercado_moneda_d (table: G9_Mercado)
ALTER TABLE G9_Mercado ADD CONSTRAINT fk_mercado_moneda_d
    FOREIGN KEY (moneda_d)
    REFERENCES G9_Moneda (moneda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_mercado_moneda_o (table: G9_Mercado)
ALTER TABLE G9_Mercado ADD CONSTRAINT fk_mercado_moneda_o
    FOREIGN KEY (moneda_o)
    REFERENCES G9_Moneda (moneda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

