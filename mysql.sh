#!/bin/bash

MYSQL_ROOT="root"
PASS_ROOT="root"
MYSQL_HOST="localhost"

NOMBRE_BD="unizar"
USUARIO_BD="mario"
PASSWORD_USUARIO="mariobd2"
usuarioProfesor="profesor"
passwordProfesor="profesor1234"

descargar_datos(){

	sudo curl -o /var/lib/mysql-files/oferta2019.csv https://zaguan.unizar.es/record/87665/files/CSV.csv -o /var/lib/mysql-files/oferta2020.csv https://zaguan.unizar.es/record/96835/files/CSV.csv -o /var/lib/mysql-files/oferta2021.csv https://zaguan.unizar.es/record/108270/files/CSV.csv -o /var/lib/mysql-files/resultados2019.csv https://zaguan.unizar.es/record/95644/files/CSV.csv -o /var/lib/mysql-files/resultados2020.csv https://zaguan.unizar.es/record/107369/files/CSV.csv -o /var/lib/mysql-files/resultados2021.csv https://zaguan.unizar.es/record/118234/files/CSV.csv -o /var/lib/mysql-files/notasDeCorteDefinitivas2019.csv https://zaguan.unizar.es/record/87663/files/CSV.csv -o /var/lib/mysql-files/notasDeCorteDefinitivas2020.csv https://zaguan.unizar.es/record/98173/files/CSV.csv -o /var/lib/mysql-files/notasDeCorteDefinitivas2021.csv https://zaguan.unizar.es/record/109322/files/CSV.csv -o /var/lib/mysql-files/acuerdosMovilidad2019.csv https://zaguan.unizar.es/record/83980/files/CSV.csv -o /var/lib/mysql-files/acuerdosMovilidad2020.csv https://zaguan.unizar.es/record/95648/files/CSV.csv -o /var/lib/mysql-files/acuerdosMovilidad2021.csv https://zaguan.unizar.es/record/107373/files/CSV.csv -o /var/lib/mysql-files/alumnosEgresados2019.csv https://zaguan.unizar.es/record/95646/files/CSV.csv -o /var/lib/mysql-files/alumnosEgresados2020.csv https://zaguan.unizar.es/record/107371/files/CSV.csv -o /var/lib/mysql-files/alumnosEgresados2021.csv https://zaguan.unizar.es/record/118236/files/CSV.csv -o /var/lib/mysql-files/rendimientoAsignatura2019.csv https://zaguan.unizar.es/record/95645/files/CSV.csv -o /var/lib/mysql-files/rendimientoAsignatura2020.csv https://zaguan.unizar.es/record/107370/files/CSV.csv -o /var/lib/mysql-files/rendimientoAsignatura2021.csv https://zaguan.unizar.es/record/118235/files/CSV.csv &>/dev/null
	
	
	sudo sed -i '/Máster/d' /var/lib/mysql-files/rendimientoAsignatura2021.csv
	sudo sed -i '/Doctorado/d' /var/lib/mysql-files/rendimientoAsignatura2021.csv
	sudo sed -i '/renewable/d' /var/lib/mysql-files/rendimientoAsignatura2021.csv	
	sudo sed -i '/Complementos/d' /var/lib/mysql-files/rendimientoAsignatura2021.csv	
}

