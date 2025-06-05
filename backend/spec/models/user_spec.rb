require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with an email and password' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = FactoryBot.build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid with a duplicate email' do
    FactoryBot.create(:user, email: 'test@example.com')
    user = FactoryBot.build(:user, email: 'test@example.com')
    expect(user).to_not be_valid
  end

  it 'authenticates with a correct password' do
    user = FactoryBot.create(:user, email: 'foo@bar.com', password: 'MySecret', password_confirmation: 'MySecret')
    expect(user.authenticate('MySecret')).to eq(user)
  end

  it 'does not authenticate with an incorrect password' do
    user = FactoryBot.create(:user, password: 'MySecret', password_confirmation: 'MySecret')
    expect(user.authenticate('WrongPassword')).to be_falsey
  end
end
