#!/usr/bin/perl
#==============================================================================
#     ARCHIVO: Router.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Clase base para los comandos del contestador Raspberry Pi que
#              acceden al router Huawei HG556a de vodafone
#==============================================================================
package Router;

use strict; 
use Net::Telnet;

sub new {
	my $usuario = $_[1] || die(__PACKAGE__.'->new() ERROR: Falta usuario de acceso al router');
	my $password = $_[2] || die(__PACKAGE__.'->new() ERROR: Falta clave de acceso al router');
	my $ip_router = $_[3] || '192.168.0.1'; # IP por defecto del router
	my $prompt = $_[4] || '/VFMN0001222915>/'; # Prompt del router

	return bless({
		usuario => $usuario,
		password => $password,
		ip => $ip_router,
		prompt => $prompt,
		conexion => undef
	});
}

sub conectar {
	my $self = $_[0];
	
	unless( $self->{conexion} ) {
		$self->{conexion} = Net::Telnet->new(Host => $self->{ip}, Prompt=>$self->{prompt})
			|| die(__PACKAGE__.'->conectar() ERROR: No se ha podido establercer la conexion con el router');
		
		$self->{conexion}->login($self->{usuario}, $self->{password});
	}
	
	return $self;
}

sub ejecutarComando {
	my $self = $_[0];
	my $comando = $_[1] || die(__PACKAGE__.'->ejecutarComando ERROR: Comando no definido');
	
	my $salida = undef;
	
	eval {
		$salida = join("\n", $self->conectar()->{conexion}->cmd($comando));
		chomp($salida);
	};
	if ($@) {
		die(__PACKAGE__.'->ejecutarComando() ERROR: FAllo en ejecucion de comando. Detalles: '.$@);
	}
	
	return $salida;
}

1;
