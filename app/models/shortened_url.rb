# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "securerandom"
require "byebug"

class ShortenedUrl < ApplicationRecord
    validates :short_url, :long_url, presence: true
    
    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User

    has_many :visits,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: :Visit

    has_many :visitors,
        through: :visits,
        source: :visitor

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

    def num_clicks
        visits.count
    end

    def uniq_visitors
        visits.distinct(:user_id)
    end

    def num_uniqs
        uniq_visitors.count
    end

    def num_recent_uniques
        window = 10.minutes.ago
        uniq_visitors.where("created_at >= '#{window}'").count
    end
end
