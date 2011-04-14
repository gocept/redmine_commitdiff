# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

class CommitMailer < ActionMailer::Base

  def diff(changeset)
    subject "#{changeset.project.name} - #{changeset.short_comments}"
    recipients changeset.recipients
    sent_on changeset.committed_on
    from changeset.committer
    body :cs => changeset
  end

end
