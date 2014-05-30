#!/usr/bin/perl
#==============================================================================
#        FILE: Transmission.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para controlar el demonio de transmission 
#==============================================================================
package Comando::Transmission;

use strict;
use parent qw(Comando);

sub params {
	my $self = shift; 
	my @parametros = @_;
	
	if ( ('estado' ~~ @parametros) || !scalar(@parametros) ) {
		$self->{accion} = 'status';
	}
	elsif ('iniciar' ~~ @parametros)  {
		$self->{accion} = 'start';
	}
	elsif ('detener' ~~ @parametros)  {
		$self->{accion} = 'stop';
	}
	elsif ('reiniciar' ~~ @parametros)  {
		$self->{accion} = 'restart';
	}
	else {
		die("opcion incorrecta");
	}
	
	$self->soloAdministradores() unless( $self->{accion} eq 'status' );
	
	return $self;
}

sub ejecutar {
	return join("\n", `service transmission-daemon $_[0]->{accion}`);
}

1;
