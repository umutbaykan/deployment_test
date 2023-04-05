# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  ### Validators
  def request_parameters_validated?(*args)
    args.each do |arg|
      return false if params[arg] == nil
      return false if params[arg] == ""
    end
    return true
  end
  

  get '/' do
    return erb(:index)
  end

  get '/hello' do
    @name = params[:name]
    return erb(:hello)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:all_albums)
  end


  get '/albums/new' do
    return erb(:new_album)
  end

  post '/albums/new' do
    unless request_parameters_validated?(:title, :release_year, :artist_id)
      status 400
      redirect '/albums/new'
      # return erb(:error_page)
    end
    title, release_year, artist_id = params[:title], params[:release_year], params[:artist_id]
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title, new_album.release_year, new_album.artist_id = title, release_year, artist_id
    repo.create(new_album)
    # return erb(:new_album_created)
    redirect '/albums'
  end

  ### This is a better way
  get '/albums/:id' do
    repo = AlbumRepository.new
    @album = repo.find(params[:id])
    a_repo = ArtistRepository.new
    @artist = a_repo.find(@album.artist_id)
    return erb(:album)
  end

  # post '/albums' do
  #   repo = AlbumRepository.new
  #   album_to_add = Album.new
  #   album_to_add.title = params[:title]
  #   album_to_add.release_year = params[:release_year]
  #   album_to_add.artist_id = params[:artist_id]
  #   repo.create(album_to_add)
  #   return 
  # end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:all_artists)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  post '/artists/new' do
    name, genre = params[:name], params[:genre]
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name, new_artist.genre = name, genre
    repo.create(new_artist)
    return erb(:new_artist_created)
    # redirect '/artists'
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    return erb(:artist)
  end
end