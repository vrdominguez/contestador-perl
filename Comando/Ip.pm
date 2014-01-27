#!/usr/bin/perl
#==============================================================================
#        FILE: Ip.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener el estado de la raspberry 
#==============================================================================
package Comando::Ip;

use strict;
use parent qw(Comando);
use Router;

sub params {
	my $self = $_[0];
	
	# Comprobamos que se sea administrador
	#$self->soloAdministradores();
	
	return $self; 
}

sub ejecutar {
	my $self = $_[0];
	
	my $ip = $self->__getIP();
	
	die('No se ha podido obtener la ip publica del router') unless($ip);
	
	return "IP: $ip";
}


sub __getIP{
	my $self = $_[0];
	
	my $config= $self->{configuraciones}->{router};
	
	my $router = Router->new($config->{usuario}, $config->{clave}, $config->{ip}, $config->{prompt});
	
	my @datos = split(/\n/, $router->ejecutarComando('ifconfig nas_0_44'));
	
	foreach my $linea (@datos) {
		if( $linea =~ /inet\s+addr\:\s*((\d+\.){3}\d+)\s+.+/) {
			return $1;
		}
	}
}

1;
