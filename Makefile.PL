# Generated by git-ship. See 'git-ship --man' for help or https://github.com/jhthorsen/app-git-ship
use ExtUtils::MakeMaker;
my %WriteMakefileArgs = (
  NAME           => 'Mojolicious::Plugin::Mailgun',
  AUTHOR         => 'Marcus Ramberg <marcus.ramberg@gmail.com>',
  LICENSE        => 'artistic_2',
  ABSTRACT_FROM  => 'lib/Mojolicious/Plugin/Mailgun.pm',
  VERSION_FROM   => 'lib/Mojolicious/Plugin/Mailgun.pm',
  EXE_FILES      => [qw()],
  BUILD_REQUIRES => {}
,
  TEST_REQUIRES  => {
  'Test::More' => '0.88'
}
,
  PREREQ_PM      => {
  'Carp' => '0',
  'Mojolicious' => '7.0',
  'perl' => 'v5.10.0'
}
,
  META_MERGE     => {
    'dynamic_config' => 0,
    'meta-spec'      => {version => 2},
    'resources'      => {
      bugtracker => {web => 'https://github.com/marcusramberg/mojolicious-plugin-mailgun/issues'},
      homepage   => 'https://github.com/marcusramberg/mojolicious-plugin-mailgun',
      repository => {
        type => 'git',
        url  => 'https://github.com/marcusramberg/mojolicious-plugin-mailgun.git',
        web  => 'https://github.com/marcusramberg/mojolicious-plugin-mailgun',
      },
    },
  },
  test => {S => (-e 'META.yml' ? 't/*.t' : 't/*.t xt/*.t')},
);

unless (eval { ExtUtils::MakeMaker->VERSION('6.63_03') }) {
  my $test_requires = delete $WriteMakefileArgs{TEST_REQUIRES};
  @{$WriteMakefileArgs{PREREQ_PM}}{keys %$test_requires} = values %$test_requires;
}

WriteMakefile(%WriteMakefileArgs);
