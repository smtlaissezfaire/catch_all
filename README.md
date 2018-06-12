# ActionMailer::CatchAll

ActionMailer::CatchAll is a simple module to define a white-list of email addresses, used for staging environments.

If the emailed user is on the whitelist, it sends to that user.

If the user isn't on the whitelist, it sends to the fallback email address(es).

## Usage

  Gemfile:

    gem 'catch_all'

  config/initializers/email_catch_all.rb:

    if Rails.env.staging?
      ActionMailer::CatchAll.enable('scott@railsnewbie.com')
    end

  Or, if you want to use a whitelist of domains:

    if Rails.env.staging?
      ActionMailer::CatchAll.enable({
        whitelist: [/\@railsnewbie.com$/, /\@example.com$/],
        fallback: 'scott@railsnewbie.com',
      })
    end
