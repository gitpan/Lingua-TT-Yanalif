package Lingua::TT::Yanalif;

use 5.005_62;
use strict;
use warnings;
use locale;
use utf8;
use base qw/Exporter/;
use POSIX qw/islower/;
our @EXPORT = our @EXPORT_OK = qw/cyr2lat/;
our $VERSION = "0.01";

no  warnings qw/once/;
use constant WAQ_SUZIQ  => "аоыуиеёэюя\x{4D9}\x{4E9}\x{4AF}";
use constant ZUR_SUZIQ  => "АОЫУИЕЁЭЮЯ\x{4D8}\x{4E8}\x{4AE}";
use constant SUZIQLAR   => WAQ_SUZIQ.ZUR_SUZIQ;
use constant WAQ_TARTIQ => "БВГДЖЗЙКЛМНПРСТФХЦЧШЩЬЪH\x{4A2}\x{496}\x{4BA}";
use constant ZUR_TARTIQ => "бвгджзйклмнпрстфхцчшщьъh\x{4A3}\x{497}\x{4BB}";
use constant TARTIQLAR  => WAQ_TARTIQ.ZUR_TARTIQ;

my $alter = sub($$){ return islower($_[0]) ? $_[1] : ucfirst($_[1]) };

sub cyr2lat(;$)
{
    my $str = scalar @_ ? $_[0] : defined wantarray ? $_ : \$_;

    for (ref $str ? $$str : $str)
    {
        s/\b(?=егет)/й/g;
        s/\bел(?=[днл]|гы|\b)/йыл/g;
        s/К(?=(?i)азан(?:[ыднлг]|\b))/\x{4A0}/g;
        s/(?<=ва)к/\x{4A1}/g;
        s/\bКазах/Къазакъ/g;
        s/\bказах/къазакъ/g;
        s/(?<=е)(в)(?=ро)/&$alter($1, 'у')/gei;

        # №37
        s/(?<=[аоуиыеёэюяАОУИЫЕЁЭЮЯ\x{4D9}\x{4E9}\x{4AF}\x{4D8}\x{4E8}\x{4AE}])ц(?=[аоуиыеёэюяАОУИЫЕЁЭЮЯ\x{4D9}\x{4E9}\x{4AF}\x{4D8}\x{4E8}\x{4AE}])/тс/go;
        s/(?<=[аоуиыеёэюяАОУИЫЕЁЭЮЯ\x{4D9}\x{4E9}\x{4AF}\x{4D8}\x{4E8}\x{4AE}])Ц(?=[аоуиыеёэюяАОУИЫЕЁЭЮЯ\x{4D9}\x{4E9}\x{4AF}\x{4D8}\x{4E8}\x{4AE}])/Тс/go;

        s/Г(?=[ъЪыЫаА])/\x{490}/g;
        s/г(?=[ъЪыЫаА])/\x{491}/g;
        s/K(?=[ъЪ])/\x{4A0}/g;
        s/k(?=[ъЪ])/\x{4A1}/g;
        s/В(?=[аоыъАОЫЪ])/\x{4B0}/g;
        s/в(?=[аоыъАОЫЪ])/\x{4B1}/g;

        # №33.1 Iskerme.2
        s/(?<=[иИ])я/\x{4D9}/g;
        s/(?<=[иИ])Я/\x{4D8}/g;
        s/(?<=[\x{4D9}\x{4D8}])я/й\x{4D9}/g;
        s/(?<=[\x{4D9}\x{4D8}])Я/й\x{4D8}/g;
        s/я/ya/g;
        s/Я/Ya/g;

        # №6 iskerme:
        # "a" hem "a:" xereflerden son kilgen "u" -> "w"
        s/(?<=\B[аА\x{4D8}\x{4D9}])У/\x{4B0}/g;
        s/(?<=\B[аА\x{4D8}\x{4D9}])У/\x{4B1}/g;

        # №31
        #s/(?<=\B[аА\x{4D8}\x{4D9}])В/\x{4B0}/g;
        #s/(?<=\B[аА\x{4D8}\x{4D9}])в/\x{4B1}/g;

        # №33.1 Iskerme.1
        s/ю/yu/g;
        s/Ю/Yu/g;

        # №33.1 Iskerme.3
        s/ё/yo/g;
        s/Ё/Yo/g;

        # №36
        s/щ/şç/g;
        s/Щ/Şç/g;

        # №60
        s/\BРГА\b/Р\x{490}А/g;
        s/\Bрга\b/р\x{491}а/g;

        tr/ьЬ/''/;
        tr/ъЪ//;

        tr/
            АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЭЫ\x{4D8}\x{4E8}\x{4AE}\x{4A2}\x{496}\x{4BA}\x{490}\x{4A0}\x{4B0}
            абвгдежзийклмнопрстуфхцчшэы\x{4D9}\x{4E9}\x{4AF}\x{4A3}\x{497}\x{4BB}\x{491}\x{4A1}\x{4B1}
        /
            ABVGDEJZİYKLMNOPRSTUFXSÇŞEIÄÖÜÑCHĞQW
            abvgdejziyklmnoprstufxsçşeıäöüñchğqw
        /;

        return $_ if defined wantarray;
    }

    $_ = $str if defined $_[0] and not ref $str;
}


1;

__END__

=head1 NAME

Lingua::TT::Yanalif - Converts text for Tatar language

=head1 SYNOPSIS

 use Lingua::TT::Yanalif;

 cyr2lat() for @iske_tatar_text_strings;
 print cyr2lat( $iske_tatar_text );

=head1 DESCRIPTION

Allow convert old cyrillic tatarish text to latin with new orfografy.

For converting a non-UTF-8 text, read "readme" file in "maps" subdir from
the package distribution.

=head1 AUTHOR

Albert Michauer <amichauer@cpan.org>

=cut
