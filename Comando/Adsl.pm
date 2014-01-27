#!/usr/bin/perl
#==============================================================================
#        FILE: Adsl.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener el estado de la conexion ADSL
#==============================================================================
package Comando::Adsl;

use strict;
use parent qw(Comando);
use Router;

sub params {
	my $self = $_[0];
	
	# Comprobamos que se sea administrador
	$self->soloAdministradores();
	
	return $self; 
}

sub ejecutar {
	my $self = $_[0];
	
	my $datos = undef;
		
	eval {	
		$datos = $self->__getAdsl();
	};
	if($@) {
		die("Error obteniendo los datos de ADSL. Detalles: $@");
	}
	
	die("No se han obtenido deatos de ADSL") unless($datos);
	
	return $datos;
}


sub __getAdsl {
	my $self = $_[0];
	
	my $config= $self->{configuraciones}->{router};
	
	my $router = Router->new($config->{usuario}, $config->{clave}, $config->{ip}, $config->{prompt});
	
	my @datos = split(/\n/, $router->ejecutarComando('adsl info'));
	
	my $datos_adsl = undef;
	my $conectado = undef;
		
	foreach my $linea (@datos) {
		if ($linea =~ /Status\:\s+Showtime/i) {
			$conectado = 1;
		}
		elsif( $linea =~ /^Channel\:\s+(\w+)\,[^\d]+(\d+)\s+(\w+)\,\s+[^\d]+(\d+)\s+(\w+)$/ ) {
			$datos_adsl = "Canal: $1\nSubida: $2 $3\nBajada: $4 $5";
		}
		last if($conectado && $datos_adsl);
	}
	
	return $conectado ? $datos_adsl : 
						'ADSL no conectada';	
}

1;
