require 'rails_helper'

describe Events::StudentsController do
  let(:student_rsvp) { create(:student_rsvp) }
  let(:event) { student_rsvp.event }
  let(:organizer) { create(:user) }

  before do
    event.organizers << organizer
    sign_in organizer
  end

  describe '#index' do
    it 'responds successfully, with the right headers' do
      get :index, event_id: event.to_param, format: :csv
      assigns(:students).should == event.student_rsvps
      response.content_type.should == 'text/csv'
      response.should be_success

      csv_rows = CSV.parse(response.body)
      expect(csv_rows[0][0]).to eq('Student Name')
      expect(csv_rows[1][0]).to eq(student_rsvp.user.full_name)
    end
  end
end