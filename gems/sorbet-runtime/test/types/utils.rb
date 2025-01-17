# frozen_string_literal: true
require_relative '../test_helper'

module Opus::Types::Test
  class UtilsTest < Critic::Unit::UnitTest
    describe 'T::Utils.unwrap_nilable' do
      it 'unwraps when multiple elements' do
        type = T.any(String, NilClass, Float)
        # require 'pry'; binding.pry
        unwrapped = T.must(T::Utils.unwrap_nilable(type))

        assert(T.any(String, Float).subtype_of?(unwrapped))
        assert(unwrapped.subtype_of?(T.any(String, Float)))
      end
    end

    describe 'T::Utils.signature_for_method' do
      it 'returns nil on methods without sigs' do
        c = Class.new do
          def no_sig; end
        end
        assert_nil(T::Utils.signature_for_method(c.instance_method(:no_sig)))
      end

      it 'returns things on methods with sigs' do
        c = Class.new do
          extend T::Sig
          sig {returns(Integer)}
          def sigfun
            85
          end
        end
        sfm = T::Utils.signature_for_method(c.instance_method(:sigfun))
        refute_nil(sfm)
        assert_equal(:sigfun, sfm.method.name)
        assert_equal(:sigfun, sfm.method_name)
        assert_equal('Integer', sfm.return_type.name)
      end
    end
  end
end
