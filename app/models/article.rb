class Article < ActiveRecord::Base

include AASM

belongs_to :user
has_many :comments
has_many :categories, through: :has_categories
has_many :has_categories



#Presence true valida que el elemento no este vacio
validates :title, presence: true, uniqueness: true
validates :body, presence:true, length: {minimum: 20}
#validates :username, format: {with: /regex/}

#Justo antes de crear el artículo iguala el contador de visitas a 0
before_create :set_visits_count
after_create :save_categories


has_attached_file :cover, styles: { medium: "1280x720", thumb:"800x600"}
validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/


#Scope para la busqueda de los articulos cuyo state es published, el primer parámetro es el nombre del método de clase que llevara :publicados
#Como segundo parámetro recibe una expresión lambda, son las condiciones que se van a ejecutar sobre el métodos 
scope :publicados, ->{ where(state: "published") }

#Esto normalmente lo hacemos para definir diferentes grupos, en este caso ordenaras los articulos por fecha de creación descendiente y lo limitamos a 10 artículos
#Lo interesante de los scopes es que son encadenables
#La query que lanzará el método index de articles sera una combinación de los dos scopes que hemos creado
scope :ultimos, -> { order("created_at DESC")}

#Custom Setter o atributo virtual
def categories=(value)
@categories = value
end

def update_visits_count 
self.update(visits_count: self.visits_count + 1)
end


aasm column: "state" do
state :in_draft, initial: true
state :published

event :publish do
transitions from: :in_draft, to: :published
end

event :unpublish do
transitions from: :published, to: :in_draft
end

end


private 

def save_categories

unless @categories.nil?
@categories.each do |category_id|
HasCategory.create(category_id: category_id,article_id: self.id)
end
end
end


def set_visits_count
#Si el contador de visitas es nulo se igualará a 0 para que pueda incrementarse
self.visits_count ||= 0
end



end
