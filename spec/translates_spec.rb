describe ActiverecordGlobalize::Translates do
  subject { Post }

  context '#translates' do
    it { expect { subject.translates }.to raise_error(ArgumentError) }
    it { expect(subject.new).to respond_to(:title) }
    it { expect(subject.new).to respond_to(:title_translations) }
  end
end
