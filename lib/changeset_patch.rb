require_dependency 'changeset'


# patch an existing model class as described by
# <http://www.redmine.org/wiki/1/Plugin_Internals>
module ChangesetPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def diff
      repository.diff('', previous.revision, revision)
    end
  end
end


Changeset.send(:include, ChangesetPatch)
