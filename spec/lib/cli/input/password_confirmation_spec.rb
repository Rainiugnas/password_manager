# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe PasswordConfirmation do
  let(:message) { 'ask message' }
  let(:input1) { 'input' }
  let(:input2) { 'input' }
  let(:confirmation) { PasswordConfirmation.new message }

  before(:each) do
    expect(Password).to receive(:new).with(message).and_return double(value: input1)
    expect(Password).to(
      receive(:new).with("Please enter password confirmation: \n").and_return double(value: input2)
    )
  end

  describe 'constructor' do
    context 'when the confirmation match' do
      it 'should have the value of the first input' do
        expect(confirmation.value).to eq input1
      end

      it 'should success' do
        expect(confirmation.success).to be_truthy
      end
    end

    context 'when the confirmation does not match' do
      let(:input1) { 'input' }
      let(:input2) { 'different' }

      it 'should have the value of the first input' do
        expect(confirmation.value).to eq input1
      end

      it 'should not success' do
        expect(confirmation.success).to be_falsy
      end

      it 'should have an error' do
        expect(confirmation.error).to eq 'The password does not match the confirmation'
      end
    end
  end
end
