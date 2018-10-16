# frozen_string_literal: true

RSpec.describe Password do
  let(:message) { 'ask message' }
  let(:input) { "input\n" }
  let(:password) { Password.new message }

  before(:each) do
    allow($stdin).to receive(:noecho).and_return input

    expect { password }.to output(message).to_stdout
  end

  describe 'constructor' do
    it 'should alway success' do
      expect(password.success).to be_truthy
      expect(password.error).to be_nil
    end

    it 'should set the value from the input and remove the \n' do
      expect(password.value).to eq 'input'
    end
  end
end
