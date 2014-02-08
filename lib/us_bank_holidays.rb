require 'date'

require 'us_bank_holidays/version'
require 'us_bank_holidays/holiday_year'
require 'us_bank_holidays/month'

module UsBankHolidays

  # Returns true if the given date is a weekend, false otherwise.
  def self.weekend?(date)
    date.sunday? || date.saturday?
  end

  # Returns true if the given date is a bank holiday, false otherwise.
  def self.bank_holiday?(date)
    weekend?(date) ||
      ::UsBankHolidays::HolidayYear.new(date.year).bank_holidays.include?(date)
  end

  # Returns true if the given date is a banking day, i.e. is not a bank holiday,
  # false otherwise.
  def self.banking_day?(date)
    !bank_holiday?(date)
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

  # Instance methods to be injected into the Date class
  module DateMethods

    # Returns true if the date if a weekend, false otherwise.
    def weekend?
      ::UsBankHolidays.weekend? self
    end

    # Returns true if the date is a bank holiday, false otherwise.
    def bank_holiday?
      ::UsBankHolidays.bank_holiday? self
    end

    # Returns the next banking day after this one.
    def next_banking_day
      ::UsBankHolidays.next_banking_day self
    end

    # Returns the previous banking day
    def previous_banking_day
      ::UsBankHolidays.previous_banking_day self
    end

    # Adds the given number of banking days, i.e. bank holidays don't count.
    # If days is negative, subtracts the given number of banking days.
    # If days is zero, returns self.
    def add_banking_days(days)
      day = self
      if days > 0
        days.times { day = day.next_banking_day }
      elsif days < 0
        (-days).times { day = day.previous_banking_day }
      end
      day
    end

    # Returns true if this is a banking day, i.e. is not a bank holiday,
    # false otherwise.
    def banking_day?
      !bank_holiday?
    end
  end

end

::Date.class_eval do
  include ::UsBankHolidays::DateMethods
end
