class Faq < ApplicationRecord
	 validates :question, length: { minimum: 10, maximum: 1000}
	 validates :answer, length: {minimum: 10, maximum: 5000}
end
