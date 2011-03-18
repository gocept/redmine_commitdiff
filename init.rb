require 'redmine'

Redmine::Plugin.register :redmine_commitdiff do
  name 'Redmine Commitdiff plugin'
  author 'Wolfgang Schnerring'
  description 'Send an email with the changeset diff'
  version '0.0.1'
end
