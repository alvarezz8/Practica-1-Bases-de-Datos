#!/bin/bash
	

PGHOST="localhost"
PGDATABASE="postgres"
PGUSER="postgres"
NOMBRE_BD="unizar"
USUARIO_BD="mario"
PASSWORD_USUARIO="mariobd2"
usuarioProfesor="profesor"
passwordProfesor="profesor1234"

descargar_datos(){

	curl -o oferta2019.csv https://zaguan.unizar.es/record/87665/files/CSV.csv -o oferta2020.csv https://zaguan.unizar.es/record/96835/files/CSV.csv -o oferta2021.csv https://zaguan.unizar.es/record/108270/files/CSV.csv -o resultados2019.csv https://zaguan.unizar.es/record/95644/files/CSV.csv -o resultados2020.csv https://zaguan.unizar.es/record/107369/files/CSV.csv -o resultados2021.csv https://zaguan.unizar.es/record/118234/files/CSV.csv -o notasDeCorteDefinitivas2019.csv https://zaguan.unizar.es/record/87663/files/CSV.csv -o notasDeCorteDefinitivas2020.csv https://zaguan.unizar.es/record/98173/files/CSV.csv -o notasDeCorteDefinitivas2021.csv https://zaguan.unizar.es/record/109322/files/CSV.csv -o acuerdosMovilidad2019.csv https://zaguan.unizar.es/record/83980/files/CSV.csv -o acuerdosMovilidad2020.csv https://zaguan.unizar.es/record/95648/files/CSV.csv -o acuerdosMovilidad2021.csv https://zaguan.unizar.es/record/107373/files/CSV.csv -o alumnosEgresados2019.csv https://zaguan.unizar.es/record/95646/files/CSV.csv -o alumnosEgresados2020.csv https://zaguan.unizar.es/record/107371/files/CSV.csv -o alumnosEgresados2021.csv https://zaguan.unizar.es/record/118236/files/CSV.csv -o rendimientoAsignatura2019.csv https://zaguan.unizar.es/record/95645/files/CSV.csv -o rendimientoAsignatura2020.csv https://zaguan.unizar.es/record/107370/files/CSV.csv -o rendimientoAsignatura2021.csv https://zaguan.unizar.es/record/118235/files/CSV.csv &>/dev/null
	
	
	if [ $? -eq 0 ]; then
		sed -i '/Máster/d' rendimientoAsignatura2021.csv
		sed -i '/Doctorado/d' rendimientoAsignatura2021.csv
		sed -i '/renewable/d' rendimientoAsignatura2021.csv	
		sed -i '/Complementos/d' rendimientoAsignatura2021.csv
		
		echo "datos descargados correctamente "
	else
		echo "No se han podido descargar los ficheros"
	fi	
}	



