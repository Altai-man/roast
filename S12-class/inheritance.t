use v6;

use Test;

plan 37;

# L<S12/Single inheritance/An "isa" is just a trait that happens to be another class>

class Foo {
    has $.bar is rw;
    has $.value is rw;
    method baz { return 'Foo::baz' }
    method getme($self:) returns Foo { return $self }
}

class Foo::Bar is Foo {
    has $.bar2 is rw;
    method baz { return 'Foo::Bar::baz' }
    method fud { return 'Foo::Bar::fud' }
    method super_baz ($self:) { return $self.Foo::baz() }
}

class Unrelated {
    method something { 'bad' };
}

my $foo_bar = Foo::Bar.new();
isa_ok($foo_bar, Foo::Bar);

ok(!defined($foo_bar.bar2()), '... we have our autogenerated accessor');
ok(!defined($foo_bar.bar()), '... we inherited the superclass autogenerated accessor');

lives_ok { $foo_bar.bar = 'BAR' }, '... our inherited the superclass autogenerated accessor is rw';
is($foo_bar.bar(), 'BAR', '... our inherited the superclass autogenerated accessor is rw');

lives_ok { $foo_bar.bar2 = 'BAR2'; }, '... our autogenerated accessor is rw';

is($foo_bar.bar2(), 'BAR2', '... our autogenerated accessor is rw');

is($foo_bar.baz(), 'Foo::Bar::baz', '... our subclass overrides the superclass method');

is($foo_bar.super_baz(), 'Foo::baz', '... our subclass can still access the superclass method through Foo::');
is($foo_bar.fud(), 'Foo::Bar::fud', '... sanity check on uninherited method');

is($foo_bar.getme, $foo_bar, 'can call inherited methods');
is($foo_bar.getme.baz, "Foo::Bar::baz", 'chained method dispatch on altered method');

ok(!defined($foo_bar.value), 'value can be used for attribute name in derived classes');
my $fud;

lives_ok { $fud = $foo_bar.getme.fud }, 'chained method dispatch on altered method';
is($fud, "Foo::Bar::fud", "returned value is correct");

is $foo_bar.Foo::baz, 'Foo::baz', '$obj.Class::method syntax works';
#?pugs todo
dies_ok { $foo_bar.Unrelated::something() },
    'Cannot call unrelated method with $obj.Class::method syntax';

# See thread "Quick OO .isa question" on p6l started by Ingo Blechschmidt:
# L<"http://www.nntp.perl.org/group/perl.perl6.language/22220">

ok  Foo::Bar.isa(Foo),      "subclass.isa(superclass) is true";
ok  Foo::Bar.isa(Foo::Bar), "subclass.isa(same_subclass) is true";
#?pugs skip 'No compatible multi variant found: "&isa"'
ok Foo::Bar.HOW.isa(Foo::Bar, Foo),      "subclass.HOW.isa(superclass) is true";
#?pugs skip 'No compatible multi variant found: "&isa"'
ok Foo::Bar.HOW.isa(Foo::Bar, Foo::Bar), "subclass.HOW.isa(same_subclass) is true";

#?pugs todo
{
    my $test = '$obj.$meth is canonical (audreyt says)';
    class Abc {
        method foo () { "found" }
    }
    class Child is Abc { }
    is( eval('my $meth = "foo"; my $obj= Child.new; $obj."$meth"()'), 'found', $test);
}

# Erroneous dispatch found by TimToady++

class X {
    method j () { 'X' }
};
class Z is X {}
class Y is X {
    method k () { Z.new.j() }
    method j () { 'Y' }
};

is(Z.new.j(), 'X', 'inherited method dispatch works');
is(Y.new.k(), 'X', 'inherited method dispatch works inside another class with same-named method');

{
    my class A {
      has @.x = <a b c>;
      has $.w = 9;

      method y($i) { return @.x[$i]; }
    }

    my class B is A {
      has $.w = 10;
      method z($i) { return $.y($i); }
    }

    is( B.new.z(1), 'b', 'initializer carries through' );
    is( B.new.w, 10, 'initializer can be overridden by derived classes' );
}

# test that you can inherit from a class with :: in the name.
{
    class A::B {
        method ab { 'a'; };
    };

    class A::B::C is A::B {
        method abc { 'b'; };
    }
    my $o = A::B::C.new;

    ok defined($o), 'can instantiate object from class A::B::C';
    is $o.ab,  'a', 'can access inherited method';
    is $o.abc, 'b', 'can access directly defined method';
}

# Make sure inheritance from Mu works (got broken in Rakudo once).
eval_lives_ok 'class NotAny is Mu { }; NotAny.new', 'inheritance from Mu works';
{
    class DirectMu is Mu { };
    ok DirectMu !~~ Any, 'class inheriting from Mu is not Any';
    #?niecza skip 'Unable to resolve method parents in class ClassHOW'
    #?pugs skip 'No such method in class Class: "&parents"'
    ok !( any(DirectMu.^parents).gist eq 'Any()'), 'and Any does not appear in the list of parents either';
}

#?pugs todo
eval_dies_ok 'class RT64642 is ::Nowhere {}', 'dies: class D is ::C {}';

# check that inheriting from Array works
#?pugs skip "Can't modify constant item: VUndef"
{
    class ArrayChild is Array {
        method summary() { self.join(', ') }
    }

    my $a = ArrayChild.new;
    $a.push('foo');
    $a.push('bar');
    is $a.join('|'), 'foo|bar', 'inheritance from Array';
    is $a.summary, 'foo, bar', 'and ArrayChild methods work';

    my @a := ArrayChild.new;
    @a.push: 3, 5;
    is @a.summary, '3, 5', 'new methods still work in @ variables';

}

# RT #82814
#?pugs skip 'callsame'
{
    my class A {
        method new { self.bless(*) }
    };
    my class B is A {
        has $.c is rw;
        method new {
            my $obj = callsame;
            $obj.c = 42;
            return $obj
        }
    }
    is B.new.c, 42, 'nextsame in constructor works';
}

# vim: ft=perl6
