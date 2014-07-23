require 'spec_helper'

describe "Absence pages" do

  subject { page }

  let(:user) { create(:user) }
  let(:submit) { "Add Leave" }

  before do
    sign_in user
    visit absences_path
  end

  describe "absence creation" do

    describe "with invalid information" do

      it "should not create an absence" do
        expect { click_button "Add Leave" }.not_to change(Absence, :count)
      end

      describe "error messages" do
        before { click_button "Add Leave" }
        it { should have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do

      before do
        fill_in "Date from",        with: "23/07/2014"
        fill_in "Date to",     with: "23/07/2014"
        page.select('Holiday', from: 'Absence type')
        fill_in "Description", with: "Test Description.."
      end

      it "should create an absence" do
        expect { click_button submit }.to change(Absence, :count).by(1)
      end

      describe "after saving the absence" do
        before { click_button submit }

        it { should have_selector('div.alert.alert-success', text: I18n.t('absence_created')) }
      end
    end
  end

  describe "days remaining widget" do

    context 'default' do
      it { should have_selector('span', text: '25') }
    end

    context 'changed year' do
      let!(:absence) {Absence.create!(date_from: "23/07/2015", date_to: "23/07/2015",
                                    description: "Test description", holiday_status_id: 1, absence_type_id: 1,
                                    user_id: user.id)}

      before {page.select('Oct 2015 to Sept 2016', from: 'holiday_year[id]') }

      # TODO: Fix this test. Testing a AJAX function (which works)
      it { should have_selector('span', text: '24') }
    end

  end
end