describe FastVersioning::Timeline do
  subject(:timeline) do
    described_class.new(fast_versions: dummy_model.fast_versions, name: 'status')
  end

  describe '#to_h' do
    subject { timeline.to_h }
    let(:dummy_model) { DummyModel.create }
    let(:start_time) { Time.parse('Mon, 03 May 2021 22:24:21 EDT -04:00').utc }

    before do
      Timecop.freeze(start_time)
      create_history(history_hash: history)
    end

    after do
      Timecop.return
    end

    let(:history) do
      {
        2.weeks => 'active'
      }
    end

    it 'returns a timeline hash' do
      expect(subject).to(
        eq(
          {
            start_time..Float::INFINITY => 'active'
          }
        )
      )
    end

    context 'with no related history' do
      let(:history) do
        {}
      end

      it 'returns empty hash' do
        expect(subject).to eq({})
      end
    end

    context 'with multiple values' do
      let(:history) do
        {
          2.weeks => 'active',
          3.days => 'inactive',
          5.months => 'active',
        }
      end

      it 'returns a timeline hash' do
        expect(subject).to(
          eq(
            {
              start_time..(start_time + 2.weeks) => 'active',
              (start_time + 2.weeks)..(start_time + 2.weeks + 3.days) => 'inactive',
              (start_time + 2.weeks + 3.days)..Float::INFINITY => 'active'
            }
          )
        )
      end
    end

    context 'with nil' do
      let(:history) do
        {
          2.weeks => 'active',
          3.days => nil
        }
      end

      it 'returns a timeline hash' do
        expect(subject).to(
          eq(
            {
              start_time..(start_time + 2.weeks) => 'active',
              (start_time + 2.weeks)..Float::INFINITY => nil
            }
          )
        )
      end
    end
  end

  # Helpers
  def create_value_duration(value:, duration:)
    dummy_model.update!(status: value)
    Timecop.freeze(duration.from_now)
  end

  def create_history(history_hash:)
    history_hash.each do |duration, value|
      create_value_duration(duration: duration, value: value)
    end
  end
end
