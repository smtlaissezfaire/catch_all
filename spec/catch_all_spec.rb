require File.dirname(__FILE__) + '/../lib/catch_all'

class Notifier < ActionMailer::Base
  def notify
    mail(:to => "scott@learnup.me")
  end

  def notify_multiple
    mail(:to => ["scott@learnup.me", "kenny@learnup.me"])
  end

  def notify_with_name
    mail(:to => "Scott Taylor <scott@learnup.me>")
  end

  def notify_no_address
    mail()
  end
end

describe ActionMailer::CatchAll do
  before :each do
    ActionMailer::CatchAll.disable
  end

  after :all do
    ActionMailer::CatchAll.disable
  end

  it "should disable properly" do
    ActionMailer::CatchAll.disable
    ActionMailer::CatchAll.disable
  end

  it "should override the to address when enabled" do
    ActionMailer::CatchAll.enable("scott@railsnewbie.com")
    mailer = Notifier.notify
    mailer.to.should == ["scott@railsnewbie.com"]
  end

  it "should use the correct email" do
    ActionMailer::CatchAll.enable("foo@railsnewbie.com")
    mailer = Notifier.notify
    mailer.to.should == ["foo@railsnewbie.com"]
  end

  it "should allow a list of emails" do
    ActionMailer::CatchAll.enable(["foo@railsnewbie.com", "bar@railsnewbie.com"])
    mailer = Notifier.notify
    mailer.to.should == ["foo@railsnewbie.com", "bar@railsnewbie.com"]
  end

  it "should allow a list of emails in splatted format" do
    ActionMailer::CatchAll.enable("foo@railsnewbie.com", "bar@railsnewbie.com")
    mailer = Notifier.notify
    mailer.to.should == ["foo@railsnewbie.com", "bar@railsnewbie.com"]
  end

  it "should send an email to the intended recipient if on the list (and only to the intended recipient)" do
    ActionMailer::CatchAll.enable("scott@learnup.me", "bar@railsnewbie.com")
    mailer = Notifier.notify
    mailer.to.should == ["scott@learnup.me"]
  end

  it "should only email the intersection of the lists" do
    ActionMailer::CatchAll.enable("scott@learnup.me", "scott@railsnewbie.com")
    mailer = Notifier.notify
    mailer.to.should == ["scott@learnup.me"]
  end

  it "should allow for <> in the email format" do
    ActionMailer::CatchAll.enable("scott@learnup.me")
    mailer = Notifier.notify
    mailer.to.should == ["scott@learnup.me"]
  end

  it "should email even if no :to address is specified" do
    ActionMailer::CatchAll.enable('scott@railsnewbie.com')
    mailer = Notifier.notify_no_address
    mailer.to.should == ["scott@railsnewbie.com"]
  end

  it "should set a header with the original to address" do
    ActionMailer::CatchAll.enable('scott@railsnewbie.com')
    mailer = Notifier.notify
    mailer['X-Action-Mailer-Staging-Original-Email-To'].value.should == "[\"scott@learnup.me\"]"
  end
end