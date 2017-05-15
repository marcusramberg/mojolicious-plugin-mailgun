package Mojolicious::Plugin::Mailgun;

use Mojo::Base 'Mojolicious::Plugin';
use Carp 'croak';

our $VERSION = '0.02';

has base_url => sub { Mojo::URL->new('https://api.mailgun.net/v3/'); };
has ua       => sub { Mojo::UserAgent->new(); };
has config   => sub { +{} };

sub register {
  my ($self, $app, $conf) = @_;
  $self->config(keys %$conf ? $conf : $app->config->{mailgun});
  $self->_test_mode($app) if $ENV{MAILGUN_TEST} // $app->mode eq 'development';
  $self->base_url($conf->{base_url}) if $conf->{base_url};
  $app->helper(
    'mailgun.send' => sub {
      my ($c, $site, $mail, $cb) = @_;
      croak "No mailgun config for $site" unless my $config = $self->config->{$site};
      my $url = $self->base_url->clone;
      $url->path->merge($config->{domain} . '/messages');
      $url->userinfo('api:' . $config->{api_key});
      $self->ua->post($url, form => $mail, $cb);
      return $c;
    }
  );
}

sub _test_mode {
  my ($self, $app) = @_;
  $self->base_url($app->ua->server->nb_url->clone->path('/dummy/mail/'));
  $app->routes->post(
    '/dummy/mail/*domain/messages' => sub {
      my $c = shift;
      $c->render(json => {params => $c->req->params->to_hash, url => $c->req->url->to_abs});
    }
  );
}


1;

=head1 NAME

Mojolicious::Plugin::Mailgun - Easy Email sending with mailgun

=head1 SYNOPSIS

  # Mojolicious::Lite
  plugin 'mailgun' => { mom => {
    api_key => '123',
    domain => 'mom.no',
  }};

  # Mojolicious
  $self->plugin(mailgun => { mom => {
    site => {
      api_key => '123',
      domain => 'mom.no',
  }});

  # in controller named params
  $self->mailgun->send( mom => {
    recipient => 'pop@pop.com',
    subject   => 'use Perl or die;'
    html      => $html,
    inline    => { file => 'public/file.png' },
    sub { my $self,$res = shift },  # receives a Mojo::Transaction from mailgun.
  );


=head1 DESCRIPTION

Provides a quick and easy way to send email using the Mailgun API.

=head1 OPTIONS

L<Mojolicious::Plusin::Mailgun> can be provided a hash of mailgun sites with api key and domain, or
you can read them directly from the settings.


=head1 HELPERS

L<Mojolicious::Plugin::Mailgun> implements one helper.

=head2 mailgun->send <$site>, <$post_options>, <$cb>



=head1 METHODS

L<Mojolicious::Plugin::SMS> inherits all methods from L<Mojolicious::Plugin>
and implements the following new ones.

=head2 C<register>

$plugin->register;

Register plugin hooks and helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<SMS::Send>, L<SMS::Send::Test>.

=head1 AUTHOR

Marcus Ramberg <mramberg@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2017 by Marcus Ramberg.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
