--Archivo de borrado

-- Drop FK.
ALTER TABLE G9_Billetera DROP CONSTRAINT fk_g9_Billetera_Moneda;
ALTER TABLE G9_Billetera DROP CONSTRAINT fk_g9_Billetera_Usuario;
ALTER TABLE G9_ComposicionOrden DROP CONSTRAINT fk_g9_CompOp_Op_d;
ALTER TABLE G9_ComposicionOrden DROP CONSTRAINT fk_g9_CompOp_Op_o;
ALTER TABLE G9_Movimiento DROP CONSTRAINT fk_g9_Movimiento_Billetera;
ALTER TABLE G9_Orden DROP CONSTRAINT fk_g9_Operacion_Mercado;
ALTER TABLE G9_Orden DROP CONSTRAINT fk_g9_Operacion_Usuario;
ALTER TABLE G9_RelMoneda DROP CONSTRAINT fk_g9_RelMoneda_Moneda;
ALTER TABLE G9_RelMoneda DROP CONSTRAINT fk_g9_RelMoneda_Monedaf;
ALTER TABLE G9_Usuario DROP CONSTRAINT fk_g9_Usuario_Pais;
ALTER TABLE G9_Mercado DROP CONSTRAINT fk_g9_mercado_moneda_d;
ALTER TABLE G9_Mercado DROP CONSTRAINT fk_g9_mercado_moneda_o;

-- tables and view
DROP TABLE G9_Billetera CASCADE ;
DROP TABLE G9_ComposicionOrden CASCADE ;
DROP TABLE G9_Mercado CASCADE ;
DROP TABLE G9_Moneda CASCADE;
DROP TABLE G9_Movimiento CASCADE;
DROP TABLE G9_Orden CASCADE;
DROP TABLE G9_Pais CASCADE;
DROP TABLE G9_RelMoneda CASCADE;
DROP TABLE G9_Usuario CASCADE;

--Function
DROP FUNCTION fn_G9_ejecutar_orden(ingreso integer, cantidad integer ,mercado1 varchar, tipo_orden varchar, id_user integer, mon_d varchar, mon_o varchar);
DROP FUNCTION fn_g9_ordenes_mercado_fecha(nombre_mercado varchar, fecha_param timestamp);
DROP FUNCTION trfn_g9_delete_SaldoUsuarios();
DROP FUNCTION trfn_g9_insertUpdate_SaldoUsuarios();
DROP FUNCTION trfn_g9_ejecucion_orden();
DROP FUNCTION trfn_g9_movimiento_null();
DROP FUNCTION TRFN_G9_RETIRO_VALIDO();
DROP FUNCTION TRFN_G9_ORDEN_VALIDA();
DROP FUNCTION TRFN_G9_MOVIMIENTO_VALIDO_BLOQUE();
DROP FUNCTION FN_G9_valor_mercado(mercado1 varchar);
DROP FUNCTION FN_G9_sumaPorcentaje(cantV numeric, cantC numeric, mercado1 varchar);
DROP FUNCTION fn_fecha_aleatoria(desde timestamp, hasta timestamp);
DROP FUNCTION fn_g9_ejecutar_orden_remanente(id_orden integer, ingreso integer, cantidad integer, mercado1 varchar, tipo_orden varchar, id_user integer, mon_d varchar, mon_o varchar);

--Procedure
DROP procedure pr_g9_CargarMercadoMonedaContraBTC();
DROP procedure pr_g9_CargarMercadoMonedaContraEstables();
DROP procedure pr_g9_cargarBilletera(id_usuario_param int, valor int, moneda_param varchar);
DROP procedure pr_g9_cargarOrdenes(i integer);

