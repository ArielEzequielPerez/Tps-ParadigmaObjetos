class Cancion{
	const property nombreDeLaCancion
	const property duracion
	const property letra	
		
	method cancionDuraMasDe(segundos) = duracion >= segundos
	method esUnaCancionCorta() = not self.cancionDuraMasDe(180)
	method tamanioDeLaLetra() = letra.size()
		
	
	method existePalabra(palabra){
		const unaPalabra = palabra.toLowerCase()
		return letra.toLowerCase().contains(unaPalabra)
		}
}

class Album{
	const property nombreDelAlbum
	const property canciones
	const property fechaLanzamiento
	var property cantidadALaVenta
	var property cantidadVendido
	
	method porcentajeDeVentas() = (cantidadVendido*100)/cantidadALaVenta > 75
	
	method todasSonCortas() = canciones.all({unaCancion => unaCancion.esUnaCancionCorta()})
	
	method devolverCancion(palabra) = canciones.filter({unaCancion => unaCancion.existePalabra(palabra)})
	
	method duracionCanciones() = (canciones.sum({unaCancion => unaCancion.duracion()}))
	
	method cancionMasLarga() = canciones.max({unaCancion =>  unaCancion.tamanioDeLaLetra()})
}

class Musico{
	var property nombre
	const property albumes
	var property cantaEnGrupo
	const habilidad 
	
	method esMinimalista() = albumes.all({unAlbum => unAlbum.todasSonCortas()})
	
	method contienePalabra(unaPalabra) = albumes.flatMap({unAlbum => unAlbum.devolverCancion(unaPalabra)})
			
	method duracionDeObra() = albumes.sum({unAlbum => unAlbum.duracionCanciones()})
	 	
	method laPego() = albumes.all({unAlbum => unAlbum.porcentajeDeVentas()})
}

class DeGrupo inherits Musico{
	const porTocarEnGrupo
	method habilidad() = if (cantaEnGrupo) habilidad + porTocarEnGrupo  else habilidad
	
    method interpretaBien(cancion) = cancion.cancionDuraMasDe(300)
    
    method cobra(presentacion) = if (cantaEnGrupo) 50 else 100
}
class VocalistaPopular inherits Musico{
    var palabraClave
     
    method habilidad() = if (cantaEnGrupo) habilidad - 20 else habilidad
	
	method interpretaBien(cancion) = cancion.existePalabra(palabraClave)
    
    method cobra(presentacion) = if (presentacion.esConcurrido()) 500 else 400
}


object luisAlberto inherits Musico(habilidad = 8,albumes = [paraLosArboles, justCrisantemo], cantaEnGrupo = false){
	var property guitarra = fender
	const fecha = new Date(day = 30, month = 11, year = 2020)
		
	method habilidad() = (habilidad * guitarra.valor()).min(100)
	
	method interpretaBien(cancion) = true
    
    method cobra(presentacion) = if (presentacion.esAntesDe(fecha)) 1000 else 1200
}
class Presentaciones{
	var property fechaPresentacion
	const property lugar 
	const property artistas
	
	method esAntesDe(unaFecha) = unaFecha >= fechaPresentacion
	 	
	method esConcurrido() = lugar.concurrido(fechaPresentacion)
	
	method agregarArtista(artista)= artistas.add(artista)
	
	method costo() = artistas.sum({artista => artista.cobra(self)})
}

class Lugar{
	const property capacidad
	method capacidad(fecha) = capacidad
	method concurrido(fecha) = self.capacidad(fecha) > 5000
}

object trastienda inherits Lugar(capacidad = 400) {
	
	method esSabado(fecha) = fecha.dayOfWeek() == saturday
	
    override method capacidad(fecha){
    		if (self.esSabado(fecha)){
    			return capacidad + 300}else{
    				return capacidad
    				}			
    			}    
 }

object fender {
    method valor() = 10
}

object gibson {
    var property estaSana = true
    
    method valor() = if (estaSana) 15 else 5
    method estaDaniada(){
    	estaSana = false
    }
}

