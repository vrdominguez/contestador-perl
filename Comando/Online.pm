#!/usr/bin/perl
#==============================================================================
#        FILE: Online.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener los usuarios online 
#==============================================================================
package Comando::Online;

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
	
	my $respuesta = "Usuarios en linea:\n";
	
	my @en_linea = sort {$a cmp $b} @{$self->__getOnline()};
	
	if ( scalar(@en_linea) ) {
		foreach (@en_linea) {
			my @datos = split(/\s+/, $_);
			
			if ( $datos[3] =~ /^\d{1,2}\:\d{2}$/ ) {
				# Eliminamnos los parentesis del host
				$datos[4] =~ s/[\(\)]//g;
				
				$respuesta .= "\tUsuario: $datos[0]\n"
					    . "\tTerminal: $datos[1]\n"
					    . "\tAcceso: $datos[2] $datos[3]\n"
					    . "\tDesde: $datos[4]\n"
					    . "\t" . '-'x8 . "\n";
			}
			else {
				# Eliminamnos los parentesis del host
				$datos[5] =~ s/[\(\)]//g;
				
				$respuesta .= "\tUsuario: $datos[0]\n"
					    . "\tTerminal: $datos[1]\n"
					    . "\tAcceso: $datos[3] $datos[2] $datos[4]\n"
					    . "\tDesde: $datos[5]\n"
					    . "\t" . '-'x8 . "\n";
			}
		}
	}
	else {
		$respuesta .= "\t- No hay usuarios en linea\n";
	}
	
	return $respuesta;
}


sub __getOnline{
	my $self = $_[0];
	
	my @salida = split(/\n/, `/usr/bin/who --ips`);
	
	return \@salida
	
}

1;
