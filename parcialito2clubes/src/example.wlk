class Equipo {
	var property cantidadDeSanciones = 0
	var property campeonatosObtenidos
	var capitan
	var property jugadores = #{capitan}
    
	method efectoDeSancion(){
		cantidadDeSanciones +=1
	}
   
}
class Club {
	var property actividadesSocial
	var property equipos
	var property cantidadSancionesClub = 0
    var property socios	
    var property gastoMensual
    
    
    method esSocioEstrella(unSocio) = unSocio.aniosEnLaInstitucionSocio() > 20 and
    socios.contains(unSocio)
    
    method esJugadorEstrella(unJugador) = unJugador.cantidadDePartidosJugados() > 50 and
    self.jugadorPerteneceAlClub(unJugador)
    
    method jugadorPerteneceAlClub(unJugador) = equipos.any({equipo=>equipo.jugadores().contains(unJugador)})
    
    method efectoDeSancion() {if(socios > 500){
    	actividadesSocial.forEach({actividad => actividad.efectoDeSancion()})}
    	equipos.forEach({equipo=>equipo.efectoDeSancion()})
    	cantidadSancionesClub += 1
    	}
    	
    	
    method cantidadDeParticipacionesEnActividadesDeUnJugador(unJugador)=
    if(self.jugadorPerteneceAlClub(unJugador))unJugador.cantidadDePartidosJugados() +
    actividadesSocial.count({actividad => if(actividad.sociosParticipantes())1 else 0 })
    
    method borrarSocio(unSocio) {socios.romeve(unSocio)}
    
    method agregarSocio(unSocio){socios.add(unSocio)}
    
    method efectoDeEvaluacion(municipio) 
}	

object valorParaClubProfesional {
	var property valor 
}
class Jugador {
	var property valorDePase
	var property cantidadDePartidosJugados

}
class ActividadSocial {
	var property estaSuspendida
	var property socioOrganizador
	var property sociosParticipantes
	
	method efectoDeSancion() {
		if(!estaSuspendida)estaSuspendida = true else estaSuspendida = false
	}
	method efectoDeReanudacionDeSancion() {
	 if(estaSuspendida)estaSuspendida = false 
	}
	
}
class Socio {
	var property aniosEnLaInstitucion
	
	
}

class ClubTradicional inherits Club {
	override method esJugadorEstrella(unJugador) = unJugador.valorDePase() > 
     valorParaClubProfesional.valor() or unJugador.cantidadDeParticipaciones() > 3
     
     override method efectoDeEvaluacion(municipio)=
    actividadesSocial.sum({actividad => municipio.evaluacionActividadSocial()}) - gastoMensual

     
     
}

class ClubComunitario inherits Club{
	override method esJugadorEstrella(unJugador)  = 
	unJugador.cantidadDeParticipacionesEnActividadesDeUnJugador() > 3

	
	override method efectoDeEvaluacion(municipio) =
	actividadesSocial.sum({actividad => municipio.evaluacionActividadSocial()})
	
	
}

class ClubProfesional inherits Club{
	override method esJugadorEstrella(unJugador) = unJugador.valorDePase() > 
     valorParaClubProfesional.valor()
     
     override method efectoDeEvaluacion(municipio) =
     actividadesSocial.sum({actividad => municipio.evaluacionActividadSocial()}) * 2 -(gastoMensual * 5)
}

class Sancion{
  
  method sancionarClub(club) {
  	 club.efectoDeSancion()
  }
  method sancionarActividad(unaActividad){unaActividad.efectoDeSacion()}
  
  method reanudarActividadSocial(unaActividad){
  	  unaActividad.efectoDeReanudacionDeSancion()
  }
  
  method cantidadDeSancionesDeUnEquipo(unEquipo) = unEquipo.cantidadDeSanciones()
  
  method actividadEstaSuspendida(unaActividad) = unaActividad.estaSuspendida()
  
 
}

class Municipio {
   var valorParaActividadSocial
   
   
	method evaluacionActividad(equipo) = (equipo.equipo().campeonatosObtenidos() * 5) +
	(equipo.equipo().size() * 2)  + if(equipo.esJugadorEstrella(equipo.capitan()))5 else 0
	- (equipo.cantidadSancionesClub()) * 20
	
	method evaluacionActividadSocial(unaActividad) = 
	if(!unaActividad.estaSuspendida()) 
	valorParaActividadSocial
	else 0
	
    
    
    
    method socioDestacadosDeUnClub(unClub) =
    unClub.socios().filer({socio => unClub.equipos().filter({equipo =>
    	self.socioEsCapitanDeUnEquipo(equipo,socio)}) or
    	 unClub.socios().filer({_socio => unClub.actividadesSocial().filter({actividad =>
    	self.socioEsOrganizadorDeActividadSocial(actividad,_socio)})
    })})
    
    
    method socioEsCapitanDeUnEquipo(unEquipo,unSocio) = unEquipo.contains(unSocio)
    
    method socioEsOrganizadorDeActividadSocial(unaActividadSocial,unSocio) =
    unaActividadSocial.socioOrgazinazor(
    )
    
    method sociosEstrellasDeLosDestacados (unClub) = self.socioDestacadosDeUnClub(unClub).filter({
    	socio=>unClub.esSocioEstrella(socio)
    })
    
    method esEquipoExperimentado(unEquipo) = unEquipo.jugadores().all({jugador=>
    	jugador.cantidadDePartidosJugados() >= 10
    })
    
    method esClubPrestigioso(unClub) = unClub.equipos().any({
    	equipo => self.esEquipoExperimentado(equipo)
    })
    
    method transferirJugador(club,unJugador,nuevoClub){
    	if(!self.socioDestacadosDeUnClub(club).contais(unJugador)){
    	club.equipos().forEach({equipo=>equipo.remove(unJugador)})
    	club.actividadesSocial().forEach({actividad=>actividad.sociosParticipantes().remove(unJugador)})
    	club.borrarSocio(unJugador)
    	nuevoClub.equipos().forEach({equipo=>equipo.add(unJugador)})
    	nuevoClub.agregarSocio(unJugador)
    	unJugador.cantidadDePartidosJugadors(0)
    	
    	}
    }
    
}