crear_bd_y_usuario(){

	
	create_table_oferta="
		create table oferta(CURSO_ACADEMICO integer,ESTUDIO varchar(500),LOCALIDAD varchar(100), CENTRO varchar(300),TIPO_CENTRO varchar(100),TIPO_ESTUDIO varchar(100),PLAZAS_OFERTADAS integer,PLAZAS_MATRICULADAS integer,PLAZAS_SOLICITADAS integer,INDICE_OCUPACION real,FECHA_ACTUALIZACION varchar(300));"
		
	create_table_resultados="
		create table resultados(CURSO_ACADEMICO integer, CENTRO varchar(300), ESTUDIO varchar(300), TIPO_ESTUDIO varchar(300), ALUMNOS_MATRICULADOS varchar(20), ALUMNOS_NUEVO_INGRESO varchar(20), PLAZAS_OFERTADAS varchar(20), ALUMNOS_GRADUADOS varchar(20), ALUMNOS_ADAPTA_GRADO_MATRI varchar(20), ALUMNOS_ADAPTA_GRADO_MATRI_NI varchar(20), ALUMNOS_ADAPTA_GRADO_TITULADO varchar(20), ALUMNOS_CON_RECONOCIMIENTO varchar(20), ALUMNOS_MOVILIDAD_ENTRADA varchar(20), ALUMNOS_MOVILIDAD_SALIDA varchar(20), CREDITOS_MATRICULADOS varchar(20), CREDITOS_RECONOCIDOS varchar(20), DURACION_MEDIA_GRADUADOS varchar(20), TASA_EXITO varchar(20), TASA_RENDIMIENTO varchar(20), TASA_EFICIENCIA varchar(20), TASA_ABANDONO varchar(10), TASA_GRADUACION varchar(10), FECHA_ACTUALIZACION varchar(300));"
		
	create_table_acuerdos="
		CREATE TABLE acuerdos(CURSO_ACADEMICO integer, NOMBRE_PROGRAMA_MOVILIDAD varchar(300), NOMBRE_AREA_ESTUDIOS_MOV varchar(300), CENTRO varchar(300), IN_OUT varchar(100), NOMBRE_IDIOMA_NIVEL_MOVILIDAD varchar(300), PAIS_UNIVERSIDAD_ACUERDO varchar(300), UNIVERSIDAD_ACUERDO varchar(300), PLAZAS_OFERTADAS_ALUMNOS integer, PLAZAS_ASIGNADAS_ALUMNOS_OUT integer, FECHA_ACTUALIZACION varchar(300));"
		
	create_table_notasDeCorte="
		create table notas_de_corte(CURSO_ACADEMICO integer,ESTUDIO varchar(500),LOCALIDAD varchar(100), CENTRO varchar(300),PRELA_CONVO_NOTA_DEF varchar(10),NOTA_CORTE_DEFINITIVA_JUNIO real,NOTA_CORTE_DEFINITIVA_SEPTIEMBRE varchar(10),FECHA_ACTUALIZACION varchar(300));"
		
	create_table_alumnosEgresados="
		create table alumnos_egresados(CURSO_ACADEMICO integer,LOCALIDAD varchar(300), ESTUDIO varchar(300),TIPO_ESTUDIO varchar(200),TIPO_EGRESO varchar(200), SEXO varchar(300),ALUMNOS_GRADUADOS integer, ALUMNOS_INTERRUMPEN_ESTUDIOS integer, ALUMNOS_INTERRUMPEN_EST_ANO1 integer,ALUMNOS_TRASLADAN_OTRA_UNIV integer, DURACION_MEDIA_GRADUADOS varchar(10), TASA_EFICIENCIA varchar(10), FECHA_ACTUALIZACION varchar(300));"
		
	create_table_rendimientoAsignatura="
		create table rendimiento_asignatura(CURSO_ACADEMICO integer,TIPO_ESTUDIO varchar(200), ESTUDIO varchar(300),LOCALIDAD varchar(300),CENTRO varchar(300),ASIGNATURA varchar(300),TIPO_ASIGNATURA varchar(300),CLASE_ASIGNATURA varchar(300),TASA_EXITO varchar(10),TASA_RENDIMIENTO varchar(10), TASA_EVALUACION varchar(10), ALUMNOS_EVALUADOS integer,ALUMNOS_SUPERADOS integer, ALUMNOS_PRESENTADOS integer, MEDIA_CONVOCATORIAS_CONSUMIDAS varchar(10), FECHA_ACTUALIZACION varchar(300));"

	importar_datos_oferta="
		LOAD DATA INFILE '/var/lib/mysql-files/oferta2019.csv' INTO TABLE oferta FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/oferta2020.csv' INTO TABLE oferta FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/oferta2021.csv' INTO TABLE oferta FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;"
	
	importar_datos_resultados="
		LOAD DATA INFILE '/var/lib/mysql-files/resultados2019.csv' INTO TABLE resultados FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/resultados2020.csv' INTO TABLE resultados FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/resultados2021.csv' INTO TABLE resultados FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;"
		
		
		
	importar_datos_acuerdos="
		LOAD DATA INFILE '/var/lib/mysql-files/acuerdosMovilidad2019.csv' INTO TABLE acuerdos FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/acuerdosMovilidad2020.csv' INTO TABLE acuerdos FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/acuerdosMovilidad2021.csv' INTO TABLE acuerdos FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS; "
	
		
	importar_datos_notas_de_corte="
		LOAD DATA INFILE '/var/lib/mysql-files/notasDeCorteDefinitivas2019.csv' INTO TABLE notas_de_corte FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/notasDeCorteDefinitivas2020.csv' INTO TABLE notas_de_corte FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/notasDeCorteDefinitivas2021.csv' INTO TABLE notas_de_corte FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;"
		
	importar_datos_alumnos_egresados="
		LOAD DATA INFILE '/var/lib/mysql-files/alumnosEgresados2019.csv' INTO TABLE alumnos_egresados FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/alumnosEgresados2020.csv' INTO TABLE alumnos_egresados FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/alumnosEgresados2021.csv' INTO TABLE alumnos_egresados FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;"
		
	importar_datos_rendimiento_asignatura="
		LOAD DATA INFILE '/var/lib/mysql-files/rendimientoAsignatura2019.csv' INTO TABLE rendimiento_asignatura FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/rendimientoAsignatura2020.csv' INTO TABLE rendimiento_asignatura FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
		LOAD DATA INFILE '/var/lib/mysql-files/rendimientoAsignatura2021.csv' INTO TABLE rendimiento_asignatura FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS; "

	actualizar_tabla_acuerdos="
		update acuerdos SET nombre_area_estudios_mov = REGEXP_REPLACE(nombre_area_estudios_mov, '[^a-zA-Z]+', '') WHERE nombre_area_estudios_mov REGEXP '[^a-zA-Z]+';"
	actualizar_tabla_alumnosEgresados="
		delete from alumnos_egresados WHERE NOT tipo_estudio = 'Grado';
		UPDATE alumnos_egresados SET estudio =substring(estudio from 8);"
	actualizar_tabla_notasDeCorte="
		UPDATE notas_de_corte SET estudio =substring(estudio from 8);"
	actualizar_tabla_oferta="
		delete from oferta WHERE NOT tipo_estudio = 'Grado'; 
		UPDATE oferta SET estudio =substring(estudio from 8);"
	actualizar_tabla_resultados="
		delete from resultados WHERE NOT tipo_estudio = 'Grado';
		UPDATE resultados SET estudio =substring(estudio from 3);"  #	REVISARRRRR SI ES FROM 3 O 4

	actualizar_tabla_tipoAsignatura="
		delete from rendimiento_asignatura WHERE NOT tipo_estudio = 'Grado';
		UPDATE rendimiento_asignatura SET estudio =substring(estudio from 8);"
	actualizar_TablaResultados="
		UPDATE resultados SET ALUMNOS_MATRICULADOS = 0 WHERE ALUMNOS_MATRICULADOS='';
		UPDATE resultados SET ALUMNOS_NUEVO_INGRESO = 0 WHERE ALUMNOS_NUEVO_INGRESO='';
		UPDATE resultados SET PLAZAS_OFERTADAS = 0 WHERE PLAZAS_OFERTADAS='';
		UPDATE resultados SET ALUMNOS_GRADUADOS = 0 WHERE ALUMNOS_GRADUADOS='';
		UPDATE resultados SET CREDITOS_MATRICULADOS = 0 WHERE CREDITOS_MATRICULADOS='';
		UPDATE resultados SET CREDITOS_RECONOCIDOS = 0 WHERE CREDITOS_RECONOCIDOS='';
		UPDATE resultados SET DURACION_MEDIA_GRADUADOS = 0 WHERE DURACION_MEDIA_GRADUADOS='';
		UPDATE resultados SET TASA_EXITO = 0 WHERE TASA_EXITO='';
		UPDATE resultados SET TASA_RENDIMIENTO = 0 WHERE TASA_RENDIMIENTO='';
		UPDATE resultados SET TASA_EFICIENCIA = 0 WHERE TASA_EFICIENCIA='';
		UPDATE resultados SET TASA_ABANDONO = 0 WHERE TASA_ABANDONO='';
		UPDATE resultados SET TASA_GRADUACION = 0 WHERE TASA_GRADUACION='';
		
		
		alter table resultados MODIFY ALUMNOS_MATRICULADOS INT;
		alter table resultados MODIFY ALUMNOS_NUEVO_INGRESO INT;
		alter table resultados MODIFY PLAZAS_OFERTADAS INT;
		alter table resultados MODIFY ALUMNOS_GRADUADOS INT;
		alter table resultados MODIFY CREDITOS_MATRICULADOS REAL;
		alter table resultados MODIFY CREDITOS_MATRICULADOS REAL;
		alter table resultados MODIFY CREDITOS_RECONOCIDOS REAL;
		alter table resultados MODIFY DURACION_MEDIA_GRADUADOS REAL;
		alter table resultados MODIFY TASA_EXITO REAL;
		alter table resultados MODIFY TASA_RENDIMIENTO REAL;
		alter table resultados MODIFY TASA_EFICIENCIA REAL;
		alter table resultados MODIFY TASA_ABANDONO REAL;
		alter table resultados MODIFY TASA_GRADUACION REAL; "
		
		
		
		
	#CREAMOS BD EN MYSQL;
	if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "CREATE DATABASE IF NOT EXISTS $NOMBRE_BD"; then
		echo "Base de datos $NOMBRE_BD creada correctamente"
		
		if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e " use unizar;
			$create_table_oferta
			$create_table_resultados
			$create_table_acuerdos
			$create_table_rendimientoAsignatura
			$create_table_alumnosEgresados
			$create_table_notasDeCorte
			$importar_datos_oferta
			$importar_datos_resultados
			$importar_datos_acuerdos
			$importar_datos_notas_de_corte
			$importar_datos_alumnos_egresados
			$importar_datos_rendimiento_asignatura	
			$actualizar_tabla_alumnosEgresados
			$actualizar_tabla_acuerdos
			$actualizar_tabla_notasDeCorte
			$actualizar_tabla_oferta
			$actualizar_tabla_resultados
			$actualizar_tabla_tipoAsignatura
			$actualizar_TablaResultados" &>/dev/null; then
				
				echo "Las tablas se han creado correctamente y los datos han sido importados correctamente"
		else 
			echo "Error al crear las tablas"
		fi
	else
		echo "Error al crear la base de datos "$NOMBRE_BD""
		
	fi
	
	
	
	#crear usuario mario y darle permiso para acceder a la bd
	if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "CREATE USER '$USUARIO_BD'@'localhost' IDENTIFIED BY '$PASSWORD_USUARIO'" ;then
	
		mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "GRANT ALL PRIVILEGES ON $NOMBRE_BD.* TO '$USUARIO_BD'@'localhost'"
	
		echo "Usuario "$USUARIO_BD" creado correctamente"
	else 
		echo "Error al crear el usuario "$USUARIO_BD""
	fi

}

