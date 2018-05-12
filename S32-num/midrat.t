use v6;
use Test;

# Tests for MidRat type

plan 2;

subtest 'creation; too-large Rat literals get promoted to MidRats' => {
    plan 10;

    cmp-ok  0.0000000000000000001.WHAT,  '=:=', Rat, 'decimal literal';
    cmp-ok <0.0000000000000000001>.WHAT, '=:=', Rat,
        'angle brackets decimal literal';
    cmp-ok <1/9999999999999999999>.WHAT, '=:=', Rat,
        'angle brackets fraction literal';
    cmp-ok Rat.new(1, 9999999999999999999).WHAT, '=:=', Rat,
        'Rat.new';

    cmp-ok  0.00000000000000000001.WHAT,  '=:=', MidRat, 'decimal literal';
    cmp-ok <0.00000000000000000001>.WHAT, '=:=', MidRat,
        'angle brackets decimal literal';
    cmp-ok <1/99999999999999999999>.WHAT, '=:=', MidRat,
        'angle brackets fraction literal';
    cmp-ok Rat.new(1, 99999999999999999999).WHAT, '=:=', MidRat,
        'Rat.new with too large denominator produces MidRat';
    cmp-ok MidRat.new(1, 2).WHAT, '=:=', MidRat,
        'MidRat.new';

    cmp-ok (1/99999999999999999999).WHAT, '=:=', Num,
        'plain Int division with too-large denominator does NOT produce MidRat';
}

subtest 'typing/coercion' => {
    plan 41;

    # Coercion FROM MidRat
    my \mr-lo := MidRat.new: 1, 2;
    my \mr-hi := MidRat.new: 1, my \large-den := 99999999999999999999;

    isa-ok mr-lo, Rat,    'MidRat inherits from a Rat';
    isa-ok mr-lo, FatRat, 'MidRat inherits from a FatRat';
    isa-ok mr-lo, MidRat;

    cmp-ok mr-lo.Numeric, '===', mr-lo, '.Numeric (small MidRat)';
    cmp-ok mr-hi.Numeric, '===', mr-hi, '.Numeric (large MidRat)';
    cmp-ok mr-lo.Real,    '===', mr-lo, '.Real (small MidRat)';
    cmp-ok mr-hi.Real,    '===', mr-hi, '.Real (large MidRat)';

    is-deeply mr-lo.Rat, ½, '.Rat (small MidRat)';
    cmp-ok    mr-hi.Rat, '=:=', Rat,  '.Rat (large MidRat) right type';
    is-approx mr-hi.Rat, 1/large-den, '.Rat (large MidRat) right value';

    is-deeply mr-lo.FatRat, FatRat.new(1, 2        ), '.FatRat (small MidRat)';
    is-deeply mr-hi.FatRat, FatRat.new(1, large-den), '.FatRat (large MidRat)';

    is-deeply mr-lo.Num, .5e0, '.Num (small MidRat)';
    cmp-ok    mr-hi.Num, '=:=', Num,  '.Num (large MidRat) right type';
    is-approx mr-hi.Num, 1/large-den, '.Num (large MidRat) right value';

    is-deeply mr-lo.Int, 0, '.Int (small MidRat)';
    is-deeply mr-hi.Int, 0, '.Int (large MidRat)';
    is-deeply MidRat.new(5, 2).Int, 2, '.Int (custom, non-zero MidRat)';

    is-deeply mr-lo.Complex, <.5+0i>, '.Complex (small MidRat)';
    cmp-ok    mr-hi.Complex, '=:=', Complex,
        '.Complex (large MidRat) right type';
    is-approx mr-hi.Complex, 1/large-den + i,
        '.Complex (large MidRat) right value';

    is-deeply mr-lo.Str, '0.5',        '.Str (small MidRat)';
    cmp-ok    mr-hi.Str, '=:=', Str,   '.Str (large MidRat) right type';
    is-approx mr-hi.Str.MidRat, mr-hi, '.Str (large MidRat) right value';

    is-deeply mr-lo.gist, '0.5',        '.gist (small MidRat)';
    cmp-ok    mr-hi.gist, '=:=', Str,   '.gist (large MidRat) right type';
    is-approx mr-hi.gist.MidRat, mr-hi, '.gist (large MidRat) right value';

    cmp-ok mr-lo.perl.EVAL, '===', mr-hi,
        '.perl.EVAL roundtrip (small MidRat)';
    cmp-ok mr-hi.perl.EVAL, '===', mr-hi,
        '.perl.EVAL roundtrip (large MidRat)';

    is-deeply mi-lo.narrow, ½, '.narrow (small MidRat)';
    is-deeply mi-hi.narrow, FatRat.new(1, large-den), '.narrow (large MidRat)';


    # Coercion TO MidRat
    is-deeply '0.5'.MidRat, mr-lo, 'Str.MidRat (small)';
    is-deeply '0.00000000000000000001'.MidRat, 0.00000000000000000001,
        'Str.MidRat (large)';
    is-deeply 421.MidRat, MidRat.new(421, 1), 'Int.MidRat';
    is-deeply 2e0.MidRat, MidRat.new(2,   1), 'Num.MidRat';

    is-deeply <2+0i>.MidRat, MidRat.new(2,1), 'Complex.MidRat (near zero i)';
    throws-like ｢<2+42i>.MidRat｣, X::Numeric::Real, 'Complex.MidRat (large i)';

    is-deeply ½.MidRat,   MidRat.new(1,   2), 'Rat.MidRat';
    is-deeply FatRat.new(1, 99999999999999999999).MidRat,
        mr-hi, 'FatRat.MidRat';
    cmp-ok    mr-lo.MidRat, '===', mr-lo, 'MidRat.MidRat (small MidRat)';
    cmp-ok    mr-hi.MidRat, '===', mr-hi, 'MidRat.MidRat (large MidRat)';
}

# vim: ft=perl6