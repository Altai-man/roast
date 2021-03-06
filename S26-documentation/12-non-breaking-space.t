use v6;

use MONKEY-SEE-NO-EVAL;
use Test;

my $f = './.tmp-test-file2';
#unlink $f if $f.IO.e;

my $code = gen-test($f);

say "See file '$f'";

EVAL $code;
#END { unlink $f }

##### subroutines #####
sub gen-test($f) {
    my $fh = open $f, :w;
    #LEAVE try close $fh;

    $fh.print: q:to/HERE/;
    use v6;

    # two-column table with various whitespace chars
    =begin table
    HERE

    # non-breaking ws chars
    my @nbchars = [
        0x00A0, # NO-BREAK SPACE
        0x202F, # NARROW NO-BREAK SPACE
        0x2060, # WORD JOINER
        0xFEFF, # ZERO WIDTH NO-BREAK SPACE
    ];
    # breaking ws chars
    my @bchars = [
        # don't use the vertical chars for this test which is single-line oriented
        #0x000A, # LINE FEED (LF)              vertical
        #0x000B, # LINE TABULATION             vertical
        #0x000C, # FORM FEED (FF)              vertical
        #0x000D, # CARRIAGE RETURN (CR)        vertical
        #0x2028, # LINE SEPARATOR              vertical
        #0x2029, # PARAGRAPH SEPARATOR         vertical

        0x0009, # CHARACTER TABULATION
        0x0020, # SPACE
        0x1680, # OGHAM SPACE MARK
        0x180E, # MONGOLIAN VOWEL SEPARATOR
        0x2000, # EN QUAD <= normalized to 0x2002
        0x2001, # EM QUAD <= normalized to 0x2003
        0x2002, # EN SPACE
        0x2003, # EM SPACE
        0x2004, # THREE-PER-EM SPACE
        0x2005, # FOUR-PER-EM SPACE
        0x2006, # SIX-PER-EM SPACE
        0x2007, # FIGURE SPACE                <= unicode considers this non-breaking, but we won't
        0x2008, # PUNCTUATION SPACE
        0x2009, # THIN SPACE
        0x200A, # HAIR SPACE                  <= PROBLEM
        0x205F, # MEDIUM MATHEMATICAL SPACE
        0x3000, # IDEOGRAPHIC SPACE
    ];

    # make one testing row per non-breaking space char
    for @nbchars -> $nbc {
        # first column
        my $row = "Perl";
        $row ~= $nbc.chr;
        $row ~= "6";
        for @bchars -> $c {
            $row ~= $c.chr;
        }
        $row ~= "is the best!";

        # second column
        $row ~= ' | ';
        $row ~= "Perl ";
        $row ~= $nbc.chr;
        $row ~= " 6";
        for @bchars -> $c {
            $row ~= $c.chr;
        }
        $row ~= "is the best!";

        $fh.say: $row;
    }
    $fh.say: "=end table";

    $fh.say;

    my $n = +@nbchars;
    # the planned num of tests is 1 + $n
    $fh.say: "plan 1 + $n * 2;";
    $fh.say: "my \$n = $n;";
    $fh.say: "my \$SPACE = ' ';";

    $fh.print: q:to/HERE/;
    my $r = $=pod[0];
    is $r.contents.elems, $n, "table has $n elements (rows)";
    HERE

    # create separate sub-tests for each non-breaking space char
    for 0..^$n -> $i {
        $fh.say;
        $fh.say: '{';
        $fh.say: "my \$i = $i;";
        $fh.say: "my \$row = $i + 1;";
        $fh.say: "my \$nbspc = \"{@nbchars[$i].chr}\";";

        $fh.print: q:to/HERE/;
        my $res0 = "Perl{$nbspc}6 is the best!";
        my $res1 = "Perl {$nbspc} 6 is the best!";
        # show cell chars separated by pipes
        =begin comment
        my $c0 = $r.contents[$i][0].comb.join('|');
        my $r0 = $res0.comb.join('|');
        my $c1 = $r.contents[$i][1].comb.join('|');
        my $r1 = $res1.comb.join('|');
        =end comment
        my $c0 = show-space-chars($r.contents[$i][0]);
        my $r0 = show-space-chars($res0);
        my $c1 = show-space-chars($r.contents[$i][1]);
        my $r1 = show-space-chars($res1);

        is $r.contents[$i][0], $res0, "row $row, col 1: '$c0' vs '$r0'";
        is $r.contents[$i][1], $res1, "row $row, col 2: '$c1' vs '$r1'";

        HERE

        $fh.say: '}';
    }

    $fh.print: q:to/HERE/;
    ##### some subroutines for the EVALed file #####
    sub int2hexstr($int, :$plain) {
        # given an int, convert it to a hex string
        if !$plain {
            return sprintf("0x%04X", $int);
        }
        else {
            return sprintf("%X", $int);
        }
    }

    sub show-space-chars($str) {
        # given a string with space chars, return a version with the
        # hex code shown for them and place a pipe separating all
        # chars in the original string
        my @c = $str.comb;
        my $new-str = '';
        for @c -> $c {
            $new-str ~= '|' if $new-str;
            if $c ~~ /\s/ {
                my $int = $c.ord;
                my $hex-str = int2hexstr($int);
                $new-str ~= $hex-str;
            }
            else {
                =begin comment
                $new-str ~= $c;
                =end comment
                my $int = $c.ord;
                my $hex-str = int2hexstr($int, :plain);
                $new-str ~= $hex-str;
            }
        }
        return $new-str;
    }
    HERE


    $fh.close;

    return slurp $f;
}
