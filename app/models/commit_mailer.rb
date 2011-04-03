# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

class CommitMailer < ActionMailer::Base

  def diff(changeset, to)
    subject "#{changeset.project.name} - #{changeset.short_comments}"
    recipients to
    sent_on changeset.committed_on
    from changeset.committer
    body :cs => changeset
  end

end
