class Article < ActiveRecord::Base

belongs_to :user
has_many :comments
#Presence true valida que el elemento no este vacio
validates :title, presence: true, uniqueness: true
validates :body, presence:true, length: {minimum: 20}
#validates :username, format: {with: /regex/}

#Justo antes de crear el artículo iguala el contador de visitas a 0
before_create :set_visits_count

has_attached_file :cover, styles: { medium: "1280x720", thumb:"800x600"}
validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/


def update_visits_count 
self.update(visits_count: self.visits_count + 1)
end

private def set_visits_count
#Si el contador de visitas es nulo se igualará a 0 para que pueda incrementarse
self.visits_count ||= 0
end



end
