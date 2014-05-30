package Alias;
use strict;
use Comando;

sub new {
	return bless( { alias => &Comando::__cargaConfiguraciones()->{alias}});
}

sub traducirAlias {
	my $self = $_[0];
	my $comando = $_[1];
	my $parametros= $_[2];
	
	# Si los parametros no son las referencias adecuadas, no modificamos nada	
	return 1 unless( (ref($comando) eq 'SCALAR') && (ref($parametros) eq 'ARRAY') );
	
	# Si el comando no es un alias, no modificamos nada
	return 1 unless( defined($self->{alias}->{$$comando}));
	
	# Modificamos el comando y convertimos el array de parametros para que lleve nuestras opciones	
	($$comando, @$parametros) = ( @{$self->{alias}->{$$comando}}, @$parametros );
}

1;
