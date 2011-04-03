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

  def set_recipient(project, value)
    field = CustomField.find_by_name('Send Diff Emails To')
    project.custom_field_values = { field.id => value }
    assert project.save!
  end

  def test_no_recipient_configured_does_not_send_email
    CommitMailer.expects(:deliver_diff).never
    @cs.send_diff
  end

  def test_sends_email_to_recipient_configured_in_custom_field
    set_recipient(@cs.project, 'foo@localhost')
    CommitMailer.expects(:deliver_diff).with(@cs, 'foo@localhost')
    @cs.send_diff
  end

  def test_looks_for_configuration_in_parent_projects
    @cs.repository.project = projects(:projects_003)
    set_recipient(@cs.project.parent, 'foo@localhost')
    CommitMailer.expects(:deliver_diff).with(@cs, 'foo@localhost')
    @cs.send_diff
  end

end
