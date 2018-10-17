# frozen_string_literal: true

RSpec.describe Stop do
  let(:message) { 'press to continue' }
  let(:input) { "input\n" }
  let(:stop) { Stop.new message }

  before(:each) do
    allow($stdin).to receive(:gets).and_return input

    expect { stop }.to output(message).to_stdout
  end

  describe 'constructor' do
    it 'should alway success' do
      expect(stop.success).to be_truthy
      expect(stop.error).to be_nil
    end

    it 'should set the value to nil' do
      expect(stop.value).to be_nil
    end
  end
end
