use strict;
use warnings;

# ------------------------------------------------------------
# Range. It is considered to include (end - start) items, from 'start'.

package Range;

sub new
{
    my $c = shift;
    $c = ref $c if ref $c;
    my $s = {};
    bless $s, $c;
    $s->{_start} = shift;
    $s->{_end} = shift;
    return undef unless defined $s->{_start} && defined $s->{_end};
    $s->{_size} = $s->{_end} - $s->{_start};
    return undef unless $s->{_size} >= 0;
    return $s;
}

sub start { return $_[0]->{_start}; }
sub end { return $_[0]->{_end}; }

sub copy
{
    my $s = shift;
    my $new = {};
    %$new = %$s;
    bless $new, ref $s;
    return $new;
}

sub equals
{
    my $s = shift;
    my $r = shift;
    return undef unless $r;
    return $s->start == $r->start && $s->end == $r->end;
}

sub intersect
{
    my $s = shift;
    my $r = shift;

    return undef unless $s->overlaps($r);

    my $start = $s->start > $r->start ? $s->start : $r->start;
    my $end = $s->end > $r->end ? $r->end : $s->end;
    return Range->new($start, $end);
}

sub add
{
    my $s = shift;
    my $val = shift;
    my $start = $s->start + $val;
    my $end = $s->end + $val;
    return Range->new($start, $end);
}

sub subtract
{
    my $s = shift;
    my $val = shift;
    return $s->add(-$val);
}

sub size
{
    my $s = shift;
    return $s->{_size};
}

sub contains_range
{
    my $s = shift;
    my $r = shift;
    return $r->equals($s->intersect($r));
}

sub contains
{
    my $s = shift;
    my $val = shift;
    return $s->start <= $val && $val < $s->end;
}

sub overlaps
{
    my $s = shift;
    my $r = shift;

    return $s->contains($r->start)
	|| $r->contains($s->start)
	|| ($r->start <= $s->start && $s->end < $r->end);
}

sub truncate_below
{
    my $s = shift;
    my $limit = shift;

    my $start = $s->start < $limit ? $limit : $s->start;
    my $end = $s->end < $limit ? $limit : $s->end;
    return Range->new($start, $end);
}

sub truncate_above
{
    my $s = shift;
    my $limit = shift;

    my $start = $s->start > $limit ? $limit : $s->start;
    my $end = $s->end > $limit ? $limit : $s->end;
    return Range->new($start, $end);
}

sub to_string
{
    my $s = shift;
    return sprintf "(0x%08x,0x%08x)", $s->start, $s->end;
#    return "(" . $s->start . "," . $s->end . ")";
}

1;
