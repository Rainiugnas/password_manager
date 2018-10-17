# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Site do
  let(:message) { "sitename: \nusername: \npassword: \n" }
  let(:input1) { "site name\n" }
  let(:input2) { "user name\n" }
  let(:input3) { "password\n" }
  let(:site) { Site.new }

  before(:each) do
    expect($stdin).to receive(:gets).and_return input1
    expect($stdin).to receive(:gets).and_return input2
    expect($stdin).to receive(:noecho).and_return input3

    expect { site }.to output(message).to_stdout
  end

  describe 'constructor' do
    it 'should set the value from the input and remove the \n' do
      expect(site.name).to eq 'site name'
      expect(site.user).to eq 'user name'
      expect(site.password).to eq 'password'
    end

    context 'when all value filled' do
      it 'should success' do
        expect(site.success).to be_truthy
      end
    end

    context 'when site name is empty' do
      let(:input1) { "\n" }

      it 'should not success' do
        expect(site.success).to be_falsy
        expect(site.error).to eq 'Error: site name must be present'
      end
    end

    context 'when user name is empty' do
      let(:input2) { "\n" }

      it 'should not success' do
        expect(site.success).to be_falsy
        expect(site.error).to eq 'Error: user name must be present'
      end
    end
  end
end