crear_bd_y_usuario(){
	
	create_table_oferta="
		create table if not exists OFERTA(CURSO_ACADEMICO integer,ESTUDIO varchar(500),LOCALIDAD varchar(100), CENTRO varchar(300),TIPO_CENTRO varchar(100),TIPO_ESTUDIO varchar(100),PLAZAS_OFERTADAS integer,PLAZAS_MATRICULADAS integer,PLAZAS_SOLICITADAS integer,INDICE_OCUPACION real,FECHA_ACTUALIZACION date);"
		
	create_table_resultados="
		create table if not exists RESULTADOS(CURSO_ACADEMICO integer, CENTRO varchar(300), ESTUDIO varchar(300), TIPO_ESTUDIO varchar(300), ALUMNOS_MATRICULADOS integer, ALUMNOS_NUEVO_INGRESO integer, PLAZAS_OFERTADAS integer, ALUMNOS_GRADUADOS integer, ALUMNOS_ADAPTA_GRADO_MATRI integer, ALUMNOS_ADAPTA_GRADO_MATRI_NI integer, ALUMNOS_ADAPTA_GRADO_TITULADO integer, ALUMNOS_CON_RECONOCIMIENTO integer, ALUMNOS_MOVILIDAD_ENTRADA integer, ALUMNOS_MOVILIDAD_SALIDA integer, CREDITOS_MATRICULADOS real, CREDITOS_RECONOCIDOS real, DURACION_MEDIA_GRADUADOS real, TASA_EXITO real, TASA_RENDIMIENTO real, TASA_EFICIENCIA real, TASA_ABANDONO real, TASA_GRADUACION real, FECHA_ACTUALIZACION date);"
		
	create_table_acuerdos="
		CREATE TABLE if not exists ACUERDOS(CURSO_ACADEMICO integer, NOMBRE_PROGRAMA_MOVILIDAD varchar(300), NOMBRE_AREA_ESTUDIOS_MOV varchar(300), CENTRO varchar(300), IN_OUT varchar(100), NOMBRE_IDIOMA_NIVEL_MOVILIDAD varchar(300), PAIS_UNIVERSIDAD_ACUERDO varchar(300), UNIVERSIDAD_ACUERDO varchar(300), PLAZAS_OFERTADAS_ALUMNOS integer, PLAZAS_ASIGNADAS_ALUMNOS_OUT integer, FECHA_ACTUALIZACION date);"
		
	create_table_notasDeCorte="
		create table if not exists NOTAS_DE_CORTE(CURSO_ACADEMICO integer,ESTUDIO varchar(500),LOCALIDAD varchar(100), CENTRO varchar(300),PRELA_CONVO_NOTA_DEF real,NOTA_CORTE_DEFINITIVA_JUNIO real,NOTA_CORTE_DEFINITIVA_SEPTIEMBRE real,FECHA_ACTUALIZACION date);"
		
	create_table_alumnosEgresados="
		create table if not exists ALUMNOS_EGRESADOS(CURSO_ACADEMICO integer,LOCALIDAD varchar(300), ESTUDIO varchar(300),TIPO_ESTUDIO varchar(200),TIPO_EGRESO varchar(200), SEXO varchar(300),ALUMNOS_GRADUADOS integer, ALUMNOS_INTERRUMPEN_ESTUDIOS integer, ALUMNOS_INTERRUMPEN_EST_ANO1 integer,ALUMNOS_TRASLADAN_OTRA_UNIV integer, DURACION_MEDIA_GRADUADOS real, TASA_EFICIENCIA real, FECHA_ACTUALIZACION date);"
		
	create_table_rendimientoAsignatura="
		create table if not exists rendimiento_asignatura(CURSO_ACADEMICO integer,TIPO_ESTUDIO varchar(200), ESTUDIO varchar(300),LOCALIDAD varchar(300),CENTRO varchar(300),ASIGNATURA varchar(300),TIPO_ASIGNATURA varchar(300),CLASE_ASIGNATURA varchar(300),TASA_EXITO real,TASA_RENDIMIENTO real, TASA_EVALUACION real, ALUMNOS_EVALUADOS integer,ALUMNOS_SUPERADOS integer, ALUMNOS_PRESENTADOS integer, MEDIA_CONVOCATORIAS_CONSUMIDAS real, FECHA_ACTUALIZACION date);"
		
	importar_datos_oferta="
		COPY oferta(curso_academico, estudio, localidad, centro, tipo_centro, tipo_estudio, plazas_ofertadas, plazas_matriculadas, plazas_solicitadas, indice_ocupacion, fecha_actualizacion) FROM '/home/alumno/bd/oferta2019.csv' DELIMITER ';' CSV HEADER;
		COPY oferta(curso_academico, estudio, localidad, centro, tipo_centro, tipo_estudio, plazas_ofertadas, plazas_matriculadas, plazas_solicitadas, indice_ocupacion, fecha_actualizacion) FROM '/home/alumno/bd/oferta2020.csv' DELIMITER ';' CSV HEADER;
		COPY oferta(curso_academico, estudio, localidad, centro, tipo_centro, tipo_estudio, plazas_ofertadas, plazas_matriculadas, plazas_solicitadas, indice_ocupacion, fecha_actualizacion) FROM '/home/alumno/bd/oferta2021.csv' DELIMITER ';' CSV HEADER;"
		
	importar_datos_resultados="
		COPY resultados (CURSO_ACADEMICO, CENTRO, ESTUDIO, TIPO_ESTUDIO, ALUMNOS_MATRICULADOS, ALUMNOS_NUEVO_INGRESO, PLAZAS_OFERTADAS, ALUMNOS_GRADUADOS, ALUMNOS_ADAPTA_GRADO_MATRI, ALUMNOS_ADAPTA_GRADO_MATRI_NI, ALUMNOS_ADAPTA_GRADO_TITULADO,ALUMNOS_CON_RECONOCIMIENTO, ALUMNOS_MOVILIDAD_ENTRADA, ALUMNOS_MOVILIDAD_SALIDA, CREDITOS_MATRICULADOS, CREDITOS_RECONOCIDOS, DURACION_MEDIA_GRADUADOS, TASA_EXITO, TASA_RENDIMIENTO, TASA_EFICIENCIA, TASA_ABANDONO, TASA_GRADUACION, FECHA_ACTUALIZACION) from '/home/alumno/bd/resultados2019.csv' WITH DELIMITER ';' CSV HEADER;
		
		COPY resultados (CURSO_ACADEMICO, CENTRO, ESTUDIO, TIPO_ESTUDIO, ALUMNOS_MATRICULADOS, ALUMNOS_NUEVO_INGRESO, PLAZAS_OFERTADAS, ALUMNOS_GRADUADOS, ALUMNOS_ADAPTA_GRADO_MATRI, ALUMNOS_ADAPTA_GRADO_MATRI_NI, ALUMNOS_ADAPTA_GRADO_TITULADO,ALUMNOS_CON_RECONOCIMIENTO, ALUMNOS_MOVILIDAD_ENTRADA, ALUMNOS_MOVILIDAD_SALIDA, CREDITOS_MATRICULADOS, CREDITOS_RECONOCIDOS, DURACION_MEDIA_GRADUADOS, TASA_EXITO, TASA_RENDIMIENTO, TASA_EFICIENCIA, TASA_ABANDONO, TASA_GRADUACION, FECHA_ACTUALIZACION) from '/home/alumno/bd/resultados2020.csv' WITH DELIMITER ';' CSV HEADER;
		
		COPY resultados (CURSO_ACADEMICO, CENTRO, ESTUDIO, TIPO_ESTUDIO, ALUMNOS_MATRICULADOS, ALUMNOS_NUEVO_INGRESO, PLAZAS_OFERTADAS, ALUMNOS_GRADUADOS, ALUMNOS_ADAPTA_GRADO_MATRI, ALUMNOS_ADAPTA_GRADO_MATRI_NI, ALUMNOS_ADAPTA_GRADO_TITULADO,ALUMNOS_CON_RECONOCIMIENTO, ALUMNOS_MOVILIDAD_ENTRADA, ALUMNOS_MOVILIDAD_SALIDA, CREDITOS_MATRICULADOS, CREDITOS_RECONOCIDOS, DURACION_MEDIA_GRADUADOS, TASA_EXITO, TASA_RENDIMIENTO, TASA_EFICIENCIA, TASA_ABANDONO, TASA_GRADUACION, FECHA_ACTUALIZACION) from '/home/alumno/bd/resultados2021.csv' WITH DELIMITER ';' CSV HEADER;"
		
		
	importar_datos_acuerdos="
		COPY acuerdos(CURSO_ACADEMICO,NOMBRE_PROGRAMA_MOVILIDAD,NOMBRE_AREA_ESTUDIOS_MOV, CENTRO, IN_OUT, NOMBRE_IDIOMA_NIVEL_MOVILIDAD, PAIS_UNIVERSIDAD_ACUERDO, UNIVERSIDAD_ACUERDO, PLAZAS_OFERTADAS_ALUMNOS, PLAZAS_ASIGNADAS_ALUMNOS_OUT, FECHA_ACTUALIZACION) from '/home/alumno/bd/acuerdosMovilidad2019.csv' WITH DELIMITER ';' CSV HEADER;	
		COPY acuerdos(CURSO_ACADEMICO,NOMBRE_PROGRAMA_MOVILIDAD,NOMBRE_AREA_ESTUDIOS_MOV, CENTRO, IN_OUT, NOMBRE_IDIOMA_NIVEL_MOVILIDAD, PAIS_UNIVERSIDAD_ACUERDO, UNIVERSIDAD_ACUERDO, PLAZAS_OFERTADAS_ALUMNOS, PLAZAS_ASIGNADAS_ALUMNOS_OUT, FECHA_ACTUALIZACION) from '/home/alumno/bd/acuerdosMovilidad2020.csv' WITH DELIMITER ';' CSV HEADER;	
		COPY acuerdos(CURSO_ACADEMICO,NOMBRE_PROGRAMA_MOVILIDAD,NOMBRE_AREA_ESTUDIOS_MOV, CENTRO, IN_OUT, NOMBRE_IDIOMA_NIVEL_MOVILIDAD, PAIS_UNIVERSIDAD_ACUERDO, UNIVERSIDAD_ACUERDO, PLAZAS_OFERTADAS_ALUMNOS, PLAZAS_ASIGNADAS_ALUMNOS_OUT, FECHA_ACTUALIZACION) from '/home/alumno/bd/acuerdosMovilidad2021.csv' WITH DELIMITER ';' CSV HEADER;"
		
	importar_datos_notas_de_corte="
		COPY NOTAS_DE_CORTE(curso_academico, estudio, localidad, centro, prela_convo_nota_def, nota_corte_definitiva_junio,nota_corte_definitiva_septiembre,fecha_actualizacion) from '/home/alumno/bd/notasDeCorteDefinitivas2019.csv' WITH DELIMITER ';' CSV HEADER;
		COPY NOTAS_DE_CORTE(curso_academico, estudio, localidad, centro, prela_convo_nota_def, nota_corte_definitiva_junio,nota_corte_definitiva_septiembre,fecha_actualizacion) from '/home/alumno/bd/notasDeCorteDefinitivas2020.csv' WITH DELIMITER ';' CSV HEADER;
		COPY NOTAS_DE_CORTE(curso_academico, estudio, localidad, centro, prela_convo_nota_def, nota_corte_definitiva_junio,nota_corte_definitiva_septiembre,fecha_actualizacion) from '/home/alumno/bd/notasDeCorteDefinitivas2021.csv' WITH DELIMITER ';' CSV HEADER;"
		
	importar_datos_alumnos_egresados="
		COPY alumnos_egresados(CURSO_ACADEMICO,LOCALIDAD, ESTUDIO, TIPO_ESTUDIO, TIPO_EGRESO, SEXO, ALUMNOS_GRADUADOS, ALUMNOS_INTERRUMPEN_ESTUDIOS, ALUMNOS_INTERRUMPEN_EST_ANO1, ALUMNOS_TRASLADAN_OTRA_UNIV, DURACION_MEDIA_GRADUADOS, TASA_EFICIENCIA, FECHA_ACTUALIZACION) from '/home/alumno/bd/alumnosEgresados2019.csv' WITH DELIMITER ';' CSV HEADER;
		COPY alumnos_egresados(CURSO_ACADEMICO,LOCALIDAD, ESTUDIO, TIPO_ESTUDIO, TIPO_EGRESO, SEXO, ALUMNOS_GRADUADOS, ALUMNOS_INTERRUMPEN_ESTUDIOS, ALUMNOS_INTERRUMPEN_EST_ANO1, ALUMNOS_TRASLADAN_OTRA_UNIV, DURACION_MEDIA_GRADUADOS, TASA_EFICIENCIA, FECHA_ACTUALIZACION) from '/home/alumno/bd/alumnosEgresados2020.csv' WITH DELIMITER ';' CSV HEADER;
		COPY alumnos_egresados(CURSO_ACADEMICO,LOCALIDAD, ESTUDIO, TIPO_ESTUDIO, TIPO_EGRESO, SEXO, ALUMNOS_GRADUADOS, ALUMNOS_INTERRUMPEN_ESTUDIOS, ALUMNOS_INTERRUMPEN_EST_ANO1, ALUMNOS_TRASLADAN_OTRA_UNIV, DURACION_MEDIA_GRADUADOS, TASA_EFICIENCIA, FECHA_ACTUALIZACION) from '/home/alumno/bd/alumnosEgresados2021.csv' WITH DELIMITER ';' CSV HEADER;"
		
	importar_datos_rendimiento_asignatura="
		COPY rendimiento_asignatura(curso_academico,tipo_estudio, estudio, localidad, centro, asignatura, tipo_asignatura, clase_asignatura, tasa_exito, tasa_rendimiento, tasa_evaluacion, alumnos_evaluados, alumnos_superados, alumnos_presentados, media_convocatorias_consumidas, fecha_actualizacion) from '/home/alumno/bd/rendimientoAsignatura2019.csv' WITH DELIMITER ';' CSV HEADER;
		COPY rendimiento_asignatura(curso_academico,tipo_estudio, estudio, localidad, centro, asignatura, tipo_asignatura, clase_asignatura, tasa_exito, tasa_rendimiento, tasa_evaluacion, alumnos_evaluados, alumnos_superados, alumnos_presentados, media_convocatorias_consumidas, fecha_actualizacion) from '/home/alumno/bd/rendimientoAsignatura2020.csv' WITH DELIMITER ';' CSV HEADER;
		COPY rendimiento_asignatura(curso_academico,tipo_estudio, estudio, localidad, centro, asignatura, tipo_asignatura, clase_asignatura, tasa_exito, tasa_rendimiento, tasa_evaluacion, alumnos_evaluados, alumnos_superados, alumnos_presentados, media_convocatorias_consumidas, fecha_actualizacion) from '/home/alumno/bd/rendimientoAsignatura2021.csv' WITH DELIMITER ';' CSV HEADER;"
		
	actualizar_tabla_acuerdos="
		update acuerdos SET nombre_area_estudios_mov = REGEXP_REPLACE(nombre_area_estudios_mov, '[^a-zA-Z]+', '') WHERE nombre_area_estudios_mov ~ '[^a-zA-Z]+';"
		
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
		
	
	#creamos base de datos:
	PGPASSWORD="$postgres" 
	if createdb -h $PGHOST -U $PGUSER $NOMBRE_BD; then
		echo "Base de datos "$NOMBRE_BD" creada correctamente"
		if psql -h $PGHOST -U "$PGUSER" -d "$NOMBRE_BD" -c "
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
	
	
		
	#creamos usuario;

	if psql -h $PGHOST -d $PGDATABASE -U $PGUSER -c "CREATE USER $USUARIO_BD WITH PASSWORD '$PASSWORD_USUARIO'; 
							  GRANT ALL PRIVILEGES ON DATABASE $NOMBRE_BD TO $USUARIO_BD;
							  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $USUARIO_BD" &>/dev/null; then
		echo "Usuario "$USUARIO_BD" creado correctamente"
	else
		echo "Error al crear el usuario "$USUARIO_BD""
	fi

}



