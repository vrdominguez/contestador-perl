#!/usr/bin/perl
#==============================================================================
#        FILE: Estado.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener el estado de la raspberry 
#==============================================================================
package Comando::Estado;

use strict;
use parent qw(Comando);

sub params {
	my $self = $_[0];
	
	# Comprobamos que se sea administrador
	$self->soloAdministradores();
	
	return $self; 
}

sub ejecutar {
	my $self = $_[0];
	
	my $version = "\t" . join("\n\t", `vcgencmd version`);
	my $temperatura = `vcgencmd measure_temp`;
	$temperatura =~ s/^temp\=//;
	
	return "Datos version:\n$version\n" . '_-'x6 ."_\n\n" .
		"Temperatura: $temperatura\n" . '_-'x6 ."_\n\n" .
		$self->__getCarga(); 
}


sub __getCarga {
	my @datos = split(/\s+/, `cat /proc/loadavg`);
	
	return "Estado de CPU/Procesos:\n".
		"\tCarga 1 minuto: $datos[0]\n".
		"\tCarga 5 minutos: $datos[1]\n".
		"\tCarga 15 minutos: $datos[2]\n".
		"\tProcesos ejecucion/totales: $datos[3]\n".
		"\tUltimo PID usado: $datos[4]\n";
}

1;
