object joaquin {
	const habilidad = 20
	const plusCantarGrupo = 5
    var property cantaEnGrupo = true
    
    method habilidad() = if (cantaEnGrupo) habilidad + plusCantarGrupo else habilidad
    method interpretaBien(cancion) = cancion.cancionDuraMasDe(300)
    method cobra(presentacion) = if (cantaEnGrupo) 50 else 100
}

object lucia {
    const habilidad = 70
    const unaPalabra = "familia"
    var property cantaEnGrupo = true
    
    method habilidad() = if (cantaEnGrupo) habilidad - 20 else habilidad
    method interpretaBien(cancion) = cancion.contienePalabra(unaPalabra)
    method cobra(presentacion) = if (presentacion.esConcurrido()) 500 else 400 
}

object luisAlberto {
    var property guitarra = fender
    const fecha = new Date(day = 30, month = 11, year = 2020)
    
    method habilidad() = (8 * guitarra.valor()).min(100)
    method interpretaBien(cancion) = true
    method cobra(presentacion) = if (presentacion.esAntesDe(fecha)) 1000 else 1200
}
object cisne {
    const property duracion = 312
    const property letra = "Hoy el viento se abrió quedó vacío el aire una vez más y el manantial brotó y nadie está aquí y puedo ver que solo estallan las hojas al brillar"
    
    method cancionDuraMasDe(segundos) = duracion > segundos
    method contienePalabra(unaPalabra) {  
    	const palabra = unaPalabra.toLowerCase()
    	return letra.toLowerCase().contains(palabra)
    }
}

object laFamilia {
    const property duracion = 264
    const property letra = "Quiero brindar por mi gente sencilla, por el amor brindo por la familia"
    
    method cancionDuraMasDe(segundos) = duracion > segundos
    method contienePalabra(unaPalabra) {  
    	const palabraMayuscula = unaPalabra.toLowerCase()
    	return letra.toLowerCase().contains(palabraMayuscula)
    }
}

object presentacionTrastienda {

	var property fechaPresentacion = new Date(day = 15, month = 11, year = 2020)
	const property lugar = trastienda
	const property artistas = [luisAlberto, joaquin, lucia]
	
	method esConcurrido() = lugar.concurrido(fechaPresentacion)
	method costos() = artistas.sum({unArtista => unArtista.cobra(self)})
	method agregarArtista(unArtista) = artistas.add(unArtista)
	
	method esAntesDe(unaFecha) = unaFecha>fechaPresentacion

}
object presentacionLunaPark {
	var property fechaPresentacion = new Date(day = 20, month = 4, year = 2021)
	const property lugar = lunaPark
	const property artistas = [luisAlberto, joaquin, lucia]
	
	method esConcurrido() = lugar.concurrido()
	method costos() = artistas.sum({unArtista => unArtista.cobra(self)})
	method agregarArtista(artista) = artistas.add(artista)
	method esAntesDe(unaFecha) = unaFecha>fechaPresentacion
	
}

object lunaPark{
    const capacidad = 9290
    
    method concurrido() = capacidad > 5000
    method capacidad(presentacion) = capacidad
    
}

object trastienda {
	var property capacidad = 400
	
	
	method esSabado(fecha) = fecha.dayOfWeek() == saturday
    method capacidad(fecha) = if (self.esSabado(fecha)) capacidad + 300 else capacidad
    method concurrido(fecha) = self.capacidad(fecha) > 5000
}


object fender {
    method valor() = 10
}

object gibson {
    var property estaSana = true
    method valor() = if (estaSana) 15 else 5
    method gibsonDaniada() {estaSana = false}
}