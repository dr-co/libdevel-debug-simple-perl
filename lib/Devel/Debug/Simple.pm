use strict;
use warnings;
use utf8;

package Devel::Debug::Simple;
use base qw(Exporter);
our @EXPORT = qw(DEBUG DEBUGF DEBUGSUB DEBUGDUMP);

use POSIX       qw(strftime);
use Test::More;
use Encode      qw(decode_utf8);

our $VERSION = '0.1';

my $ENABLE;
my $IN_TEST;

BEGIN {
    # Disable if console not exists
    unless( -t STDERR ) {
        $ENABLE = 0;
        return;
    }
    # Disable in tests
    if( $0 =~ m{\.t$} ) {
        $IN_TEST = 1;
        return;
    }
}

=head1 NAME

Devel::Debug::Simple - Simple perl debug module use standart output.

=head1 SINOPSYS

    use Devel::Debug::Simple;
    # Enable debug messages
    DEBUG( 1 );
    # Disable debug messaged
    DEBUG( 0 );

    # Print debug message
    DEBUGF('Some debug info "%s"', $foo);

    # Run you debug code
    DEBUGSUB( sub{ ... }, $foo, $bar );

    # Dumper
    DEBUGDUMP( $foo );

=cut

=head1 FUNCTIONS

=cut

=head2 DEBUG $enable

Enable/Disable debug messaged. Default: disable.

=cut

sub DEBUG($) {
    my ($enable) = @_;

    # Если хотим выключить то всегда пожалуйста
    return $ENABLE = 0 unless $enable;
    # Если нет консоли то не включаем
    return $ENABLE = 0 unless -t STDERR;

    return $ENABLE = 1;
}

=head2 DEBUGF $message, @opts

Same as printf but check for debug enabled. Print some debug info in begin of
string.

=cut

sub DEBUGF($@) {
    my ($message, @opts) = @_;

    return unless $ENABLE;

    $| = 1 unless $|;

    my ($module, undef, $line) = caller;
    my $time = strftime("%Y-%m-%d %H:%M:%S", localtime);

    $_ = decode_utf8($_) for $message, @opts;
    my $str  = sprintf "[%s][%s line:%s] $message\n",
        $time, $module, $line, @opts;

    # Для тестов выведем отладку в специальном формате
    ($IN_TEST)
        ? note $str
        : print STDERR $str;

    return $str;
}

=head2 DEBUGSUB $cb, @opts

Run some subroutine if debug enabled.

Note if you want to output some strings you must to it in STDERR.

=cut

sub DEBUGSUB(&@) {
    my ($cb, @opts) = @_;

    return unless $ENABLE;

    $| = 1 unless $|;

    return $cb->(@opts);
}

=head2 DEBUGDUMP @opts

Print dump of input vars.

=cut

sub DEBUGDUMP(@) {
    my (@opts) = @_;

    return unless $ENABLE;

    require Data::Dumper;

    {
        no warnings 'once';
        local $Data::Dumper::Indent     = 1;
        local $Data::Dumper::Terse      = 1;
        local $Data::Dumper::Useqq      = 1;
        local $Data::Dumper::Deepcopy   = 1;
        local $Data::Dumper::Maxdepth   = 0;
    }

    return DEBUGF( Data::Dumper::Dumper(\@opts) );
}

1;

=head1 COPYRIGHT

Copyright (C) 2011 Dmitry E. Oboukhov <unera@debian.org>

Copyright (C) 2011 Roman V. Nikolaev <rshadow@rambler.ru>

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
