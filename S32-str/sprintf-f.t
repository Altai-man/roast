use v6;

#BEGIN %*ENV<PERL6_TEST_DIE_ON_FAIL> = True;
use Test;

# Test combinations of flags for "%f".  The @info array is intialized with
# the flags (as a string), the size/precision specification (either a
# string or a # number), and the expected strings for the values 0, 1, 2.71
# and -2.71.  The flags values will be expanded to all possible permutations to
# ensure that the order of the flags is irrelevant.  Each flag permutation is
# combined with the size/permutation value to create a proper format string.

my ($v0, $v1, $v4, $vm) =
                          0 ,          1 ,       2.71 ,      -2.71 ;
my @info = ( # |------------|------------|------------|------------|
             # no size or size explicitely 0
       '',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
      ' ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '0',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '0 ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '+',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '+ ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '+0',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '+0 ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
      '-',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '-+',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '- ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
    '-+ ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '-0',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '-+0',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '-0 ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '#',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '# ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
     '#0',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '#0 ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
     '#+',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#+ ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#+0',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '#+0 ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '#-',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '#-+',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#- ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
   '#-+ ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#-0',   '',  "0.000000",  "1.000000",  "2.710000", "-2.710000",
   '#-+0',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '#-0 ',   '', " 0.000000", " 1.000000", " 2.710000", "-2.710000",
  '#-+0 ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",
  '#-+0 ',   '', "+0.000000", "+1.000000", "+2.710000", "-2.710000",

             # no size, precision 0
       '', '.0',         "0",         "1",         "3",        "-3",
      ' ', '.0',        " 0",        " 1",        " 3",        "-3",
      '0', '.0',         "0",         "1",         "3",        "-3",
     '0 ', '.0',        " 0",        " 1",        " 3",        "-3",
      '+', '.0',        "+0",        "+1",        "+3",        "-3",
     '+ ', '.0',        "+0",        "+1",        "+3",        "-3",
     '+0', '.0',        "+0",        "+1",        "+3",        "-3",
    '+0 ', '.0',        "+0",        "+1",        "+3",        "-3",
      '-', '.0',         "0",         "1",         "3",        "-3",
     '-+', '.0',        "+0",        "+1",        "+3",        "-3",
     '- ', '.0',        " 0",        " 1",        " 3",        "-3",
    '-+ ', '.0',        "+0",        "+1",        "+3",        "-3",
     '-0', '.0',         "0",         "1",         "3",        "-3",
    '-+0', '.0',        "+0",        "+1",        "+3",        "-3",
    '-0 ', '.0',        " 0",        " 1",        " 3",        "-3",
   '-+0 ', '.0',        "+0",        "+1",        "+3",        "-3",
      '#', '.0',         "0",         "1",         "3",        "-3",
     '# ', '.0',        " 0",        " 1",        " 3",        "-3",
     '#0', '.0',         "0",         "1",         "3",        "-3",
    '#0 ', '.0',        " 0",        " 1",        " 3",        "-3",
     '#+', '.0',        "+0",        "+1",        "+3",        "-3",
    '#+ ', '.0',        "+0",        "+1",        "+3",        "-3",
    '#+0', '.0',        "+0",        "+1",        "+3",        "-3",
   '#+0 ', '.0',        "+0",        "+1",        "+3",        "-3",
     '#-', '.0',         "0",         "1",         "3",        "-3",
    '#-+', '.0',        "+0",        "+1",        "+3",        "-3",
    '#- ', '.0',        " 0",        " 1",        " 3",        "-3",
   '#-+ ', '.0',        "+0",        "+1",        "+3",        "-3",
    '#-0', '.0',         "0",         "1",         "3",        "-3",
   '#-+0', '.0',        "+0",        "+1",        "+3",        "-3",
   '#-0 ', '.0',        " 0",        " 1",        " 3",        "-3",
  '#-+0 ', '.0',        "+0",        "+1",        "+3",        "-3",

             # 2 positions, usually doesn't fit
       '',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
      ' ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '0',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '0 ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '+',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '+ ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '+0',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '+0 ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
      '-',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '-+',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '- ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
    '-+ ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '-0',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '-0 ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
    '-+0',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '-+0 ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
      '#',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '# ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
     '#0',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '#0 ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
     '#+',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#+ ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#+0',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '#+0 ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '#-',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '#-+',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#- ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
   '#-+ ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#-0',    2,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
   '#-+0',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '#-0 ',    2, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
  '#-+0 ',    2, "+0.000000", "+1.000000", "+2.710000", "-2.710000",

             # 8 positions, should always fit
       '',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
      ' ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '0',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '0 ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
      '+',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '+ ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '+0',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '+0 ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
      '-',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '-+',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '- ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
    '-+ ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '-0',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '-0 ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
    '-+0',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '-+0 ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
      '#',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
     '# ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
     '#0',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '#0 ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
     '#+',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#+ ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#+0',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
   '#+0 ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
     '#-',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
    '#-+',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#- ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
   '#-+ ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
    '#-0',    8,  "0.000000",  "1.000000",  "2.710000", "-2.710000",
   '#-0 ',    8, " 0.000000", " 1.000000", " 2.710000", "-2.710000",
   '#-+0',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",
  '#-+0 ',    8, "+0.000000", "+1.000000", "+2.710000", "-2.710000",

             # 8 positions with precision, precision fits sometimes
       '',  8.2,  "    0.00",  "    1.00",  "    2.71",  "   -2.71",
      ' ',  8.2,  "    0.00",  "    1.00",  "    2.71",  "   -2.71",
      '0',  8.2,  "00000.00",  "00001.00",  "00002.71",  "-0002.71",
     '0 ',  8.2,  " 0000.00",  " 0001.00",  " 0002.71",  "-0002.71",
      '+',  8.2,  "   +0.00",  "   +1.00",  "   +2.71",  "   -2.71",
     '+ ',  8.2,  "   +0.00",  "   +1.00",  "   +2.71",  "   -2.71",
     '+0',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
    '+0 ',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
      '-',  8.2,  "0.00    ",  "1.00    ",  "2.71    ",  "-2.71   ",
     '-+',  8.2,  "+0.00   ",  "+1.00   ",  "+2.71   ",  "-2.71   ",
     '- ',  8.2,  " 0.00   ",  " 1.00   ",  " 2.71   ",  "-2.71   ",
    '-+ ',  8.2,  "+0.00   ",  "+1.00   ",  "+2.71   ",  "-2.71   ",
# NOTE: all the ".xxx" are bogus, but provided by the current implementation
     '-0',  8.2,  "0000.000",  "0001.000",  "0002.710",  "-0002.71",
    '-+0',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
    '-0 ',  8.2,  " 0000.00",  " 0001.00",  " 0002.71",  "-0002.71",
   '-+0 ',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
      '#',  8.2,  "    0.00",  "    1.00",  "    2.71",  "   -2.71",
     '# ',  8.2,  "    0.00",  "    1.00",  "    2.71",  "   -2.71",
     '#0',  8.2,  "00000.00",  "00001.00",  "00002.71",  "-0002.71",
    '#0 ',  8.2,  " 0000.00",  " 0001.00",  " 0002.71",  "-0002.71",
     '#+',  8.2,  "   +0.00",  "   +1.00",  "   +2.71",  "   -2.71",
    '#+ ',  8.2,  "   +0.00",  "   +1.00",  "   +2.71",  "   -2.71",
    '#+0',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
   '#+0 ',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
     '#-',  8.2,  "0.00    ",  "1.00    ",  "2.71    ",  "-2.71   ",
    '#-+',  8.2,  "+0.00   ",  "+1.00   ",  "+2.71   ",  "-2.71   ",
    '#- ',  8.2,  " 0.00   ",  " 1.00   ",  " 2.71   ",  "-2.71   ",
   '#-+ ',  8.2,  "+0.00   ",  "+1.00   ",  "+2.71   ",  "-2.71   ",
# NOTE: all the ".xxx" are bogus, but provided by the current implementation
    '#-0',  8.2,  "0000.000",  "0001.000",  "0002.710",  "-0002.71",
   '#-+0',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",
   '#-0 ',  8.2,  " 0000.00",  " 0001.00",  " 0002.71",  "-0002.71",
  '#-+0 ',  8.2,  "+0000.00",  "+0001.00",  "+0002.71",  "-0002.71",

).map: -> $flags, $size, $r0, $r1, $r4, $rm {
    my @flat;
    @flat.append('%' ~ $_ ~ $size ~ 'f', $r0, $r1, $r4, $rm)
      for $flags.comb.permutations>>.join;
    |@flat
}

plan @info/5;

for @info -> $format, $r0, $r1, $r4, $rm {
    subtest {
        plan 4;

        is sprintf($format, $v0), $r0,
          "sprintf('$format',$v0) eq '$r0'";
        is sprintf($format, $v1), $r1,
          "sprintf('$format',$v1) eq '$r1'";
        is sprintf($format, $v4), $r4,
          "sprintf('$format',$v4) eq '$r4'";
        is sprintf($format, $vm), $rm,
          "sprintf('$format',$vm) eq '$rm'";
    }, "Tested '$format'";
}

# vim: ft=perl6
