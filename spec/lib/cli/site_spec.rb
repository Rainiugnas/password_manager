# frozen_string_literal: true

RSpec.describe Cli::Input::Site do
  let(:message) { "sitename: \nusername: \npassword: \n" }
  let(:input1) { "site name\n" }
  let(:input2) { "user name\n" }
  let(:input3) { "password\n" }
  let(:site) { described_class.new }

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
  end
end
