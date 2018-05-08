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

my @dbs = split /\|\|/, $ENV{'DATABASES'};
my $dbs_config = '';

for my $db (@dbs) {
    my @db_config = split /\|/, $db;
    $dbs_config = $dbs_config . $db_config[0] . " = host=" . $db_config[1] . " port=" . $db_config[2] . " dbname=" . $db_config[3] . "\n";
}

$template =~ s/\{\{DATABASES\}\}/$dbs_config/g;
$template = substitute_env($template, 'PGBOUNCER_LISTEN_HOST');
$template = substitute_env($template, 'PGBOUNCER_LISTEN_PORT');
$template = substitute_env($template, 'PGBOUNCER_POOL_MODE');
$template = substitute_env($template, 'PGBOUNCER_MAX_CLIENT_CONN');
$template = substitute_env($template, 'PGBOUNCER_DEFAULT_POOL_SIZE');
$template = substitute_env($template, 'PGBOUNCER_IDLE_TIMEOUT');
$template = substitute_env($template, 'PGBOUNCER_USER');
$template = substitute_env($template, 'PGBOUNCER_ADMIN_USERS');
$template = substitute_env($template, 'PGBOUNCER_STAT_USERS');
$template = substitute_env($template, 'PGBOUNCER_SERVER_ROUND_ROBIN');

if ($ENV{TLS_ENABLE} eq 'true') {
  $template = $template . "\nserver_tls_sslmode = " . $ENV{TLS_SSLMODE};
  $template = $template . "\nserver_tls_ca_file = " . $ENV{TLS_CA_FILE};
  $template = $template . "\n";
}

open(my $config_file, '>', '/etc/pgbouncer/config.ini');
print $config_file $template;
close $config_file;

open(my $user_file, '>', '/etc/pgbouncer/userlist.txt');
print $user_file "\"$ENV{'PGBOUNCER_USER'}\" \"$ENV{'PGBOUNCER_PASSWORD_MD5'}\"\n";
close $user_file;
