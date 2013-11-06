#!/usr/bin/perl
#==============================================================================
#        FILE: Espacio.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener el espacio ocupado
#==============================================================================
package Comando::Espacio;

use strict;
use parent qw(Comando);

sub params {
	my $self = shift;
	my @parametros = @_;
	
	foreach my $ruta (@parametros) {
		push ( @{$self->{rutas_espacio}}, $ruta ) if (-d $ruta);
	}
	
	# Si no hay carpetas, por defecto siempre pediremos el espacio en / y /Descargas
	unless( defined($self->{rutas_espacio}) && scalar(@{$self->{rutas_espacio}}) ) { 
		push ( @{$self->{rutas_espacio}}, @{$self->{configuraciones}->{espacio}->{carpetas}} );
	}
	
	return $self;
	
}

sub ejecutar {
	my $self = $_[0];

	my $respuesta = "Uso de disco:\n";
	
	foreach my $ruta (@{$self->{rutas_espacio}}) {
		if ( !$self->{configuraciones}->{espacio}->{solo_mountpoints} || $self->__comprobarMountpoint($ruta) ) {
			$respuesta .= "\t$ruta  => " . $self->__getEspacio($ruta) . " libres\n";
		}
		else {
			$respuesta .= "\t$ruta  => No es un punto de montaje\n";
		}
	}
	
	return $respuesta;
}


sub __getEspacio {
	my $self = $_[0];
	my $directorio = $_[1] || '/';
	
	my @salida = split(/\n/, `/bin/df -h $directorio`);
	
	return (split(/\s+/, $salida[1]))[3];
}


sub __comprobarMountpoint {
	my $self = $_[0];
	
	my $directorio = $_[1] || '/';
	
	$self->__cargarPuntosMontaje() unless( defined($self->{puntos_montaje}) );
	
	return ($directorio ~~ @{$self->{puntos_montaje}}) ? 1 : undef;
}

sub __cargarPuntosMontaje {
	my $self = $_[0];
	
	if (open(MONTAJE, '<', '/proc/mounts')) {
		my @lineas = <MONTAJE>;
		close MONTAJE;
		
		@{$self->{puntos_montaje}} = map { (split(/\s+/, $_))[1]} @lineas;
	}
	else {
		die("Error cargando los puntos de montaje");
	}
}


1;
