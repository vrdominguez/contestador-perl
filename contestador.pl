#!/usr/bin/perl
#==============================================================================
#     ARCHIVO: contestador.pl
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Lanzador de comandos para el contestador
#==============================================================================
sub BEGIN {
	##
	# 
	# Calculamos la ruta real a la aplicacion, aunque se lance desde un enlace
	# y nos cambiamos a ella, asi evitamos problemas de ruta
	#
	# Este bloque de codigo (BEGIN) se ejecutara antes de aplicar los "use"
	#
	use File::Basename;
	my $origen = (caller(0))[1];
	if (my $ruta_real = readlink((caller(0))[1])) {
		chdir(dirname($ruta_real));
	}
	else {
		chdir(dirname($origen));
	}	
}

use Comando;
use strict;

my $comando = shift(@ARGV);
my @argumentos = @ARGV;


unless($comando) {
	print "No se ha definido comando a ejecutar.\nUso: contestador <comando> [<argumentos>]\n";
	exit 1;
}


my $comandos_disponibes = &Comando::comandosDisponibles();

unless(lc($comando) ~~ @$comandos_disponibes) {
	print "Comando no soportado '$comando'.\nLos comandos validos son: " . join(', ', @$comandos_disponibes)."\n";
	exit 1;
}

eval {
	print &Comando::instanciarComando($comando)->params(@argumentos)->ejecutar();
};
if ($@) {
	my $error = $@;
	# Eliminamos la ruta al codigo y la linea del error
	$error =~ s/\s+at\s+\/?[\w\d\/\.\-]+\s+line\s+\d+\.$//;
	
	print "Error ejecutando $comando. Detalles: $error";
	exit 1;
}

exit 0;
