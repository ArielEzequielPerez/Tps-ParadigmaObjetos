class NoCumpleRequerimientoException inherits Exception {
}

class Cancion {

	const property titulo
	const property duracion
	const property letra

	method duraMasDe(segundos)= duracion >= segundos

	method esUnaCancionCorta() = !self.duraMasDe(180)
	
	method tamanioDeLaLetra() = letra.size()
	
	method tamanioTitulo()= titulo.size()

	method duracionImpar() = duracion.odd()

	method existePalabra(palabra) {
		const unaPalabra = palabra.toLowerCase()
		return letra.toLowerCase().contains(unaPalabra)
	}
	
}

class Remix inherits Cancion {

	const property cancion

	override method duracion() = cancion.duracion() * 3

	override method letra() = "mueve tu cuerpo baby" + " " + cancion.letra() + " " + "yeah oh yeah"

}

class Mashup inherits Cancion {

	const property canciones

	override method duracion() = canciones.max({ unaCancion => unaCancion.duracion() }).duracion()

	method concatenarLetras() = canciones.map({unaCancion => unaCancion.letra()}).join(" ")
	override method letra() = self.concatenarLetras().trim()
	
	}



class Album {
	const property nombreDelAlbum
	const property canciones
	const property fechaLanzamiento
	var property cantidadALaVenta
	var property cantidadVendido
	
	method porcentajeDeVentas() = (cantidadVendido * 100) / cantidadALaVenta > 75

	method sonTodasCortas() = canciones.all({ unaCancion => unaCancion.esUnaCancionCorta()})

	method devolverCancion(palabra) = canciones.filter({ unaCancion => unaCancion.existePalabra(palabra)})

	method duracionCanciones() = canciones.sum({ unaCancion => unaCancion.duracion() })

	method cancionDuraMasQue(segundos) = canciones.any({ unaCancion => unaCancion.duraMasDe(segundos)})
	
	method estaLaCancion(cancion) = canciones.contains(cancion)

	method mayorDelAlbum(criterio) = canciones.fold(canciones.anyOne(),{cancionActual, unaCancion => criterio.mayorCancion(cancionActual, unaCancion)})
}
	
object porDuracion{
	method mayorCancion(cancionA, cancionB) = if(cancionA.duracion()> cancionB.duracion()) cancionA else cancionB
}
object porLetra{
	method mayorCancion(cancionA, cancionB) = if(cancionA.tamanioDeLaLetra()> cancionB.tamanioDeLaLetra()) cancionA else cancionB
}
object porTitulo{
	method mayorCancion(cancionA, cancionB) = if(cancionA.tamanioTitulo() > cancionB.tamanioTitulo()) cancionA else cancionB
}

class Musico {
	const property nombre
	const property albumes
	var property cantaEnGrupo
	var property habilidad
	var property categoriaMusico
	var property criterioDeCobro

	
	

	method esMinimalista() = albumes.all({ unAlbum => unAlbum.sonTodasCortas() })

	method cancionesContienenPalabra(unaPalabra) = albumes.flatMap{ unAlbum => unAlbum.devolverCancion(unaPalabra) }

	method duracionDeObra() = albumes.sum({ unAlbum => unAlbum.duracionCanciones() })

	method laPego() = albumes.all({ unAlbum => unAlbum.porcentajeDeVentas() })

	method esDeSuAutoria(cancion) = albumes.any{unAlbum => unAlbum.estaLaCancion(cancion)}
	
	method compusoAlMenosUnaCancion() = !albumes.isEmpty()

	method habilidadMayorA(numero) = self.habilidad() > numero

	method ejecutaBien(cancion) = self.esDeSuAutoria(cancion) || self.habilidadMayorA(60) || categoriaMusico.interpretaBien(cancion) 

	method interpretarPorCriterio(cancion) = categoriaMusico.interpretaBien(cancion)
	
	method cobraPorCriterio(presentacion) = criterioDeCobro.nuevaFormaCobro(presentacion)
	
	method habilidad()

	method interpretaBien(cancion)

}


class CriterioDeCobro{
	const property xPesos
	}
 
class CuantosCantan inherits CriterioDeCobro{
	method nuevaFormaCobro(presentacion) = if(presentacion.masDeUnArtista()) xPesos/2 else xPesos
	}

class PorCapacidad inherits CriterioDeCobro{
	const pPersonas
	method nuevaFormaCobro(presentacion) = if(presentacion.capacidadPresentacion() >pPersonas) xPesos else xPesos-100
	}
	
