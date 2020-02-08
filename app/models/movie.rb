class Movie < ActiveRecord::Base
  public 
  
  #returns an array of strings containing all possible ratings in the list of movies
  def  Movie.possible_ratings()
    #returns all ratings that are present in the table (one of each), as a string rather than part of a movie record
    #ascending alphabetic order: should ascend okay, provided you aren't include "A" films for some reason
    return Movie.select("DISTINCT rating").order(:rating).map { |tomato| tomato.rating }
  end
  
  #rating_list is an array containing the ratings to return
  def Movie.return_by_rating(rating_list)
    Movie.where("rating IN (?)", rating_list)
  end
end
 