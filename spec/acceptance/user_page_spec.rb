require File.dirname(__FILE__) + '/acceptance_helper'

feature "User Page", %q{
  In order to manage users
  As an admin
  I want to see the user page
} do

  before :each do
    fake_pivotal_api

    sign_in_as "user@amberbit.com"
  end

  describe "Employee hourly rate" do

    describe "Admin " do
      before :each do
        u = User.first
        u.admin = true
        u.save!

        click_link 'Projects'
        click_link 'Users'
      end

      scenario 'View hourly rates' do
        rate_field = find_field('rate')
        rate_field.value.should eql "0.00"
      end

      scenario "Set hourly rate" do
        fill_in 'rate', with: '50.00'
        click_button 'Set'

        User.first.employee_hourly_rates.last.rate.should eql(5000)
      end
    end
  end
end
