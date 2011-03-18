# Copyright (c) 2011 gocept gmbh & co. kg
# See also LICENSE.txt

class CommitMailer < ActionMailer::Base

  def diff(sent_at = Time.now)
    subject    'CommitMailer#diff'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

end
