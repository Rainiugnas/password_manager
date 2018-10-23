# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe PasswordManager::Site do
  let(:name) { 'site name' }
  let(:user) { 'user name' }
  let(:password) { 'user password' }
  let(:site) { described_class.new name, user, password }

  describe 'constructor' do
    it 'should set the attributes with the given values' do
      expect(site.name).to eq name
      expect(site.user).to eq user
      expect(site.password).to eq password
    end

    context 'when all value filled' do
      it 'should success' do
        expect(site.success).to be_truthy
      end
    end

    context 'when site name is empty' do
      let(:name) { '' }

      it 'should not success' do
        expect(site.success).to be_falsy
        expect(site.error).to eq 'Error: site name must be present'
      end
    end

    context 'when site name is nil' do
      let(:name) { nil }

      it 'should not success' do
        expect(site.success).to be_falsy
        expect(site.error).to eq 'Error: site name must be present'
      end
    end

    context 'when user name is empty' do
      let(:user) { '' }

      it 'should not success' do
        expect(site.success).to be_falsy
        expect(site.error).to eq 'Error: user name must be present'
      end
    end

    context 'when user name is nil' do
      let(:user) { nil }

      it 'should not success' do
        expect(site.success).to be_falsy
        expect(site.error).to eq 'Error: user name must be present'
      end
    end
  end
end
