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
    text.gsub(/\b[a-f0-9]{12}\b/, 'REV')
  end

  def test_basic_email_format
    cs = @repos.latest_changeset

    @expected.date = cs.committed_on
    @expected.from = cs.committer
    @expected.to = 'nobody@localhost'
    @expected.subject = 'eCookbook - Multiple changes'
    @expected.body = read_fixture('basic_email')

    @actual = CommitMailer.create_diff(cs, 'nobody@localhost')
    assert_equal(
      normalize_revisions(@expected.encoded),
      normalize_revisions(@actual.encoded))
  end

end
