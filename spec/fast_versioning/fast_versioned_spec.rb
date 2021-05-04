describe 'fast_versioned' do
  before do
    PaperTrail::Version.destroy_all
    FastVersioning::FastVersion.destroy_all
  end

  describe 'injects associations to model' do
    it 'should have fast_versions association' do
      expect(DummyModel.new).to respond_to(:fast_versions)
    end
  end

  describe 'after_commit callback' do
    it 'creates fast versions' do
      item = DummyModel.create(status: 'incomplete')
      expect(FastVersioning::FastVersion.last.value).to eq('incomplete')
      expect(FastVersioning::FastVersion.last.prev_value).to eq(nil)
      expect(FastVersioning::FastVersion.last.version_id).to eq(PaperTrail::Version.last.id)

      item.update(status: 'active')
      expect(FastVersioning::FastVersion.last.value).to eq('active')
      expect(FastVersioning::FastVersion.last.prev_value).to eq('incomplete')
    end

    context 'for numeric value' do
      it 'stores value as string' do
        DummyModel.create(number: 12)
        expect(FastVersioning::FastVersion.last.value).to eq('12')
      end
    end

    context 'for hash argument' do
      it 'stores serialized data' do
        item = DummyModel.create(complex: 'yes')
        expect(FastVersioning::FastVersion.last.meta['store_me']).to eq(1)
        expect(FastVersioning::FastVersion.last.meta['other_thing']).to eq('some string')
        item.update(complex: 'no')
        expect(FastVersioning::FastVersion.last.meta['store_me']).to eq(2)
      end
    end
  end

  describe 'fast_versions_for' do
    it 'returns property versions' do
      item = DummyModel.create(status: 'incomplete', number: 12)
      item.update(status: 'active', number: 15)
      expect(item.fast_versions_for(:number).pluck(:value)).to eq(['12', '15'])
    end
  end
end
