require 'rails_helper'

RSpec.describe GEFProjectImport, type: :model do
  context 'on create' do
    let(:gef_project_import) { build(:gef_project_import, status: 'completed') }
    let(:gef_project_import_with_errors) { build(:gef_project_import, :with_errors, status: 'completed') }

    it 'does not send an email notification if there were not errors in the import' do
      expect(ImportErrorMailer).not_to receive(:with)
      gef_project_import.save
    end

    it 'sends an email notification if there were errors in the import' do
      dbl = double('Mailer', import_errors: double('MailerMethod', deliver_later: nil))
      expect(ImportErrorMailer).to receive(:with).once.and_return(dbl)
      gef_project_import_with_errors.save
    end
  end
end
