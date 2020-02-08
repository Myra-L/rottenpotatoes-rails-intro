class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.possible_ratings()
    
    #only display movies matching the requested ratings
    movie_collection = nil
    #this is kinda ugly, but now it works without putting any code in views (a virtue)
    if (params.key?("ratings"))
      @current_ratings = params["ratings"]
      movie_collection = Movie.return_by_rating(params["ratings"].keys)
    else
      @current_ratings = Hash[@all_ratings.collect { |rating| [rating, 1] } ]
      movie_collection = Movie.all
    end
    
    #sort by title or rating
    if (params["sort"] == "title")
      @movies = movie_collection.order(:title)
      @title_header = "hilite bg-warning"
    elsif (params["sort"] == "release_date")
      @movies = movie_collection.order(:release_date)
      @release_date_header = 'hilite bg-warning'
    else 
      @movies = movie_collection
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
