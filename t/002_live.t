# --perl--
use strict;
use warnings;
use JSON::XS qw{encode_json};

use Test::More tests => 3;
BEGIN { use_ok('SMS::Send::Adapter::Node::Red') };

my $ini_file = '/etc/SMS-Send.ini';
my $phone    = $ENV{'SMS_SEND_ADAPTER_NODE_RED_TEST_PHONE'};

SKIP: {
  skip "SMS_SEND_ADAPTER_NODE_RED_TEST_PHONE not set", 2  unless $phone;
  die("Error: $ini_file not readable") unless -r $ini_file;
  my $time    = time;
  my $content = encode_json({to=>$phone, text=>"Test: $0 ($time)"});
  my $adapter = SMS::Send::Adapter::Node::Red->new(content=>$content);
  isa_ok($adapter, 'SMS::Send::Adapter::Node::Red');
  my $sent    = $adapter->send_sms;
  ok($sent, 'send_sms status');
  diag($adapter->status) if $adapter->status ne 200;
  diag($adapter->error)  if $adapter->error;
}
