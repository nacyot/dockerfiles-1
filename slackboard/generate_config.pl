use strict;
use warnings;

# ex) TAGS_CONFIG="clamav|#dev-monitoring|clamav|:imp:||log_to_s3|#dev-monitoring|log-to-s3|:truck:"

my $config = $ENV{'TAGS_CONFIG'};
my @keys = ('tag', 'channel', 'username', 'icon_emoji');
my @tags = split /\|\|/, $config;
my $template = "";

my $port = $ENV{'PORT'};
my $slack_url = $ENV{'SLACK_URL'};
my $qps = $ENV{'QPS'};
my $max_delay_duration = $ENV{'MAX_DELAY_DURATION'};

open my $sample_toml_file, '<', '/tmp/config.toml.sample' or die "Can't open file $!";
my $file_content = do { local $/; <$sample_toml_file> };

$file_content =~ s/\{\{PORT\}\}/$port/g;
$file_content =~ s/\{\{SLACK_URL\}\}/$slack_url/g;
$file_content =~ s/\{\{QPS\}\}/$qps/g;
$file_content =~ s/\{\{MAX_DELAY_DURATION\}\}/$max_delay_duration/g;
$template = $template . $file_content;

for my $tag (@tags) {
    my @tag_config = split /\|/, $tag;
    $template = $template . "\n[[tags]]\n";

    while (my ($i, $value) = each @tag_config) {
        $template = $template . $keys[$i] . " = \"" . $value . "\"" . "\n";
    }
}

open(my $config_toml_file, '>', '/tmp/config.toml');
print $config_toml_file $template;
close $config_toml_file;
