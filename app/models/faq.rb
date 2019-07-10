class Faq < ApplicationRecord
	 validates :question, length: { minimum: 5, maximum: 25}
	 validates :answer, length: {minimum: 10}
end