//CANCIONES
const eres = new Cancion(nombreDeLaCancion = "eres",
						 duracion = 145,
    					 letra = "Eres lo mejor que me pasó en la vida, no tengo duda, no habrá más nada después de ti. Eres lo que le dio brillo al día a día, y así será por siempre, no cambiará, hasta el final de mis días")


const corazonAmericano = new Cancion(nombreDeLaCancion = "corazonAmericano",
									 duracion = 154,
									 letra = "canta corazon, canta mas alto, que tu pena al fin se va marchando, el nuevo milenio ha de encontrarnos, junto corazon, como soniamos")

const almaDeDiamante = new Cancion(nombreDeLaCancion = "almaDeDiamante",
								   duracion = 216,
								   letra = "Ven a mí con tu dulce luz alma de diamante. Y aunque el sol se nuble después sos alma de diamante. Cielo o piel silencio o verdad sos alma de diamante. Por eso ven así con la humanidad alma de diamante")
    

const crisantemo = new Cancion(nombreDeLaCancion = "crisantemo",
							   duracion = 175,
							   letra = "Tócame junto a esta pared, yo quedé por aquí... cuando no hubo más luz... quiero mirar a través de mi piel... Crisantemo, que se abrió... encuentra el camino hacia el cielo")

const cisne = new Cancion(nombreDeLaCancion = "cisne",
						  duracion = 312,
						  letra = "Hoy el viento se abrió quedó vacío el aire una vez más y el manantial brotó y nadie está aquí y puedo ver que solo estallan las hojas al brillar")


const laFamilia = new Cancion(nombreDeLaCancion  = "laFamilia",
							  duracion = 264,
							  letra = "Quiero brindar por mi gente sencilla, por el amor brindo por la familia")


//ÁLBUMES
const especialLaFamilia = new Album(nombreDelAlbum = "especialLaFamilia",
									canciones = #{laFamilia},
									fechaLanzamiento = new Date(day=17,month=6,year=1992),
									cantidadALaVenta=100000,
									cantidadVendido=89000)

const laSole = new Album(nombreDelAlbum = "laSole",
						 canciones = #{eres, corazonAmericano},
						 fechaLanzamiento = new Date(day=4,month=2,year=2005),
						 cantidadALaVenta= 200000,
						 cantidadVendido= 130000)

const paraLosArboles = new Album(nombreDelAlbum = "paraLosArboles",
								 canciones = #{cisne, almaDeDiamante},
							 	 fechaLanzamiento = new Date(day=31,month=3,year=2003),
							 	 cantidadALaVenta=50000,
							 	 cantidadVendido=49000 )
							 	 
const justCrisantemo = new Album(nombreDelAlbum = "justCrisantemo",
 							     canciones = #{crisantemo},
								 fechaLanzamiento = new Date(day=5,month=12,year=2007),
    		       	 		 	 cantidadALaVenta=28000,
    		       	 		 	 cantidadVendido=27500)
    		       	 		 	 
//MUSICOS
const joaquin = new DeGrupo(nombre = "joaquin",
							habilidad = 20,
							porTocarEnGrupo = 5,  
							albumes =[especialLaFamilia],
							cantaEnGrupo = true)

const lucia = new VocalistaPopular(nombre = "lucia",
								   habilidad = 70,
								   palabraClave = "familia", 
								   albumes = [],
								   cantaEnGrupo = false)

const kike = new DeGrupo(nombre = "kike",
						 	   albumes = [], 
						 	   cantaEnGrupo = true,
						 	   habilidad = 60,
						 	   porTocarEnGrupo = 20)

const soledad = new VocalistaPopular(nombre = "soledad", 
									 palabraClave= "amor",
									 habilidad = 55,
									 albumes = [laSole],
									 cantaEnGrupo = false)

//Presentaciones
const presentacionLunaPark = new Presentaciones(fechaPresentacion = new Date(day = 20, month = 4, year = 2021),
												lugar = lunaPark,
												artistas = [joaquin, lucia, luisAlberto])
const presentacionTrastienda = new Presentaciones(fechaPresentacion = new Date(day = 15, month = 11, year = 2020),
												  lugar = trastienda,
												  artistas =[joaquin, lucia, luisAlberto])
const lunaPark = new Lugar(capacidad = 9290)
