# frozen_string_literal: true

class ImportErrorMailer < ApplicationMailer
  default from: Rails.application.credentials.mail.from
  ERROR_CONTACT_EMAIL = Rails.application.credentials.error_contact

  def import_errors
    @import = params[:import]
    @class_name = @import.class.name

    mail(to: ERROR_CONTACT_EMAIL,
      subject: I18n.t('imports.email.subject', class_name: @class_name, error_count: @import.import_errors.count))
  end
end