crearBase_Buena(){

	crearTablaLocalidad="
		create table if not exists localidad(id_localidad serial primary key, ciudad text not null);
		insert into localidad(ciudad) select distinct localidad from oferta;
		"
	crearTablaCentro="
		create table if not exists centro(id_centro serial PRIMARY KEY, nombre_centro TEXT NOT NULL, id_localidad integer REFERENCES localidad(id_localidad));
		insert into centro(nombre_centro, id_localidad) SELECT DISTINCT centro, id_localidad FROM oferta JOIN localidad on oferta.localidad=localidad.ciudad;
	"
	
	crearTablaEstudio="
		create table if not exists estudio(id_estudio serial PRIMARY KEY, nombre_estudio TEXT NOT NULL);
		INSERT INTO estudio (nombre_estudio) SELECT DISTINCT estudio from oferta;
		"

	#alter table if exists ofrece drop constraint ofrece_pkey;
	crearTablaOfrece="
		create table if not exists ofrece(id_estudio INTEGER NOT NULL, id_centro INTEGER NOT NULL, año INTEGER NOT NULL,PLAZAS_OFERTADAS integer,PLAZAS_MATRICULADAS integer,PLAZAS_SOLICITADAS integer,INDICE_OCUPACION real,NOTA_CORTE_DEFINITIVA_JUNIO real,NOTA_CORTE_DEFINITIVA_SEPTIEMBRE real,ALUMNOS_MATRICULADOS integer, ALUMNOS_NUEVO_INGRESO integer,ALUMNOS_GRADUADOS integer, CREDITOS_MATRICULADOS real, CREDITOS_RECONOCIDOS real, DURACION_MEDIA_GRADUADOS real, TASA_EXITO real, TASA_RENDIMIENTO real, TASA_EFICIENCIA real, TASA_ABANDONO real, TASA_GRADUACION real, PRIMARY KEY (id_estudio, id_centro), FOREIGN KEY (id_estudio) REFERENCES estudio (id_estudio), FOREIGN KEY (id_centro) REFERENCES centro (id_centro));
		
		alter table ofrece drop constraint if exists ofrece_pkey;
		
		insert into ofrece(id_estudio, id_centro, año) select distinct estudio.id_estudio, centro.id_centro, oferta.curso_academico from oferta join estudio on oferta.estudio = estudio.nombre_estudio join centro on oferta.centro = centro.nombre_centro;
		

		UPDATE ofrece 
		SET plazas_ofertadas = oferta.plazas_ofertadas, 
  		  plazas_matriculadas = oferta.plazas_matriculadas, 
   		  plazas_solicitadas = oferta.plazas_solicitadas, 
	          indice_ocupacion = oferta.indice_ocupacion 
		FROM oferta 
		JOIN estudio ON estudio.nombre_estudio = oferta.estudio 
		JOIN centro ON centro.nombre_centro = oferta.centro 
		WHERE ofrece.id_estudio = estudio.id_estudio 
		  AND ofrece.id_centro = centro.id_centro 
		  AND ofrece.año = oferta.curso_academico;
		
		
		UPDATE ofrece
		SET nota_corte_definitiva_junio = notas_de_corte.nota_corte_definitiva_junio, 
		    nota_corte_definitiva_septiembre = notas_de_corte.nota_corte_definitiva_septiembre
		FROM notas_de_corte
		JOIN estudio ON estudio.nombre_estudio = notas_de_corte.estudio
		JOIN centro ON centro.nombre_centro = notas_de_corte.centro
		WHERE ofrece.id_estudio = estudio.id_estudio 
		    AND ofrece.id_centro = centro.id_centro 
		    AND ofrece.año = notas_de_corte.curso_academico;

		
		UPDATE ofrece 
		SET alumnos_matriculados = resultados.alumnos_matriculados, 
		    alumnos_nuevo_ingreso = resultados.alumnos_nuevo_ingreso, 
		    alumnos_graduados = resultados.alumnos_graduados, 
		    creditos_matriculados = resultados.creditos_matriculados, 
		    creditos_reconocidos = resultados.creditos_reconocidos, 
		    duracion_media_graduados = resultados.duracion_media_graduados, 
		    tasa_exito = resultados.tasa_exito, 
		    tasa_rendimiento = resultados.tasa_rendimiento, 
		    tasa_eficiencia = resultados.tasa_eficiencia, 
		    tasa_abandono = resultados.tasa_abandono, 
		    tasa_graduacion = resultados.tasa_graduacion 
		FROM resultados 
		JOIN estudio ON resultados.estudio = estudio.nombre_estudio 
		JOIN centro ON resultados.centro = centro.nombre_centro 
		WHERE ofrece.id_estudio = estudio.id_estudio 
		    AND ofrece.id_centro = centro.id_centro 
		    AND ofrece.año = resultados.curso_academico; "
		
	
	crearTablaPais="create table if not exists pais(id_pais serial primary key, nombre_pais text not null);
			insert into pais(nombre_pais) select distinct pais_universidad_acuerdo from acuerdos;"
		
	crearTablaUniversidad="create table if not exists universidad(id_universidad serial primary key, nombre_universidad varchar(300) not null, id_pais integer REFERENCES pais(id_pais));
		insert into universidad(nombre_universidad,id_pais) select distinct universidad_acuerdo,id_pais from acuerdos JOIN pais on acuerdos.pais_universidad_acuerdo=pais.nombre_pais;
			
	"
	#update universidad set universidad = regexp_replace(universidad, '\s*\([^)]*\)','','g');
	
	
	crearTablaAcuerdoMovilidad="	
		create table if not exists acuerdo_movilidad(id_universidad integer not null, id_centro integer not null, año integer not null, in_out varchar(300),nombre_idioma_nivel_movilidad varchar(300), plazas_ofertadas_alumnos integer, plazas_asignadas_alumnos_out integer, PRIMARY KEY (id_universidad, id_centro,año), FOREIGN KEY (id_universidad) REFERENCES universidad(id_universidad), FOREIGN KEY (id_centro) REFERENCES centro (id_centro));
		
		alter table acuerdo_movilidad drop constraint if exists acuerdo_movilidad_pkey;
	
	insert into acuerdo_movilidad(id_universidad,id_centro,año,in_out,nombre_idioma_nivel_movilidad,plazas_ofertadas_alumnos,plazas_asignadas_alumnos_out) select universidad.id_universidad, centro.id_centro, acuerdos.curso_academico, acuerdos.in_out,acuerdos.nombre_idioma_nivel_movilidad,acuerdos.plazas_ofertadas_alumnos,acuerdos.plazas_asignadas_alumnos_out from acuerdos JOIN universidad on acuerdos.universidad_acuerdo=universidad.nombre_universidad JOIN centro ON acuerdos.centro = centro.nombre_centro;
"
	
		
	crearTablaAsignatura="create table if not exists asignatura(id_asignatura serial primary key, nombre_asignatura varchar(300) not null);	
		insert into asignatura(nombre_asignatura) select distinct asignatura from rendimiento_asignatura;"
	
	crearTablaTieneASignatura="create table if not exists tiene_asignatura(id_asignatura integer not null REFERENCES asignatura(id_asignatura), id_centro integer not null REFERENCES centro(id_centro), id_estudio integer not null REFERENCES estudio(id_estudio), año integer not null,tipo_asignatura varchar(300), clase_asignatura varchar(300),tasa_exito real,tasa_rendimiento real, tasa_evaluacion real,alumnos_evaluados integer,alumnos_superados integer,alumnos_presentados integer,media_convocatorias_consumidas real,PRIMARY KEY(id_asignatura,id_centro,id_estudio,año)); 
			
	alter table tiene_asignatura drop constraint if exists tiene_asignatura_pkey; 
	insert into tiene_asignatura(id_asignatura,id_centro, id_estudio, año,tipo_asignatura, clase_asignatura,tasa_exito,tasa_rendimiento,tasa_evaluacion,alumnos_evaluados,alumnos_superados,alumnos_presentados,media_convocatorias_consumidas) select asignatura.id_asignatura,centro.id_centro,estudio.id_estudio,rendimiento_asignatura.curso_academico,rendimiento_asignatura.tipo_asignatura, rendimiento_asignatura.clase_asignatura,rendimiento_asignatura.tasa_exito,rendimiento_asignatura.tasa_rendimiento,rendimiento_asignatura.tasa_evaluacion,rendimiento_asignatura.alumnos_evaluados,rendimiento_asignatura.alumnos_superados,rendimiento_asignatura.alumnos_presentados,rendimiento_asignatura.media_convocatorias_consumidas FROM asignatura,centro,estudio,ofrece,rendimiento_asignatura WHERE centro.nombre_centro=rendimiento_asignatura.centro AND estudio.nombre_estudio=rendimiento_asignatura.estudio AND centro.id_centro=ofrece.id_centro AND estudio.id_estudio=ofrece.id_estudio AND asignatura.nombre_asignatura=rendimiento_asignatura.asignatura;  
	"
	
	crearTablaTipoEgreso="
	create table if not exists tipo_egreso(id_tipo_egreso serial primary key, nombre_tipo_egreso text not null);
	insert into tipo_egreso(nombre_tipo_egreso) select distinct tipo_egreso from alumnos_egresados;
	"
	crearTablaEgresan="create table if not exists egresan(id_tipo_egreso integer not null REFERENCES tipo_egreso(id_tipo_egreso), id_estudio integer not null REFERENCES estudio(id_estudio), id_localidad integer not null REFERENCES localidad(id_localidad), año integer not null, sexo varchar(100), alumnos_graduados integer, PRIMARY KEY(id_tipo_egreso,id_estudio,id_localidad,año));
	
	alter table egresan drop constraint if exists egresan_pkey;
	
	insert into egresan(id_tipo_egreso,id_estudio,id_localidad,año,sexo,alumnos_graduados) select tipo_egreso.id_tipo_egreso,estudio.id_estudio,localidad.id_localidad,alumnos_egresados.curso_academico,alumnos_egresados.sexo,alumnos_egresados.alumnos_graduados FROM tipo_egreso,estudio,localidad,alumnos_egresados WHERE estudio.nombre_estudio=alumnos_egresados.estudio AND localidad.ciudad=alumnos_egresados.localidad AND tipo_egreso.nombre_tipo_egreso=alumnos_egresados.tipo_egreso;
	"
	
	borrarTablasAntiguas="drop table if exists acuerdos;
	drop table if exists alumnos_egresados;
	drop table if exists notas_de_corte;
	drop table if exists oferta;
	drop table if exists rendimiento_asignatura;
	drop table if exists resultados;"
	
	if psql -h $PGHOST -U "$PGUSER" -lqt | cut -d "|" -f 1 | grep -w "$NOMBRE_BD" &>/dev/null; then

		psql -h $PGHOST -U "$PGUSER" -d "$NOMBRE_BD" -c "
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
			$borrarTablasAntiguas
		" &>/dev/null
		
		if [ $? -eq 0 ]; then
			echo "Base de datos buena creada correctamente."
		else
			echo "No se ha podido crear la base de datos buena"
		fi
	
	else 	
		echo "la base de datos no existe"
	fi
	

}


