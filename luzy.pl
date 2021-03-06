#!/usr/bin/env perl

BEGIN {
    use FindBin;
    use lib "$FindBin::Bin/lib";
}

use Mojolicious::Lite;

plugin Luzy => {
    cache_options => {
        namespace          => 'luzy',
        auto_purge_on_set  => 1,
        default_expires_in => 600,
        cache_root         => app->home->rel_dir('content_cache'),
    },
    no_auto_route => 1,
    plugins       => []
};

get '/(*everything)' => [ everything => qr(.*) ] => ( cms => 1 ) => 'cms';

get '/tag/(*tag)' => [ tag => qr(.+) ] => 'tag';

app->start;

__DATA__
@@ cms.html.ep
<html><body>
<h1><%= $cms_content->title %></h1>
<h2>Resolved Content</h2>
<%== resolve $cms_content %>
<h2>Content</h2>
<%== $cms_content %>
<h2>Raw</h2>
<%== $cms_content->raw %>
<hr />
Content Tags: 
% my $tags = $cms_content->tags;
% for my $tag (@$tags) {
<a href="/tag/<%= $tag %>"><%= $tag %></a>
% }
<hr />
All Tags: 
% $tags = cms_all_tags $cms_language;
% for my $tag (@$tags) {
<a href="/tag/<%= $tag %>"><%= $tag %></a>
% }
</body></html>

@@ tag.html.ep
<html><body>
<h1>Tag <%== $tag %></h1>
% my $list = cms_list_by_tag $tag;
% for my $c (@$list)  {
<a href="<%= $c->path %>"><%= $c->title %></a><br />
% }
</body></html>
__END__