crearBase_Buena(){

	crearTablaLocalidad="
		create table if not exists localidad(id_localidad int NOT NULL AUTO_INCREMENT PRIMARY KEY, ciudad text not null);
		insert into localidad(ciudad) select distinct localidad from oferta;
		"
	crearTablaCentro="
		create table if not exists centro(id_centro int NOT NULL AUTO_INCREMENT PRIMARY KEY, nombre_centro TEXT NOT NULL, id_localidad integer REFERENCES localidad(id_localidad));
		insert into centro(nombre_centro, id_localidad) SELECT DISTINCT centro, id_localidad FROM oferta JOIN localidad on oferta.localidad=localidad.ciudad;
	"
	
	crearTablaEstudio="
		create table if not exists estudio(id_estudio int NOT NULL AUTO_INCREMENT PRIMARY KEY, nombre_estudio TEXT NOT NULL);
		INSERT INTO estudio (nombre_estudio) SELECT DISTINCT estudio from oferta;
		"
		
	crearTablaOfrece="
		create table if not exists ofrece(id_estudio INTEGER NOT NULL, id_centro INTEGER NOT NULL, año INTEGER NOT NULL,PLAZAS_OFERTADAS integer,PLAZAS_MATRICULADAS integer,PLAZAS_SOLICITADAS integer,INDICE_OCUPACION real,NOTA_CORTE_DEFINITIVA_JUNIO real,NOTA_CORTE_DEFINITIVA_SEPTIEMBRE real,ALUMNOS_MATRICULADOS integer, ALUMNOS_NUEVO_INGRESO integer,ALUMNOS_GRADUADOS integer, CREDITOS_MATRICULADOS real, CREDITOS_RECONOCIDOS real, DURACION_MEDIA_GRADUADOS real, TASA_EXITO real, TASA_RENDIMIENTO real, TASA_EFICIENCIA real, TASA_ABANDONO real, TASA_GRADUACION real, PRIMARY KEY (id_estudio, id_centro,año), FOREIGN KEY (id_estudio) REFERENCES estudio (id_estudio), FOREIGN KEY (id_centro) REFERENCES centro (id_centro)); 
		
		insert into ofrece(id_estudio, id_centro, año) select distinct estudio.id_estudio, centro.id_centro, oferta.curso_academico from oferta join estudio on oferta.estudio = estudio.nombre_estudio join centro on oferta.centro = centro.nombre_centro;
		
		
		UPDATE ofrece o JOIN centro c ON o.id_centro=c.id_centro JOIN estudio e ON o.id_estudio=e.id_estudio JOIN oferta f ON f.centro=c.nombre_centro AND f.estudio =e.nombre_estudio AND f.curso_academico=o.año SET o.plazas_ofertadas=f.plazas_ofertadas, o.plazas_matriculadas=f.plazas_matriculadas,o.plazas_solicitadas=f.plazas_solicitadas,o.indice_ocupacion=f.indice_ocupacion;


		
		UPDATE ofrece o JOIN centro c ON o.id_centro=c.id_centro JOIN estudio e ON o.id_estudio=e.id_estudio JOIN notas_de_corte n ON n.centro=c.nombre_centro AND n.estudio =e.nombre_estudio AND n.curso_academico=o.año SET o.nota_corte_definitiva_junio=n.nota_corte_definitiva_junio;
		
		UPDATE ofrece o JOIN centro c ON o.id_centro=c.id_centro JOIN estudio e ON o.id_estudio=e.id_estudio JOIN resultados r ON r.centro=c.nombre_centro AND r.estudio =e.nombre_estudio AND r.curso_academico=o.año SET o.alumnos_matriculados = r.alumnos_matriculados,o.alumnos_nuevo_ingreso = r.alumnos_nuevo_ingreso, o.alumnos_graduados = r.alumnos_graduados, o.tasa_exito = r.tasa_exito;
	"	
	
	
	crearTablaPais="create table if not exists pais(id_pais int NOT NULL AUTO_INCREMENT PRIMARY KEY, nombre_pais text not null);
			insert into pais(nombre_pais) select distinct pais_universidad_acuerdo from acuerdos;"
		
	crearTablaUniversidad="create table if not exists universidad(id_universidad int NOT NULL AUTO_INCREMENT PRIMARY KEY, nombre_universidad varchar(300) not null, id_pais integer REFERENCES pais(id_pais));
		insert into universidad(nombre_universidad,id_pais) select distinct universidad_acuerdo,id_pais from acuerdos JOIN pais on acuerdos.pais_universidad_acuerdo=pais.nombre_pais;
			
	"
	crearTablaAcuerdoMovilidad="	
		create table if not exists acuerdo_movilidad(id_acuerdo int NOT NULL AUTO_INCREMENT PRIMARY KEY,id_universidad integer not null, id_centro integer not null, año integer not null, in_out varchar(300),nombre_idioma_nivel_movilidad varchar(300), plazas_ofertadas_alumnos integer, plazas_asignadas_alumnos_out integer, FOREIGN KEY (id_universidad) REFERENCES universidad(id_universidad), FOREIGN KEY (id_centro) REFERENCES centro (id_centro));
		
	
	insert into acuerdo_movilidad(id_universidad,id_centro,año,in_out,nombre_idioma_nivel_movilidad,plazas_ofertadas_alumnos,plazas_asignadas_alumnos_out) select universidad.id_universidad, centro.id_centro, acuerdos.curso_academico, acuerdos.in_out,acuerdos.nombre_idioma_nivel_movilidad,acuerdos.plazas_ofertadas_alumnos,acuerdos.plazas_asignadas_alumnos_out from acuerdos JOIN universidad on acuerdos.universidad_acuerdo=universidad.nombre_universidad JOIN centro ON acuerdos.centro = centro.nombre_centro; "
	
	
	crearTablaAsignatura="create table if not exists asignatura(id_asignatura int NOT NULL AUTO_INCREMENT PRIMARY KEY, nombre_asignatura varchar(300) not null);	
		insert into asignatura(nombre_asignatura) select distinct asignatura from rendimiento_asignatura;"
	
	crearTablaTieneASignatura="create table if not exists tiene_asignatura(id_tiene_asignatura int NOT NULL AUTO_INCREMENT PRIMARY KEY,id_asignatura integer not null REFERENCES asignatura(id_asignatura), id_centro integer not null REFERENCES centro(id_centro), id_estudio integer not null REFERENCES estudio(id_estudio), año integer not null,tipo_asignatura varchar(300), clase_asignatura varchar(300),tasa_exito real,tasa_rendimiento real, tasa_evaluacion real,alumnos_evaluados integer,alumnos_superados integer,alumnos_presentados integer,media_convocatorias_consumidas real); 
	insert into tiene_asignatura(id_asignatura,id_centro, id_estudio, año,tipo_asignatura, clase_asignatura,alumnos_evaluados,alumnos_superados,alumnos_presentados) select asignatura.id_asignatura,centro.id_centro,estudio.id_estudio,rendimiento_asignatura.curso_academico,rendimiento_asignatura.tipo_asignatura, rendimiento_asignatura.clase_asignatura,rendimiento_asignatura.alumnos_evaluados,rendimiento_asignatura.alumnos_superados,rendimiento_asignatura.alumnos_presentados FROM asignatura,centro,estudio,ofrece,rendimiento_asignatura WHERE centro.nombre_centro=rendimiento_asignatura.centro AND estudio.nombre_estudio=rendimiento_asignatura.estudio AND centro.id_centro=ofrece.id_centro AND estudio.id_estudio=ofrece.id_estudio AND asignatura.nombre_asignatura=rendimiento_asignatura.asignatura;  "
	
	crearTablaTipoEgreso="
	create table if not exists tipo_egreso(id_tipo_egreso int NOT NULL AUTO_INCREMENT PRIMARY KEY, nombre_tipo_egreso text not null);
	insert into tipo_egreso(nombre_tipo_egreso) select distinct tipo_egreso from alumnos_egresados;
	"
	crearTablaEgresan="create table if not exists egresan(id_tiene_asignatura int NOT NULL AUTO_INCREMENT PRIMARY KEY,id_tipo_egreso integer not null REFERENCES tipo_egreso(id_tipo_egreso), id_estudio integer not null REFERENCES estudio(id_estudio), id_localidad integer not null REFERENCES localidad(id_localidad), año integer not null, sexo varchar(100), alumnos_graduados integer);
	
	
	insert into egresan(id_tipo_egreso,id_estudio,id_localidad,año,sexo,alumnos_graduados) select tipo_egreso.id_tipo_egreso,estudio.id_estudio,localidad.id_localidad,alumnos_egresados.curso_academico,alumnos_egresados.sexo,alumnos_egresados.alumnos_graduados FROM tipo_egreso,estudio,localidad,alumnos_egresados WHERE estudio.nombre_estudio=alumnos_egresados.estudio AND localidad.ciudad=alumnos_egresados.localidad AND tipo_egreso.nombre_tipo_egreso=alumnos_egresados.tipo_egreso;
	"
	
	borrarTablasAntiguas="drop table if exists acuerdos;
	drop table if exists alumnos_egresados;
	drop table if exists notas_de_corte;
	drop table if exists oferta;
	drop table if exists rendimiento_asignatura;
	drop table if exists resultados;"
	
	
	#if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e " use unizar;
	if mysql -u $USUARIO_BD -p$PASSWORD_USUARIO $NOMBRE_BD -h $MYSQL_HOST -e "
		$crearTablaLocalidad
		$crearTablaCentro
		$crearTablaEstudio
		$crearTablaOfrece
		$crearTablaPais
		$crearTablaUniversidad
		$crearTablaAcuerdoMovilidad
		$crearTablaAsignatura
		$crearTablaTieneASignatura
		$crearTablaTipoEgreso
		$crearTablaEgresan
		$borrarTablasAntiguas" &>/dev/null; then
		echo "Base de datos buena creada correctamente"
	else
		echo "No se ha podido crear la base buena"
	fi 

}


