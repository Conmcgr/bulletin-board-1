class PostsController < ApplicationController
  def index
    the_id = params.fetch("path_id")
    @board = Board.where({ :id => the_id }).at(0)
    active = Post.where({ :board_id => the_id}).where("expires_on > ?", Date.today)
    inactive = Post.where({ :board_id => the_id}).where("expires_on <= ?", Date.today)

    @active_posts = active.order({ :created_at => :desc })
    @inactive_posts = inactive.order({ :created_at => :desc })


    render({ :template => "posts/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_posts = Post.where({ :id => the_id })

    @the_post = matching_posts.at(0)

    render({ :template => "posts/show" })
  end

  def create
    the_post = Post.new
    the_post.title = params.fetch("query_title")
    the_post.body = params.fetch("query_body")
    the_post.expires_on = params.fetch("query_expires_on")
    the_post.board_id = params.fetch("query_board_id")

    if the_post.valid?
      the_post.save
      redirect_to("/posts", { :notice => "Post created successfully." })
    else
      redirect_to("/posts", { :alert => the_post.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_post = Post.where({ :id => the_id }).at(0)

    the_post.title = params.fetch("query_title")
    the_post.body = params.fetch("query_body")
    the_post.expires_on = params.fetch("query_expires_on")
    the_post.board_id = params.fetch("query_board_id")

    if the_post.valid?
      the_post.save
      redirect_to("/posts/#{the_post.id}", { :notice => "Post updated successfully."} )
    else
      redirect_to("/posts/#{the_post.id}", { :alert => the_post.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_post = Post.where({ :id => the_id }).at(0)

    the_post.destroy

    redirect_to("/posts", { :notice => "Post deleted successfully."} )
  end
end
