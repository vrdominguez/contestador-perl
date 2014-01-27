#!/usr/bin/perl
#==============================================================================
#     ARCHIVO: contestador.pl
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Lanzador de comandos para el contestador
#==============================================================================
BEGIN {
	##
	# 
	# Este bloque de codigo (BEGIN) se ejecutara antes de aplicar los "use".
	# Gracias a esto, nos posicionamos en el directorio donde se encuentran
	# las fuentes para poder cargar las clases necesarias
	#
	use Cwd qw(abs_path);
	use File::Basename;
	chdir(dirname(abs_path(__FILE__)));
}

use strict;
use Comando;

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
