# frozen_string_literal: true

RSpec.describe ConfigParser do
  context 'when defining the class' do
    let(:config_parser) { ConfigParser.new(path_file) }
    let(:path_file) { 'spec/fixtures/files/data.txt' }

    subject { config_parser.params }

    context 'correct output' do
      let(:expected_output) do
        {
          'host' => 'test.com',
          'server_id' => 55331,
          'cost' => 2.56,
          'user' => 'user',
          'verbose' => true,
          'test_mode' => true,
          'debug_mode' => false,
          'log_file_path' => '/tmp/logfile.log',
          'send_notifications' => true
        }
      end

      it { expect(subject).to eql(expected_output) }
    end

    context 'correct output' do
      let(:expected_output) do
        {
          'host' => 'test.com',
          'server_id' => '55331',
          'cost' => '2.56',
          'user' => 'user',
          'verbose' => 'true',
          'test_mode' => 'on',
          'debug_mode' => 'off',
          'log_file_path' => '/tmp/logfile.log',
          'send_notifications' => 'yes'
        }
      end

      it { expect(subject).not_to eql(expected_output) }
    end
  end
end
