#!/usr/bin/perl
#==============================================================================
#        FILE: Descargas.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para listar la actividad de transmission-daemon 
#==============================================================================
package Comando::Descargas;

use strict;
use parent qw(Comando);

sub params {
	# No usaremos parametros, devolvemos directamente el propio objeto
	return $_[0];
}

sub ejecutar {
	my $self = $_[0];
	
	my $ejecutable = $self->{configuraciones}->{descargas}->{ejecutable};
	my $usuario = $self->{configuraciones}->{descargas}->{usuario};
	my $clave = $self->{configuraciones}->{descargas}->{clave};
	
	
	unless ($ejecutable && -x $ejecutable) {
		die("Error en la configuracion del ejecutable de transmission-remote");
	}
	
	my @datos = split(/\n/, `$ejecutable -n $usuario:$clave --list`);
	# Eliminamos la primera y la ultima linea de datos
	shift @datos; pop @datos;
	
	if (scalar(@datos)) {
		my $salida = "Torrents actuales:\n";
		$salida .= $self->__parsearSalida($_) foreach(@datos);
		return $salida;
	}
	
	return "No hay descargas activas\n";
}

sub __parsearSalida {
	my $self = $_[0];
	my $linea = $_[1];
	
	my @partes = split(/\s{2,}/, $linea);
	
	return "Fichero: $partes[9]\n".
		"\tEstado: $partes[8]\n".
		"\tDatos descargados: $partes[3] ($partes[2])\n".
		"\tTiempo restante: $partes[4]\n" . '-'x10 . "\n";
}

1;
