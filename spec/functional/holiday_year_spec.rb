require 'spec_helper'

describe UsBankHolidays::HolidayYear do

  it 'should determine bank holidays' do
    UsBankHolidays::HolidayYear.new(2017).bank_holidays.should == [
      '2017-01-02', #New Year’s Day
                                          '2017-01-16', #Birthday of Martin Luther King, Jr.
                                          '2017-02-20', #Washington’s Birthday
                                          '2017-05-29', #Memorial Day
                                          '2017-07-04', #Independence Day
                                          '2017-09-04', #Labor Day
                                          '2017-10-09', #Columbus Day
                                          '2017-11-10', #Veterans Day
                                          '2017-11-23', #Thanksgiving Day
                                          '2017-12-25' #Christmas Day
    ].map{|d| Date.parse(d) }
  end

  it 'should declare Dec. 31 a bank holiday if it falls on a Friday' do
    UsBankHolidays::HolidayYear.new(2021).bank_holidays.last.should == Date.new(2021, 12, 31)
  end
end