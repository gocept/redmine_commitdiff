# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require_dependency 'mailer'


class CommitMailer < Mailer

  layout nil

  def diff(changeset)
    redmine_headers 'Project' => changeset.project.identifier,
                    'Changeset-Id' => changeset.id

    headers['return-path'] = Setting.mail_from

    subject "#{changeset.project.name} - #{changeset.short_comments}"
    recipients changeset.recipients
    sent_on changeset.committed_on
    from changeset.committer
    body :cs => changeset
  end

end