class PorInflacion inherits CriterioDeCobro{
	const plusPorInflacion
	const fecha		
	method nuevaFormaCobro(presentacion) = if(presentacion.esAntesDe(fecha)) xPesos else xPesos + plusPorInflacion
	}


class Palabrero{
	var property xPalabra	
	method interpretaBien(cancion) = cancion.existePalabra(xPalabra)
	}

class Larguero{
	var xSegundos
	method interpretaBien(cancion) = cancion.duraMasDe(xSegundos)
}

object imparero{
	method interpretaBien(cancion) = cancion.duracionImpar()
}

class DeGrupo inherits Musico {
	const porTocarEnGrupo
	
	override method habilidad() = if (cantaEnGrupo) habilidad + porTocarEnGrupo else habilidad
	override method interpretaBien(cancion) = cancion.duraMasDe(300)
}

class VocalistaPopular inherits Musico {
	const property palabra
	override method habilidad() = if (cantaEnGrupo) habilidad - 20 else habilidad
	override method interpretaBien(cancion) = cancion.existePalabra(palabra)
}

object luisAlberto inherits Musico(nombre = "luisAlberto", albumes = [paraLosArboles, justCrisantemo], cantaEnGrupo = false, habilidad = 8, categoriaMusico = imparero, criterioDeCobro =porInflacion){
	
	var property guitarra= fender
		
	override method habilidad() = (habilidad * guitarra.valor()).min(100)
	override method interpretaBien(cancion) = true
}

class Presentacion{

	var property fechaPresentacion
	const property lugar
	const property artistas = []
	
	method esAntesDe(fecha) = fechaPresentacion < fecha 

	method esConcurrido() = lugar.concurrido(fechaPresentacion)

	method costo() = artistas.sum({ artista => artista.cobra(self) })

	method masDeUnArtista() = artistas.size() > 1
	
	method agregarArtista(artista){
		artistas.add(artista)	
	} 
	method capacidadPresentacion() = lugar.capacidad(fechaPresentacion)
	
	method costos() = artistas.sum{unArtista => unArtista.cobraPorCriterio(self)}

}

object pdpalooza inherits Presentacion(fechaPresentacion = new Date(day = 18, month = 12, year = 2020),lugar = lunaPark ,artistas = []){
 
	var property numeroHabilidad = 70
	var property cancionAInterpretar = cancionDeAliciaEnElPais

	override method agregarArtista(artista) {
		if(!artista.habilidadMayorA(numeroHabilidad)){
			throw new NoCumpleRequerimientoException(message = "No cumple requerimiento de habilidad")
		}
		if (!artista.compusoAlMenosUnaCancion()) {
			throw new NoCumpleRequerimientoException(message = "el artista no compuso una cancion")
			}
		if (!artista.ejecutaBien(cancionAInterpretar)) {
			throw new NoCumpleRequerimientoException(message = "el artista no puede interpretar la cancion")
				}
			artistas.add(artista)
	}
}


class Lugar {

	const capacidad

	method concurrido(fecha) = self.capacidad(fecha) > 5000

	method capacidad(fecha) = capacidad

}

object trastienda inherits Lugar(capacidad = 400){

	method esSabado(fecha) = fecha.dayOfWeek() == saturday

