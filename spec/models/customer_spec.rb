RSpec.describe Customer, type: :model do
  it 'is valid with all values set' do
    customer = build(:customer)
    expect(customer).to be_valid
  end

  context 'first_name validations' do
    context 'first_name is blank' do
      it 'is invalid' do
        expect(build(:customer, first_name: nil)).to be_invalid
      end
    end

    context 'first_name shorter than 2 chars' do
      it 'is invalid' do
        expect(build(:customer, first_name: 'A')).to be_invalid
      end
    end
  end

  context 'last_name validations' do
    context 'last_name is blank' do
      it 'is invalid' do
        expect(build(:customer, last_name: nil)).to be_invalid
      end
    end

    context 'last_name shorter than 2 chars' do
      it 'is invalid' do
        expect(build(:customer, last_name: 'A')).to be_invalid
      end
    end
  end

  context 'email validations' do
    context 'email is blank' do
      it 'is invalid' do
        expect(build(:customer, email: '')).to be_invalid
      end
    end

    context 'email is non-unique' do
      it 'is invalid' do
        customer1 = create(:customer)

        expect(build(:customer, email: customer1.email)).to be_invalid
      end
    end

    context 'email is in invalid format' do
      it 'is invalid' do
        expect(build(:customer, email: 'hello_world')).to be_invalid
      end
    end
  end

  context 'date_of_birth validations' do
    context 'date_of_birth blank' do
      it 'is invalid' do
        expect(build(:customer, date_of_birth: '')).to be_invalid
      end
    end

    context 'date_of_birth is more than 100 years ago' do
      it 'is invalid' do
        expect(build(:customer, date_of_birth: 100.years.ago - 2.days)).to be_invalid
      end
    end

    context 'date_of_birth is less than 18 years ago' do
      it 'is invalid' do
        expect(build(:customer, date_of_birth: 18.years.ago + 2.days)).to be_invalid
      end
    end
  end
end
