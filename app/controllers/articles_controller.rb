#   Copyright 2017 Javier Sevilla
#    
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Note: ActiveRecord::RecordNotFound exception is handled automatically in the production environment (404.html)

require 'digest/md5'

class ArticlesController < ApplicationController
    before_action(:authenticate, except: [:index, :show])
    

    def new
        @article = Article.new
    end
    
    def index
        @articles = Article.all
    end
    
    def create
        @article = Article.new(article_params)
        
        if @article.save
            redirect_to @article
        else
            render 'new'
        end
    end
    
    def show
        @article = Article.find(params[:id])
    end
    
    def edit
        @article = Article.find(params[:id])
    end
    
    def update
        @article = Article.find(params[:id])
        
        if @article.update(article_params)
            redirect_to @article
        else
            render 'edit'
        end
    end
    
    def destroy
        @article = Article.find(params[:id])
        @article.destroy
        
        redirect_to articles_path
    end
    
    
    private
    def article_params
        params.require(:article).permit(:title, :name, :text)
    end
    
    def authenticate
        authenticate_or_request_with_http_digest(Rails.application.config.realm) do |username|
            user = User.find_by(name: username, admin: true)
            
            if user
                user.password
            end
        end
    end
end