	override method capacidad(fecha) {
		if (self.esSabado(fecha)) {
			return capacidad + 300
		} else {
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

	method estaDaniada() {
		estaSana = false
	}

}
 
//CANCIONES

const eres = new Cancion(titulo = "eres",
						 duracion = 145,
						 letra = "Eres lo mejor que me pasó en la vida, no tengo duda, no habrá más nada después de ti. Eres lo que le dio brillo al día a día, y así será por siempre, no cambiará, hasta el final de mis días")

const corazonAmericano = new Cancion(titulo = "corazonAmericano",
									 duracion = 154,
									 letra = "canta corazon, canta mas alto, que tu pena al fin se va marchando, el nuevo milenio ha de encontrarnos, junto corazon, como soniamos")

const almaDeDiamante = new Cancion(titulo = "almaDeDiamante",
								   duracion = 216, 
								   letra = "Ven a mí con tu dulce luz alma de diamante. Y aunque el sol se nuble después sos alma de diamante. Cielo o piel silencio o verdad sos alma de diamante. Por eso ven así con la humanidad alma de diamante")

const crisantemo = new Cancion(titulo = "crisantemo",
							   duracion = 175, 
							   letra = "Tócame junto a esta pared, yo quedé por aquí... cuando no hubo más luz... quiero mirar a través de mi piel... Crisantemo, que se abrió... encuentra el camino hacia el cielo")

const cisne = new Cancion(titulo = "cisne", 
						  duracion = 312, 
						  letra = "Hoy el viento se abrió quedó vacío el aire una vez más y el manantial brotó y nadie está aquí y puedo ver que solo estallan las hojas al brillar")

const laFamilia = new Cancion(titulo = "laFamilia", 
							  duracion = 264, 
							  letra = "Quiero brindar por mi gente sencilla, por el amor brindo por la familia")

const laFamiliaRemix = new Remix(cancion = laFamilia, 
								 titulo = "la Familia remix", 
								 duracion = 264, 
								 letra = "")
								 

const nuevoMashup = new Mashup(canciones = [ almaDeDiamante, crisantemo ], 
							   titulo = "Nueva cancion mashup", 
							   duracion = 0, 
							   letra = "")
							   

const cancionDeAliciaEnElPais = new Cancion(titulo = "Canción de Alicia en el país", 
											duracion = 510, 
											letra = "quién sabe Alicia, este país no estuvo hecho porque sí. Te vas a ir, vas a salir pero te quedas, ¿dónde más vas a ir? Y es que aquí, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acabó ese juego que te hacía feliz")
 
//ÁLBUMES
const especialLaFamilia = new Album(nombreDelAlbum = "especialLaFamilia", 
									canciones = [ laFamilia ], 
									fechaLanzamiento = new Date(day = 17, month = 6, year = 1992), 
									cantidadALaVenta = 100000, 
									cantidadVendido = 89000)

const laSole = new Album(nombreDelAlbum = "laSole", 
						 canciones = [eres, corazonAmericano], 
						 fechaLanzamiento = new Date(day = 4, month = 2, year = 2005), 
						 cantidadALaVenta = 200000, 
						 cantidadVendido = 130000)

const paraLosArboles = new Album(nombreDelAlbum = "paraLosArboles", 
								 canciones = [cisne, almaDeDiamante], 
								 fechaLanzamiento = new Date(day = 31, month = 3, year = 2003), 
								 cantidadALaVenta = 50000, 
								 cantidadVendido = 49000)

const justCrisantemo = new Album(nombreDelAlbum = "justCrisantemo", 
								 canciones = [crisantemo], 
								 fechaLanzamiento = new Date(day = 5, month = 12, year = 2007), 
								 cantidadALaVenta = 28000, 
								 cantidadVendido = 27500)

//MUSICOS 

	

const joaquin = new DeGrupo(nombre = "joaquin",
							albumes = [ especialLaFamilia ], 
							cantaEnGrupo = true,
							habilidad = 20,
							porTocarEnGrupo = 5,
							categoriaMusico = larguero,
							criterioDeCobro = cuantosCantan)
							
const lucia = new VocalistaPopular(nombre = "lucia", 
								   albumes = [], 
								   cantaEnGrupo = false,
								   habilidad = 70, 
								   palabra = "familia",
								   categoriaMusico = palabrero,
								   criterioDeCobro = porCapacidad)

const kike = new DeGrupo(nombre = "kike", 
						 albumes = [], 
						 cantaEnGrupo = true, 
						 habilidad = 60, 
						 porTocarEnGrupo = 20, 
						 categoriaMusico = larguero,
						 criterioDeCobro =porCapacidad)


const soledad = new VocalistaPopular(nombre = "soledad", 
									 habilidad = 55, 
									 albumes = [ laSole ], 
									 cantaEnGrupo = false,
									 palabra = "amor",
									 categoriaMusico = palabrero,
									 criterioDeCobro =porCapacidad)
//CriteriosDeCobro
const porInflacion = new PorInflacion(xPesos = 1000, plusPorInflacion = 200, fecha = new Date(day = 30, month = 11, year = 2020))
const porCapacidad = new PorCapacidad(xPesos = 500, pPersonas =5000)
const cuantosCantan = new CuantosCantan(xPesos = 100)

//CategoriaDeMusicos
const palabrero = new Palabrero(xPalabra = "familia")
const larguero = new Larguero(xSegundos = 300)

//Presentaciones
const presentacionLunaPark = new Presentacion(fechaPresentacion = new Date(day = 20, month = 4, year = 2021),
												lugar = lunaPark, 
												artistas = [ joaquin, lucia, luisAlberto ]
)

const presentacionTrastienda = new Presentacion(fechaPresentacion = new Date(day = 15, month = 11, year = 2020), 
												lugar = trastienda, 
												artistas = [ joaquin, lucia, luisAlberto ]
)


//Lugares
const laCueva = new Lugar(capacidad = 14000)

const lunaPark = new Lugar(capacidad = 9290)

const prixDAmi = new Lugar(capacidad = 150)