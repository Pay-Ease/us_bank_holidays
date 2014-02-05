require 'date'

require 'us_bank_holidays/version'
require 'us_bank_holidays/holiday_year'
require 'us_bank_holidays/month'

module UsBankHolidays

  def self.federal_holidays_list
    @federal_holidays_list ||= [
      '2014-01-01', #New Year’s Day
      '2014-01-20', #Birthday of Martin Luther King, Jr.
      '2014-02-17', #Washington’s Birthday
      '2014-05-26', #Memorial Day
      '2014-07-04', #Independence Day
      '2014-09-01', #Labor Day
      '2014-10-13', #Columbus Day
      '2014-11-11', #Veterans Day
      '2014-11-27', #Thanksgiving Day
      '2014-12-25', #Christmas Day

      '2015-01-01', #New Year’s Day
      '2015-01-19', #Birthday of Martin Luther King, Jr.
      '2015-02-16', #Washington’s Birthday
      '2015-05-25', #Memorial Day
      '2015-07-03', #Independence Day
      '2015-09-07', #Labor Day
      '2015-10-12', #Columbus Day
      '2015-11-11', #Veterans Day
      '2015-11-26', #Thanksgiving Day
      '2015-12-25', #Christmas Day

      '2016-01-01', #New Year’s Day
      '2016-01-18', #Birthday of Martin Luther King, Jr.
      '2016-02-15', #Washington’s Birthday
      '2016-05-30', #Memorial Day
      '2016-07-04', #Independence Day
      '2016-09-05', #Labor Day
      '2016-10-10', #Columbus Day
      '2016-11-11', #Veterans Day
      '2016-11-24', #Thanksgiving Day
      '2016-12-26', #Christmas Day

      '2017-01-02', #New Year’s Day
      '2017-01-16', #Birthday of Martin Luther King, Jr.
      '2017-02-20', #Washington’s Birthday
      '2017-05-29', #Memorial Day
      '2017-07-04', #Independence Day
      '2017-09-04', #Labor Day
      '2017-10-09', #Columbus Day
      '2017-11-10', #Veterans Day
      '2017-11-23', #Thanksgiving Day
      '2017-12-25', #Christmas Day

      '2018-01-01', #New Year’s Day
      '2018-01-15', #Birthday of Martin Luther King, Jr.
      '2018-02-19', #Washington’s Birthday
      '2018-05-28', #Memorial Day
      '2018-07-04', #Independence Day
      '2018-09-03', #Labor Day
      '2018-10-08', #Columbus Day
      '2018-11-12', #Veterans Day
      '2018-11-22', #Thanksgiving Day
      '2018-12-25', #Christmas Day

      '2019-01-01', #New Year’s Day
      '2019-01-21', #Birthday of Martin Luther King, Jr.
      '2019-02-18', #Washington’s Birthday
      '2019-05-27', #Memorial Day
      '2019-07-04', #Independence Day
      '2019-09-02', #Labor Day
      '2019-10-14', #Columbus Day
      '2019-11-11', #Veterans Day
      '2019-11-28', #Thanksgiving Day
      '2019-12-25', #Christmas Day

      '2020-01-01', #New Year’s Day
      '2020-01-20', #Birthday of Martin Luther King, Jr.
      '2020-02-17', #Washington’s Birthday
      '2020-05-25', #Memorial Day
      '2020-07-03', #Independence Day
      '2020-09-07', #Labor Day
      '2020-10-12', #Columbus Day
      '2020-11-11', #Veterans Day
      '2020-11-26', #Thanksgiving Day
      '2020-12-25'  #Christmas Day
    ].map {|date_str| Date.parse(date_str) }.freeze
  end

  def self.weekend?(date)
    date.sunday? || date.saturday?
  end

  def self.bank_holiday?(date)
    weekend?(date) || ::UsBankHolidays::HolidayYear.new(date.year).bank_holidays.include?(date)
  end

  def self.next_banking_day(date)
    if (next_date = date + 1).bank_holiday?
      next_banking_day(next_date)
    else
      next_date
    end
  end

  def self.previous_banking_day(date)
    if (previous_date = date - 1).bank_holiday?
      previous_banking_day(previous_date)
    else
      previous_date
    end
  end

  module DateMethods

    def weekend?
      ::UsBankHolidays.weekend? self
    end

    def bank_holiday?
      ::UsBankHolidays.bank_holiday? self
    end

    def next_banking_day
      ::UsBankHolidays.next_banking_day self
    end

    def previous_banking_day
      ::UsBankHolidays.previous_banking_day self
    end

    def add_banking_days(days)
      day = self
      if days > 0
        days.times { day = day.next_banking_day }
      elsif days < 0
        (-days).times { day = day.previous_banking_day }
      end
      day
    end
  end

end

::Date.class_eval do
  include ::UsBankHolidays::DateMethods
end
