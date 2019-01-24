# == Schema Information
#
# Table name: users
#
#  id    :bigint(8)        not null, primary key
#  email :string           not null
#

class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    has_many :submitted_urls,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :ShortenedUrl

    has_many :visits,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Visit
end
