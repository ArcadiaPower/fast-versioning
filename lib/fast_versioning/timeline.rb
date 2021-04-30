module FastVersioning
  # a timeline for a tracked property
  class Timeline
    # @param name [String] tracked property name
    # @param fast_versions [ActiveRecord::Collection] FastVersion collection
    #
    def initialize(fast_versions:, name:)
      self.fast_versions = fast_versions
      self.name = name
    end

    # @return [Hash] hash of duration => date ranges
    #
    # @example
    #
    #   FastVersioning::Timeline.new(fast_versions: model.fast_versions, name: 'status').to_h
    #
    #   {
    #     Thu, 01 Apr 2021 14:08:48 EDT -04:00..Mon, 05 Apr 2021 21:53:48 EDT -04:00 => 'active',
    #     Mon, 05 Apr 2021 21:53:48 EDT -04:00..Mon, 05 Apr 2021 22:02:44 EDT -04:00 => 'inactive'
    #   }
    #
    def to_h
      durations_array.map do |duration|
        [duration.date_range, duration.value]
      end.to_h
    end

    private

      attr_accessor :fast_versions, :name

      def filtered_fast_versions
        fast_versions.where(name: name).order('created_at')
      end

      def durations_array
        @value_durations ||= (filtered_fast_versions.to_a + [nil]).each_cons(2).map do |item, prev_item|
          Timelines::Duration.new(
            value: item.value,
            start_date: item.created_at,
            end_date: prev_item&.created_at
          )
        end
      end
  end
end
