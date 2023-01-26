# frozen_string_literal: true

RSpec.describe ConfigParser do
  context 'when call the library' do
    let(:config_parser) { described_class.new(filepath: filepath) }
    let(:filepath) { 'spec/fixtures/files/data.txt' }

    before { config_parser.call }
    subject { config_parser }

    context 'correct output' do
      let(:expected_output) do
        {
          'host' => 'test.com',
          'server_id' => 55_331,
          'cost' => 2.56,
          'user' => 'user',
          'verbose' => true,
          'test_mode' => true,
          'debug_mode' => false,
          'log_file_path' => '/tmp/logfile.log',
          'send_notifications' => true
        }
      end

      it { expect(subject.params).to eql(expected_output) }
    end

    context 'incorrect output' do
      let(:unexpected_output) do
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

      it { expect(subject.params).not_to eql(unexpected_output) }
    end

    context 'file' do
      context 'integrity'do
        it 'file exists?' do
          expect(File.exist?(filepath)).to be true
        end

        it 'check file extension' do
          expect(File.extname(filepath)).to eq('.txt')
        end
      end
    end

    context 'values expected' do
      context 'when entry data is a string' do
        let(:value) { 'string' }

        it { expect(subject.type_of_value(value)).to be_a(String) }
      end

      context 'when entry data is a integer' do
        let(:value) { '55331' }

        it { expect(subject.type_of_value(value)).to be_a(Integer) }
      end

      context 'when entry data is a decimal' do
        let(:value) { '2.56' }

        it { expect(subject.type_of_value(value)).to be_a(Float) }
      end

      context 'when entry data is a boolean or similar (on, off, yes, no)' do
        context 'when entry data is true' do
          let(:value) { 'true' }

          it { expect(subject.type_of_value(value)).to be_boolean }
        end

        context 'when entry data is false' do
          let(:value) { 'false' }

          it { expect(subject.type_of_value(value)).to be_boolean }
        end

        context 'when entry data is on' do
          let(:value) { 'on' }

          it { expect(subject.type_of_value(value)).to be_boolean }
        end

        context 'when entry data is off' do
          let(:value) { 'off' }

          it { expect(subject.type_of_value(value)).to be_boolean }
        end

        context 'when entry data is yes' do
          let(:value) { 'yes' }

          it { expect(subject.type_of_value(value)).to be_boolean }
        end

        context 'when entry data is no' do
          let(:value) { 'no' }

          it { expect(subject.type_of_value(value)).to be_boolean }
        end
      end
    end

    context 'changed existing key value' do
      let(:param_name) { 'server_id' }
      let(:value) { 55_332 }

      let(:expected_hash) do
        {
          'host' => 'test.com',
          'server_id' => 55_332,
          'cost' => 2.56,
          'user' => 'user',
          'verbose' => true,
          'test_mode' => true,
          'debug_mode' => false,
          'log_file_path' => '/tmp/logfile.log',
          'send_notifications' => true
        }
      end

      before { subject.add_to_hash(param_name, value) }

      it { expect(subject.params).to eq(expected_hash) }
    end
  end
end
