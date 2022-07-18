# frozen_string_literal: true

class IndicatorType < ApplicationRecord
  has_many :indicators

  validates_presence_of :name
end
