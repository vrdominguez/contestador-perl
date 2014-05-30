#!/usr/bin/perl
#==============================================================================
#     ARCHIVO: Comando.pm
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Clase base para los comandos del contestador Raspberry Pi
#==============================================================================
package Comando;

use strict;
use YAML;
use Cwd qw(abs_path);
use File::Basename;
	
# --- metodos de clase -------------------------------------------------------------
sub instanciarComando {
	my $comando = shift;

	#comando siempre debe tener el mismo formato: todo mininusculas menos la primera letra
	$comando = ucfirst(lc($comando));
	
	my $class = "Comando::$comando";
	my $ruta = "Comando/$comando\.pm";
	
	eval {
		require $ruta; 
	};
	if ($@) {
		die("Error cargando la clase necesaria para ejecutar $comando. Detalles: $@");
	}
	
	return $class->new();
}


sub comandosDisponibles {
	my $ruta_base = dirname(abs_path(__FILE__));
	my @lista_comandos = `ls $ruta_base/Comando/`;
	
	foreach my $comando (@lista_comandos) {
		chomp $comando;
		$comando =~ s/\.pm$//g;
		$comando = lc($comando);
	}
	
	return \@lista_comandos;
}

# --- metodos para objetos ---------------------------------------------------------
sub new {
	my $self = bless({'usuario' => $ENV{CONTACT_NICK}}, $_[0]);
	$self->{configuraciones} = $self->__cargaConfiguraciones();
	
	return $self;
}

sub __cargaConfiguraciones {
	# Calculamos la ruta al fichero de configuracion
	my $fichero_config = dirname(abs_path(__FILE__)) . '/config.yml';
	
	# Abrimos el fichero de configuracion
	open(my $fichero, '<', $fichero_config)
		 || die('No se pudo cargar la configuracion');
	my $config = &YAML::LoadFile($fichero);
	close($fichero);
	
	return $config;
}

sub params {
	my $self = $_[0];
	
	die("Metodo no definido, es necesario reescribirlo en cada comando");
}

sub ejecutar {
	my $self = $_[0];
	
	die("Metodo no definido, es necesario reescribirlo en cada comando");
}

sub soloAdministradores {
	my $self = $_[0];
	
	die "Permisos insuficinetes" unless ( $self->{usuario} ~~ @{$self->{configuraciones}->{administradores}} ); 
	
	return 1;
}

1;
