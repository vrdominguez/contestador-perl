#!/usr/bin/perl
#==============================================================================
#        FILE: Conectados.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener los dispositivos conectados a la red 
#==============================================================================
package Comando::Conectados;

use strict;
use parent qw(Comando);
use Router;
use Data::Dumper;

sub params {
	my $self = $_[0];
	
	# Comprobamos que se sea administrador
	$self->soloAdministradores();
	
	return $self; 
}

sub ejecutar {
	my $self = $_[0];
	
	my $dispositivos= $self->__getDevices();
	
	die('No se ha podido obtener la lista de dispositivos conectados') unless($dispositivos);
	
	my $respuesta = "Dispositivos conectados:\n";
	
	foreach my $dispositivo (sort {$a->{dispositivo} cmp $b->{dispositivo}} @$dispositivos) {
		if ($dispositivo->{dispositivo}) {
			$respuesta .= "\t-" . $dispositivo->{dispositivo} . ': ' . $dispositivo->{ip} . "\n"
		}
		else {
			$respuesta .= "\t-Desconocido (" . $dispositivo->{mac} . '): ' . $dispositivo->{ip} . "\n"
		}
	}
	
	return $respuesta;
}


sub __getDevices{
	my $self = $_[0];
	
	my $config= $self->{configuraciones}->{router};
	
	my $router = Router->new($config->{usuario}, $config->{clave}, $config->{ip}, $config->{prompt});
	
	my @datos = split(/\n/, $router->ejecutarComando('arp show'));
	
	my $respuesta = [];
	
	foreach my $linea(@datos) {
		#'IP address       HW type     Flags       HW address            Mask     Device',
		next unless $linea =~ /br0$/;
		my @data = split(/\s+/, $linea);
		
		my $datos_dispositivo = {
			mac=>$data[3],
			ip=>$data[0],
			dispositivo => $self->{configuraciones}->{macs}->{$data[3]} 
		};
		
		
		push(@$respuesta, $datos_dispositivo); 
	}
	
	return $respuesta;
}

1;