consultaE(){
	consultaE="
		SELECT e.nombre_estudio, c.nombre_centro, l.ciudad, t.indice_ocupacion, t.año
		FROM (
		  SELECT o.id_estudio, o.id_centro, o.año, o.indice_ocupacion, c.id_localidad, 
		    ROW_NUMBER() OVER (PARTITION BY c.id_localidad, o.año ORDER BY o.indice_ocupacion DESC) AS row_num 
		  FROM ofrece o 
		  JOIN centro c ON o.id_centro = c.id_centro 
		  WHERE o.año = 2021
		) t 
		JOIN estudio e ON t.id_estudio = e.id_estudio
		JOIN centro c ON t.id_centro = c.id_centro
		JOIN localidad l ON t.id_localidad = l.id_localidad
		WHERE t.row_num <= 2;"
	
	if psql -h $PGHOST -U "$PGUSER" -lqt | cut -d "|" -f 1 | grep -w "$NOMBRE_BD" &>/dev/null; then

		psql -h $PGHOST -U "$PGUSER" -d "$NOMBRE_BD" -c "$consultaE"
		#psql -h $PGHOST -U "$USUARIO_BD" -d "$NOMBRE_BD" -c "$consultaE"

	else 	
		echo "la base de datos no existe"
	fi
}


