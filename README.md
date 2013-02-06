# ActionMailer::CatchAll

ActionMailer::CatchAll is a simple module to define a white-list of email addresses, used for staging environments.

## Usage

  Gemfile:

    gem 'catch_all'

  $ bundle install

  config/initializers/email_catch_all.rb:

    if Rails.env.staging?
      ActionMailer::CatchAll.enable('scott@railsnewbie.com')
    end


