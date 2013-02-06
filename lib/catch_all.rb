require 'action_mailer'

module ActionMailer
  module CatchAll
    class << self
      def enable(*to_addresses)
        to_addresses = to_addresses.flatten

        ActionMailer::Base.class_eval do
          if instance_methods.include?(:mail_aliased_from_action_mailer_staging)
            ActionMailerStaging.disable
          end

          alias_method :mail_aliased_from_action_mailer_staging, :mail

          define_method :mail do |*args, &block|
            mailer = mail_aliased_from_action_mailer_staging(*args, &block)

            to_values = Array(mailer[:to]).map do |field|
              field.value
            end

            # save the original to header
            mailer['X-Action-Mailer-Staging-Original-Email-To'] = to_values.inspect
            selected_to_addresses = to_values.select { |to| to_addresses.include?(to) }
            if selected_to_addresses.any?
              mailer[:to] = selected_to_addresses
            else
              mailer[:to] = to_addresses
            end

            mailer
          end
        end
      end

      def disable
        ActionMailer::Base.class_eval do
          if instance_methods.include?(:mail_aliased_from_action_mailer_staging)
            alias_method :mail, :mail_aliased_from_action_mailer_staging
            remove_method :mail_aliased_from_action_mailer_staging
          end
        end
      end
    end
  end
end