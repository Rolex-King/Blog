class ArticlesController < ApplicationController

before_action :authenticate_user!, except: [:index,:show]
#El siguiente callback es para las acciones que no necesitan un recibir un id como parámetro
before_action :set_article, except: [:index,:new,:create]
before_action :authenticate_editor!, only: [:new,:create,:update]
before_action :authenticate_admin!, only: [:destroy,:publish]

#A esta ruta se accede con GET /articles
def index	
#@articles = Article.publicados.ultimos
@articles = Article.paginate(page: params[:page],per_page:9).publicados.ultimos
end

#GET /articles/id
#EL objeto params es un hash que contiene todos los parametros que se envian al servidor web
def show
@article.update_visits_count
#Article.where(" title LIKE ?", "articulo")
#Article.where("id = #{params[:id]}")
#Article.where("id = ?",params[:id])
#Article.where.not("id = 1")
@comment = Comment.new
end


#POST /articles
def create
#@article = Article.new(title: params[:article][:title], 
					#   body: params[:article][:body])
#@article = Article.new(article_params)
@article = current_user.articles.new(article_params)
@article.categories = params[:categories]

if @article.save()
	redirect_to @article
else
	render :new  
end

end


def new 
@article = Article.new
@categories = Category.all
end

def edit
end


#PUT /articles/:id
def update
if @article.update(article_params)
	redirect_to articles_path
else
render :edit
end
end

def publish
@article.publish!
redirect_to @article
end

def destroy
@article.destroy
redirect_to articles_path
end

private def set_article
@article = Article.find(params[:id])
end


private def article_params
params.require(:article).permit(:title,:body,:cover,:categories,:markup_body)
end


end
