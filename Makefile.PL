use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'          => 'Lingua::TT::Yanalif',
    'VERSION_FROM'  => 'Yanalif.pm',
    'EXE_FILES'     => ['tatarlat'],
    'PREREQ_PM'     => {
        'Unicode::Lite' => 0.12,
    },
);
