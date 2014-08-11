# NAME

Taxon::Parse - Parse bio Taxon names

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
