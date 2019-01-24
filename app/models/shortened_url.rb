require "securerandom"
require "byebug"

class ShortenedUrl < ApplicationRecord
    def self.shortened(url, user_id)
        ShortenedUrl.create!(short_url: random_code,
                             long_url: url,
                             user_id: user_id)
    end

    def self.random_code
        code = SecureRandom::urlsafe_base64
        while ShortenedUrl.exists?(short_url: code)
            code = SecureRandom::urlsafe_base64
        end
        code
    end

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User
end
