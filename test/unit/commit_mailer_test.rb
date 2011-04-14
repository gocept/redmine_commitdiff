# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')


class CommitMailerTest < ActionMailer::TestCase

  fixtures :projects

  def setup
    bundle = File.join(ActiveSupport::TestCase.fixture_path, 'example.hg')

    @tmpdir = Dir.mktmpdir()
    system "hg init #@tmpdir"
    system "hg -q -R #@tmpdir unbundle #{bundle}"

    @repos = Repository.factory('Mercurial')
    @repos.url = @tmpdir
    @repos.project = projects(:projects_001)
    assert @repos.save!

    @repos.fetch_changesets
  end

  def teardown
    FileUtils.rm_rf @tmpdir
  end

  def normalize_revisions(text)
    text.gsub!(/\b[a-f0-9]{12}\b/, 'REV')
  end

  def normalize_id(text)
    text.gsub!(/(X-Redmine-Changeset-Id: )[0-9]+/, '\\1ID')
  end

  def normalize(text)
    normalize_revisions(text)
    normalize_id(text)
    text
  end

  def test_basic_email_format
    cs = @repos.latest_changeset

    @expected.date = cs.committed_on
    @expected.from = cs.committer
    @expected.subject = 'eCookbook - Multiple changes'
    @expected.body = read_fixture('basic_email')
    @expected['X-Redmine-Project'] = 'ecookbook'
    @expected['X-Redmine-Changeset-Id'] = '42'
    @expected['X-Mailer'] = 'Redmine'
    @expected['X-Redmine-Host'] = Setting.host_name
    @expected['X-Redmine-Site'] = Setting.app_title
    @expected['Precedence'] = 'bulk'
    @expected['Auto-Submitted'] = 'auto-generated'

    @actual = CommitMailer.create_diff(cs)
    assert_equal(normalize(@expected.encoded), normalize(@actual.encoded))
  end

end
