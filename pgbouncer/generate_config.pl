use strict;
use warnings;

sub substitute_env {
  my($content, $env) = @_;
  $content =~ s/\{\{$env\}\}/$ENV{$env}/g;
  return $content;
}

my $template = '';

open my $sample_config_file, '<', '/etc/pgbouncer/config.ini.sample' or die "Can't open file $!";
my $file_content = do { local $/; <$sample_config_file> };

$template = $file_content;
$template = substitute_env($template, 'POSTGRES_HOST');
$template = substitute_env($template, 'POSTGRES_PORT');
$template = substitute_env($template, 'PGBOUNCER_LISTEN_HOST');
$template = substitute_env($template, 'PGBOUNCER_LISTEN_PORT');
$template = substitute_env($template, 'PGBOUNCER_POOL_MODE');
$template = substitute_env($template, 'PGBOUNCER_MAX_CLIENT_CONN');
$template = substitute_env($template, 'PGBOUNCER_DEFAULT_POOL_SIZE');
$template = substitute_env($template, 'PGBOUNCER_IDLE_TIMEOUT');

if ($ENV{TLS_ENABLE} eq 'true') {
  $template = $template . "\nserver_tls_sslmode = " . $ENV{TLS_SSLMODE};
  $template = $template . "\nserver_tls_ca_file = " . $ENV{TLS_CA_FILE};
  $template = $template . "\n";
}

open(my $config_file, '>', '/etc/pgbouncer/config.ini');
print $config_file $template;
close $config_file;

open(my $user_file, '>', '/etc/pgbouncer/userlist.txt');
print $user_file "\"$ENV{'PGBOUNCER_USER'}\" \"\"\n";
close $user_file;
