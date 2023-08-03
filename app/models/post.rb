class Post < ApplicationRecord
	enum category: {sports: 1, entertainment: 2, political: 3}
	belongs_to :user
end
