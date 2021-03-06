# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require 'redmine'
require_dependency 'changeset_patch'


Redmine::Plugin.register :redmine_commitdiff do
  name 'Redmine Commitdiff plugin'
  author 'Wolfgang Schnerring'
  description 'Send an email with the changeset diff'
  version '0.0.1'
end


# note to self: run test with
# rake test:plugins:units PLUGIN=redmine_commitdiff
