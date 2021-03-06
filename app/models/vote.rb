class Vote < ApplicationRecord
    belongs_to :ballot, optional: true
    belongs_to :voting

    has_many :votes_voting_options, dependent: :destroy
    has_many :voting_options, through: :votes_voting_options
end
