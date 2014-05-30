#!/usr/bin/perl
#==============================================================================
#        FILE: Uptime.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener el uptime de la raspberry 
#==============================================================================
package Comando::Uptime;

use strict;
use parent qw(Comando);

sub params {
	return $_[0]; 
}

sub ejecutar {
	my @datos = split(/\s+/, `/usr/bin/uptime`);
	
	# Descartamos la primera posicion del array si esta en blanco
	shift(@datos) if($datos[0] eq '');
	
	# Eliminamos posibles comas y/o saltos de linea al final de los datos
	$_ =~ s/[\,\n]+$// foreach(@datos);
	
	if ( $datos[3] =~ /days?/ ) {
		if ($datos[5] eq 'min') {
			return "Uptime:\n".
				"\tDias: $datos[2]\n".
				"\tHoras: 0\n".
				"\tMinutos: $datos[4]\n";
		}
		
		my @tiempo = split(':', $datos[4]);
		return "Uptime:\n".
			"\tDias: $datos[2]\n".
			"\tHoras: $tiempo[0]\n".
			"\tMinutos: $tiempo[1]\n";
	}
	elsif ( $datos[3] eq 'min' ) {
		return "Uptime:\n".
			"\tDias: 0\n".
			"\tHoras: 0\n".
			"\tMinutos: $datos[2]\n";
	}
	
	my @tiempo = split(':', $datos[2]);
	return "Uptime:\n".
		"\tDias: 0\n".
		"\tHoras: $tiempo[0]\n".
		"\tMinutos: $tiempo[1]\n";
}

1;
