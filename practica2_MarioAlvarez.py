#Practica 2 Bases de datos 2 
#Mario Alvarez Gracia  -  780799

from sqlalchemy import create_engine, MetaData, inspect
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from datetime import datetime

# Crear conexión a la base de datos
engine = create_engine('mysql+pymysql://root:root@localhost/sakila')
Session = sessionmaker(bind=engine)
Base = declarative_base()
session = Session()


# Definir la estructura de la tabla Country
class Country(Base):
	__tablename__ = 'country'
	country_id = Column(Integer, primary_key=True, autoincrement=True)
	country = Column(String(50), nullable=False)
	last_update = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

# Definir la estructura de la tabla City
class City(Base):
    	__tablename__ = 'city'
    	city_id = Column(Integer, primary_key=True, autoincrement=True)
    	city = Column(String(50), nullable=False)
    	country_id = Column(Integer, ForeignKey('country.country_id'), nullable=False)
    	last_update = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Usuarios(Base):
	__tablename__ = 'usuarios'
	id = Column(Integer, primary_key=True, autoincrement=True)
	name = Column(String(50))
	age = Column(Integer)
	email = Column(String(50), unique=True)


# Función para crear un país
def crear_pais():
	nombre = input("Introduce el nombre del País: ")
	pais = Country(country=nombre)
	pais = session.query(Country).filter_by(country=nombre).first() 
	if pais: #si existe el pais, no lo crea
		print(f"Error, el Pais '{nombre}' ya existe")
	else:
		session.add(pais)
		session.commit()
		print(f"País '{nombre}' creado con éxito.")

# Función para listar todos los países
def listar_paises():
    	paises = session.query(Country).all() #hacemos una consulta a l atabla Country, devuelve una lista con todos los registros de la tabla Country
    	print("Lista de paises: ")
    	for pais in paises:
   	    print(f"{pais.country_id}: {pais.country} - {pais.last_update}")


# Función para eliminar un país
def eliminar_pais():
	id_pais = input("Introduce el id del País que quieres eliminar: ")
	pais = session.query(Country).filter_by(country_id=id_pais).first() #consulta para obtener la primera instancia que cumpla con la condicion especificada en el filtro (filter_by), que es el id que hemos introducido
	if pais: #si existe el pais
		session.delete(pais)
		session.commit()
		print(f"País con ID {id_pais} eliminado con éxito.")
	else:
		print(f"No se encontró el país con ID {id_pais}.")


# Función para crear una ciudad
def crear_ciudad():
	paises = session.query(Country).all() #hacemos una consulta para listar los paises, los almacenamos en "paises"
	nombre_ciudad = input("Introduce el nombre de la ciudad: ")
	nombre_pais = input("Introduce el pais al que pertenece la ciudad: ")
	pais = None
	for p in paises:  #bucle para cada registro de la tabla Country
		if p.country == nombre_pais: #comparamos el atributo "country" de cada registro con el nombre del pais que hemos introducido, si esta, se guarda en la variable pais y sale del bucle
			pais = p
			break
	if pais is not None: #si existe el pais, se añade la ciudad y se le asocia el id correspondiente del pais
		ciudad = City(city=nombre_ciudad, country_id=pais.country_id)
		session.add(ciudad)
		session.commit()
		print(f"La ciudad '{nombre_ciudad}' ha sido creada con exito y se ha asociado al pais {nombre_pais} con id {pais.country_id}")
	else:
		print(f"No existe el pais {nombre_pais}")

# Función para listar todas las ciudades

def listar_ciudades():
	ciudades = session.query(City).all()
	print("Lista de ciudades: ")
	for ciudad in ciudades:
		print(f"{ciudad.city_id}: {ciudad.city} - Pais: {ciudad.country_id}")


# Función para eliminar una ciudad
def eliminar_ciudad():
	id_ciudad = input("Introduce el id de la ciudad que quieras eliminar: ")
	ciudad = session.query(City).filter_by(city_id=id_ciudad).first()
	if ciudad:
		session.delete(ciudad)
		session.commit()
		print(f"Ciudad con ID {id_ciudad} eliminada con éxito.")
	else:
		print(f"No se encontró la ciudad con ID {id_ciudad}.")


def crear_tabla_usuarios():
	inspector = inspect(engine)
	if 'usuarios' in inspector.get_table_names(): #comprobamos si existe la tabla usuarios
		print("La tabla usuarios ya existe")
	else:
		try:
			Base.metadata.create_all(engine, tables=[Usuarios.__table__])
			print("tabla usuarios creada correctamente")
		except exc.SQLAlchemyerror as e:
			print("error al crear la tabla usuarios")
	

def mostrar_estructura_tabla_usuarios():
	inspector = inspect(engine)
	
	if 'usuarios' in inspector.get_table_names(): #comprobamos si existe la tabla usuarios
		print("Estructura de la tabla usuarios: ")

		for column in inspector.get_columns('usuarios'):
			print(column['name'], column['type'])
	else:
		print("La tabla usuarios no existe")
	

def borrar_tabla_usuarios():
	inspector = inspect(engine)
	if 'usuarios' in inspector.get_table_names(): #comprobamos si existe la tabla usuarios
		try:
			Base.metadata.tables['usuarios'].drop(engine)
			print("tabla usuarios borrada correctamente")
		except exc.SQLAlchemyerror as e:
			print("error al borrar la tabla usuarios")
	else:
		print("La tabla usuarios no existe")
	
def salir():
	session.close()
	exit()

if __name__ == "__main__":
    
    while True:
        print("Menú principal:")
        print("1. Crear país")
        print("2. Listar países")
        print("3. Eliminar país")
        print("4. Crear ciudad")
        print("5. Listar ciudades")
        print("6. Eliminar ciudad")
        print("7. Crear tabla usuarios")
        print("8. Borrar tabla usuarios")
        print("9. Mostrar estructura tabla")
        print("0. Salir")

        opcion = input("Seleccione una opción: ")

        if opcion == "1":
            crear_pais()
        elif opcion == "2":
            listar_paises()
        elif opcion == "3":
            eliminar_pais()
        elif opcion == "4":
            crear_ciudad()
        elif opcion == "5":
            listar_ciudades()
        elif opcion == "6":
            eliminar_ciudad()
        elif opcion == "7":
            crear_tabla_usuarios()
        elif opcion == "8":
            borrar_tabla_usuarios()
        elif opcion == "9":
            mostrar_estructura_tabla_usuarios()
        elif opcion == "0":
            salir()
        else:
            print("Opción incorrecta. Seleccione una opción válida.")

