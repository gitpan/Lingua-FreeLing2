package Lingua::FreeLing2::ParseTree;

use warnings;
use strict;
use Try::Tiny;

use Lingua::FreeLing2::Bindings;

our $VERSION = "0.01";

=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::ParseTree - Interface to FreeLing2 ParseTree object

=head1 SYNOPSIS

   use Lingua::FreeLing2::ParseTree;

   $ptree = $sentence->parse_tree;

   $node_info = $ptree->info;


=head1 DESCRIPTION

=cut

sub _new_from_sentence {
    my ($class, $sentence) = @_;

    return undef unless $sentence->is_parsed();

    my @words = $sentence->words();
    my $tree = $class->_build_tree($sentence->{sentence}->get_parse_tree(), \@words);

    return $tree;
}

sub _build_tree {
    my ($class, $tree, $words) = @_;

    my $node = {
                label    => $tree->get_info()->get_label(),
                is_head  => $tree->get_info()->is_head(),
                is_chunk => $tree->get_info()->is_chunk(),
               };

    my $nchild = $tree->num_children();
    if ($nchild) {
        for my $i (0 .. $nchild-1) {
            $node->{child}[$i] = $class->_build_tree($tree->nth_child_ref($i), $words);
        }
    }
    else {
        $node->{word} = shift @$words;
    }
    return bless $node => $class;
}

=head2 ACCESSORS

=over 4

=item C<info>

Returns all available information for the node data as a hash reference.

=cut

# sub info {
#     my $self = shift;
#     my $childs = $self->num_children;
#     my $info = $self->SUPER::get_info;

#     my $word = undef;

#     my $label = $info->get_label;
#     print STDERR "$label has $childs children\n";
#     if (!$childs) {
#         $word = $info->get_word;
#     }

#     return {
#             label    => $info->get_label,
#             word     => $word,
#             is_head  => $info->is_head,
#             is_chunk => $info->is_chunk,
#            }
# }

=item C<child>

Returns the nth child.

=cut

# sub child {
#     my ($self, $id) = @_;
#     return ref($self)->_new_from_binding($self->nth_child_ref($id));
# }

=item C<num_children>

Returns the number of childs for this tree node.

=cut

# *nth_child = *Lingua::FreeLing2::Bindingsc::TreeNode_nth_child;
# *nth_child_ref = *Lingua::FreeLing2::Bindingsc::TreeNode_nth_child_ref;
# *get_info = *Lingua::FreeLing2::Bindingsc::TreeNode_get_info;
# *append_child = *Lingua::FreeLing2::Bindingsc::TreeNode_append_child;
# *hang_child = *Lingua::FreeLing2::Bindingsc::TreeNode_hang_child;
# *clear = *Lingua::FreeLing2::Bindingsc::TreeNode_clear;
# *empty = *Lingua::FreeLing2::Bindingsc::TreeNode_empty;
# *sibling_begin = *Lingua::FreeLing2::Bindingsc::TreeNode_sibling_begin;
# *sibling_end = *Lingua::FreeLing2::Bindingsc::TreeNode_sibling_end;
# *begin = *Lingua::FreeLing2::Bindingsc::TreeNode_begin;
# *end = *Lingua::FreeLing2::Bindingsc::TreeNode_end;

### getInfo returns ::node

##package Lingua::FreeLing2::ParseTreeNode;

# *get_label = *Lingua::FreeLing2::Bindingsc::node_get_label;
# *get_word = *Lingua::FreeLing2::Bindingsc::node_get_word;
# *set_word = *Lingua::FreeLing2::Bindingsc::node_set_word;
# *set_label = *Lingua::FreeLing2::Bindingsc::node_set_label;
# *is_head = *Lingua::FreeLing2::Bindingsc::node_is_head;
# *set_head = *Lingua::FreeLing2::Bindingsc::node_set_head;
# *is_chunk = *Lingua::FreeLing2::Bindingsc::node_is_chunk;
# *set_chunk = *Lingua::FreeLing2::Bindingsc::node_set_chunk;
# *get_chunk_ord = *Lingua::FreeLing2::Bindingsc::node_get_chunk_ord;



=pod

=back

=head2 METHODS

=over 4

=item C<dump>

Dumps the tree in a textual format, useful for debug purposes.

=cut

sub dump {
    my $tree = shift;

    my $label = $tree->{label};
    $label .= " (". $tree->{word}->get_form(). ")" if exists($tree->{word});

    $label .= "\n";

    my $indent = sub {
        my $str = shift;
        $str =~ s/^/  /mg;
        return $str;
    };

    for my $child (@{$tree->{child}}) {
        $label .= $indent->($child->dump);
    }

    return $label;
}

=pod

=back

=cut

1;

__END__


=head1 SEE ALSO

Lingua::FreeLing2(3) for the documentation table of contents. The
freeling library for extra information, or perl(1) itself.

=head1 AUTHOR

Alberto Manuel Brandão Simões, E<lt>ambs@cpan.orgE<gt>

Jorge Cunha Mendes E<lt>jorgecunhamendes@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011-2012 by Projecto Natura

=cut


