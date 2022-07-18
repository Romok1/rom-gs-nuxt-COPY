# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :resources, inverse_of: %i[created_by updated_by]
  has_many :gef_projects_users
  belongs_to :role, optional: true

  validates :name, presence: true, length: { minimum: 2 }
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: EMAIL_PATTERN }

  # @see https://www.rubydoc.info/github/plataformatec/devise/Devise/Models
  devise :database_authenticatable,
    # :confirmable,
    :lockable,
    # :omniauthable,
    :recoverable,
    :registerable,
    # :rememberable,
    # :timeoutable,
    # :trackable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: self

  def as_json(*_args)
    {
      id:,
      name:,
      email:,
      role:,
      jti:,
      created_at:,
      updated_at:
    }
  end

  Role::NAMES.each do |role_name|
    role_snakecase = role_name.downcase.gsub(' ', '_')

    define_method("#{role_snakecase}?") do
      return nil unless role

      role == Role.find_by_name(role_name)
    end
  end
end
