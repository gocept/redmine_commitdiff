# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')


class SendDiffTest < ActiveSupport::TestCase

  fixtures :repositories, :projects

  def setup
    @cs = Changeset.new(
      :repository => repositories(:repositories_002),
      :revision => 1,
      :committed_on => Time.now,
      :commit_date => Time.now
    )
  end

  def test_send_diff_is_called_in_addition_to_other_after_create_hooks
    @cs.expects(:send_diff)
    @cs.expects(:scan_comment_for_issue_ids)
    assert @cs.save!
  end

end
