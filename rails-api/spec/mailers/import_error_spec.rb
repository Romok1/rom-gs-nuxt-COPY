require 'rails_helper'

RSpec.describe ImportErrorMailer, type: :mailer do
  describe 'errors email' do
    let(:import) { create(:gef_project_import) }

    it 'sends import errors email in background job' do
      expect do
        described_class.with(import:).import_errors.deliver_later
      end.to have_enqueued_job.on_queue('mailer').exactly(:once)
    end
  end
end
