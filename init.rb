# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require 'redmine'


Redmine::Plugin.register :redmine_commitdiff do
  name 'Redmine Commitdiff plugin'
  author 'Wolfgang Schnerring'
  description 'Send an email with the changeset diff'
  version '0.0.1'
end