consultaE(){
	consultaE="
SELECT e.nombre_estudio, c.nombre_centro, l.ciudad, t.indice_ocupacion, t.año FROM (   SELECT o.id_estudio, o.id_centro, o.año, o.indice_ocupacion, c.id_localidad,      ROW_NUMBER() OVER (PARTITION BY c.id_localidad, o.año ORDER BY o.indice_ocupacion DESC) AS row_num    FROM ofrece o    JOIN centro c ON o.id_centro = c.id_centro    WHERE o.año = 2020 ) t  JOIN estudio e ON t.id_estudio = e.id_estudio JOIN centro c ON t.id_centro = c.id_centro JOIN localidad l ON t.id_localidad = l.id_localidad WHERE t.row_num <= 2;
"
	
	
	existe_usuario_mario=$(mysql -u $MYSQL_ROOT -h $MYSQL_HOST -s -N -e "select count(*) from mysql.user where user='$USUARIO_BD'" mysql)
	
	if mysql -u $MYSQL_ROOT -h localhost -e "use $NOMBRE_BD;";then 
	
		if [ $existe_usuario_mario -gt 0 ]; then
			mysql -u $USUARIO_BD -p$PASSWORD_USUARIO $NOMBRE_BD -h $MYSQL_HOST -e "$consultaE"
		else 
			echo "no existe el usuario mario"
		fi 
	else
		echo "no existe la base de datos $NOMBRE_BD"
	fi
}


