# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

# note to self: run test with
# rake test:plugins:units PLUGIN=redmine_commitdiff


class CommitMailerTest < ActionMailer::TestCase
  test "diff" do
    @expected.subject = 'CommitMailer#diff'
    @expected.body    = read_fixture('diff')
    @expected.date    = Time.now

    assert_equal @expected.encoded, CommitMailer.create_diff(@expected.date).encoded
  end

end
