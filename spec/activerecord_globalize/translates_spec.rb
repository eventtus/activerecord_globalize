describe ActiverecordGlobalize::Translates do
  subject { Post }
  let(:record){ subject.new }

  context '#translates' do
    it { expect { subject.translates }.to raise_error(ArgumentError) }
    it { expect(record).to respond_to(:title) }
    it { expect(record).to respond_to(:title_translations) }
  end

  context '#read_translation' do
    it 'should return translatins by current locale' do
      record.update_with_locale!(:es, title: 'Hola')
      I18n.with_locale :es do
        expect(record.read_translation(:title)).to eq('Hola')
        expect(record.title).to eq('Hola')
      end
    end

    it 'should return translatins by default locale if current locale not found' do
      record.update_with_locale!(I18n.default_locale, title: 'Hello')
      I18n.with_locale :fr do
        expect(record.read_translation(:title)).to eq('Hello')
        expect(record.title).to eq('Hello')
      end
    end

    it 'should return field value if no translations found' do
      record.update!(title_translations: {}, title: 'Hi')
      I18n.with_locale :fr do
        expect(record.read_translation(:title)).to eq('Hi')
        expect(record.title).to eq('Hi')
      end
    end
  end

  context '#write_translation' do
    it 'should set value to specific locale' do
      record.write_translation(:title, 'Hola', :es)
      expect(record.title_translations[:es]).to eq('Hola')
    end

    it 'should set value to original field if locale equals default locale' do
      record.write_translation(:title, 'Hello', :en)
      expect(record[:title]).to eq('Hello')
      expect(record.title_translations[:en]).to eq('Hello')
    end
  end

  context '#as_json' do
    it { expect(JSON.parse(record.to_json).keys).to eq(%w(id title)) }
  end

  context '#update_with_locale!' do
    it 'should update in specific locale' do
      record.update_with_locale!(:es, title: 'Hola')
      expect(record.title_translations[:es]).to eq('Hola')
    end
  end
end