consultaF(){


	consultaF="
		SELECT c.nombre_centro, u.nombre_universidad, am.plazas_asignadas_alumnos_out
		FROM centro c
		JOIN acuerdo_movilidad am ON c.id_centro = am.id_centro
		JOIN universidad u ON am.id_universidad = u.id_universidad
		WHERE am.año = 2020 AND am.plazas_asignadas_alumnos_out = (
		    SELECT MAX(am2.plazas_asignadas_alumnos_out)
		    FROM acuerdo_movilidad am2
		    WHERE am2.id_centro = am.id_centro AND am2.año = am.año
		);
		"
	existe_usuario_mario=$(mysql -u $MYSQL_ROOT -h $MYSQL_HOST -s -N -e "select count(*) from mysql.user where user='$USUARIO_BD'" mysql)
	if mysql -u $MYSQL_ROOT -h localhost -e "use $NOMBRE_BD;";then 
		
		if [ $existe_usuario_mario -gt 0 ]; then
			mysql -u $USUARIO_BD -p$PASSWORD_USUARIO $NOMBRE_BD -h $MYSQL_HOST -e "$consultaF"
		else 
			echo "no existe el usuario mario"
		fi
	
	else 
		echo "La base de datos $NOMBRE_DB no existe"
	fi

}


crearUsuarioProfesor(){

	if mysql -u $MYSQL_ROOT -h localhost -e "use $NOMBRE_BD;";then 
	
		if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "CREATE USER '$usuarioProfesor'@'localhost' IDENTIFIED BY '$passwordProfesor'"; then
			
			if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "GRANT ALL PRIVILEGES ON $NOMBRE_BD.* TO '$usuarioProfesor'@'localhost'";then
				echo "Usuario $usuarioProfesor creado correctamente con permisos sobre la base $NOMBRE_DB."
			else
				echo "No  se han podido otorgar permisos sobre la base de datos $NOMBRE_BD"
			fi
		else
		
			echo "No se ha podido crear el usuario $usuarioProfesor"
		fi
	else
		echo "no existe la base de datos $NOMBRE_BD,  no se ha creado el usuario $usuarioProfesor"
	fi
}


