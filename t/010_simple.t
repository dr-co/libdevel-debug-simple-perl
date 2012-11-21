use warnings;
use strict;
use utf8;
use open qw(:std :utf8);
use lib qw(lib ../lib blib ../blib);

use Test::More tests => 6;

BEGIN {
    # Подготовка объекта тестирования для работы с utf8
    my $builder = Test::More->builder;
    binmode $builder->output,         ":utf8";
    binmode $builder->failure_output, ":utf8";
    binmode $builder->todo_output,    ":utf8";

    use_ok 'Devel::Debug::Simple';
}

can_ok 'main', 'DEBUG';
can_ok 'main', 'DEBUGF';
can_ok 'main', 'DEBUGSUB';
can_ok 'main', 'DEBUGDUMP';

ok !DEBUG( 1 ), 'Can`t enable in tests';
DEBUGSUB( sub{ ok $_[0] eq 'OK', 'Not applicable in tests' }, 'OK');

=head1 COPYRIGHT

Copyright (C) 2011 Dmitry E. Oboukhov <unera@debian.org>

Copyright (C) 2011 Roman V. Nikolaev <rshadow@rambler.ru>

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
