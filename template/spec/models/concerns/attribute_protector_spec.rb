# frozen_string_literal: true

require 'rails_helper'

# Sample model that implements AttributeProtector.
class HasProtectedAttributes
  include ActiveModel::Model
  include ActiveModel::Serialization
  include AttributeProtector

  # :reek:Attribute
  attr_accessor :a_secret_attr, :a_not_secret_attr, :some_other_attr

  protect_attributes :a_secret_attr, :a_secret_method

  def attributes
    {
      'a_secret_attr' => nil,
      'a_not_secret_attr' => nil,
      'a_not_secret_method' => nil,
      'some_other_attr' => nil
    }
  end

  def a_secret_method
    "I return #{a_secret_attr}"
  end

  def a_not_secret_method
    "I return #{a_not_secret_attr}"
  end

  def some_other_method
    "I return #{some_other_attr}"
  end
end

RSpec.describe AttributeProtector do
  subject(:model) do
    HasProtectedAttributes.new(a_secret_attr:, a_not_secret_attr:, some_other_attr:)
  end

  let(:a_secret_attr) { Faker::String.random }
  let(:a_not_secret_attr) { Faker::String.random }
  let(:some_other_attr) { Faker::String.random }

  describe '#serializable_hash' do
    subject { model.serializable_hash(options) }

    let(:options) { nil }

    context 'with empty options' do
      it { is_expected.not_to include 'a_secret_attr' }
      it { is_expected.to include 'a_not_secret_attr' => a_not_secret_attr }
      it { is_expected.to include 'a_not_secret_method' => "I return #{a_not_secret_attr}" }
      it { is_expected.to include 'some_other_attr' => some_other_attr }
    end

    context 'with additional :except fields' do
      let(:options) { { except: %i[some_other_attr] } }

      it { is_expected.not_to include 'a_secret_attr' }
      it { is_expected.to include 'a_not_secret_attr' => a_not_secret_attr }
      it { is_expected.to include 'a_not_secret_method' => "I return #{a_not_secret_attr}" }
      it { is_expected.not_to include 'some_other_attr' }
    end

    context 'with protected attributes in :only' do
      let(:options) { { only: %i[a_secret_attr a_secret_method some_other_attr] } }

      it { is_expected.not_to include 'a_secret_attr' }
      it { is_expected.not_to include 'a_secret_method' }
      it { is_expected.not_to include 'a_not_secret_attr' }
      it { is_expected.not_to include 'a_not_secret_method' }
      it { is_expected.to include 'some_other_attr' => some_other_attr }
    end

    context 'with protected attributes in :methods' do
      let(:options) { { methods: %i[a_secret_attr a_secret_method some_other_method] } }

      it { is_expected.not_to include 'a_secret_attr' }
      it { is_expected.not_to include 'a_secret_method' }
      it { is_expected.to include 'a_not_secret_attr' => a_not_secret_attr }
      it { is_expected.to include 'a_not_secret_method' => "I return #{a_not_secret_attr}" }
      it { is_expected.to include 'some_other_attr' => some_other_attr }
      it { is_expected.to include 'some_other_method' => "I return #{some_other_attr}" }
    end
  end
end
