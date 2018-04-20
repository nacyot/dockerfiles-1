use strict;
use warnings;

sub substitute_env {
  my($content, $env) = @_;
  $content =~ s/\{\{$env\}\}/$ENV{$env}/g;
  return $content;
}

my $template = "";

open my $sample_config_file, '<', '/etc/pgbouncer/config.ini.sample' or die "Can't open file $!";
my $file_content = do { local $/; <$sample_config_file> };

$file_content = substitute_env($file_content, 'POSTGRES_HOST');
$file_content = substitute_env($file_content, 'POSTGRES_PORT');
$file_content = substitute_env($file_content, 'PGBOUNCER_LISTEN_HOST');
$file_content = substitute_env($file_content, 'PGBOUNCER_LISTEN_PORT');
$file_content = substitute_env($file_content, 'PGBOUNCER_POOL_MODE');
$file_content = substitute_env($file_content, 'PGBOUNCER_MAX_CLIENT_CONN');
$file_content = substitute_env($file_content, 'PGBOUNCER_DEFAULT_POOL_SIZE');
$file_content = substitute_env($file_content, 'PGBOUNCER_IDLE_TIMEOUT');

$template = $template . $file_content;

open(my $config_file, '>', '/etc/pgbouncer/config.ini');
print $config_file $template;
close $config_file;

open(my $user_file, '>', '/etc/pgbouncer/userlist.txt');
print $user_file "\"$ENV{'PGBOUNCER_USER'}\" \"\"\n";
close $user_file;
