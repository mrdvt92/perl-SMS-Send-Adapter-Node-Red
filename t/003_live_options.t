# --perl--
use strict;
use warnings;
use JSON::XS qw{encode_json};
use Config::IniFiles;

use Test::More tests => 3;
BEGIN { use_ok('SMS::Send::Adapter::Node::Red') };

my $phone  = $ENV{'SMS_SEND_ADAPTER_NODE_RED_TEST_PHONE'};
my $driver = $ENV{'SMS_SEND_ADAPTER_NODE_RED_TEST_DRIVER'} || 'VoIP::MS';

SKIP: {
  skip "SMS_SEND_ADAPTER_NODE_RED_TEST_PHONE not set", 2  unless $phone;
  my $ini_file = '/etc/SMS-Send.ini';
  die("Error: INI $ini_file not readabe") unless -r $ini_file;
  my $cfg      = Config::IniFiles->new(-file=>$ini_file);
  my %options  = map {$_ => $cfg->val($driver, $_)} $cfg->Parameters($driver);
  my $time     = time;
  my $content  = encode_json({driver=>$driver, to=>$phone, text=>"Test: $0 ($time)", options=>\%options});
  my $adapter  = SMS::Send::Adapter::Node::Red->new(content=>$content);
  isa_ok($adapter, 'SMS::Send::Adapter::Node::Red');
  my $sent     = $adapter->send_sms;
  ok($sent, 'send_sms status');
  diag($adapter->status) if $adapter->status ne 200;
  diag($adapter->error)  if $adapter->error;
}
