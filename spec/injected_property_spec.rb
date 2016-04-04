require 'spec_helper'

describe InjectedProperty do
  it 'has a version number' do
    expect(InjectedProperty::VERSION).not_to be nil
  end

  describe 'injected_accessors' do
    let(:mock_class) { Class.new { include InjectedProperty } }

    context 'setter injection' do
      before do
        mock_class.send(
          :injected_accessors,
          :a,
          inject_set: ->(_obj, val) { val.upcase }
        )
        @mock = mock_class.new
        @mock.a = 'a'
      end

      it { expect(@mock.a).to eq 'A' }
    end

    context 'setter not injected' do
      before do
        mock_class.send(:injected_accessors, :a)
        @mock = mock_class.new
      end

      it { expect(@mock.a = 'a').to eq 'a' }
    end

    context 'before setter' do
      before do
        mock_class.send(
          :injected_accessors,
          :a,
          before_set: ->(_obj, _val) { puts 'before' }
        )
        @mock = mock_class.new
      end

      it { expect { @mock.a = '' }.to output("before\n").to_stdout }
    end

    context 'after setter' do
      before do
        mock_class.send(
          :injected_accessors,
          :a,
          after_set: ->(_obj, _val) { puts 'after' }
        )
        @mock = mock_class.new
      end

      it { expect { @mock.a = '' }.to output("after\n").to_stdout }
    end

    context 'getter injection' do
      before do
        mock_class.send(
          :injected_accessors,
          :a,
          inject_get: ->(_obj, val) { val.upcase }
        )
        @mock = mock_class.new
        @mock.a = 'a'
      end

      it { expect(@mock.a).to eq 'A' }
    end

    context 'getter not injected' do
      before do
        mock_class.send(:injected_accessors, :a)
        @mock = mock_class.new
        @mock.a = 'a'
      end

      it { expect(@mock.a).to eq 'a' }
    end

    context 'before getter' do
      before do
        mock_class.send(
          :injected_accessors,
          :a,
          before_get: ->(_obj) { puts 'before' }
        )
        @mock = mock_class.new
      end

      it { expect { @mock.a }.to output("before\n").to_stdout }
    end

    context 'after getter' do
      before do
        mock_class.send(
          :injected_accessors,
          :a,
          after_get: ->(_obj, _val) { puts 'after' }
        )
        @mock = mock_class.new
      end

      it { expect { @mock.a }.to output("after\n").to_stdout }
    end
  end
end
