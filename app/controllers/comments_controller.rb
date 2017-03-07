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


class CommentsController < ApplicationController
    def new
        @article = Article.find(params[:article_id])
        @comment = Comment.new
    end
    
    def create
        @article = Article.find(params[:article_id])
        @comment = @article.comments.new(comment_params)
        
        if @comment.save
            redirect_to article_path(@article)
        else
            @commenterError = false
            @bodyError = false
            
            if @comment.errors.any?
                if @comment.errors.messages.include?(:commenter)
                    @commenterError = true
                end
                if @comment.errors.messages.include?(:body)
                    @bodyError = true
                end
            end
            
            render 'new'
        end
    end
    
    def destroy
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        @comment.destroy
        
        redirect_to article_path(@article)
    end
    
    private
    def comment_params
        params.require(:comment).permit(:commenter, :body)
    end
end

