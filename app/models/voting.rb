class Voting < ApplicationRecord
    belongs_to :meeting

    has_many :ballots, dependent: :destroy
    has_many :votes, dependent: :destroy

    has_many :voting_options, dependent: :destroy

    validates :text, presence: true
    validates :voting_type, presence: true

    enum voting_type: { single_choice: 0, multiple_choice: 1 }

    N_('single_choice')
    N_('multiple_choice')

    def result
        tallies = self.voting_options.map { |x| Tally.new(voting_option: x) }

        total = 0
        # count the votes
        self.votes.each do |vote|
            logger.debug(vote.inspect)
            total += vote.amount
            vote.voting_options.each do |opt|
                tallies.each do |tally|
                    if tally.id == opt.id
                        tally.add(opt, vote.amount)
                        next
                    end
                end
            end
        end
        logger.debug(tallies.inspect)
        [ tallies, total ]
    end
end
