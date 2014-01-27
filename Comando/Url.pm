#!/usr/bin/perl
#==============================================================================
#        FILE: Url.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para obtener el estado de la raspberry 
#==============================================================================
package Comando::Url;

use strict;
use parent qw(Comando::Ip);

sub params {
	my $self = shift;
	my @parametros = @_;
	
	$self->soloAdministradores();
	
	if('ip' ~~ @parametros)	{
		$self->{ip} = 1;
	}
	
	return $self;
}

sub ejecutar {
	my $self = $_[0];
	
	if ( $self->{ip} ) {
		my $ip = $self->__getIP();
		return "http://$ip:9091/";
	}
	
	return 'http://'.$self->{configuraciones}->{descargas}->{dominio}.':9091/';
}

1;
