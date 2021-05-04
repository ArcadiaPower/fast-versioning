module FastVersioning
  # value duration period
  # @private
  module Timelines
    class Duration
      # @param value [String] tracked property name
      # @param start_date [Time] when was the value set
      # @param end_date [Time, nil] when was the value unset (nil will default to Float::INFINITY)
      def initialize(value:, start_date:, end_date:)
        self.value = value
        self.start_date = start_date
        self.end_date = end_date
      end

      # @return [Range]
      def date_range
        start_date..end_date_or_the_future
      end

      attr_reader :value

      private

      attr_accessor :start_date, :end_date
      attr_writer :value

      def end_date_or_the_future
        end_date || Float::INFINITY
      end
    end
  end
end
