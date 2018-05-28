class Club {
	var capitan 
	var equipo = #{capitan}
	var socios = #{}
	
    method esSocioEstrella(unSocio) = unSocio.aniosEnLaInstitucionSocio() > 20
	
}

class Jugador {
	var valorDePase
	var cantidadDePartidosClub
	

}

class ActividadSocial {
	var socioOrganizador
	var sociosParticipantes
	
}

class Socio {
	var aniosEnLaInstitucion
	
	method aniosEnLaInstitucionSocio() = aniosEnLaInstitucion
}

class ClubTradicional inherits Club {
	
}

class ClubComunitario inherits Club{
	
}

class ClubProfesional inherits Club{
	
}








