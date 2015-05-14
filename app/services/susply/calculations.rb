module Susply
  module Calculations
    def end_period_calculation(start, interval)
      case interval
      when 'yearly'
        start + 1.year
      when 'monthly'
        start + 1.month
      else
        start + 1.month
      end
    end
    module_function :end_period_calculation
  end
end
