#!/usr/bin/perl
#==============================================================================
#        FILE: Apagar.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Comando para apagar el sistema 
#==============================================================================
package Comando::Apagar;

use strict;
use parent qw(Comando);

sub params {
	$_[0]->soloAdministradores();
	return $_[0];
}

sub ejecutar {
	my $self = $_[0];
	
	`/sbin/shutdown -h now`;
	
	return "Apagando...";
}

1;
