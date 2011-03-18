# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path


class ActionMailer::TestCase
  # original uses hardcoded path from RAILS_ROOT, which of course doesn't work
  def read_fixture(action)
    IO.readlines(File.join(
      ActiveSupport::TestCase.fixture_path,
      self.class.mailer_class.name.underscore,
      action))
  end
end
