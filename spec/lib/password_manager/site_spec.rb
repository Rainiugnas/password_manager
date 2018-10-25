# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe PasswordManager::Site do
  let(:name) { 'site name' }
  let(:user) { 'user name' }
  let(:password) { 'user password' }
  let(:extra) { { 'extra1' => '1', 'extra2' => '2' } }
  let(:site) { described_class.new name, user, password, extra }

  describe 'constructor' do
    it 'should set the attributes with the given values' do
      expect(site.name).to eq name
      expect(site.user).to eq user
      expect(site.password).to eq password
    end

    it 'should set the extra attributes' do
      expect(site.extra['extra1']).to eq '1'
      expect(site.extra['extra2']).to eq '2'
    end
  end

  describe 'validation' do
    context 'when all value filled' do
      it 'should success' do
        expect(site.success).to be_truthy
      end
    end

    describe 'name validation' do
      context 'when name is not present' do
        it 'should fail' do
          ['', nil].each do |name|
            site = described_class.new name, user, password

            expect(site.success).to be_falsy
            expect(site.error).to eq 'Error: site name must be present'
          end
        end
      end
    end

    describe 'user and extra email validation' do
      context 'when extra email is present but not user' do
        let(:extra) { { 'email' => 'user_email' } }

        it 'should success' do
          expect(site.success).to be_truthy
        end
      end

      context 'when user or email is not present' do
        it 'should fail' do
          ['', nil].each do |user|
            site = described_class.new name, user, password

            expect(site.success).to be_falsy
            expect(site.error).to eq 'Error: user name or extra email must be present'
          end
        end
      end
    end
  end
end
