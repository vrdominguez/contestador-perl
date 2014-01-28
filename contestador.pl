#!/usr/bin/perl
#==============================================================================
#     ARCHIVO: contestador.pl
#       AUTOR: Victor Rodriguez - victor <at> vrdominguez.es
# DESCRIPCION: Lanzador de comandos para el contestador
#==============================================================================
BEGIN {
	use Cwd qw(abs_path);
	use File::Basename;
	
	# Incluimos en @INC la ruta con el codigo del contestador 
	push @INC, dirname(abs_path(__FILE__));

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
