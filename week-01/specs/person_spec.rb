require_relative '../person'

require 'timecop'

describe Person do
  subject(:person) { Person.new('Walter', 'White', Date.parse('March 7, 1956')) }

  it { is_expected.to respond_to(:first_name).with(0).arguments }
  it { is_expected.to respond_to(:last_name).with(0).arguments }
  it { is_expected.to respond_to(:birth_date).with(0).arguments }
  it { is_expected.to respond_to(:age).with(0).arguments }
  it { is_expected.to respond_to(:younger_than?).with(1).argument }

  describe '.new' do
    it 'returns an instance of Person' do
      expect(person).to be_instance_of(Person)
    end
  end

  describe '#first_name' do
    it "returns the person's first name" do
      expect(person.first_name).to eq('Walter')
    end
  end

  describe '#last_name' do
    it "returns the person's last name" do
      expect(person.last_name).to eq('White')
    end
  end

  describe '#birth_date' do
    it "returns the person's birth date" do
      expect(person.birth_date).to eq(Date.parse('March 7, 1956'))
    end
  end

  describe '#full_name' do
    it "returns the person's full name" do
      expect(person.full_name).to eq('Walter White')
    end
  end

  describe '#age' do
    it "returns the person's age in years" do
      year, month, day = 2000, 1, 1

      past   = Date.new(year, month, day)
      future = Date.new(year + 30, month, day)

      person = Person.new('Walter', 'White', past)

      Timecop.freeze(future) do
        expect(person.age).to eq(30)
      end
    end
  end

  describe '#younger_than?' do
    let(:older_date)   { Date.new(1950, 1, 1) }
    let(:younger_date) { Date.new(2000, 1, 1) }

    let(:younger_person) { Person.new('Skyler', 'White', younger_date) }
    let(:older_person)   { Person.new('Skyler', 'White', older_date) }

    it 'returns true when person is younger' do
      expect(younger_person).to be_younger_than(older_person)
    end

    it 'returns false when person is same age' do
      expect(younger_person).to_not be_younger_than(younger_person)
    end

    it 'returns false when person is older' do
      expect(older_person).to_not be_younger_than(younger_person)
    end
  end
end