consultaF(){


	consultaF="
		SELECT DISTINCT ON (ac.id_centro) c.nombre_centro, u.nombre_universidad, ac.plazas_asignadas_alumnos_out
		FROM acuerdo_movilidad ac
		JOIN centro c ON ac.id_centro = c.id_centro
		JOIN universidad u ON u.id_universidad = ac.id_universidad
		WHERE ac.año = 2021
		ORDER BY ac.id_centro,ac.plazas_asignadas_alumnos_out DESC;"

	if psql -h $PGHOST -U "$PGUSER" -lqt | cut -d "|" -f 1 | grep -w "$NOMBRE_BD" &>/dev/null; then

		psql -h $PGHOST -U "$PGUSER" -d "$NOMBRE_BD" -c "
			$consultaF
		"
	else 	
		echo "la base de datos no existe"
	fi

}


crearUsuarioProfesor(){

	psql -h $PGHOST -d $PGDATABASE -U $PGUSER -c "CREATE USER $usuarioProfesor WITH PASSWORD '$passwordProfesor';"
	psql -h $PGHOST -d $PGDATABASE -U $PGUSER -c "GRANT ALL PRIVILEGES ON DATABASE $NOMBRE_BD TO $usuarioProfesor; "
							

	if [ $? -eq 0 ]; then
		echo "Usuario profesor creado correctamente."
	else
		echo "No se ha podido crear el usuario profesor"
	fi
}


salirYBorrarBaseDeDatos(){

	borrarBaseDeDatos="drop database if exists unizar; 
	"
	borrarUsuarios="drop user if exists mario;
			drop user if exists profesor;"
	
	if psql -h $PGHOST -U "$PGUSER" -c " $borrarBaseDeDatos " &>/dev/null; then
		echo "Base de datos borrada correctamente"
	else 	
		echo "la base de datos no se ha podido borrar"
	fi
	
	if psql -h $PGHOST -U "$PGUSER" -c " $borrarUsuarios " &>/dev/null; then
		echo "Usuarios profesor y mario borrados correctamente"
		exit 0
	else 	
		echo "No se han podido borrar los usuarios profesor y mario"
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
	echo " "
	 
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




