use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => "Devel::Debug::Simple",
    VERSION_FROM    => "lib/Devel/Debug/Simple.pm",
    ABSTRACT_FROM   => "lib/Devel/Debug/Simple.pm",
    MAKEFILE        => 'Makefile',
    PREREQ_PM       => {
    'Data::Dumper'     => 0,
    },
    LICENSE         => 'GPLv3',
    AUTHOR          => [
        'Dmitry E. Oboukhov <unera@debian.org>,',
        'Roman V. Nikolaev <rshadow@rambler.ru>',
    ],
);