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
      to = send_diff_recipient
      CommitMailer.deliver_diff(self, to) unless to.blank?
    end

    def send_diff_recipient
      project = self.project
      while project
        value = project.custom_value_for(
          CustomField.find_by_name('Send Diff Emails To'))
        return value.to_s if value
        project = project.parent
      end
    end

    def diff
      if previous
        repository.diff(nil, previous.revision, revision)
     else
        repository.diff(nil, revision, nil)
      end
    end
  end
end


Changeset.send(:include, ChangesetPatch)
