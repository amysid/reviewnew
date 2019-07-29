class Faq < ApplicationRecord
	 validates :question, length: { minimum: 20, maximum: 100}
	 validates :answer, length: {minimum: 20, maximum: 500}
end
