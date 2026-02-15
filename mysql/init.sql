-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: db_baucort
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `banco`
--

DROP TABLE IF EXISTS `banco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banco` (
  `ad_banco` int NOT NULL COMMENT 'Secuencia banco',
  `ds_codigo` varchar(10) NOT NULL COMMENT 'Código interno o bancario',
  `ds_nombre` varchar(100) NOT NULL,
  `ic_activo` char(1) NOT NULL DEFAULT 'Y',
  `dt_creacion` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`ad_banco`),
  UNIQUE KEY `uk_banco_codigo` (`ds_codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banco`
--

LOCK TABLES `banco` WRITE;
/*!40000 ALTER TABLE `banco` DISABLE KEYS */;
/*!40000 ALTER TABLE `banco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cotizacion`
--

DROP TABLE IF EXISTS `cotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cotizacion` (
  `ad_cotizacion` int NOT NULL COMMENT 'Secuencia seq_cotizacion',
  `fk_provee_ad_proveedor` int NOT NULL,
  `fk_sucursal_ad_sucursal` int DEFAULT NULL,
  `dt_fecha_cotizacion` date NOT NULL,
  `dt_fecha_vencimiento` date DEFAULT NULL,
  `ds_estado` enum('borrador','enviada','aprobada','rechazada','vencida') NOT NULL DEFAULT 'borrador',
  `ds_observaciones` varchar(150) DEFAULT NULL,
  `ic_activa` enum('S','N') NOT NULL DEFAULT 'S',
  `dt_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ad_cotizacion`),
  KEY `fk_cot_proveedor` (`fk_provee_ad_proveedor`),
  KEY `fk_cot_sucursal` (`fk_sucursal_ad_sucursal`),
  CONSTRAINT `fk_cot_proveedor` FOREIGN KEY (`fk_provee_ad_proveedor`) REFERENCES `proveedor` (`ad_proveedor`),
  CONSTRAINT `fk_cot_sucursal` FOREIGN KEY (`fk_sucursal_ad_sucursal`) REFERENCES `sucursal` (`ad_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizacion`
--

LOCK TABLES `cotizacion` WRITE;
/*!40000 ALTER TABLE `cotizacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `cotizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuenta_bancaria`
--

DROP TABLE IF EXISTS `cuenta_bancaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuenta_bancaria` (
  `ad_cuenta_bancaria` int NOT NULL COMMENT 'Secuencia cuenta bancaria',
  `fk_banco_ad_banco` int NOT NULL,
  `fk_sucursal_banco_ad_sucursal` int DEFAULT NULL,
  `ds_numero_cuenta` varchar(30) NOT NULL,
  `cl_tipo_cuenta` enum('ahorros','corriente') NOT NULL,
  `ds_titular` varchar(100) NOT NULL,
  `nm_saldo_inicial` decimal(14,2) NOT NULL DEFAULT '0.00',
  `nm_saldo_actual` decimal(14,2) NOT NULL DEFAULT '0.00',
  `ic_activa` char(1) NOT NULL DEFAULT 'Y',
  `dt_apertura` date NOT NULL,
  PRIMARY KEY (`ad_cuenta_bancaria`),
  UNIQUE KEY `uk_numero_cuenta` (`ds_numero_cuenta`),
  KEY `fk_cuenta_banco` (`fk_banco_ad_banco`),
  KEY `fk_cuenta_sucursal` (`fk_sucursal_banco_ad_sucursal`),
  CONSTRAINT `fk_cuenta_banco` FOREIGN KEY (`fk_banco_ad_banco`) REFERENCES `banco` (`ad_banco`),
  CONSTRAINT `fk_cuenta_sucursal` FOREIGN KEY (`fk_sucursal_banco_ad_sucursal`) REFERENCES `sucursal_banco` (`ad_sucursal_banco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuenta_bancaria`
--

LOCK TABLES `cuenta_bancaria` WRITE;
/*!40000 ALTER TABLE `cuenta_bancaria` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuenta_bancaria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_cotizacion`
--

DROP TABLE IF EXISTS `detalle_cotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_cotizacion` (
  `ad_cotizacion_detalle` int NOT NULL COMMENT 'Secuencia seq_cotizacion_detalle',
  `fk_cotizacion_ad_cotizacion` int NOT NULL,
  `fk_product_ad_producto` int NOT NULL,
  `vl_cantidad` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_precio_unitario` decimal(10,2) NOT NULL,
  `vl_subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`ad_cotizacion_detalle`),
  KEY `fk_det_cotizacion` (`fk_cotizacion_ad_cotizacion`),
  KEY `fk_det_producto` (`fk_product_ad_producto`),
  CONSTRAINT `fk_det_cotizacion` FOREIGN KEY (`fk_cotizacion_ad_cotizacion`) REFERENCES `cotizacion` (`ad_cotizacion`),
  CONSTRAINT `fk_det_producto` FOREIGN KEY (`fk_product_ad_producto`) REFERENCES `productos` (`ad_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_cotizacion`
--

LOCK TABLES `detalle_cotizacion` WRITE;
/*!40000 ALTER TABLE `detalle_cotizacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_cotizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_factura_compra`
--

DROP TABLE IF EXISTS `detalle_factura_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_factura_compra` (
  `ad_detalle_factura` int NOT NULL COMMENT 'Secuencia asociada seq_detalle_factura_compra',
  `fk_factura_ad_factura` int NOT NULL,
  `fk_product_ad_producto` int NOT NULL,
  `vl_cantidad` decimal(10,2) NOT NULL,
  `vl_costo_unitario` decimal(10,2) NOT NULL,
  `vl_subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ad_detalle_factura`),
  KEY `fk_detfac_factura` (`fk_factura_ad_factura`),
  KEY `fk_detfac_producto` (`fk_product_ad_producto`),
  CONSTRAINT `fk_detfac_factura` FOREIGN KEY (`fk_factura_ad_factura`) REFERENCES `factura_compra` (`ad_factura`),
  CONSTRAINT `fk_detfac_producto` FOREIGN KEY (`fk_product_ad_producto`) REFERENCES `productos` (`ad_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_factura_compra`
--

LOCK TABLES `detalle_factura_compra` WRITE;
/*!40000 ALTER TABLE `detalle_factura_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_factura_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedido` (
  `ad_detalle_pedido` int NOT NULL COMMENT 'Secuencia asociada seq_detalle_pedido',
  `fk_pedido_ad_pedido` int NOT NULL,
  `fk_product_ad_producto` int NOT NULL,
  `vl_cantidad` decimal(10,2) NOT NULL DEFAULT '0.00',
  `ic_registro_activo` enum('S','N') NOT NULL DEFAULT 'S',
  `fk_proveedor_ad_proveedor` int DEFAULT NULL,
  `vl_compra` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`ad_detalle_pedido`),
  KEY `fk_detalle_pedido_pedido` (`fk_pedido_ad_pedido`),
  KEY `fk_detalle_pedido_producto` (`fk_product_ad_producto`),
  KEY `fk_detalle_pedido_proveedor` (`fk_proveedor_ad_proveedor`),
  CONSTRAINT `fk_detalle_pedido_pedido` FOREIGN KEY (`fk_pedido_ad_pedido`) REFERENCES `pedido` (`ad_pedido`),
  CONSTRAINT `fk_detalle_pedido_producto` FOREIGN KEY (`fk_product_ad_producto`) REFERENCES `productos` (`ad_producto`),
  CONSTRAINT `fk_detalle_pedido_proveedor` FOREIGN KEY (`fk_proveedor_ad_proveedor`) REFERENCES `proveedor` (`ad_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalles_orden_compra`
--

DROP TABLE IF EXISTS `detalles_orden_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalles_orden_compra` (
  `ad_detalle_ordencom` int NOT NULL COMMENT 'Secuencia asociada seq_detalles_orden_compra',
  `fk_ordencom_ad_orden` int NOT NULL,
  `fk_product_ad_producto` int NOT NULL,
  `vl_cantidad` int NOT NULL DEFAULT '0',
  `vl_precio_unitario` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`ad_detalle_ordencom`),
  KEY `fk_detord_product` (`fk_product_ad_producto`),
  KEY `fk_detord_ordencom` (`fk_ordencom_ad_orden`),
  CONSTRAINT `fk_detord_ordencom` FOREIGN KEY (`fk_ordencom_ad_orden`) REFERENCES `ordenes_compra` (`ad_orden`),
  CONSTRAINT `fk_detord_product` FOREIGN KEY (`fk_product_ad_producto`) REFERENCES `productos` (`ad_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalles_orden_compra`
--

LOCK TABLES `detalles_orden_compra` WRITE;
/*!40000 ALTER TABLE `detalles_orden_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalles_orden_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresa`
--

DROP TABLE IF EXISTS `empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresa` (
  `ad_empresa` int NOT NULL COMMENT 'Secuencia asociada seq_empresa',
  `ds_identificacion` varchar(20) NOT NULL,
  `ds_razon_social` varchar(60) NOT NULL,
  `ds_direccion` varchar(45) DEFAULT NULL,
  `ds_correo_electronico` varchar(100) DEFAULT NULL,
  `ds_telefono` varchar(45) DEFAULT NULL,
  `cl_tipo_identificacion` varchar(2) NOT NULL DEFAULT 'NI',
  `dt_creacion` date NOT NULL DEFAULT (curdate()),
  `ds_observacion` varchar(100) DEFAULT NULL,
  `ds_contacto` varchar(45) DEFAULT NULL,
  `ic_registro_activo` varchar(1) NOT NULL DEFAULT 'Y',
  `nm_cuenta_puc` int NOT NULL COMMENT 'Cuenta contable asociada, tomada del PUC',
  PRIMARY KEY (`ad_empresa`),
  CONSTRAINT `ck_empresa_ic_registro_activo` CHECK ((`ic_registro_activo` in (_utf8mb4'Y',_utf8mb4'N'))),
  CONSTRAINT `ck_empresa_tipo_identif` CHECK ((`cl_tipo_identificacion` in (_utf8mb4'NI',_utf8mb4'CC')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa`
--

LOCK TABLES `empresa` WRITE;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
INSERT INTO `empresa` VALUES (1,'830080391','BAUCORT LTDA','Calle 23 C #69 B - 01','baucortltda@hotmail.com','3124488169','NI','2026-01-12','','Jorge Gaitan','Y',0);
/*!40000 ALTER TABLE `empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura_compra`
--

DROP TABLE IF EXISTS `factura_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura_compra` (
  `ad_factura` int NOT NULL COMMENT 'Secuencia asociada seq_factura_compra',
  `fk_provee_ad_proveedor` int NOT NULL,
  `fk_sucursal_ad_sucursal` int NOT NULL,
  `fk_ordencom_ad_orden` int DEFAULT NULL,
  `ds_numero_factura` varchar(45) NOT NULL,
  `dt_fecha_factura` date NOT NULL,
  `vl_facturado` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_descuento` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_impuestos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_retencion` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_total` decimal(10,2) NOT NULL,
  `vl_pagado` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_saldo` decimal(10,2) NOT NULL DEFAULT '0.00',
  `ds_estado_factura` enum('registrada','anulada','cancelada','cerrada') NOT NULL DEFAULT 'registrada',
  `ds_estado_pago` enum('pendiente','parcial','pagada') NOT NULL DEFAULT 'pendiente',
  `ds_observaciones` text,
  `dt_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ic_cuenta_cobro` enum('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`ad_factura`),
  UNIQUE KEY `uk_factura_proveedor` (`fk_provee_ad_proveedor`,`ds_numero_factura`),
  KEY `fk_factura_proveedor` (`fk_provee_ad_proveedor`),
  KEY `fk_factura_sucursal` (`fk_sucursal_ad_sucursal`),
  KEY `fk_factura_orden` (`fk_ordencom_ad_orden`),
  CONSTRAINT `fk_factura_orden` FOREIGN KEY (`fk_ordencom_ad_orden`) REFERENCES `ordenes_compra` (`ad_orden`),
  CONSTRAINT `fk_factura_proveedor` FOREIGN KEY (`fk_provee_ad_proveedor`) REFERENCES `proveedor` (`ad_proveedor`),
  CONSTRAINT `fk_factura_sucursal` FOREIGN KEY (`fk_sucursal_ad_sucursal`) REFERENCES `sucursal` (`ad_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura_compra`
--

LOCK TABLES `factura_compra` WRITE;
/*!40000 ALTER TABLE `factura_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `factura_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura_compra_impuesto`
--

DROP TABLE IF EXISTS `factura_compra_impuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura_compra_impuesto` (
  `ad_factura_impuesto` int NOT NULL,
  `fk_factura_ad_factura` int NOT NULL,
  `fk_tipo_impu_ad_tipo_impuesto` int NOT NULL,
  `vl_base` decimal(10,2) NOT NULL,
  `vl_impuesto` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ad_factura_impuesto`),
  KEY `fk_fci_factura` (`fk_factura_ad_factura`),
  KEY `fk_fci_impuesto` (`fk_tipo_impu_ad_tipo_impuesto`),
  CONSTRAINT `fk_fci_factura` FOREIGN KEY (`fk_factura_ad_factura`) REFERENCES `factura_compra` (`ad_factura`),
  CONSTRAINT `fk_fci_impuesto` FOREIGN KEY (`fk_tipo_impu_ad_tipo_impuesto`) REFERENCES `tipo_impuesto` (`ad_tipo_impuesto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura_compra_impuesto`
--

LOCK TABLES `factura_compra_impuesto` WRITE;
/*!40000 ALTER TABLE `factura_compra_impuesto` DISABLE KEYS */;
/*!40000 ALTER TABLE `factura_compra_impuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historico_precios_proveedor`
--

DROP TABLE IF EXISTS `historico_precios_proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_precios_proveedor` (
  `ad_historico` int NOT NULL COMMENT 'Secuencia asociada seq_historico_precios_proveedor',
  `fk_product_ad_producto` int NOT NULL,
  `fk_provee_ad_proveedor` int NOT NULL,
  `vl_precio_unitario` decimal(10,2) NOT NULL,
  `dt_fecha_precio` date NOT NULL,
  `observaciones` text,
  PRIMARY KEY (`ad_historico`),
  KEY `idx_producto_proveedor_fecha` (`fk_product_ad_producto`,`fk_provee_ad_proveedor`,`dt_fecha_precio`),
  KEY `fk_histprec_proveedor` (`fk_provee_ad_proveedor`),
  CONSTRAINT `fk_histprec_producto` FOREIGN KEY (`fk_product_ad_producto`) REFERENCES `productos` (`ad_producto`),
  CONSTRAINT `fk_histprec_proveedor` FOREIGN KEY (`fk_provee_ad_proveedor`) REFERENCES `proveedor` (`ad_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_precios_proveedor`
--

LOCK TABLES `historico_precios_proveedor` WRITE;
/*!40000 ALTER TABLE `historico_precios_proveedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `historico_precios_proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `ad_inventario` int NOT NULL COMMENT 'Secuencia asociada seq_inventario',
  `fk_product_ad_producto` int NOT NULL,
  `cl_tipo_movimiento` enum('entrada','salida') NOT NULL,
  `dt_movimiento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `vl_cantidad` int NOT NULL DEFAULT '0',
  `vl_costo_unitario` decimal(10,2) NOT NULL DEFAULT '0.00',
  `vl_cantidad_disponible` int DEFAULT NULL COMMENT 'Solo para entradas',
  `fk_referencia_origen` int DEFAULT NULL COMMENT 'ID origen: compra, venta u orden',
  `observaciones` text,
  PRIMARY KEY (`ad_inventario`),
  KEY `idx_producto_tipo_fecha` (`fk_product_ad_producto`,`cl_tipo_movimiento`,`dt_movimiento`),
  CONSTRAINT `fk_inv_producto` FOREIGN KEY (`fk_product_ad_producto`) REFERENCES `productos` (`ad_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_errores`
--

DROP TABLE IF EXISTS `log_errores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_errores` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `modulo` varchar(100) DEFAULT NULL,
  `operacion` varchar(10) DEFAULT NULL,
  `mensaje_error` text,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `datos_entrada` text,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_errores`
--

LOCK TABLES `log_errores` WRITE;
/*!40000 ALTER TABLE `log_errores` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_errores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordenes_compra`
--

DROP TABLE IF EXISTS `ordenes_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordenes_compra` (
  `ad_orden` int NOT NULL COMMENT 'Secuencia asociada seq_ordenes_compra',
  `fk_sucursal_ad_sucursal` int NOT NULL,
  `fk_provee_ad_proveedor` int NOT NULL,
  `dt_fecha_orden` datetime NOT NULL,
  `ds_estado` enum('pendiente','completada','cancelada') DEFAULT 'pendiente',
  `vl_total` decimal(10,2) NOT NULL,
  `ds_metodo_pago` enum('efectivo','tarjeta','transferencia','otro') DEFAULT 'tarjeta',
  `dt_fecha_entrega` date DEFAULT NULL,
  `observaciones` text,
  PRIMARY KEY (`ad_orden`),
  KEY `fk_ordcomp_proveedor` (`fk_provee_ad_proveedor`),
  KEY `fk_ordcomp_sucursal` (`fk_sucursal_ad_sucursal`),
  CONSTRAINT `fk_ordcomp_proveedor` FOREIGN KEY (`fk_provee_ad_proveedor`) REFERENCES `proveedor` (`ad_proveedor`),
  CONSTRAINT `fk_ordcomp_sucursal` FOREIGN KEY (`fk_sucursal_ad_sucursal`) REFERENCES `sucursal` (`ad_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordenes_compra`
--

LOCK TABLES `ordenes_compra` WRITE;
/*!40000 ALTER TABLE `ordenes_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `ad_pedido` int NOT NULL COMMENT 'Secuencia asociada seq_pedido',
  `fk_sucursal_ad_sucursal` int NOT NULL,
  `dt_fecha_pedido` date NOT NULL,
  `dt_fecha_entrega` date NOT NULL,
  `ds_preparado_por` varchar(45) DEFAULT NULL,
  `ds_recibido_por` varchar(45) DEFAULT NULL,
  `ds_observaciones` varchar(45) DEFAULT NULL,
  `ds_estado_pedido` enum('abierto','cerrado') NOT NULL DEFAULT 'abierto',
  PRIMARY KEY (`ad_pedido`),
  KEY `pk_pedido` (`ad_pedido`) /*!80000 INVISIBLE */,
  KEY `fk_pedido_sucursal` (`fk_sucursal_ad_sucursal`),
  CONSTRAINT `fk_pedido_sucursal` FOREIGN KEY (`fk_sucursal_ad_sucursal`) REFERENCES `sucursal` (`ad_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `ad_producto` int NOT NULL COMMENT 'Secuencia asociada seq_producto',
  `nm_producto` varchar(100) NOT NULL,
  `ds_embalaje` varchar(45) NOT NULL,
  `ic_refrigeracion` varchar(1) NOT NULL DEFAULT 'N',
  `ds_observaciones` varchar(100) DEFAULT NULL,
  `nm_cuenta_puc` int NOT NULL,
  PRIMARY KEY (`ad_producto`),
  CONSTRAINT `ck_product_ic_refrigeracion` CHECK ((`ic_refrigeracion` in (_utf8mb4'Y',_utf8mb4'N')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabla maestra de productos, se codificaran tanto los insumos como el producto terminado a comercializar.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'ACEITE','BIDON','N',NULL,0),(2,'ACEITE DE SOYA','GALON','N',NULL,0),(3,'ACEITE OLIVA SUAVE','UNIDAD','N',NULL,0),(4,'ACEITE SOYA ZAPATOCA','UNIDAD','N',NULL,0),(5,'ACELGA','UNIDAD','N',NULL,0),(6,'AGUA CRISTAL PLANA 300 ML PET x 24','UNIDAD','N',NULL,0),(7,'AGUA CRISTAL 600 ML PET x 24','UNIDAD','N',NULL,0),(8,'AGUACATE','UNIDAD','N',NULL,0),(9,'AGUACATE HASS','UNIDAD','N',NULL,0),(10,'AGUACATE PAPELILLO','UNIDAD','N',NULL,0),(11,'AJO','GALON','N',NULL,0),(12,'AJO CABEZA','UNIDAD','N',NULL,0),(13,'ALBAHACA','UNIDAD','N',NULL,0),(14,'ALMENDRAS','LIBRA','N',NULL,0),(15,'ALPIN CHOC CAJ 200 ML','UNIDAD','N',NULL,0),(16,'ALPIN FRE CAJ 200 ML','UNIDAD','N',NULL,0),(17,'ALPINITO FRE 90 G x 4 UND TAT','UNIDAD','N',NULL,0),(18,'ALPINITO FRUGTA 90 G x 4 UND TAT','UNIDAD','N',NULL,0),(19,'ALPINITO MOR 90 G x 4 UND TAT','UNIDAD','N',NULL,0),(20,'ALUMINIO CHEF 300 MTS Cx6','CAJA','N',NULL,0),(21,'APIO','CANASTILLA','N',NULL,0),(22,'ARANDANOS FRESCOS','UNIDAD','N',NULL,0),(23,'AREPA ANTIOQUEÑA','UNIDAD','Y',NULL,0),(24,'AREPA BOYACENSE PA SUMERCE PAQUETE x 5','UNIDAD','Y',NULL,0),(25,'AREPA CON CARNE 110 GR','UNIDAD','Y',NULL,0),(26,'AREPA CON HUEVO 105 GR','UNIDAD','Y',NULL,0),(27,'AREPA CON QUESO 40 GR','UNIDAD','Y',NULL,0),(28,'AREPA CON QUESO 60 GR','UNIDAD','Y',NULL,0),(29,'AREPA MAIZAL RELLENA','UNIDAD','Y',NULL,0),(30,'AREPA PAISA RELLENA DE QUESO x 5','UNIDAD','Y',NULL,0),(31,'AREPA RELLENA DE QUESO DOBLE CREMA Paq x 5','UNIDAD','Y',NULL,0),(32,'AREPA SARY EXTRA','UNIDAD','Y',NULL,0),(33,'AROMATICAS','UNIDAD','N',NULL,0),(34,'ARRACACHA','KILO','N',NULL,0),(35,'ARROZ DIANA PREMIUM','UNIDAD','N',NULL,0),(36,'ARROZ FLOR HUILA','ARROBA','N',NULL,0),(37,'ARROZ ROA x 25 Libras','UNIDAD','N',NULL,0),(38,'ARVEJA','KILO','N',NULL,0),(39,'ARVEJA DESGRANADA','UNIDAD','N',NULL,0),(40,'ASESORIA NUTRICION','UNIDAD','N',NULL,0),(41,'ATUN','UNIDAD','N',NULL,0),(42,'ATUN AGUA','UNIDAD','N',NULL,0),(43,'AUYAMA','KILO','N',NULL,0),(44,'AVENA','UNIDAD','N',NULL,0),(45,'AVENA ORIGINAL VASO 250 G','UNIDAD','N',NULL,0),(46,'AZUCAR','BULTO','N',NULL,0),(47,'BAGRE PINTADO POSTA','KILO','Y',NULL,0),(48,'BANANO','UNIDAD','N',NULL,0),(49,'BANANO','KILO','N',NULL,0),(50,'BOCADILLO COMBINADO','UNIDAD','N',NULL,0),(51,'BOCADITOS','UNIDAD','N',NULL,0),(52,'BOLSA BASURA GRANDE/INDUSTRIAL x 6 UND #28','UNIDAD','N',NULL,0),(53,'BOLSA BASURA NEGRA JUMBO # 36','UNIDAD','N',NULL,0),(54,'BOLSA MANIJA 3 KL Paca x 10 Paq','UNIDAD','N',NULL,0),(55,'BOLSA MANIJA 5 KL Paca x 10 Paq','UNIDAD','N',NULL,0),(56,'BON YURT BLACK 173 G','UNIDAD','N',NULL,0),(57,'BON YURT CHOCGOZ 171 G','UNIDAD','N',NULL,0),(58,'BON YURT CHOCOKR 169 G','UNIDAD','N',NULL,0),(59,'BON YURT ZUC 170 G','UNIDAD','N',NULL,0),(60,'BY PIAZZA 174 G','UNIDAD','N',NULL,0),(61,'C-1 ICOPOR AJOVER Paq x 50 Paca x 10','UNIDAD','N',NULL,0),(62,'CABANO TAJADO','UNIDAD','N',NULL,0),(63,'CAFÉ','LIBRA','N',NULL,0),(64,'CAFÉ SELLO ROJO','UNIDAD','N',NULL,0),(65,'CALABACIN','UNIDAD','N',NULL,0),(66,'CALABAZA','UNIDAD','N',NULL,0),(67,'CAMARON','KILO','Y',NULL,0),(68,'CAMARON CRUDO 31 -35','UNIDAD','Y',NULL,0),(69,'CARNE FINA PORCIONADA','KILO','Y',NULL,0),(70,'CARNE MOLIDA ESPECIAL','KILO','Y',NULL,0),(71,'CEBOLLA CABEZONA','UNIDAD','N',NULL,0),(72,'CEBOLLA CABEZONA BLANCA','UNIDAD','N',NULL,0),(73,'CEBOLLA LARGA','KILO','N',NULL,0),(74,'CEBOLLIN','UNIDAD','N',NULL,0),(75,'CHAMPIÑON','UNIDAD','N',NULL,0),(76,'CHOCOLATE CORONA','UNIDAD','N',NULL,0),(77,'CHORIZO PREMIUM','KILO','Y',NULL,0),(78,'CHORIZO SANTARROSANO','KILO','Y',NULL,0),(79,'CHURRASCO','KILO','Y',NULL,0),(80,'CILANTRO','KILO','N',NULL,0),(81,'CIRUELA','UNIDAD','N',NULL,0),(82,'CIRUELA CHILENA','KILO','N',NULL,0),(83,'CLUB SOCIAL Bx9 Cx24','CAJA','N',NULL,0),(84,'CLUB SOCIAL INTEGRAL Bx9 Cx24','CAJA','N',NULL,0),(85,'COCA COLA','UNIDAD','N',NULL,0),(86,'COCADAS','UNIDAD','N',NULL,0),(87,'COCO','UNIDAD','N',NULL,0),(88,'COHOMBRO','KILO','N',NULL,0),(89,'COLICERO','UNIDAD','N',NULL,0),(90,'COLOMBINAS A GRANEL','KILO','Y',NULL,0),(91,'COLOR','LIBRA','N',NULL,0),(92,'CONDIMENTOS EL REY CANELA','UNIDAD','N',NULL,0),(93,'CONTENEDOR 316 T PLASTICA Paq x 20 Uni Caja x 20 Paq','UNIDAD','N',NULL,0),(94,'COOKIES CHOCO DISPLAY x 70 C x12','UNIDAD','N',NULL,0),(95,'COPA SOUFFLE x 2 ONZ Caja x 25 Paq','UNIDAD','N',NULL,0),(96,'COSTILLA RES ESPECIAL','KILO','Y',NULL,0),(97,'COSTILLA ST. LOUIS','KILO','Y',NULL,0),(98,'CRAKEÑAS CLUB INDIV Bx10 Cx24','UNIDAD','N',NULL,0),(99,'CRAKEÑAS DORADITAS Bx8 Cx24','CAJA','N',NULL,0),(100,'CREMA DE LECHE ALQUERIA','UNIDAD','Y',NULL,0),(101,'CROTONES','UNIDAD','N',NULL,0),(102,'CUCHUCO DE CEBADA','UNIDAD','N',NULL,0),(103,'DELANTAL CORTO DESECHABLE','UNIDAD','N',NULL,0),(104,'DELANTAL LARGO x 12 Caja x 50 UND','UNIDAD','N',NULL,0),(105,'DESCARGUE TAJADO','KILO','Y',NULL,0),(106,'DOMICILIO','UNIDAD','N',NULL,0),(107,'DURAZNO','UNIDAD','N',NULL,0),(108,'DURAZNO LARGA VIDA','KILO','N',NULL,0),(109,'EMPANADA CON CARNE RES 50GR','UNIDAD','Y',NULL,0),(110,'EMPANADA CON CARNE RES 80GR','UNIDAD','Y',NULL,0),(111,'EMPANADA CON QUESO 50GR','UNIDAD','Y',NULL,0),(112,'ENDULZANTE ERBA','UNIDAD','N',NULL,0),(113,'ESENCIA DE VAINILLA','FRASCO','N',NULL,0),(114,'ESPINACA','KILO','N',NULL,0),(115,'FIDEOS','LIBRA','N',NULL,0),(116,'FILETE DE SALMON','KILO','Y',NULL,0),(117,'FILETE DE TILAPIA','KILO','Y',NULL,0),(118,'FILETE DE TRUCHA','KILO','Y',NULL,0),(119,'FRAMBUESAS MADURAS','KILO','N',NULL,0),(120,'FRESA','UNIDAD','N',NULL,0),(121,'FRESA LARGA VIDA','KILO','N',NULL,0),(122,'FRIJOL BOLA ROJA ZAPATOCA','UNIDAD','N',NULL,0),(123,'FRIJOL VERDE DESGRANADO','KILO','N',NULL,0),(124,'FRUTOS AMARILLOS LARGA VIDA','KILO','N',NULL,0),(125,'FRUTOS ROJOS LARGA VIDA','KILO','N',NULL,0),(126,'GELATINA ROJA','LIBRA','N',NULL,0),(127,'GORRO EN VELO BLANCO TIPO MONJA','UNIDAD','N',NULL,0),(128,'GOULASH DE BOLA','KILO','Y',NULL,0),(129,'GRANADILLA','UNIDAD','N',NULL,0),(130,'GRISSLY FERIAS 8g Bx45 Cx16','CAJA','N',NULL,0),(131,'GUANABANA','UNIDAD','N',NULL,0),(132,'GUANTE ETERNA CLASICO','UNIDAD','N',NULL,0),(133,'GUANTE NITRILO NEGRO','UNIDAD','N',NULL,0),(134,'GUANTE NITRILO NEGRO x 100 UND Caja x 10 Display','UNIDAD','N',NULL,0),(135,'GUASCAS','UNIDAD','N',NULL,0),(136,'GUAYABA','UNIDAD','N',NULL,0),(137,'HABAS','KILO','N',NULL,0),(138,'HABICHUELA','UNIDAD','N',NULL,0),(139,'HAMBURGUESA RES 100 GR CRUDA','UNIDAD','Y',NULL,0),(140,'HOJA DE BIJAO','KILO','N',NULL,0),(141,'HUEVOS A','UNIDAD','N',NULL,0),(142,'JAMON AHUMADO','UNIDAD','N',NULL,0),(143,'JAMON PIETRAN PAVO','UNIDAD','Y',NULL,0),(144,'JAMON PIETRAN x 431 GR','UNIDAD','Y',NULL,0),(145,'JAMON YORK ESPECIAL','UNIDAD','N',NULL,0),(146,'JENGIBRE','LIBRA','N',NULL,0),(147,'KIWI','UNIDAD','N',NULL,0),(148,'LAUREL','UNIDAD','N',NULL,0),(149,'LECHE ALMENDRA SILK','UNIDAD','N',NULL,0),(150,'LECHE CONDENSADA','GALON','Y',NULL,0),(151,'LECHE DESLACTOSADA ALQUERIA','UNIDAD','Y',NULL,0),(152,'LECHE EN POLVO','UNIDAD','N',NULL,0),(153,'LECHE ENTERA ZAPATOCA','UNIDAD','Y',NULL,0),(154,'LECHUGAS','DOCENA','N',NULL,0),(155,'LIMON','UNIDAD','N',NULL,0),(156,'LIMON TAHITI','UNIDAD','N',NULL,0),(157,'LIMONADA X 24 250ML','UNIDAD','Y',NULL,0),(158,'LIMONADA X 24 500ML','UNIDAD','Y',NULL,0),(159,'LOMO CERDO ALMENDRA','KILO','Y',NULL,0),(160,'LULO LARGA VIDA','KILO','N',NULL,0),(161,'MANDARINA','UNIDAD','N',NULL,0),(162,'MANDARINA ARRAYANA','UNIDAD','N',NULL,0),(163,'MANGO','UNIDAD','N',NULL,0),(164,'MANGO LARGA VIDA','KILO','N',NULL,0),(165,'MANGO TOMI','UNIDAD','N',NULL,0),(166,'MANTEQUILLA','LIBRA','N',NULL,0),(167,'MANZANA','CAJA','N',NULL,0),(168,'MANZANA LARGA VIDA','KILO','N',NULL,0),(169,'MANZANA ROYAL','UNIDAD','N',NULL,0),(170,'MARACUYA','UNIDAD','N',NULL,0),(171,'MARACUYA LARGA VIDA','KILO','N',NULL,0),(172,'MARAÑON SECO x 500 GR','UNIDAD','N',NULL,0),(173,'MARGARINA LA PREFERIDA BARRA','UNIDAD','N',NULL,0),(174,'MAZORCA','KILO','N',NULL,0),(175,'MAZORCA DESGRANADA','KILO','N',NULL,0),(176,'MAZORCA DULCE x BANDEJAS','UNIDAD','N',NULL,0),(177,'MELON','UNIDAD','N',NULL,0),(178,'MIEL DE ABEJAS','BOTELLA','N',NULL,0),(179,'MILO','UNIDAD','N',NULL,0),(180,'MINI BY CHOCCAN VASO 100 G','UNIDAD','N',NULL,0),(181,'MOLIDA ESPECIAL','KILO','Y',NULL,0),(182,'MORA','UNIDAD','N',NULL,0),(183,'MUCHACHO','KILO','Y',NULL,0),(184,'MUTE','KILO','Y',NULL,0),(185,'NARANJA','UNIDAD','N',NULL,0),(186,'NARANJA VALENCIA','UNIDAD','N',NULL,0),(187,'NESCAFE','UNIDAD','N',NULL,0),(188,'NESCAFE CAPUCCINO ORIGINAL ALEGRIA 1000 G','UNIDAD','N',NULL,0),(189,'NESCAFE CAPUCCINO VAINILLA 1000 G','UNIDAD','N',NULL,0),(190,'PALOMILLA','KILO','Y',NULL,0),(191,'PAN BIMBO PERRO x 6','UNIDAD','N',NULL,0),(192,'PAN BLANCO','UNIDAD','N',NULL,0),(193,'PAN BLANCO EXTRA GRANDE x 750 G','UNIDAD','N',NULL,0),(194,'PAN HAMBURGUESA x 12 Uni x 780 G','UNIDAD','N',NULL,0),(195,'PAN HOJALDRADO GLORIA BOCADILLO 75 GR','UNIDAD','N',NULL,0),(196,'PAN HOJALDRADO GLORIA BOCADILLO 85 GR','UNIDAD','N',NULL,0),(197,'PAN HOJALDRADO PALITO CON QUESO 65 GR','UNIDAD','N',NULL,0),(198,'PAN PERRO x 780 G x 12 Uni','UNIDAD','N',NULL,0),(199,'PANELA','UNIDAD','N',NULL,0),(200,'PANELITAS DE LECHE','UNIDAD','N',NULL,0),(201,'PAPA CASCO','KILO','N',NULL,0),(202,'PAPA CORTE 9X9 X 2','UNIDAD','N',NULL,0),(203,'PAPA CRIOLLA','KILO','N',NULL,0),(204,'PAPA CRIOLLA RODAJAS','KILO','N',NULL,0),(205,'PAPA CRIOLLA SOPA','KILO','N',NULL,0),(206,'PAPA PASTUSA','KILO','N',NULL,0),(207,'PAPA PASTUSA CHALECO','KILO','N',NULL,0),(208,'PAPA PASTUSA RODAJAS','KILO','N',NULL,0),(209,'PAPA PASTUSA SOPA','KILO','N',NULL,0),(210,'PAPA SABANERA','KILO','N',NULL,0),(211,'PAPA SABANERA RODAJAS','KILO','N',NULL,0),(212,'PAPAYA','UNIDAD','N',NULL,0),(213,'PAPAYA','UNIDAD','N',NULL,0),(214,'PAPEL HIGIENICO RENDIPEL 250 MTS Paca x 4 Rollos','UNIDAD','N',NULL,0),(215,'PASTA DORIA CONCHAS','UNIDAD','N',NULL,0),(216,'PASTA DORIA FIDEOS','UNIDAD','N',NULL,0),(217,'PASTA DORIA SPAGUETI','UNIDAD','N',NULL,0),(218,'PECHUGA A GRANEL','KILO','Y',NULL,0),(219,'PECHUGA x 20 CTA GRANDE','UNIDAD','N',NULL,0),(220,'PEPINO','UNIDAD','N',NULL,0),(221,'PERA','UNIDAD','N',NULL,0),(222,'PEREJIL CRESPO','UNIDAD','N',NULL,0),(223,'PERNIL DE CERDO PULPO','KILO','Y',NULL,0),(224,'PEZUÑA DE CERDO','KILO','Y',NULL,0),(225,'PIERNAS DE POLLO A GRANEL','KILO','Y',NULL,0),(226,'PIMENTON','KILO','N',NULL,0),(227,'PIMIENTA','LIBRA','N',NULL,0),(228,'PIÑA','UNIDAD','N',NULL,0),(229,'PITAYA','UNIDAD','N',NULL,0),(230,'PLATANO MADURO','KILO','N',NULL,0),(231,'PLATANO VERDE','KILO','N',NULL,0),(232,'POLVO DE HORNEAR','LIBRA','N',NULL,0),(233,'PORTA HAMBURGUESA x 100 Caja x 10 Paq','UNIDAD','N',NULL,0),(234,'PORTA PIZZA','UNIDAD','N',NULL,0),(235,'PORTACOMIDA J-1','UNIDAD','N',NULL,0),(236,'PULPA DE CERDO','KILO','Y',NULL,0),(237,'QUESO','UNIDAD','Y',NULL,0),(238,'QUESO DOBLE CREMA','UNIDAD','Y',NULL,0),(239,'QUESO PAIPA','UNIDAD','N',NULL,0),(240,'QUESO PARMESANO','UNIDAD','N',NULL,0),(241,'QUESO PERA','UNIDAD','Y',NULL,0),(242,'REMOLACHA','UNIDAD','N',NULL,0),(243,'SABILA','UNIDAD','N',NULL,0),(244,'SAL','KILO','N',NULL,0),(245,'SAL REFISAL BOL x 20','UNIDAD','N',NULL,0),(246,'SAL SOBRES','CAJA','N',NULL,0),(247,'SALAMI FINO','UNIDAD','N',NULL,0),(248,'SALCHICHA','UNIDAD','Y',NULL,0),(249,'SALCHICHA RANCHERA x 14','UNIDAD','Y',NULL,0),(250,'SALCHICHA ZENU PERRO','UNIDAD','Y',NULL,0),(251,'SALSA TERIYAKI','GALON','N',NULL,0),(252,'SELLO PLUS 8 ONZ TAPA PLANA Paca x 200 Uni','UNIDAD','N',NULL,0),(253,'SERVILLETA FAVORITA 300 Caja x 15 Paq','UNIDAD','N',NULL,0),(254,'SUKINI','UNIDAD','N',NULL,0),(255,'SULTANA NOEL B x 12 C x 24','UNIDAD','N',NULL,0),(256,'TAPA 3.5-6-7 WAU Caja x 90 Paq','UNIDAD','N',NULL,0),(257,'TAPA DOMO PET 12 ONZ MIO Paq x 50 Caja x 20 Paq','UNIDAD','N',NULL,0),(258,'TAPA SOUFFLE 1.5-2 ONZ Caja x 25 Paq','UNIDAD','N',NULL,0),(259,'TAPABOCAS EMPAQUE INDIVIDUAL X 50 Uni Caja x 40','UNIDAD','N',NULL,0),(260,'TARAPACA','UNIDAD','N',NULL,0),(261,'TE VERDE HINDU','UNIDAD','N',NULL,0),(262,'TOALLA COLTISU NATURAL x 150 Uni Caja x 24 Paq','UNIDAD','N',NULL,0),(263,'TOMATE','KILO','N',NULL,0),(264,'TOMATE CHERRY','UNIDAD','N',NULL,0),(265,'TOMATE CHONTO','UNIDAD','N',NULL,0),(266,'TOMILLO','UNIDAD','N',NULL,0),(267,'TORTA TIRAMISU','UNIDAD','N',NULL,0),(268,'TOSH BARRA CEREAL SURT D x 24 C x 12','UNIDAD','N',NULL,0),(269,'TOSH MIEL Bx9 Cx24','CAJA','N',NULL,0),(270,'TRANSPORTE DE RESIDUOS','UNIDAD','N',NULL,0),(271,'UCHUVA','KILO','N',NULL,0),(272,'UVA ROJA CHILENA','UNIDAD','N',NULL,0),(273,'UVA VERDE','UNIDAD','N',NULL,0),(274,'UVA VERDE CHILENA','UNIDAD','N',NULL,0),(275,'UVA VERDE IMPORTADA','UNIDAD','N',NULL,0),(276,'VASO 12 PET ONZ x 25 Uni MIO Caja x 20 Paq','UNIDAD','N',NULL,0),(277,'VASO 3.5 ONZ TRANSPARENTE WAU Caja x 60 Paq','UNIDAD','N',NULL,0),(278,'VASO 7 ONZ TRANSPARENTE WAU Caja x 60 Paq','UNIDAD','N',NULL,0),(279,'VINIPEL x 1500 ECONOMICO 12 \" x Rollo','UNIDAD','N',NULL,0),(280,'YOG ALPINA ORIGINAL VASO','UNIDAD','Y',NULL,0),(281,'YOG GRIEGO ALPINA','UNIDAD','Y',NULL,0),(282,'YOG ORIG FRE BOT 1750 G','UNIDAD','N',NULL,0),(283,'YOG ORIG FRE VASO 150 G','UNIDAD','N',NULL,0),(284,'YOG ORIG FTRROJ VASO 150 G','UNIDAD','N',NULL,0),(285,'YOG ORIG GUANAB VASO 150 G','UNIDAD','N',NULL,0),(286,'YOG ORIG MELO BOT 1750 G','UNIDAD','N',NULL,0),(287,'YOG ORIG MELOC VASO 150 G','UNIDAD','N',NULL,0),(288,'YOG ORIG MORA VASO 150 G','UNIDAD','N',NULL,0),(289,'YOX FRE BOT 100 G','UNIDAD','N',NULL,0),(290,'YOX MELOC BOT 100 G','UNIDAD','N',NULL,0),(291,'YOX MULTFRT BOT 100 G','UNIDAD','N',NULL,0),(292,'YUCA','UNIDAD','N',NULL,0),(293,'ZANAHORIA','KILO','N',NULL,0),(294,'ZANAHORIA PICADA','KILO','N',NULL,0),(295,'ZUMO DE LIMON 3.785 ML','GALON','Y',NULL,0);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedor` (
  `ad_proveedor` int NOT NULL COMMENT 'Secuencia asociada seq_proveedor',
  `ds_identificacion` varchar(20) NOT NULL,
  `ds_razon_social` varchar(80) NOT NULL,
  `ds_direccion` varchar(100) DEFAULT NULL,
  `ds_correo_electronico` varchar(100) DEFAULT NULL,
  `ds_telefono` varchar(45) DEFAULT NULL,
  `cl_tipo_identificacion` varchar(2) NOT NULL DEFAULT 'NI',
  `dt_creacion` date NOT NULL DEFAULT (curdate()),
  `ds_productos` varchar(100) DEFAULT NULL,
  `ds_contacto` varchar(45) DEFAULT NULL,
  `ic_registro_activo` varchar(1) NOT NULL DEFAULT 'Y',
  `nm_cuenta_puc` int NOT NULL COMMENT 'Cuenta contable asociada, tomada del PUC',
  PRIMARY KEY (`ad_proveedor`),
  CONSTRAINT `ck_provee_ic_registro_activo` CHECK ((`ic_registro_activo` in (_utf8mb4'Y',_utf8mb4'N'))),
  CONSTRAINT `ck_provee_tipo_identif` CHECK ((`cl_tipo_identificacion` in (_utf8mb4'NI',_utf8mb4'CC')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedor`
--

LOCK TABLES `proveedor` WRITE;
/*!40000 ALTER TABLE `proveedor` DISABLE KEYS */;
INSERT INTO `proveedor` VALUES (1,'900123316-5','PROALCARNICOS S.A.S','AV CIUDAD DE CALI #15A-91 Local B11 y B12','carnespuntorojo@gmail.com','3144140420','NI','2026-02-14','Carne',NULL,'Y',0),(2,'79465304-7','COMERCIALIZADORA DE FRUTAS LA HUERTA DE RICHAR','Plaza de Mercado Paloquemao Local 81671-81669',NULL,'3704283 - 3118536742','NI','2026-02-14','Frutas y Verduras',NULL,'Y',0),(3,'901357068-1','INVERSIONES MAFREDCHI SAS','Carrera 143 Bis #137 - 54','fredychia86@gmail.com','3212178017','NI','2026-02-14','Pescado y Verduras',NULL,'Y',0),(4,'800195623-7','ALIMENTOS SAS S.A.S','DIAGONAL 19D #39-20','contabilidad@sas.com.co','2699978','NI','2026-02-14','PULPA DE FRUTA',NULL,'Y',0),(5,'900130706-3','INVERSIONES COARALI S.A.','TRANSV. 124 #18A-02','carteracoarali@gmail.com','PBX 7433433 - 3138870686','NI','2026-02-14','Empanadas, Hamburguesas',NULL,'Y',0),(6,'900607964','FRUTERA COLOMBO UNIVERSAL SAS','Diagonal 16 Sur #40 a - 13','servicioalcliente@frucun.com','7277279','NI','2026-02-14','Papa',NULL,'Y',0),(7,'1001060162-6','SWEET DELIVERY','Avenida Carrera 33 # 42 - 19 Sur',NULL,'3144544601','NI','2026-02-14','Pstres, Cafeteria',NULL,'Y',0),(8,'900526069','MAIZAREPAS SAS','Calle 25 a # 102 a - 43','contabilidad@maizarepas.com',NULL,'NI','2026-02-14','Arepas',NULL,'Y',0),(9,'901852625-7','LIMON Y LIMONADA SAS','Carrera 69 d # 67 - 70','ventas.limonylimonada@hotmail.com','3157827362','NI','2026-02-14','Limos, Limonada',NULL,'Y',0),(10,'860047427-4','CARNES FRIAS SAN MARTIN LTDA','Carrera 69 C # 31 - 63/73 SUR','contabilidad@carnesfriassanmartin.com','7131020','NI','2026-02-14','Carnes Frias',NULL,'Y',0),(11,'901845922-0','DISTRIBUIDORA AGUACATES Y LIMONES AyM SAS','Carrera 47 Sur # 59 a - 02','edinsonalejandroricaurtefact@gmail.com','3105859035','NI','2026-02-14','Verduras',NULL,'Y',0),(12,'901027291-2','M & A SURTINEGOCIOS S.A.S.','Calle 66 # 22 - 40','myasurtinegocios@gmail.com',NULL,'NI','2026-02-14','Desechables',NULL,'Y',0),(13,'830088784-5','COMERCIALIZADORA DULCENEV SAS','Carrera 52c # 43 - 11 Sur',NULL,'2382919','NI','2026-02-14','Galleteria, Dulces',NULL,'Y',0),(14,'51780116','DIAZ GAMEZ MARIA MONICA ELENA','Calle 30 D Sur # 5 A - 19','abejaymiel@hotmail.com','3138866140','NI','2026-02-14','Asesoria Nutrición',NULL,'Y',0),(15,'890201881-4','AVSA S.A','Calle 24a #69a - 76 Local 7','servicliente@macpollo.com','6013789592','NI','2026-02-14','Pollo',NULL,'Y',0),(16,'900969661-2','COMERCIALIZADORES R&M SAS','Calle 22H # 103 b -03','servicioalcliente@rymsas.com','4185418','NI','2026-02-14','Lacteos',NULL,'Y',0),(17,'900269019-1','LOGISTICA AMBIENTAL COLOMBIA SAS','KM 14 VIA MOSQUERA LA MESA','logisticaambientalistica@hotmail.com','3172753044 - 3006703456','NI','2026-02-14','Transporte de Residuos',NULL,'Y',0),(18,'17162561','GUILLERMO MESA TRIANA',NULL,NULL,'3114451143','CC','2026-02-14','SERVICIO CONTABLE',NULL,'Y',0),(19,'1','NESTOR CORDERO',NULL,NULL,NULL,'CC','2026-02-14','SERVICIO DE TRANSPORTE',NULL,'Y',0),(20,'2','ROCIO TELLEZ',NULL,NULL,NULL,'CC','2026-02-14','SERVICIO DE TRANSPORTE',NULL,'Y',0),(21,'3','JOSE ALVARO RUGE',NULL,NULL,NULL,'CC','2026-02-14','SERVICIO DE TRANSPORTE',NULL,'Y',0),(22,'4','LUIS BAEZ',NULL,NULL,NULL,'CC','2026-02-14','SERVICIO DE TRANSPORTE',NULL,'Y',0),(23,'900334800-4','PRODUCTOS ALIMENTICIOS VALDANI S.A.S.','Calle 66 # 74 b - 05',NULL,'6016954016 - 3112343059','NI','2026-02-14','Arepas',NULL,'Y',0),(24,'860001697','GASESOSAS LUX S.A.S.','AVENIDA CALLE 9 # 50 - 85','recepcionfe@gaslux.com.co',NULL,'NI','2026-02-14','Gaseosa',NULL,'Y',0),(25,'800106774-0','MERCADO ZAPATOCA S.A VILLA LUZ','Carrera 77 bis # 63C - 33',NULL,'3019900000','NI','2026-02-14','Mercado y abarrotes',NULL,'Y',0),(26,'900319753-3','PRICESMART Colombia S.A.S.','Avenida Calle 26 # 71 A - 16',NULL,NULL,'NI','2026-02-14','Mercado y abarrotes',NULL,'Y',0),(27,'5','JUAN CARLOS PARRAGA',NULL,NULL,NULL,'CC','2026-02-14',NULL,NULL,'Y',0),(28,'890900608-9','ALMACENES ÉXITO S.A.','CENTRO COMERCIAL SALITRE PLAZA',NULL,NULL,'NI','2026-02-14','Mercado y abarrotes',NULL,'Y',0),(29,'901759127-3','PLASTICOS Y DESECHABLES LA ESPERANZA','CALLE 24 # 69 - 51 LOCAL 6','dalvanind@gmail.com','3005737991 - 6014661137','NI','2026-02-14','Desechables',NULL,'Y',0),(30,'900561507','PUNTA CAMARON SAN MARTIN','AVENIDA CIUDAD DE CALI # 15 a - 91 Local B 21',NULL,'3232209593','NI','2026-02-14','PESCADO',NULL,'Y',0),(31,'890905975-1','ABRASIVOS INDUSTRIALES S.A.S','Carrera 52 # 25 -17 Avenida Guayabal',NULL,'604 3222274','NI','2026-02-14','Articulos de Protección',NULL,'Y',0);
/*!40000 ALTER TABLE `proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secuencias`
--

DROP TABLE IF EXISTS `secuencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `secuencias` (
  `nombre_secuencia` varchar(30) NOT NULL,
  `valor_actual` bigint NOT NULL,
  `valor_incremental` int NOT NULL,
  `valor_minimo` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`nombre_secuencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Almacena todas las secuencias utilizadas en las tablas de la BD';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secuencias`
--

LOCK TABLES `secuencias` WRITE;
/*!40000 ALTER TABLE `secuencias` DISABLE KEYS */;
INSERT INTO `secuencias` VALUES ('seq_banco',0,1,0),('seq_cotizacion',0,1,0),('seq_cotizacion_detalle',0,1,0),('seq_cuenta_bancaria',0,1,0),('seq_cuenta_cobro',0,1,0),('seq_detalle_factura_compra',0,1,0),('seq_detalle_pedido',0,1,0),('seq_detalles_orden_compra',0,1,0),('seq_empresa',1,1,0),('seq_factura_compra',0,1,0),('seq_factura_impuesto',0,1,0),('seq_historico_pre_prov',0,1,0),('seq_inventario',0,1,0),('seq_ordenes_compra',0,1,0),('seq_pedido',0,1,0),('seq_producto',295,1,0),('seq_proveedor',31,1,0),('seq_sucursal',3,1,0),('seq_sucursal_banco',0,1,0),('seq_tipo_impuesto',0,1,0);
/*!40000 ALTER TABLE `secuencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursal`
--

DROP TABLE IF EXISTS `sucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sucursal` (
  `ad_sucursal` int NOT NULL COMMENT 'Secuencia asociada seq_sucursal',
  `fk_empresa_ad_empresa` int NOT NULL,
  `ds_nombre` varchar(60) NOT NULL,
  `ds_direccion` varchar(45) DEFAULT NULL,
  `ds_correo_electronico` varchar(100) DEFAULT NULL,
  `ds_telefono` varchar(45) DEFAULT NULL,
  `dt_creacion` date NOT NULL DEFAULT (curdate()),
  `ds_observacion` varchar(100) DEFAULT NULL,
  `ds_contacto` varchar(45) DEFAULT NULL,
  `ic_registro_activo` varchar(1) NOT NULL DEFAULT 'Y',
  `nm_cuenta_puc` int NOT NULL COMMENT 'Cuenta contable asociada, tomada del PUC',
  PRIMARY KEY (`ad_sucursal`),
  KEY `fk_sucursal_empresa` (`fk_empresa_ad_empresa`),
  CONSTRAINT `fk_sucursal_empresa` FOREIGN KEY (`fk_empresa_ad_empresa`) REFERENCES `empresa` (`ad_empresa`),
  CONSTRAINT `ck_sucursal_ic_registro_activo` CHECK ((`ic_registro_activo` in (_utf8mb4'Y',_utf8mb4'N')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal`
--

LOCK TABLES `sucursal` WRITE;
/*!40000 ALTER TABLE `sucursal` DISABLE KEYS */;
INSERT INTO `sucursal` VALUES (1,1,'Colegio Agustiniano Ciudad Salitre','Calle 23C # 69B - 01','baucortltda@hotmail.com','3223491893','2026-01-16','','Jorge Enrique Gaitán Pedraza','Y',0),(2,1,'Colegio Bilingüe Nuestra Señora Del Rosario','Calle 4 # 57 - 49','baucortnuestrasradelrosariobta@gmail.com','3102157084','2026-01-16','','Jorge Enrique Gaitán Pedraza','Y',0),(3,1,'Alimentación Religiosos','Calle 23C # 69B - 01','baucortltda@hotmail.com','7559697 - 3223491893','2026-01-19','','Jorge Enrique Gaitán Pedraza','Y',0);
/*!40000 ALTER TABLE `sucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursal_banco`
--

DROP TABLE IF EXISTS `sucursal_banco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sucursal_banco` (
  `ad_sucursal_banco` int NOT NULL COMMENT 'Secuencia sucursal banco',
  `fk_banco_ad_banco` int NOT NULL,
  `ds_nombre` varchar(100) NOT NULL,
  `ds_direccion` varchar(100) DEFAULT NULL,
  `ds_telefono` varchar(45) DEFAULT NULL,
  `ic_activo` char(1) NOT NULL DEFAULT 'Y',
  `dt_creacion` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`ad_sucursal_banco`),
  KEY `fk_sucursal_banco_banco` (`fk_banco_ad_banco`),
  CONSTRAINT `fk_sucursal_banco_banco` FOREIGN KEY (`fk_banco_ad_banco`) REFERENCES `banco` (`ad_banco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal_banco`
--

LOCK TABLES `sucursal_banco` WRITE;
/*!40000 ALTER TABLE `sucursal_banco` DISABLE KEYS */;
/*!40000 ALTER TABLE `sucursal_banco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_impuesto`
--

DROP TABLE IF EXISTS `tipo_impuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_impuesto` (
  `ad_tipo_impuesto` int NOT NULL COMMENT 'Secuencia tipo impuesto',
  `ds_codigo` varchar(10) NOT NULL COMMENT 'Código interno (IVA, RTF, ICE, etc)',
  `ds_nombre` varchar(100) NOT NULL COMMENT 'Nombre del impuesto',
  `pr_porcentaje` decimal(5,2) NOT NULL COMMENT 'Porcentaje del impuesto',
  `cl_tipo` enum('impuesto','retencion') NOT NULL COMMENT 'Tipo de impuesto',
  `ic_activo` char(1) NOT NULL DEFAULT 'Y',
  `dt_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ad_tipo_impuesto`),
  UNIQUE KEY `uk_tipo_impuesto_codigo` (`ds_codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_impuesto`
--

LOCK TABLES `tipo_impuesto` WRITE;
/*!40000 ALTER TABLE `tipo_impuesto` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipo_impuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'db_baucort'
--

--
-- Dumping routines for database 'db_baucort'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_actualiza_secuencias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_actualiza_secuencias`(str_nombre_seq varchar(30)) RETURNS int
    DETERMINISTIC
BEGIN
declare v_valor_actualizado bigint;
declare v_valor_actual bigint;
declare v_valor_incremental int;

set v_valor_actualizado = 0;
set v_valor_actual = 0;
set v_valor_incremental = 0;

SELECT 
    se.valor_actual, se.valor_incremental
INTO v_valor_actual , v_valor_incremental FROM
    secuencias se
WHERE
    se.nombre_secuencia = str_nombre_seq;
    
    set v_valor_actualizado = v_valor_actual + v_valor_incremental;
    
UPDATE secuencias se 
SET 
    se.valor_actual = v_valor_actualizado
WHERE
    se.nombre_secuencia = str_nombre_seq;

RETURN v_valor_actualizado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregar_impuesto_factura_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agregar_impuesto_factura_compra`(
    IN p_fk_factura_ad_factura INT,
    IN p_fk_tipo_impuesto INT,
    IN p_vl_impuesto DECIMAL(10,2),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_estado_factura VARCHAR(20);
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_error TEXT;

    /* ================= MANEJO DE ERRORES ================= */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* ================= VALIDACIONES ================= */

    IF p_fk_factura_ad_factura IS NULL
       OR p_fk_tipo_impuesto IS NULL
       OR p_vl_impuesto < 0 THEN
        SET p_mensaje = 'ERROR: Datos de impuesto inválidos';
        LEAVE proc;
    END IF;

    /* Validar estado factura */
    SELECT ds_estado_factura
    INTO v_estado_factura
    FROM factura_compra
    WHERE ad_factura = p_fk_factura_ad_factura;

    IF v_estado_factura IS NULL THEN
        SET p_mensaje = 'ERROR: La factura no existe';
        LEAVE proc;
    END IF;

    IF v_estado_factura <> 'registrada' THEN
        SET p_mensaje = 'ERROR: La factura no permite modificación de impuestos';
        LEAVE proc;
    END IF;

    /* Validar tipo de impuesto */
    SELECT COUNT(*) INTO v_existe
    FROM tipo_impuesto
    WHERE ad_tipo_impuesto = p_fk_tipo_impuesto
      AND ic_activo = 'Y';

    IF v_existe = 0 THEN
        SET p_mensaje = 'ERROR: Tipo de impuesto inválido o inactivo';
        LEAVE proc;
    END IF;

    /* Validar duplicidad */
    SELECT COUNT(*) INTO v_existe
    FROM factura_compra_impuesto
    WHERE fk_factura_ad_factura = p_fk_factura_ad_factura
      AND fk_tipo_impuesto = p_fk_tipo_impuesto;

    IF v_existe > 0 THEN
        SET p_mensaje = 'ERROR: Este impuesto ya fue registrado en la factura';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    /* ================= INSERTAR IMPUESTO ================= */
    INSERT INTO factura_compra_impuesto (
        ad_factura_impuesto,
        fk_factura_ad_factura,
        fk_tipo_impuesto,
        vl_impuesto
    ) VALUES (
        fn_actualiza_secuencias('seq_factura_compra_impuesto'),
        p_fk_factura_ad_factura,
        p_fk_tipo_impuesto,
        p_vl_impuesto
    );

    COMMIT;

    SET p_mensaje = 'Impuesto registrado correctamente en la factura';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cerrar_factura_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cerrar_factura_compra`(
    IN p_ad_factura INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_facturado DECIMAL(10,2) DEFAULT 0;
    DECLARE v_descuento DECIMAL(10,2) DEFAULT 0;
    DECLARE v_impuestos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_retencion DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_estado VARCHAR(20);
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_error TEXT;
    DECLARE p_fk_ordencom_ad_orden INT;
    DECLARE v_fk_provee_ad_proveedor INT;

    /* ================= MANEJO DE ERRORES ================= */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* ================= VALIDACIONES ================= */
    IF p_ad_factura IS NULL THEN
        SET p_mensaje = 'ERROR: ID de factura obligatorio';
        LEAVE proc;
    END IF;

    SELECT ds_estado_factura, vl_descuento, vl_retencion, vl_impuestos, vl_total, fk_ordencom_ad_orden, fk_provee_ad_proveedor
    INTO v_estado, v_descuento, v_retencion, v_impuestos, v_total, p_fk_ordencom_ad_orden, v_fk_provee_ad_proveedor
    FROM factura_compra
    WHERE ad_factura = p_ad_factura;

    IF v_estado IS NULL THEN
        SET p_mensaje = 'ERROR: La factura no existe';
        LEAVE proc;
    END IF;

    IF v_estado <> 'registrada' THEN
        SET p_mensaje = 'ERROR: La factura ya fue cerrada o no es editable';
        LEAVE proc;
    END IF;

    /* Validar que tenga detalle */
    SELECT COUNT(*) INTO v_existe
    FROM detalle_factura_compra
    WHERE fk_factura_ad_factura = p_ad_factura;

    IF v_existe = 0 THEN
        SET p_mensaje = 'ERROR: La factura no tiene detalle';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    /* ================= CALCULAR BASE FACTURADA ================= */
    SELECT SUM(vl_subtotal)
    INTO v_facturado
    FROM detalle_factura_compra
    WHERE fk_factura_ad_factura = p_ad_factura;

    /* ================= CALCULAR IMPUESTOS ================= */
    IF v_impuestos = 0 THEN
        SELECT IFNULL(SUM(vl_impuesto),0)
        INTO v_impuestos
        FROM factura_compra_impuesto
        WHERE fk_factura_ad_factura = p_ad_factura;
    END IF;
    /* ================= VALIDACIONES DE NEGOCIO ================= */
    IF v_facturado <= 0 THEN
        SET p_mensaje = 'ERROR: El valor facturado es inválido';
        ROLLBACK;
        LEAVE proc;
    END IF;

    IF v_impuestos < 0 OR v_descuento < 0 OR v_retencion < 0 THEN
        SET p_mensaje = 'ERROR: Valores financieros inválidos';
        ROLLBACK;
        LEAVE proc;
    END IF;

    /* ================= CALCULAR TOTAL ================= */
    SET v_total = v_facturado - v_descuento + v_impuestos;

    IF v_total < 0 THEN
        SET p_mensaje = 'ERROR: El total de la factura es inválido';
        ROLLBACK;
        LEAVE proc;
    END IF;

    /* ================= ACTUALIZAR FACTURA ================= */
    UPDATE factura_compra
    SET vl_facturado = v_facturado,
        vl_impuestos = v_impuestos,
        vl_total = v_total,
        ds_estado_factura = 'cerrada'
    WHERE ad_factura = p_ad_factura;


    /* ================= ACTUALIZAR ESTADO ORDEN ================= */
    UPDATE ordenes_compra
    SET ds_estado = 'completada'
    WHERE ad_orden = p_fk_ordencom_ad_orden;

    /* ================= INVENTARIO (ENTRADA) ================= */
    INSERT INTO inventario (
        ad_inventario,
        fk_product_ad_producto,
        cl_tipo_movimiento,
        dt_movimiento,
        vl_cantidad,
        vl_costo_unitario,
        vl_cantidad_disponible,
        fk_referencia_origen,
        observaciones
    ) 
    SELECT
        fn_actualiza_secuencias('seq_inventario'),
        fk_product_ad_producto,
        'entrada',
        CURRENT_DATE,
        vl_cantidad,
        vl_costo_unitario,
        vl_cantidad,
        fk_factura_ad_factura,
        null
	FROM detalle_factura_compra
    WHERE fk_factura_ad_factura = p_ad_factura;
    
      INSERT INTO historico_precios_proveedor (
          ad_historico,
          fk_product_ad_producto,
          fk_provee_ad_proveedor,
          vl_precio_unitario,
          dt_fecha_precio,
          observaciones
      )
      SELECT
          fn_actualiza_secuencias('seq_historico_pre_prov'),
          fk_product_ad_producto,
          v_fk_provee_ad_proveedor,
          vl_costo_unitario,
          CURRENT_DATE,
          NULL
 	  FROM detalle_factura_compra
	  WHERE fk_factura_ad_factura = p_ad_factura;
       
    COMMIT;

    SET p_mensaje = CONCAT(
        'Factura cerrada correctamente. ',
        'Base: ', v_facturado,
        ', Impuestos: ', v_impuestos,
        ', Total: ', v_total
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_cotizacion_desde_ultima` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_cotizacion_desde_ultima`(
    IN p_fk_provee_ad_proveedor INT,
    OUT p_ad_cotizacion_nueva INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_ad_cotizacion_base INT;
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* =========================
       OBTENER ÚLTIMA COTIZACIÓN
    ==========================*/
    SELECT ad_cotizacion
    INTO v_ad_cotizacion_base
    FROM cotizacion
    WHERE fk_provee_ad_proveedor = p_fk_provee_ad_proveedor
      AND ic_activa = 'S'
    ORDER BY dt_fecha_cotizacion DESC, ad_cotizacion DESC
    LIMIT 1;

    IF v_ad_cotizacion_base IS NULL THEN
        SET p_mensaje = 'ERROR: El proveedor no tiene cotizaciones previas';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    /* =========================
       CREAR CABECERA NUEVA
    ==========================*/
    SET p_ad_cotizacion_nueva = fn_actualiza_secuencias('seq_cotizacion');

    INSERT INTO cotizacion (
        ad_cotizacion,
        fk_provee_ad_proveedor,
        fk_sucursal_ad_sucursal,
        fk_product_ad_producto,
        vl_cantidad,
        vl_precio_unitario,
        vl_subtotal,
        dt_fecha_cotizacion,
        dt_fecha_vencimiento,
        ds_observaciones,
        ic_activa,
        dt_creacion
    )
    SELECT
        p_ad_cotizacion_nueva,
        fk_provee_ad_proveedor,
        null,
        fk_product_ad_producto,
        0,
        vl_precio_unitario,
        0,
        CURRENT_DATE,
        null,
        null,
        'S',
        NOW()
    FROM cotizacion
    WHERE ad_cotizacion = v_ad_cotizacion_base;

    /* =========================
       CREAR DETALLE NUEVO
    ==========================*/
    INSERT INTO detalle_cotizacion (
        ad_cotizacion_detalle,
        fk_cotizacion_ad_cotizacion,
        fk_product_ad_producto,
        vl_cantidad,
        vl_precio_unitario,
        vl_subtotal
    )
    SELECT
        fn_actualiza_secuencias('seq_cotizacion_detalle'),
        p_ad_cotizacion_nueva,
        fk_product_ad_producto,
        0,
        0,
        0
    FROM detalle_cotizacion
    WHERE fk_cotizacion_ad_cotizacion = v_ad_cotizacion_base;

    COMMIT;

    SET p_mensaje = 'Cotización creada a partir de la última cotización del proveedor';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generar_ordenes_compra_desde_pedido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generar_ordenes_compra_desde_pedido`(
    IN p_ad_pedido INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
	DECLARE v_sucursal INT;
    DECLARE v_estado_pedido ENUM('abierto','cerrado');
    DECLARE v_proveedor INT;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_ad_orden INT;
    DECLARE fin INT DEFAULT 0;
    DECLARE v_error TEXT;
    DECLARE v_dt_fecha_entrega DATE;

    /* Cursor de proveedores */
    DECLARE cur_proveedores CURSOR FOR
        SELECT DISTINCT fk_proveedor_ad_proveedor
        FROM detalle_pedido
        WHERE fk_pedido_ad_pedido = p_ad_pedido
          AND ic_registro_activo = 'S'
          AND fk_proveedor_ad_proveedor IS NOT NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_generar_ordenes_compra_desde_pedido',
            'GENERAR',
            v_error,
            CONCAT('pedido=', p_ad_pedido)
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* 1️. Validar pedido */
    SELECT fk_sucursal_ad_sucursal, ds_estado_pedido, dt_fecha_entrega
    INTO v_sucursal, v_estado_pedido, v_dt_fecha_entrega
    FROM pedido
    WHERE ad_pedido = p_ad_pedido;

    IF v_sucursal IS NULL THEN
        SET p_mensaje = 'ERROR: El pedido no existe';
        LEAVE proc;
    END IF;

    IF v_estado_pedido <> 'abierto' THEN
        SET p_mensaje = 'ERROR: El pedido ya está cerrado';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    /* 2️. Recorrer proveedores */
    OPEN cur_proveedores;

    proveedores_loop: LOOP
        FETCH cur_proveedores INTO v_proveedor;
        IF fin = 1 THEN
            LEAVE proveedores_loop;
        END IF;

        /* Total por proveedor */
        SELECT SUM(vl_cantidad * vl_compra)
        INTO v_total
        FROM detalle_pedido
        WHERE fk_pedido_ad_pedido = p_ad_pedido
          AND fk_proveedor_ad_proveedor = v_proveedor
          AND ic_registro_activo = 'S';

        /* Crear orden */
        SET v_ad_orden = fn_actualiza_secuencias('seq_ordenes_compra');

        INSERT INTO ordenes_compra (
            ad_orden,
            fk_sucursal_ad_sucursal,
            fk_provee_ad_proveedor,
            dt_fecha_orden,
            ds_estado,
            vl_total,
            ds_metodo_pago,
            dt_fecha_entrega,
            observaciones
        ) VALUES (
            v_ad_orden,
            v_sucursal,
            v_proveedor,
            NOW(),
            'pendiente',
            v_total,
            'transferencia',
            v_dt_fecha_entrega,
            CONCAT('Generada desde pedido interno #', p_ad_pedido)
        );

        /* Detalle de la orden */
        INSERT INTO detalles_orden_compra (
            ad_detalle_ordencom,
            fk_ordencom_ad_orden,
            fk_product_ad_producto,
            vl_cantidad,
            vl_precio_unitario,
            vl_subtotal
        )
        SELECT
            fn_actualiza_secuencias('seq_detalles_orden_compra'),
            v_ad_orden,
            dp.fk_product_ad_producto,
            dp.vl_cantidad,
            dp.vl_compra,
            dp.vl_cantidad * dp.vl_compra
        FROM detalle_pedido dp
        WHERE dp.fk_pedido_ad_pedido = p_ad_pedido
          AND dp.fk_proveedor_ad_proveedor = v_proveedor
          AND dp.ic_registro_activo = 'S';

    END LOOP;

    CLOSE cur_proveedores;

    /* 3️. Cerrar pedido */
    UPDATE pedido
    SET ds_estado_pedido = 'cerrado'
    WHERE ad_pedido = p_ad_pedido;

    COMMIT;

    SET p_mensaje = CONCAT(
        'Órdenes de compra generadas correctamente desde el pedido ',
        p_ad_pedido
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_banco` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_banco`(
    IN p_accion CHAR(1),              -- I, U, D, C, V
    IN p_ad_banco INT,
    IN p_ds_codigo VARCHAR(10),
    IN p_ds_nombre VARCHAR(100),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_banco INT DEFAULT 0;
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_banco',
            p_accion,
            v_error,
            CONCAT(
                'ad_banco=', IFNULL(p_ad_banco,'NULL'), '; ',
                'codigo=', IFNULL(p_ds_codigo,'NULL'), '; ',
                'nombre=', IFNULL(p_ds_nombre,'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* =========================
       VALIDACIONES GENERALES
    ==========================*/
    IF p_accion NOT IN ('I','U','D','C','V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    /* =========================
       VALIDAR EXISTENCIA POR CÓDIGO
    ==========================*/
    IF p_accion IN ('I','V') THEN
        SELECT COUNT(*) INTO v_existente
        FROM banco
        WHERE ds_codigo = p_ds_codigo
          AND ic_activo = 'Y';
    END IF;

    /* =========================
       TRANSACCIÓN
    ==========================*/
    IF p_accion IN ('I','U','D') THEN
        START TRANSACTION;
    END IF;

    /* =========================
       LÓGICA PRINCIPAL
    ==========================*/
    CASE p_accion

        /* ========= INSERTAR ========= */
        WHEN 'I' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'ERROR: Ya existe un banco activo con ese código';
                ROLLBACK;
                LEAVE proc;
            END IF;

            SET v_ad_banco = fn_actualiza_secuencias('seq_banco');

            INSERT INTO banco (
                ad_banco,
                ds_codigo,
                ds_nombre,
                ic_activo,
                dt_creacion
            ) VALUES (
                v_ad_banco,
                p_ds_codigo,
                p_ds_nombre,
                'Y',
                CURDATE()
            );

            COMMIT;
            SET p_mensaje = CONCAT('Banco registrado correctamente. ID: ', v_ad_banco);

        /* ========= ACTUALIZAR ========= */
        WHEN 'U' THEN
            IF p_ad_banco IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del banco';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE banco
            SET ds_codigo = p_ds_codigo,
                ds_nombre = p_ds_nombre
            WHERE ad_banco = p_ad_banco;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Banco no encontrado o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Banco actualizado correctamente';

        /* ========= ELIMINACIÓN LÓGICA ========= */
        WHEN 'D' THEN
            IF p_ad_banco IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del banco';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE banco
            SET ic_activo = 'N'
            WHERE ad_banco = p_ad_banco;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Banco no encontrado';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Banco desactivado correctamente';

        /* ========= CONSULTAR ========= */
        WHEN 'C' THEN
            SELECT *
            FROM banco
            WHERE ic_activo = 'Y'
            ORDER BY ds_nombre;

            SET p_mensaje = 'Consulta realizada correctamente';

        /* ========= VALIDAR EXISTENCIA ========= */
        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Banco activo: SI';
            ELSE
                SET p_mensaje = 'Banco activo: NO';
            END IF;

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_cotizacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_cotizacion`(
    IN p_accion CHAR(1),                  -- I,U,A,R,D,C,V
    IN p_ad_cotizacion INT,
    IN p_fk_provee_ad_proveedor INT,
    IN p_fk_sucursal_ad_sucursal INT,
    IN p_dt_fecha_cotizacion DATE,
    IN p_dt_fecha_vencimiento DATE,
    IN p_ds_observaciones VARCHAR(150),
    OUT p_id_cotizacion INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_estado_actual VARCHAR(20);
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* Inicializar salida */
    SET p_id_cotizacion = NULL;

    /* =========================
       VALIDAR ACCIÓN
    ==========================*/
    IF p_accion NOT IN ('I','U','A','R','D','C','V') THEN
        SET p_mensaje = 'ERROR: Acción no válida';
        LEAVE proc;
    END IF;

    /* =========================
       TRANSACCIÓN
    ==========================*/
    IF p_accion IN ('I','U','A','R','D') THEN
        START TRANSACTION;
    END IF;

    /* =========================
       LÓGICA PRINCIPAL
    ==========================*/
    CASE p_accion

        /* ========= INSERTAR ========= */
        WHEN 'I' THEN
            IF p_fk_provee_ad_proveedor IS NULL THEN
                SET p_mensaje = 'ERROR: Proveedor obligatorio';
                ROLLBACK;
                LEAVE proc;
            END IF;

            SET p_ad_cotizacion = fn_actualiza_secuencias('seq_cotizacion');

            INSERT INTO cotizacion (
                ad_cotizacion,
                fk_provee_ad_proveedor,
                fk_sucursal_ad_sucursal,
                dt_fecha_cotizacion,
                dt_fecha_vencimiento,
                ds_estado,
                ds_observaciones
            ) VALUES (
                p_ad_cotizacion,
                p_fk_provee_ad_proveedor,
                p_fk_sucursal_ad_sucursal,
                p_dt_fecha_cotizacion,
                p_dt_fecha_vencimiento,
                'borrador',
                p_ds_observaciones
            );

            COMMIT;
            SET p_id_cotizacion = p_ad_cotizacion;
            SET p_mensaje = CONCAT(
                'Cotización creada correctamente. ID: ',
                p_ad_cotizacion
            );

        /* ========= ACTUALIZAR ========= */
        WHEN 'U' THEN
            SELECT ds_estado
            INTO v_estado_actual
            FROM cotizacion
            WHERE ad_cotizacion = p_ad_cotizacion
              AND ic_activa = 'S';

            IF v_estado_actual <> 'borrador' THEN
                SET p_mensaje = 'ERROR: Solo se puede modificar en estado borrador';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE cotizacion
            SET dt_fecha_cotizacion = p_dt_fecha_cotizacion,
                dt_fecha_vencimiento = p_dt_fecha_vencimiento,
                ds_observaciones = p_ds_observaciones
            WHERE ad_cotizacion = p_ad_cotizacion;

            COMMIT;
            SET p_id_cotizacion = p_ad_cotizacion;
            SET p_mensaje = 'Cotización actualizada correctamente';

        /* ========= APROBAR ========= */
        WHEN 'A' THEN
            UPDATE cotizacion
            SET ds_estado = 'aprobada'
            WHERE ad_cotizacion = p_ad_cotizacion
              AND ds_estado = 'borrador';

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Cotización no aprobable';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Cotización aprobada correctamente';

        /* ========= RECHAZAR ========= */
        WHEN 'R' THEN
            UPDATE cotizacion
            SET ds_estado = 'rechazada'
            WHERE ad_cotizacion = p_ad_cotizacion
              AND ds_estado IN ('borrador','aprobada');

            COMMIT;
            SET p_mensaje = 'Cotización rechazada';

        /* ========= DESACTIVAR ========= */
        WHEN 'D' THEN
            UPDATE cotizacion
            SET ic_activa = 'N'
            WHERE ad_cotizacion = p_ad_cotizacion;

            COMMIT;
            SET p_mensaje = 'Cotización desactivada';

        /* ========= CONSULTAR ========= */
        WHEN 'C' THEN
            SELECT *
            FROM cotizacion
            WHERE ic_activa = 'S'
            ORDER BY dt_fecha_cotizacion DESC;

            SET p_mensaje = 'Consulta realizada correctamente';

        /* ========= VALIDAR ========= */
        WHEN 'V' THEN
            SELECT COUNT(*) INTO v_existente
            FROM cotizacion
            WHERE ad_cotizacion = p_ad_cotizacion
              AND ic_activa = 'S';

            IF v_existente > 0 THEN
                SET p_mensaje = 'Cotización existe';
            ELSE
                SET p_mensaje = 'Cotización no existe';
            END IF;

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_cuenta_bancaria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_cuenta_bancaria`(
    IN p_accion CHAR(1),                       -- I, U, D, C, V
    IN p_ad_cuenta_bancaria INT,
    IN p_fk_banco_ad_banco INT,
    IN p_fk_sucursal_banco_ad_sucursal INT,
    IN p_ds_numero_cuenta VARCHAR(30),
    IN p_cl_tipo_cuenta ENUM('ahorros','corriente'),
    IN p_ds_titular VARCHAR(100),
    IN p_nm_saldo_inicial DECIMAL(14,2),
    IN p_dt_apertura DATE,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_cuenta_bancaria INT DEFAULT 0;
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_cuenta_bancaria',
            p_accion,
            v_error,
            CONCAT(
                'ad_cuenta=', IFNULL(p_ad_cuenta_bancaria,'NULL'), '; ',
                'numero=', IFNULL(p_ds_numero_cuenta,'NULL'), '; ',
                'banco=', IFNULL(p_fk_banco_ad_banco,'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* =========================
       VALIDACIONES GENERALES
    ==========================*/
    IF p_accion NOT IN ('I','U','D','C','V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    /* =========================
       VALIDAR EXISTENCIA POR NÚMERO DE CUENTA
    ==========================*/
    IF p_accion IN ('I','V') THEN
        SELECT COUNT(*) INTO v_existente
        FROM cuenta_bancaria
        WHERE ds_numero_cuenta = p_ds_numero_cuenta
          AND ic_activa = 'Y';
    END IF;

    /* =========================
       TRANSACCIÓN
    ==========================*/
    IF p_accion IN ('I','U','D') THEN
        START TRANSACTION;
    END IF;

    /* =========================
       LÓGICA PRINCIPAL
    ==========================*/
    CASE p_accion

        /* ========= INSERTAR ========= */
        WHEN 'I' THEN
            IF p_fk_banco_ad_banco IS NULL
               OR p_ds_numero_cuenta IS NULL
               OR p_cl_tipo_cuenta IS NULL
               OR p_ds_titular IS NULL
               OR p_dt_apertura IS NULL THEN
                SET p_mensaje = 'ERROR: Datos obligatorios incompletos';
                ROLLBACK;
                LEAVE proc;
            END IF;

            IF v_existente > 0 THEN
                SET p_mensaje = 'ERROR: Ya existe una cuenta bancaria activa con ese número';
                ROLLBACK;
                LEAVE proc;
            END IF;

            SET v_ad_cuenta_bancaria = fn_actualiza_secuencias('seq_cuenta_bancaria');

            INSERT INTO cuenta_bancaria (
                ad_cuenta_bancaria,
                fk_banco_ad_banco,
                fk_sucursal_banco_ad_sucursal,
                ds_numero_cuenta,
                cl_tipo_cuenta,
                ds_titular,
                nm_saldo_inicial,
                nm_saldo_actual,
                ic_activa,
                dt_apertura
            ) VALUES (
                v_ad_cuenta_bancaria,
                p_fk_banco_ad_banco,
                p_fk_sucursal_banco_ad_sucursal,
                p_ds_numero_cuenta,
                p_cl_tipo_cuenta,
                p_ds_titular,
                IFNULL(p_nm_saldo_inicial,0),
                IFNULL(p_nm_saldo_inicial,0),
                'Y',
                p_dt_apertura
            );

            COMMIT;
            SET p_mensaje = CONCAT(
                'Cuenta bancaria registrada correctamente. ID: ',
                v_ad_cuenta_bancaria
            );

        /* ========= ACTUALIZAR ========= */
        WHEN 'U' THEN
            IF p_ad_cuenta_bancaria IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la cuenta bancaria';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE cuenta_bancaria
            SET fk_banco_ad_banco = p_fk_banco_ad_banco,
                fk_sucursal_banco_ad_sucursal = p_fk_sucursal_banco_ad_sucursal,
                ds_titular = p_ds_titular
            WHERE ad_cuenta_bancaria = p_ad_cuenta_bancaria;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Cuenta bancaria no encontrada o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Cuenta bancaria actualizada correctamente';

        /* ========= ELIMINACIÓN LÓGICA ========= */
        WHEN 'D' THEN
            IF p_ad_cuenta_bancaria IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la cuenta bancaria';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE cuenta_bancaria
            SET ic_activa = 'N'
            WHERE ad_cuenta_bancaria = p_ad_cuenta_bancaria;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Cuenta bancaria no encontrada';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Cuenta bancaria desactivada correctamente';

        /* ========= CONSULTAR ========= */
        WHEN 'C' THEN
            SELECT cb.*,
                   b.ds_nombre AS banco,
                   sb.ds_nombre AS sucursal_banco
            FROM cuenta_bancaria cb
            INNER JOIN banco b ON b.ad_banco = cb.fk_banco_ad_banco
            LEFT JOIN sucursal_banco sb ON sb.ad_sucursal_banco = cb.fk_sucursal_banco_ad_sucursal
            WHERE cb.ic_activa = 'Y'
            ORDER BY b.ds_nombre, cb.ds_numero_cuenta;

            SET p_mensaje = 'Consulta realizada correctamente';

        /* ========= VALIDAR EXISTENCIA ========= */
        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Cuenta bancaria activa: SI';
            ELSE
                SET p_mensaje = 'Cuenta bancaria activa: NO';
            END IF;

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_detalle_cotizacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_detalle_cotizacion`(
    IN p_accion CHAR(1),                      -- I,U,D,C
    IN p_ad_cotizacion_detalle INT,
    IN p_fk_cotizacion_ad_cotizacion INT,
    IN p_fk_product_ad_producto INT,
    IN p_vl_cantidad DECIMAL(10,2),
    IN p_vl_precio_unitario DECIMAL(10,2),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_estado_cotizacion VARCHAR(20);
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* =========================
       VALIDAR ACCIÓN
    ==========================*/
    IF p_accion NOT IN ('I','U','D','C') THEN
        SET p_mensaje = 'ERROR: Acción no válida';
        LEAVE proc;
    END IF;

    /* =========================
       VALIDAR ESTADO COTIZACIÓN
    ==========================*/
    IF p_accion IN ('I','U','D') THEN
        SELECT ds_estado
        INTO v_estado_cotizacion
        FROM cotizacion
        WHERE ad_cotizacion = p_fk_cotizacion_ad_cotizacion;

        IF v_estado_cotizacion <> 'borrador' THEN
            SET p_mensaje = 'ERROR: Solo se puede modificar el detalle en estado borrador';
            LEAVE proc;
        END IF;

        START TRANSACTION;
    END IF;

    /* =========================
       LÓGICA PRINCIPAL
    ==========================*/
    CASE p_accion

        /* ========= INSERTAR ========= */
        WHEN 'I' THEN
            IF p_fk_product_ad_producto IS NULL THEN
                SET p_mensaje = 'ERROR: Producto obligatorio';
                ROLLBACK;
                LEAVE proc;
            END IF;

            IF EXISTS (
                SELECT 1 FROM detalle_cotizacion
                 WHERE fk_cotizacion_ad_cotizacion = p_fk_cotizacion_ad_cotizacion
                   AND fk_product_ad_producto = p_fk_product_ad_producto
            ) THEN
                 SET p_mensaje = 'ERROR: El producto ya existe en la cotización';
                 ROLLBACK;
                 LEAVE proc;
            END IF;

            INSERT INTO detalle_cotizacion (
                ad_cotizacion_detalle,
                fk_cotizacion_ad_cotizacion,
                fk_product_ad_producto,
                vl_cantidad,
                vl_precio_unitario,
                vl_subtotal
            ) VALUES (
                fn_actualiza_secuencias('seq_cotizacion_detalle'),
                p_fk_cotizacion_ad_cotizacion,
                p_fk_product_ad_producto,
                p_vl_cantidad,
                p_vl_precio_unitario,
                p_vl_cantidad * p_vl_precio_unitario
            );

            COMMIT;
            SET p_mensaje = 'Producto agregado a la cotización';

        /* ========= ACTUALIZAR ========= */
        WHEN 'U' THEN
            UPDATE detalle_cotizacion
            SET vl_cantidad = p_vl_cantidad,
                vl_precio_unitario = p_vl_precio_unitario,
                vl_subtotal = p_vl_cantidad * p_vl_precio_unitario
            WHERE ad_cotizacion_detalle = p_ad_cotizacion_detalle;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Detalle no encontrado';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Detalle de cotización actualizado';

        /* ========= ELIMINAR ========= */
        WHEN 'D' THEN
            DELETE FROM detalle_cotizacion
            WHERE ad_cotizacion_detalle = p_ad_cotizacion_detalle;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Detalle no encontrado';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Producto eliminado de la cotización';

        /* ========= CONSULTAR ========= */
        WHEN 'C' THEN
            SELECT dc.*,
                   p.ds_nombre AS producto
            FROM detalle_cotizacion dc
            JOIN productos p ON p.ad_producto = dc.fk_product_ad_producto
            WHERE dc.fk_cotizacion_ad_cotizacion = p_fk_cotizacion_ad_cotizacion
            ORDER BY p.ds_nombre;

            SET p_mensaje = 'Consulta realizada correctamente';

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_detalle_factura_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_detalle_factura_compra`(
    IN p_accion CHAR(1), -- I, U, D
    IN p_ad_detalle_factura INT,
    IN p_fk_factura_ad_factura INT,
    IN p_fk_product_ad_producto INT,
    IN p_vl_cantidad DECIMAL(10,2),
    IN p_vl_costo_unitario DECIMAL(10,2),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_error TEXT;

    /* ============ MANEJO DE ERRORES ============ */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    IF p_accion NOT IN ('I','U','D') THEN
        SET p_mensaje = 'ERROR: Acción no válida';
        LEAVE proc;
    END IF;

    SELECT ds_estado_factura
    INTO v_estado
    FROM factura_compra
    WHERE ad_factura = p_fk_factura_ad_factura;

    IF v_estado IS NULL THEN
        SET p_mensaje = 'ERROR: Factura no existe';
        LEAVE proc;
    END IF;

    IF v_estado <> 'registrada' THEN
        SET p_mensaje = 'ERROR: La factura no permite modificar detalle';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    CASE p_accion

        /* ===== INSERTAR ===== */
        WHEN 'I' THEN
            INSERT INTO detalle_factura_compra (
                ad_detalle_factura,
                fk_factura_ad_factura,
                fk_product_ad_producto,
                vl_cantidad,
                vl_costo_unitario,
                vl_subtotal
            ) VALUES (
                fn_actualiza_secuencias('seq_detalle_factura_compra'),
                p_fk_factura_ad_factura,
                p_fk_product_ad_producto,
                p_vl_cantidad,
                p_vl_costo_unitario,
                p_vl_cantidad * p_vl_costo_unitario
            );

            COMMIT;
            SET p_mensaje = 'Detalle agregado correctamente';

        /* ===== ACTUALIZAR ===== */
        WHEN 'U' THEN
            UPDATE detalle_factura_compra
            SET vl_cantidad = p_vl_cantidad,
                vl_costo_unitario = p_vl_costo_unitario,
                vl_subtotal = p_vl_cantidad * p_vl_costo_unitario
            WHERE ad_detalle_factura = p_ad_detalle_factura;

            COMMIT;
            SET p_mensaje = 'Detalle actualizado correctamente';

        /* ===== ELIMINAR ===== */
        WHEN 'D' THEN
            DELETE FROM detalle_factura_compra
            WHERE ad_detalle_factura = p_ad_detalle_factura;

            COMMIT;
            SET p_mensaje = 'Detalle eliminado correctamente';

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_detalle_orden_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_detalle_orden_compra`(
    IN p_accion CHAR(1), -- I, U, D, C, V
    IN p_ad_detalle_ordencom INT,
    IN p_fk_ordencom_ad_orden INT,
    IN p_fk_product_ad_producto INT,
    IN p_vl_cantidad INT,
    IN p_vl_precio_unitario DECIMAL(10,2),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_detalle_ordencom INT DEFAULT 0;
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_error TEXT;
    DECLARE v_fk_proveedor INT;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_detalle_orden_compra',
            p_accion,
            v_error,
            CONCAT(
                'ad_detalle_ordencom=', IFNULL(p_ad_detalle_ordencom, 'NULL'), '; ',
                'fk_orden=', IFNULL(p_fk_ordencom_ad_orden, 'NULL'), '; ',
                'producto=', IFNULL(p_fk_product_ad_producto, 'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    -- Validaciones
    IF p_accion NOT IN ('I', 'U', 'D', 'C', 'V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'U') AND (p_fk_ordencom_ad_orden IS NULL OR p_fk_product_ad_producto IS NULL) THEN
        SET p_mensaje = 'ERROR: Debe indicar orden y producto';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'U') AND (p_vl_cantidad <= 0 OR p_vl_precio_unitario < 0) THEN
        SET p_mensaje = 'ERROR: Cantidad debe ser > 0 y precio >= 0';
        LEAVE proc;
    END IF;

    SET v_subtotal = p_vl_cantidad * p_vl_precio_unitario;

    -- Verificación
    IF p_accion = 'V' THEN
        SELECT COUNT(*) INTO v_existente
        FROM detalles_orden_compra
        WHERE fk_ordencom_ad_orden = p_fk_ordencom_ad_orden
          AND fk_product_ad_producto = p_fk_product_ad_producto;
    END IF;

    -- Transacción
    IF p_accion IN ('I', 'U', 'D') THEN
        START TRANSACTION;
    END IF;

    CASE p_accion
        WHEN 'I' THEN
            SET v_ad_detalle_ordencom = fn_actualiza_secuencias('seq_detalles_orden_compra');

            INSERT INTO detalles_orden_compra (
                ad_detalle_ordencom, fk_ordencom_ad_orden, fk_product_ad_producto,
                vl_cantidad, vl_precio_unitario, vl_subtotal
            ) VALUES (
                v_ad_detalle_ordencom, p_fk_ordencom_ad_orden, p_fk_product_ad_producto,
                p_vl_cantidad, p_vl_precio_unitario, v_subtotal
            );

            -- Insertar en histórico si no existe
            SELECT fk_provee_ad_proveedor INTO v_fk_proveedor
            FROM ordenes_compra
            WHERE ad_orden = p_fk_ordencom_ad_orden;

            INSERT INTO historico_precios_proveedor (
                ad_historico, fk_product_ad_producto, fk_provee_ad_proveedor,
                vl_precio_unitario, dt_fecha_precio
            )
            SELECT
                fn_actualiza_secuencias('seq_historico_pre_prov'),
                p_fk_product_ad_producto,
                v_fk_proveedor,
                p_vl_precio_unitario,
                CURDATE()
            FROM DUAL
            WHERE NOT EXISTS (
                SELECT 1
                FROM historico_precios_proveedor
                WHERE fk_product_ad_producto = p_fk_product_ad_producto
                  AND fk_provee_ad_proveedor = v_fk_proveedor
                  AND vl_precio_unitario = p_vl_precio_unitario
                  AND dt_fecha_precio = CURDATE()
            );

            COMMIT;
            SET p_mensaje = 'Detalle insertado y precio registrado si era nuevo';

        WHEN 'U' THEN
            IF p_ad_detalle_ordencom IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del detalle para actualizar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE detalles_orden_compra
            SET fk_ordencom_ad_orden = p_fk_ordencom_ad_orden,
                fk_product_ad_producto = p_fk_product_ad_producto,
                vl_cantidad = p_vl_cantidad,
                vl_precio_unitario = p_vl_precio_unitario,
                vl_subtotal = v_subtotal
            WHERE ad_detalle_ordencom = p_ad_detalle_ordencom;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Detalle no encontrado o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Detalle actualizado correctamente';

        WHEN 'D' THEN
            IF p_ad_detalle_ordencom IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del detalle para eliminar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            DELETE FROM detalles_orden_compra
            WHERE ad_detalle_ordencom = p_ad_detalle_ordencom;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Detalle no encontrado';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Detalle eliminado correctamente';

        WHEN 'C' THEN
            SELECT *
            FROM detalles_orden_compra
            WHERE fk_ordencom_ad_orden = p_fk_ordencom_ad_orden;

            SET p_mensaje = 'Consulta realizada correctamente';

        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Detalle existente: SÍ';
            ELSE
                SET p_mensaje = 'Detalle existente: NO';
            END IF;
    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_detalle_pedido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_detalle_pedido`(
    IN p_accion CHAR(1),                     -- I, U, D, C, V
    IN p_ad_detalle_pedido INT,
    IN p_fk_pedido_ad_pedido INT,
    IN p_fk_product_ad_producto INT,
    IN p_vl_cantidad DECIMAL(10,2),
    IN p_fk_proveedor_ad_proveedor INT,
    IN p_vl_compra DECIMAL(10,2),
    IN p_ic_registro_activo CHAR(1),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
	DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_detalle_pedido INT DEFAULT 0;
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_detalle_pedido',
            p_accion,
            v_error,
            CONCAT(
                'detalle=', IFNULL(p_ad_detalle_pedido,'NULL'), '; ',
                'pedido=', IFNULL(p_fk_pedido_ad_pedido,'NULL'), '; ',
                'producto=', IFNULL(p_fk_product_ad_producto,'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* =========================
       VALIDACIONES INICIALES
    ==========================*/
    IF p_accion NOT IN ('I','U','D','C','V') THEN
        SET p_mensaje = 'ERROR: Acción no válida';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I','U') THEN
        IF p_fk_pedido_ad_pedido IS NULL
           OR p_fk_product_ad_producto IS NULL
           OR p_vl_cantidad <= 0 THEN
            SET p_mensaje = 'ERROR: Pedido, producto y cantidad válida son obligatorios';
            LEAVE proc;
        END IF;
    END IF;

    /* =========================
       VALIDAR EXISTENCIA
    ==========================*/
    IF p_accion IN ('U','D','V') THEN
        SELECT COUNT(*)
        INTO v_existente
        FROM detalle_pedido
        WHERE ad_detalle_pedido = p_ad_detalle_pedido
          AND ic_registro_activo = 'S';

        IF v_existente = 0 THEN
            SET p_mensaje = 'ERROR: Detalle de pedido no encontrado';
            LEAVE proc;
        END IF;
    END IF;

    /* =========================
       TRANSACCIÓN
    ==========================*/
    IF p_accion IN ('I','U','D') THEN
        START TRANSACTION;
    END IF;

    /* =========================
       LÓGICA PRINCIPAL
    ==========================*/
    CASE p_accion

        /* ========= INSERTAR ========= */
        WHEN 'I' THEN
            SET v_ad_detalle_pedido = fn_actualiza_secuencias('seq_detalle_pedido');

            INSERT INTO detalle_pedido (
                ad_detalle_pedido,
                fk_pedido_ad_pedido,
                fk_product_ad_producto,
                vl_cantidad,
                fk_proveedor_ad_proveedor,
                vl_compra,
                ic_registro_activo
            ) VALUES (
                v_ad_detalle_pedido,
                p_fk_pedido_ad_pedido,
                p_fk_product_ad_producto,
                p_vl_cantidad,
                p_fk_proveedor_ad_proveedor,
                IFNULL(p_vl_compra,0),
                p_ic_registro_activo
            );

            COMMIT;
            SET p_mensaje = CONCAT(
                'Detalle de pedido registrado correctamente. ID: ',
                v_ad_detalle_pedido
            );

        /* ========= ACTUALIZAR ========= */
        WHEN 'U' THEN
            UPDATE detalle_pedido
            SET fk_product_ad_producto = p_fk_product_ad_producto,
                vl_cantidad = p_vl_cantidad,
                fk_proveedor_ad_proveedor = p_fk_proveedor_ad_proveedor,
                vl_compra = p_vl_compra,
                ic_registro_activo = p_ic_registro_activo
            WHERE ad_detalle_pedido = p_ad_detalle_pedido;

            IF ROW_COUNT() = 0 THEN
                ROLLBACK;
                SET p_mensaje = 'ERROR: Detalle no actualizado';
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Detalle de pedido actualizado correctamente';

        /* ========= ELIMINACIÓN LÓGICA ========= */
        WHEN 'D' THEN
            IF p_fk_proveedor_ad_proveedor IS NOT NULL THEN
                SET p_mensaje = 'ERROR: Ya ha sido asignado Proveedor, no se puede eliminar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            DELETE FROM detalle_pedido
            WHERE ad_detalle_pedido = p_ad_detalle_pedido;

            COMMIT;
            SET p_mensaje = 'Detalle de pedido desactivado correctamente';

        /* ========= CONSULTA ========= */
        WHEN 'C' THEN
            SELECT d.*,
                   pr.ds_nombre_producto,
                   pv.ds_nombre_proveedor
            FROM detalle_pedido d
            JOIN productos pr
                ON pr.ad_producto = d.fk_product_ad_producto
            LEFT JOIN proveedor pv
                ON pv.ad_proveedor = d.fk_proveedor_ad_proveedor
            WHERE d.fk_pedido_ad_pedido = p_fk_pedido_ad_pedido
              AND d.ic_registro_activo = 'S';

            SET p_mensaje = 'Consulta realizada correctamente';

        /* ========= VALIDAR EXISTENCIA ========= */
        WHEN 'V' THEN
            SET p_mensaje = 'Detalle de pedido encontrado: SÍ';

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_empresa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_empresa`(
    IN p_accion CHAR(1),  -- I, U, D, C, V
    IN p_ad_empresa INT,
    IN p_ds_identificacion VARCHAR(20),
    IN p_ds_razon_social VARCHAR(60),
    IN p_ds_direccion VARCHAR(45),
    IN p_ds_correo_electronico VARCHAR(100),
    IN p_ds_telefono VARCHAR(45),
    IN p_cl_tipo_identificacion VARCHAR(2),
    IN p_ds_observacion VARCHAR(100),
    IN p_ds_contacto VARCHAR(45),
    IN p_nm_cuenta_puc INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_empresa INT DEFAULT 0;
    DECLARE v_error TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;

        ROLLBACK;

        -- Registrar en log
        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_empresa',
            p_accion,
            v_error,
            CONCAT(
                'ad_empresa=', IFNULL(p_ad_empresa, 'NULL'), '; ',
                'ds_identificacion=', IFNULL(p_ds_identificacion, 'NULL'), '; ',
                'razon_social=', IFNULL(p_ds_razon_social, 'NULL'), '; ',
                'cuenta_puc=', IFNULL(p_nm_cuenta_puc, 'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;
    
	-- Validaciones iniciales
    IF p_accion NOT IN ('I', 'U', 'D', 'C', 'V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'U') AND p_cl_tipo_identificacion NOT IN ('NI', 'CC') THEN
        SET p_mensaje = 'ERROR: Tipo de identificación no válido. Debe ser NI o CC';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'V', 'C') THEN
        SELECT COUNT(*) INTO v_existente
        FROM empresa
        WHERE ds_identificacion = p_ds_identificacion
          AND ic_registro_activo = 'Y';
    END IF;
    
    -- Iniciar transacción si aplica
    IF p_accion IN ('I', 'U', 'D') THEN
        START TRANSACTION;
    END IF;
    
    -- Acciones
    CASE p_accion
        WHEN 'I' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'ERROR: Ya existe una empresa activa con esa identificación';
                ROLLBACK;
                LEAVE proc;
            END IF;

        -- Llamada a la función para obtener la secuencia
        SET v_ad_empresa = fn_actualiza_secuencias('seq_empresa');

            INSERT INTO empresa (
                ad_empresa, ds_identificacion, ds_razon_social,
                ds_direccion, ds_correo_electronico, ds_telefono,
                cl_tipo_identificacion, dt_creacion, ds_observacion,
                ds_contacto, ic_registro_activo, nm_cuenta_puc
            )
            VALUES (
                v_ad_empresa, p_ds_identificacion, p_ds_razon_social,
                p_ds_direccion, p_ds_correo_electronico, p_ds_telefono,
                p_cl_tipo_identificacion, CURDATE(), p_ds_observacion,
                p_ds_contacto, 'Y', p_nm_cuenta_puc
            );

            COMMIT;
            SET p_mensaje = 'Empresa insertada correctamente';

        WHEN 'U' THEN
            IF p_ad_empresa IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de empresa para actualizar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE empresa
            SET ds_razon_social = p_ds_razon_social,
                ds_direccion = p_ds_direccion,
                ds_correo_electronico = p_ds_correo_electronico,
                ds_telefono = p_ds_telefono,
                cl_tipo_identificacion = p_cl_tipo_identificacion,
                ds_observacion = p_ds_observacion,
                ds_contacto = p_ds_contacto,
                nm_cuenta_puc = p_nm_cuenta_puc
            WHERE ad_empresa = p_ad_empresa;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Empresa no encontrada o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Empresa actualizada correctamente';

        WHEN 'D' THEN
            IF p_ad_empresa IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de empresa para eliminar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE empresa
            SET ic_registro_activo = 'N'
            WHERE ad_empresa = p_ad_empresa;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Empresa no encontrada';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Empresa eliminada correctamente';

        WHEN 'C' THEN
            SELECT * FROM empresa
            WHERE ds_identificacion = p_ds_identificacion
              AND ic_registro_activo = 'Y';
            SET p_mensaje = 'Consulta realizada correctamente';

        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Empresa activa: SI';
            ELSE
                SET p_mensaje = 'Empresa activa: NO';
            END IF;
    END CASE;
    
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_factura_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_factura_compra`(
    IN p_accion CHAR(1), -- U=Actualizar, A=Anular
    IN p_ad_factura INT,
    IN p_ds_numero_factura VARCHAR(45),
    IN p_dt_fecha_factura DATE,
    IN p_vl_facturado DECIMAL(10,2),
    IN p_vl_descuento DECIMAL(10,2),
    IN p_vl_impuestos DECIMAL(10,2),
    IN p_vl_retencion DECIMAL(10,2),
    IN p_vl_total DECIMAL(10,2),
    IN p_ds_observaciones TEXT,
    IN p_ic_cuenta_cobro VARCHAR(1),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_error TEXT;
    DECLARE v_cuenta_cobro INT;

    /* ============ MANEJO DE ERRORES ============ */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    IF p_accion NOT IN ('U','A') THEN
        SET p_mensaje = 'ERROR: Acción no válida';
        LEAVE proc;
    END IF;

    SELECT ds_estado_factura
    INTO v_estado
    FROM factura_compra
    WHERE ad_factura = p_ad_factura;

    IF v_estado IS NULL THEN
        SET p_mensaje = 'ERROR: Factura no existe';
        LEAVE proc;
    END IF;

    IF v_estado <> 'registrada' THEN
        SET p_mensaje = 'ERROR: La factura no permite modificaciones';
        LEAVE proc;
    END IF;
    
    IF p_ic_cuenta_cobro = 'Y' THEN
        SET v_cuenta_cobro = fn_actualiza_secuencias('seq_cuenta_cobro');
        SET p_ds_numero_factura = CONCAT('CTA_COBRO', v_cuenta_cobro);
    END IF;

    START TRANSACTION;

    CASE p_accion

        /* ===== ACTUALIZAR CABECERA ===== */
        WHEN 'U' THEN
            UPDATE factura_compra
            SET ds_numero_factura = p_ds_numero_factura,
                dt_fecha_factura = p_dt_fecha_factura,
                vl_facturado = p_vl_facturado,
                vl_descuento = p_vl_descuento,
                vl_impuestos = p_vl_impuestos,
                vl_retencion = p_vl_retencion,
                vl_total = p_vl_total,
                ds_observaciones = p_ds_observaciones,
                ic_cuenta_cobro = p_ic_cuenta_cobro
            WHERE ad_factura = p_ad_factura;

            COMMIT;
            SET p_mensaje = 'Factura actualizada correctamente';

        /* ===== ANULAR FACTURA ===== */
        WHEN 'A' THEN
            UPDATE factura_compra
            SET ds_estado_factura = 'anulada'
            WHERE ad_factura = p_ad_factura;

            COMMIT;
            SET p_mensaje = 'Factura anulada correctamente';

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_orden_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_orden_compra`(
    IN p_accion CHAR(1), -- I, U, D, C, V
    IN p_ad_orden INT,
    IN p_fk_sucursal_ad_sucursal INT,
    IN p_fk_provee_ad_proveedor INT,
    IN p_dt_fecha_orden DATETIME,
    IN p_ds_estado ENUM('pendiente','completada','cancelada'),
    IN p_vl_total DECIMAL(10,2),
    IN p_ds_metodo_pago ENUM('efectivo','tarjeta','transferencia','otro'),
    IN p_dt_fecha_entrega DATE,
    IN p_observaciones TEXT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_orden INT DEFAULT 0;
    DECLARE v_error TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_orden_compra',
            p_accion,
            v_error,
            CONCAT(
                'ad_orden=', IFNULL(p_ad_orden, 'NULL'), '; ',
                'sucursal=', IFNULL(p_fk_sucursal_ad_sucursal, 'NULL'), '; ',
                'proveedor=', IFNULL(p_fk_provee_ad_proveedor, 'NULL'), '; ',
                'fecha_orden=', IFNULL(p_dt_fecha_orden, 'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    -- Validaciones iniciales
    IF p_accion NOT IN ('I', 'U', 'D', 'C', 'V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'U') AND (p_fk_provee_ad_proveedor IS NULL OR p_vl_total <= 0) THEN
        SET p_mensaje = 'ERROR: Proveedor y total son obligatorios y válidos';
        LEAVE proc;
    END IF;

    -- Verificar existencia
    IF p_accion IN ('V', 'C') THEN
        SELECT COUNT(*) INTO v_existente
        FROM ordenes_compra
        WHERE fk_provee_ad_proveedor = p_fk_provee_ad_proveedor
          AND DATE(dt_fecha_orden) = DATE(p_dt_fecha_orden);
    END IF;

    -- Iniciar transacción
    IF p_accion IN ('I', 'U', 'D') THEN
        START TRANSACTION;
    END IF;

    -- Lógica principal
    CASE p_accion
        WHEN 'I' THEN
            -- Obtener nueva secuencia
            SET v_ad_orden = fn_actualiza_secuencias('seq_ordenes_compra');

            INSERT INTO ordenes_compra (
                ad_orden, fk_sucursal_ad_sucursal, fk_provee_ad_proveedor, dt_fecha_orden,
                ds_estado, vl_total, ds_metodo_pago,
                dt_fecha_entrega, observaciones
            ) VALUES (
                v_ad_orden, p_fk_sucursal_ad_sucursal, p_fk_provee_ad_proveedor, p_dt_fecha_orden,
                COALESCE(p_ds_estado, 'pendiente'), p_vl_total, COALESCE(p_ds_metodo_pago, 'tarjeta'),
                p_dt_fecha_entrega, p_observaciones
            );

            COMMIT;
            SET p_mensaje = 'Orden de compra insertada correctamente';

        WHEN 'U' THEN
            IF p_ad_orden IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la orden para actualizar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE ordenes_compra
            SET fk_sucursal_ad_sucursal = p_fk_sucursal_ad_sucursal,
                fk_provee_ad_proveedor = p_fk_provee_ad_proveedor,
                dt_fecha_orden = p_dt_fecha_orden,
                ds_estado = p_ds_estado,
                vl_total = p_vl_total,
                ds_metodo_pago = p_ds_metodo_pago,
                dt_fecha_entrega = p_dt_fecha_entrega,
                observaciones = p_observaciones
            WHERE ad_orden = p_ad_orden;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Orden no encontrada o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Orden de compra actualizada correctamente';

        WHEN 'D' THEN
            IF p_ad_orden IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la orden para cancelar';
                ROLLBACK;
                LEAVE proc;
            END IF;
            
            IF p_ds_estado = 'completada' THEN
				SET p_mensaje = 'ERROR: Orden ya se encuentra completada';
                ROLLBACK;
                LEAVE proc;
           END IF;

            UPDATE ordenes_compra
            SET ds_estado = 'cancelada'
            WHERE ad_orden = p_ad_orden;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Orden no encontrada';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Orden de compra cancelada correctamente';

        WHEN 'C' THEN
            SELECT * FROM ordenes_compra
            WHERE fk_sucursal_ad_sucursal = p_fk_sucursal_ad_sucursal
              AND fk_provee_ad_proveedor = p_fk_provee_ad_proveedor
              AND DATE(dt_fecha_orden) = DATE(p_dt_fecha_orden);
            SET p_mensaje = 'Consulta realizada correctamente';

        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Orden encontrada: SÍ';
            ELSE
                SET p_mensaje = 'Orden encontrada: NO';
            END IF;
    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_pedido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_pedido`(
	IN p_accion CHAR(1),                 -- I, U, D, C, V
    IN p_ad_pedido INT,
    IN p_fk_sucursal_ad_sucursal INT,
    IN p_dt_fecha_pedido DATE,
    IN p_dt_fecha_entrega DATE,
    IN p_ds_preparado_por VARCHAR(45),
    IN p_ds_recibido_por VARCHAR(45),
    IN p_ds_observaciones VARCHAR(45),
    OUT p_mensaje VARCHAR(255),
    OUT p_id_pedido INT
)
proc: BEGIN
	DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_pedido INT DEFAULT 0;
	DECLARE v_estado_pedido ENUM('abierto','cerrado');
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_pedido',
            p_accion,
            v_error,
            CONCAT(
                'ad_pedido=', IFNULL(p_ad_pedido,'NULL'), '; ',
                'sucursal=', IFNULL(p_fk_sucursal_ad_sucursal,'NULL'), '; ',
                'fecha_pedido=', IFNULL(p_dt_fecha_pedido,'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;
    
    /* Inicializar salida */
    SET p_id_pedido = NULL;
    
    /* ================= VALIDACIONES ================= */
    IF p_accion NOT IN ('I','U','D','C','V') THEN
        SET p_mensaje = 'ERROR: Acción no válida';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I','U') THEN
        IF p_fk_sucursal_ad_sucursal IS NULL
           OR p_dt_fecha_pedido IS NULL
           OR p_dt_fecha_entrega IS NULL THEN
            SET p_mensaje = 'ERROR: Sucursal y fechas son obligatorias';
            LEAVE proc;
        END IF;
    END IF;

    /* ================= EXISTENCIA ================= */
    IF p_accion IN ('U','D','V') THEN
        SELECT COUNT(*)
        INTO v_existente
        FROM pedido
        WHERE ad_pedido = p_ad_pedido;

        IF v_existente = 0 THEN
            SET p_mensaje = 'ERROR: Pedido no encontrado';
            LEAVE proc;
        END IF;
    END IF;

    /* ================= TRANSACCIÓN ================= */
    IF p_accion IN ('I','U','D') THEN
        START TRANSACTION;
    END IF;

    /* ================= LÓGICA ================= */
    CASE p_accion

        /* ===== INSERTAR ===== */
        WHEN 'I' THEN
            SET v_ad_pedido = fn_actualiza_secuencias('seq_pedido');

            INSERT INTO pedido (
                ad_pedido,
                fk_sucursal_ad_sucursal,
                dt_fecha_pedido,
                dt_fecha_entrega,
                ds_preparado_por,
                ds_recibido_por,
                ds_observaciones,
                ds_estado_pedido
            ) VALUES (
                v_ad_pedido,
                p_fk_sucursal_ad_sucursal,
                p_dt_fecha_pedido,
                p_dt_fecha_entrega,
                p_ds_preparado_por,
                p_ds_recibido_por,
                p_ds_observaciones,
                'abierto'
            );

            COMMIT;
            SET p_id_pedido = v_ad_pedido;
            SET p_mensaje = CONCAT('Pedido registrado correctamente. ID: ', v_ad_pedido);

        /* ===== ACTUALIZAR ===== */
        WHEN 'U' THEN
            UPDATE pedido
            SET fk_sucursal_ad_sucursal = p_fk_sucursal_ad_sucursal,
                dt_fecha_pedido = p_dt_fecha_pedido,
                dt_fecha_entrega = p_dt_fecha_entrega,
                ds_preparado_por = p_ds_preparado_por,
                ds_recibido_por = p_ds_recibido_por,
                ds_observaciones = p_ds_observaciones
            WHERE ad_pedido = p_ad_pedido;

            IF ROW_COUNT() = 0 THEN
                ROLLBACK;
                SET p_mensaje = 'ERROR: Pedido no actualizado';
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_id_pedido = p_ad_pedido;
            SET p_mensaje = 'Pedido actualizado correctamente';

        /* ===== ELIMINAR ===== */
        WHEN 'D' THEN
            DELETE FROM pedido
            WHERE ad_pedido = p_ad_pedido;

            COMMIT;
            SET p_id_pedido = p_ad_pedido;
            SET p_mensaje = 'Pedido eliminado correctamente';

        /* ===== CONSULTAR ===== */
        WHEN 'C' THEN
            SELECT *
            FROM pedido
            WHERE fk_sucursal_ad_sucursal = p_fk_sucursal_ad_sucursal
            ORDER BY dt_fecha_pedido DESC;

            SET p_id_pedido = NULL;
            SET p_mensaje = 'Consulta realizada correctamente';

        /* ===== VALIDAR ===== */
        WHEN 'V' THEN
            SET p_id_pedido = p_ad_pedido;
            SET p_mensaje = 'Pedido encontrado: SÍ';

    END CASE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_producto`(
    IN p_accion CHAR(1),  -- I, U, D, C, V
    IN p_ad_producto INT,
    IN p_nm_producto VARCHAR(100),
    IN p_ds_embalaje VARCHAR(45),
    IN p_ic_refrigeracion CHAR(1),
    IN p_ds_observaciones VARCHAR(100),
    IN p_nm_cuenta_puc INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN

DECLARE v_ad_producto INT DEFAULT 0;
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_error TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;

        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_producto',
            p_accion,
            v_error,
            CONCAT(
                'ad_producto=', IFNULL(p_ad_producto, 'NULL'), '; ',
                'producto=', IFNULL(p_nm_producto, 'NULL'), '; ',
                'cuenta_puc=', IFNULL(p_nm_cuenta_puc, 'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    -- Validaciones iniciales
    IF p_accion NOT IN ('I', 'U', 'D', 'C', 'V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'U') AND p_ic_refrigeracion NOT IN ('Y', 'N') THEN
        SET p_mensaje = 'ERROR: Valor no válido para refrigeración. Use Y o N';
        LEAVE proc;
    END IF;

    IF p_accion IN ('V', 'C') THEN
        SELECT COUNT(*) INTO v_existente
        FROM productos
        WHERE ad_producto = p_ad_producto;
    END IF;

    IF p_accion IN ('I', 'U', 'D') THEN
        START TRANSACTION;
    END IF;

    -- Acciones
    CASE p_accion
        WHEN 'I' THEN
        -- Llamada a la función para obtener la secuencia
        SET v_ad_producto = fn_actualiza_secuencias('seq_producto');

            INSERT INTO productos (
                ad_producto, nm_producto, ds_embalaje,
                ic_refrigeracion, ds_observaciones, nm_cuenta_puc
            )
            VALUES (
                v_ad_producto, p_nm_producto, p_ds_embalaje,
                p_ic_refrigeracion, p_ds_observaciones, p_nm_cuenta_puc
            );

            COMMIT;
            SET p_mensaje = 'Producto insertado correctamente';

        WHEN 'U' THEN
            IF p_ad_producto IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del producto para actualizar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE productos
            SET nm_producto = p_nm_producto,
                ds_embalaje = p_ds_embalaje,
                ic_refrigeracion = p_ic_refrigeracion,
                ds_observaciones = p_ds_observaciones,
                nm_cuenta_puc = p_nm_cuenta_puc
            WHERE ad_producto = p_ad_producto;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Producto no encontrado o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Producto actualizado correctamente';

        WHEN 'D' THEN
            IF p_ad_producto IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del producto para eliminar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            DELETE FROM productos WHERE ad_producto = p_ad_producto;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Producto no encontrado';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Producto eliminado correctamente';

        WHEN 'C' THEN
            SELECT * FROM productos WHERE ad_producto = p_ad_producto;
            SET p_mensaje = 'Consulta realizada correctamente';

        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Producto existe: SI';
            ELSE
                SET p_mensaje = 'Producto existe: NO';
            END IF;
    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_proveedor`(
    IN p_accion CHAR(1),  -- I, U, D, C, V
    IN p_ad_proveedor INT,
    IN p_ds_identificacion VARCHAR(20),
    IN p_ds_razon_social VARCHAR(80),
    IN p_ds_direccion VARCHAR(100),
    IN p_ds_correo_electronico VARCHAR(100),
    IN p_ds_telefono VARCHAR(45),
    IN p_cl_tipo_identificacion VARCHAR(2),
    IN p_ds_productos VARCHAR(100),
    IN p_ds_contacto VARCHAR(45),
    IN p_nm_cuenta_puc INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_proveedor INT DEFAULT 0;
    DECLARE v_error TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;

        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_proveedor',
            p_accion,
            v_error,
            CONCAT(
                'ad_proveedor=', IFNULL(p_ad_proveedor, 'NULL'), '; ',
                'identificacion=', IFNULL(p_ds_identificacion, 'NULL'), '; ',
                'razon_social=', IFNULL(p_ds_razon_social, 'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    -- Validaciones generales
    IF p_accion NOT IN ('I', 'U', 'D', 'C', 'V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    IF p_accion IN ('I', 'U') AND p_cl_tipo_identificacion NOT IN ('NI', 'CC') THEN
        SET p_mensaje = 'ERROR: Tipo de identificación inválido. Use NI o CC';
        LEAVE proc;
    END IF;

    -- Validar proveedor por identificación en I, V, C
    IF p_accion IN ('I', 'V', 'C') THEN
        SELECT COUNT(*) INTO v_existente
        FROM proveedor
        WHERE ds_identificacion = p_ds_identificacion
          AND ic_registro_activo = 'Y';
    END IF;

    -- Transacción para acciones que modifican
    IF p_accion IN ('I', 'U', 'D') THEN
        START TRANSACTION;
    END IF;

    -- Acciones
    CASE p_accion
        WHEN 'I' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'ERROR: Ya existe un proveedor activo con esa identificación';
                ROLLBACK;
                LEAVE proc;
            END IF;

        -- Llamada a la función para obtener la secuencia
        SET v_ad_proveedor = fn_actualiza_secuencias('seq_proveedor');

            INSERT INTO proveedor (
                ad_proveedor, ds_identificacion, ds_razon_social,
                ds_direccion, ds_correo_electronico, ds_telefono,
                cl_tipo_identificacion, dt_creacion, ds_productos,
                ds_contacto, ic_registro_activo, nm_cuenta_puc
            )
            VALUES (
                v_ad_proveedor, p_ds_identificacion, p_ds_razon_social,
                p_ds_direccion, p_ds_correo_electronico, p_ds_telefono,
                p_cl_tipo_identificacion, CURDATE(), p_ds_productos,
                p_ds_contacto, 'Y', p_nm_cuenta_puc
            );

            COMMIT;
            SET p_mensaje = 'Proveedor insertado correctamente';

        WHEN 'U' THEN
            IF p_ad_proveedor IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del proveedor para actualizar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE proveedor
            SET ds_razon_social = p_ds_razon_social,
                ds_direccion = p_ds_direccion,
                ds_correo_electronico = p_ds_correo_electronico,
                ds_telefono = p_ds_telefono,
                cl_tipo_identificacion = p_cl_tipo_identificacion,
                ds_productos = p_ds_productos,
                ds_contacto = p_ds_contacto,
                nm_cuenta_puc = p_nm_cuenta_puc
            WHERE ad_proveedor = p_ad_proveedor;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Proveedor no encontrado o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Proveedor actualizado correctamente';

        WHEN 'D' THEN
            IF p_ad_proveedor IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID del proveedor para eliminar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE proveedor
            SET ic_registro_activo = 'N'
            WHERE ad_proveedor = p_ad_proveedor;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Proveedor no encontrado';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Proveedor eliminado correctamente';

        WHEN 'C' THEN
            SELECT * FROM proveedor
            WHERE ds_identificacion = p_ds_identificacion
              AND ic_registro_activo = 'Y';
            SET p_mensaje = 'Consulta realizada correctamente';

        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Proveedor activo: SI';
            ELSE
                SET p_mensaje = 'Proveedor activo: NO';
            END IF;
    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_sucursal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_sucursal`(
    IN p_accion CHAR(1),  -- I, U, D, C, V
    IN p_ad_sucursal INT,
    IN p_fk_empresa_ad_empresa INT,
    IN p_ds_nombre VARCHAR(60),
    IN p_ds_direccion VARCHAR(45),
    IN p_ds_correo_electronico VARCHAR(100),
    IN p_ds_telefono VARCHAR(45),
    IN p_ds_observacion VARCHAR(100),
    IN p_ds_contacto VARCHAR(45),
    IN p_nm_cuenta_puc INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_sucursal INT DEFAULT 0;
    DECLARE v_empresa_activa INT DEFAULT 0;
    DECLARE v_error TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;

        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_sucursal',
            p_accion,
            v_error,
            CONCAT(
                'ad_sucursal=', IFNULL(p_ad_sucursal, 'NULL'), '; ',
                'fk_empresa=', IFNULL(p_fk_empresa_ad_empresa, 'NULL'), '; ',
                'nombre=', IFNULL(p_ds_nombre, 'NULL'), '; ',
                'cuenta_puc=', IFNULL(p_nm_cuenta_puc, 'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    -- Validaciones generales
    IF p_accion NOT IN ('I', 'U', 'D', 'C', 'V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    -- Validar existencia de sucursal si aplica
    IF p_accion IN ('V', 'C') THEN
        SELECT COUNT(*) INTO v_existente
        FROM sucursal
        WHERE ad_sucursal = p_ad_sucursal
          AND ic_registro_activo = 'Y';
    END IF;

    -- Validar existencia de empresa activa al insertar o actualizar
    IF p_accion IN ('I', 'U') THEN
        SELECT COUNT(*) INTO v_empresa_activa
        FROM empresa
        WHERE ad_empresa = p_fk_empresa_ad_empresa
          AND ic_registro_activo = 'Y';

        IF v_empresa_activa = 0 THEN
            SET p_mensaje = 'ERROR: La empresa asociada no existe o está inactiva';
            LEAVE proc;
        END IF;
    END IF;

    -- Iniciar transacción si modifica datos
    IF p_accion IN ('I', 'U', 'D') THEN
        START TRANSACTION;
    END IF;

    -- Operaciones
    CASE p_accion
        WHEN 'I' THEN
        -- Llamada a la función para obtener la secuencia
        SET v_ad_sucursal = fn_actualiza_secuencias('seq_sucursal');

            INSERT INTO sucursal (
                ad_sucursal, fk_empresa_ad_empresa, ds_nombre,
                ds_direccion, ds_correo_electronico, ds_telefono,
                dt_creacion, ds_observacion, ds_contacto,
                ic_registro_activo, nm_cuenta_puc
            ) VALUES (
                v_ad_sucursal, p_fk_empresa_ad_empresa, p_ds_nombre,
                p_ds_direccion, p_ds_correo_electronico, p_ds_telefono,
                CURDATE(), p_ds_observacion, p_ds_contacto,
                'Y', p_nm_cuenta_puc
            );

            COMMIT;
            SET p_mensaje = 'Sucursal insertada correctamente';

        WHEN 'U' THEN
            IF p_ad_sucursal IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la sucursal para actualizar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE sucursal
            SET fk_empresa_ad_empresa = p_fk_empresa_ad_empresa,
                ds_nombre = p_ds_nombre,
                ds_direccion = p_ds_direccion,
                ds_correo_electronico = p_ds_correo_electronico,
                ds_telefono = p_ds_telefono,
                ds_observacion = p_ds_observacion,
                ds_contacto = p_ds_contacto,
                nm_cuenta_puc = p_nm_cuenta_puc
            WHERE ad_sucursal = p_ad_sucursal;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Sucursal no encontrada o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Sucursal actualizada correctamente';

        WHEN 'D' THEN
            IF p_ad_sucursal IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la sucursal para eliminar';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE sucursal
            SET ic_registro_activo = 'N'
            WHERE ad_sucursal = p_ad_sucursal;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Sucursal no encontrada';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Sucursal eliminada correctamente';

        WHEN 'C' THEN
            SELECT * FROM sucursal
            WHERE ad_sucursal = p_ad_sucursal
              AND ic_registro_activo = 'Y';
            SET p_mensaje = 'Consulta realizada correctamente';

        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Sucursal activa: SI';
            ELSE
                SET p_mensaje = 'Sucursal activa: NO';
            END IF;
    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_gestionar_sucursal_banco` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gestionar_sucursal_banco`(
    IN p_accion CHAR(1),                  -- I, U, D, C, V
    IN p_ad_sucursal_banco INT,
    IN p_fk_banco_ad_banco INT,
    IN p_ds_nombre VARCHAR(100),
    IN p_ds_direccion VARCHAR(100),
    IN p_ds_telefono VARCHAR(45),
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_existente INT DEFAULT 0;
    DECLARE v_ad_sucursal_banco INT DEFAULT 0;
    DECLARE v_error TEXT;

    /* =========================
       MANEJO DE ERRORES
    ==========================*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;

        INSERT INTO log_errores (
            modulo, operacion, mensaje_error, datos_entrada
        ) VALUES (
            'sp_gestionar_sucursal_banco',
            p_accion,
            v_error,
            CONCAT(
                'ad_sucursal_banco=', IFNULL(p_ad_sucursal_banco,'NULL'), '; ',
                'banco=', IFNULL(p_fk_banco_ad_banco,'NULL'), '; ',
                'nombre=', IFNULL(p_ds_nombre,'NULL')
            )
        );

        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* =========================
       VALIDACIONES GENERALES
    ==========================*/
    IF p_accion NOT IN ('I','U','D','C','V') THEN
        SET p_mensaje = 'ERROR: Acción no válida. Use I, U, D, C o V';
        LEAVE proc;
    END IF;

    /* =========================
       VALIDAR EXISTENCIA (por banco + nombre)
    ==========================*/
    IF p_accion IN ('I','V') THEN
        SELECT COUNT(*) INTO v_existente
        FROM sucursal_banco
        WHERE fk_banco_ad_banco = p_fk_banco_ad_banco
          AND ds_nombre = p_ds_nombre
          AND ic_activo = 'Y';
    END IF;

    /* =========================
       TRANSACCIÓN
    ==========================*/
    IF p_accion IN ('I','U','D') THEN
        START TRANSACTION;
    END IF;

    /* =========================
       LÓGICA PRINCIPAL
    ==========================*/
    CASE p_accion

        /* ========= INSERTAR ========= */
        WHEN 'I' THEN
            IF p_fk_banco_ad_banco IS NULL OR p_ds_nombre IS NULL THEN
                SET p_mensaje = 'ERROR: Banco y nombre de sucursal son obligatorios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            IF v_existente > 0 THEN
                SET p_mensaje = 'ERROR: Ya existe una sucursal activa con ese nombre para el banco';
                ROLLBACK;
                LEAVE proc;
            END IF;

            SET v_ad_sucursal_banco = fn_actualiza_secuencias('seq_sucursal_banco');

            INSERT INTO sucursal_banco (
                ad_sucursal_banco,
                fk_banco_ad_banco,
                ds_nombre,
                ds_direccion,
                ds_telefono,
                ic_activo,
                dt_creacion
            ) VALUES (
                v_ad_sucursal_banco,
                p_fk_banco_ad_banco,
                p_ds_nombre,
                p_ds_direccion,
                p_ds_telefono,
                'Y',
                CURDATE()
            );

            COMMIT;
            SET p_mensaje = CONCAT(
                'Sucursal bancaria registrada correctamente. ID: ',
                v_ad_sucursal_banco
            );

        /* ========= ACTUALIZAR ========= */
        WHEN 'U' THEN
            IF p_ad_sucursal_banco IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la sucursal bancaria';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE sucursal_banco
            SET fk_banco_ad_banco = p_fk_banco_ad_banco,
                ds_nombre = p_ds_nombre,
                ds_direccion = p_ds_direccion,
                ds_telefono = p_ds_telefono
            WHERE ad_sucursal_banco = p_ad_sucursal_banco;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Sucursal bancaria no encontrada o sin cambios';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Sucursal bancaria actualizada correctamente';

        /* ========= ELIMINACIÓN LÓGICA ========= */
        WHEN 'D' THEN
            IF p_ad_sucursal_banco IS NULL THEN
                SET p_mensaje = 'ERROR: Debe indicar el ID de la sucursal bancaria';
                ROLLBACK;
                LEAVE proc;
            END IF;

            UPDATE sucursal_banco
            SET ic_activo = 'N'
            WHERE ad_sucursal_banco = p_ad_sucursal_banco;

            IF ROW_COUNT() = 0 THEN
                SET p_mensaje = 'ERROR: Sucursal bancaria no encontrada';
                ROLLBACK;
                LEAVE proc;
            END IF;

            COMMIT;
            SET p_mensaje = 'Sucursal bancaria desactivada correctamente';

        /* ========= CONSULTAR ========= */
        WHEN 'C' THEN
            SELECT sb.*,
                   b.ds_nombre AS banco
            FROM sucursal_banco sb
            INNER JOIN banco b ON b.ad_banco = sb.fk_banco_ad_banco
            WHERE sb.ic_activo = 'Y'
            ORDER BY b.ds_nombre, sb.ds_nombre;

            SET p_mensaje = 'Consulta realizada correctamente';

        /* ========= VALIDAR EXISTENCIA ========= */
        WHEN 'V' THEN
            IF v_existente > 0 THEN
                SET p_mensaje = 'Sucursal bancaria activa: SI';
            ELSE
                SET p_mensaje = 'Sucursal bancaria activa: NO';
            END IF;

    END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_factura_compra_desde_orden` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_factura_compra_desde_orden`(
    IN p_fk_ordencom_ad_orden INT,
    OUT p_ad_factura INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_ad_factura INT;
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_error TEXT;
    DECLARE v_total_detalle DECIMAL(10,2) DEFAULT 0;

    /* ============ MANEJO DE ERRORES ============ */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        ROLLBACK;
        SET p_ad_factura = NULL;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* ============ VALIDACIONES ============ */

    -- Validar orden
    SELECT COUNT(*) INTO v_existe
    FROM ordenes_compra
    WHERE ad_orden = p_fk_ordencom_ad_orden
      AND ds_estado <> 'completada';

    IF v_existe = 0 THEN
        SET p_mensaje = 'ERROR: Orden de compra no válida o no completada';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    /* ============ CREAR CABECERA FACTURA ============ */
    SET v_ad_factura = fn_actualiza_secuencias('seq_factura_compra');

    INSERT INTO factura_compra (
        ad_factura,
        fk_provee_ad_proveedor,
        fk_sucursal_ad_sucursal,
        fk_ordencom_ad_orden,
        ds_numero_factura,
        dt_fecha_factura,
        vl_facturado,
        vl_descuento,
        vl_impuestos,
        vl_retencion,
        vl_total,
        vl_pagado,
        vl_saldo,
        ds_estado_factura,
        ds_estado_pago,
        ds_observaciones,
        ic_cuenta_cobro
    )
    SELECT
        v_ad_factura,
        o.fk_provee_ad_proveedor,
        o.fk_sucursal_ad_sucursal,
        o.ad_orden,
        concat('XX',v_ad_factura),
        '2000-01-01',
        0,
        0,
        0,
	    0,
        0,
        0, 0,
        'registrada',
        'pendiente',
        null,
        'N'
    FROM ordenes_compra o
    WHERE o.ad_orden = p_fk_ordencom_ad_orden;

    /* ============ COPIAR DETALLE DESDE ORDEN ============ */
    INSERT INTO detalle_factura_compra (
        ad_detalle_factura,
        fk_factura_ad_factura,
        fk_product_ad_producto,
        vl_cantidad,
        vl_costo_unitario,
        vl_subtotal
    )
    SELECT
        fn_actualiza_secuencias('seq_detalle_factura_compra'),
        v_ad_factura,
        d.fk_product_ad_producto,
        d.vl_cantidad,
        d.vl_precio_unitario,
        d.vl_subtotal
    FROM detalles_orden_compra d
    WHERE d.fk_ordencom_ad_orden = p_fk_ordencom_ad_orden;

    /* ============ CALCULAR VALOR DE LA FACTURA DE ACUERDO A LOS DETALLES ============ */
    SELECT SUM(vl_subtotal) INTO v_total_detalle
    FROM detalle_factura_compra
    WHERE fk_factura_ad_factura = v_ad_factura;
    
    UPDATE factura_compra
    SET vl_facturado = v_total_detalle
    WHERE ad_factura = v_ad_factura;

    UPDATE ordenes_compra
    SET ds_estado = 'completada'
    WHERE ad_orden = p_fk_ordencom_ad_orden;

    COMMIT;

    SET p_ad_factura = v_ad_factura;
    SET p_mensaje = CONCAT(
        'Factura creada desde orden. ',
        'ID: ', v_ad_factura,
        '. Impuestos y totales deben registrarse antes del cierre.'
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_tipo_impuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_tipo_impuesto`(
    IN p_ds_codigo VARCHAR(10),
    IN p_ds_nombre VARCHAR(100),
    IN p_pr_porcentaje DECIMAL(5,2),
    IN p_cl_tipo ENUM('impuesto','retencion'),
    OUT p_id_tipo_impuesto INT,
    OUT p_mensaje VARCHAR(255)
)
proc: BEGIN
    DECLARE v_error TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error = MESSAGE_TEXT;
        SET p_id_tipo_impuesto = NULL;
        SET p_mensaje = CONCAT('ERROR: ', v_error);
    END;

    /* VALIDACIONES */
    IF p_ds_codigo IS NULL
       OR p_ds_nombre IS NULL
       OR p_pr_porcentaje < 0 THEN
        SET p_mensaje = 'ERROR: Datos inválidos';
        LEAVE proc;
    END IF;

    /* VALIDAR DUPLICADO */
    IF EXISTS (
        SELECT 1 FROM tipo_impuesto WHERE ds_codigo = p_ds_codigo
    ) THEN
        SET p_mensaje = 'ERROR: El código de impuesto ya existe';
        LEAVE proc;
    END IF;

    SET p_id_tipo_impuesto = fn_actualiza_secuencias('seq_tipo_impuesto');

    INSERT INTO tipo_impuesto (
        ad_tipo_impuesto,
        ds_codigo,
        ds_nombre,
        pr_porcentaje,
        cl_tipo
    ) VALUES (
        p_id_tipo_impuesto,
        p_ds_codigo,
        p_ds_nombre,
        p_pr_porcentaje,
        p_cl_tipo
    );

    SET p_mensaje = CONCAT('Tipo de impuesto registrado correctamente. ID: ', p_id_tipo_impuesto);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-14 20:50:11
