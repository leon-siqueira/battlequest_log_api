# frozen_string_literal: true

require "rails_helper"

class UnimplementedClass < BaseService; end

class ImplementedClass < BaseService
  def initialize(**kwargs)
    @kwarg = kwargs[:kwarg] || ""
  end
  private
  def run
    "Implemented kwarg = #{@kwarg}"
  end
end

RSpec.describe BaseService do
  describe ".call" do
    it "returns an exception if not implemented" do
      expect { described_class.call }.to raise_error(NotImplementedError)
    end

    it "returns the result of the implemented run method" do
      expect(ImplementedClass.call(kwarg: "test")).to eq("Implemented kwarg = test")
    end
  end
end
