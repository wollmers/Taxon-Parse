# NAME

Taxon::Parse - Parse bio Taxon names

<div>

</div>

<a href="https://travis-ci.org/wollmers/Taxon-Parse"><img src="https://travis-ci.org/wollmers/Taxon-Parse.png" alt="Taxon-Parse"></a>
<a href='https://coveralls.io/r/wollmers/Taxon-Parse?branch=master'><img src='https://coveralls.io/repos/wollmers/Taxon-Parse/badge.png?branch=master' alt='Coverage Status' /></a>

# SYNOPSIS

    use Taxon::Parse;
    Taxon::Parse->new();
    

# DESCRIPTION

`Taxon::Parse` is the base module providing utility methods for parsers.

# METHODS

## new

    my $object = Taxon::Parse->new();
    

## pattern

    my $regex = $object->pattern($pattern_name);

## pattern\_parts

    my $regex = $object->pattern_parts($pattern_name);
    

# SOURCE REPOSITORY

[http://github.com/wollmers/Taxon-Parse](http://github.com/wollmers/Taxon-Parse)

# AUTHOR

Helmut Wollmersdorfer, <helmut.wollmersdorfer@gmail.com>

# COPYRIGHT AND LICENSE

Copyright (C) 2013-2014 by Helmut Wollmersdorfer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
