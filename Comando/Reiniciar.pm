#!/usr/bin/perl
#==============================================================================
#        FILE: Reiniciar.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para reinciar el sistema 
#==============================================================================
package Comando::Reiniciar;

use strict;
use parent qw(Comando);

sub params {
	$_[0]->soloAdministradores();
	return $_[0];
}

sub ejecutar {
	my $self = $_[0];
	
	`/sbin/reboot`;
	
	return "Reiniciando...";
}

1;
