# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require_dependency 'changeset'


# patch an existing model class as described by
# <http://www.redmine.org/wiki/1/Plugin_Internals>
module ChangesetPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      after_create :send_diff
    end
  end

  module InstanceMethods
    def send_diff
      CommitMailer.deliver_diff(self)
    end

    def recipients
      notified = project.notified_users
      notified.reject! {|user| !visible?(user)}
      notified.collect(&:mail)
    end

    def visible?(user=nil)
      (user || User.current).allowed_to?(:view_issues, self.project)
    end

    def diff
      if previous
        repository.diff(nil, previous.revision, revision)
     else
        repository.diff(nil, revision, nil)
      end
    end

    def branch
      # XXX seems to never return anything useful
      repository.scm.revisions(nil, revision).first.branch or '(unknown)'
    end
  end
end


Changeset.send(:include, ChangesetPatch)