salirYBorrarBaseDeDatos(){

	borrarBaseDeDatos="drop database if exists unizar; "
	
	borrarUsuarios="drop user if exists 'mario'@'localhost';
		drop user if exists 'profesor'@'localhost';"
	
	if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "$borrarBaseDeDatos"; then
	
		echo "Base de datos borrada correctamente."
		
		if mysql -u $MYSQL_ROOT -h $MYSQL_HOST -e "$borrarUsuarios"; then
			echo "usuarios profesor y mario borrados correctamente"
			exit 0
		else 
			echo "no se han podido borrar los usuarios mario y profesor"
		fi	
	else
		echo "No se ha podido borrar la base de datos unizar"
	fi
}

while true
do
	echo " "
	echo "a. Descargar datos del repositorio"
	echo "b. crear base de datos y usuario"
	echo "c. crear base buena"
	echo "d. implementar trigger"
	echo "e. consulta SQL que devuelva los dos estudios de cada localidad con mayor indice de ocupacion en el 2021"
	echo "f. consulta SQL que devuelva la universidad que mas alumnos recibe de cada centro en el 2021"
	echo "g. crear vista"
	echo "h. crear usuario profesor"
	echo "s. Salir"
	echo "z. Salir y borrar usuarios y base de datos"

	
	read -p "Selecciona una opcion: " opcion
	 
 	if [ "$opcion" = "a" ];then
		descargar_datos
	
	elif [ "$opcion" = "b" ]; then
		crear_bd_y_usuario
		 
	elif [ "$opcion" = "c" ]; then
		crearBase_Buena
		
	elif [ "$opcion" = "d" ]; then
		echo "trigger"
		
	elif [ "$opcion" = "e" ]; then
		consultaE
		
	elif [ "$opcion" = "f" ]; then
		consultaF
		
	elif [ "$opcion" = "g" ]; then
		echo "Vista"
		
	elif [ "$opcion" = "h" ]; then
		crearUsuarioProfesor
		
	elif [ "$opcion" = "z" ]; then
		salirYBorrarBaseDeDatos
		
	elif [ "$opcion" = "s" ]; then
		exit 0

	fi
	
done


