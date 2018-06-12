require 'action_mailer'
require File.dirname(__FILE__) + "/catch_all/version"

module ActionMailer
  module CatchAll
    class << self
      def enabled?
        ActionMailer::Base.instance_methods.include?(:mail_aliased_from_action_mailer_staging)
      end

      def enable(*options)
        if options.length == 1 && options[0].is_a?(Hash)
          hash = options[0]

          whitelist_email_addresses = Array(hash[:whitelist]).flatten.compact
          fallback_email_addresses = Array(hash[:fallback]).flatten.compact
        else
          whitelist_email_addresses = options.flatten.compact
          fallback_email_addresses = whitelist_email_addresses
        end

        if fallback_email_addresses.length == 0
          Kernel.warn("No email addresses passed to ActionMailer::CatchAll!")
        end

        if enabled?
          disable
        end

        ActionMailer::Base.class_eval do
          alias_method :mail_aliased_from_action_mailer_staging, :mail

          define_method :mail do |*args, &block|
            mailer = mail_aliased_from_action_mailer_staging(*args, &block)

            to_values = Array(mailer[:to]).map do |field|
              field.value
            end

            # save the original to header
            mailer['X-Action-Mailer-Staging-Original-Email-To'] = to_values.inspect

            selected_to_addresses = to_values.select do |to|
              whitelist_email_addresses.any? do |email|
                if email.is_a?(Regexp)
                  email =~ to
                else
                  email == to
                end
              end
            end

            if selected_to_addresses.any?
              mailer[:to] = selected_to_addresses
            else
              mailer[:to] = fallback_email_addresses
            end

            mailer
          end
        end
      end

      def disable
        if enabled?
          ActionMailer::Base.class_eval do
            alias_method :mail, :mail_aliased_from_action_mailer_staging
            remove_method :mail_aliased_from_action_mailer_staging
          end
        end
      end
    end
  end
end
