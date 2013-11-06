#!/usr/bin/perl
#==============================================================================
#        FILE: Carga.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener datos de carga de la maquina 
#==============================================================================
package Comando::Carga;

use strict;
use parent qw(Comando);

sub params {
	# No usaremos parametros, devolvemos directamente el propio objeto
	return $_[0];
}

sub ejecutar {
	my $self = $_[0];
	
	my @datos = split(/\s+/, `cat /proc/loadavg`);
	
	return "Estado de CPU/Procesos:\n".
		"\tCarga 1 minuto: $datos[0]\n".
		"\tCarga 5 minutos: $datos[1]\n".
		"\tCarga 15 minutos: $datos[2]\n".
		"\tProcesos ejecucion/totales: $datos[3]\n".
		"\tUltimo PID usado: $datos[4]\n";
}

1;
