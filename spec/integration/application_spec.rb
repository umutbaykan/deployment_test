require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET to /" do
    it 'contains a h1 title' do
      response = get('/')
      expect(response.body).to include('<h1>Welcome to my page</h1>')
    end
    
    it 'contains a div' do
      response = get('/')
      expect(response.body).to include('<h1>')
    end
  end

  context "GET /hello" do
    it 'contains a hello in h1 title' do
      response = get('/hello')
      expect(response.body).to include('<h1>Hello !</h1>')
    end

    it 'contains a the name after hello in h1 title' do
      response = get('/hello', name: "John")
      expect(response.body).to include('<h1>Hello John!</h1>')
    end
  end

  ### Artist Tests

  context 'GET /artists/id' do
    it 'should return the relevant artist' do
      response = get('/artists/2')
      expect(response.body).to include("ABBA")
      expect(response.body).to include("Pop")
    end

    it 'should return the relevant artist' do
      response = get('/artists/1')
      expect(response.body).to include("Pixies")
      expect(response.body).to include("Rock")
    end
  end

  context 'GET /artists' do
    it 'should get all artists' do
      response = get('/artists')
      expect(response.status).to eq 200
      expect(response.body).to include(
        "<div><a href='artists/1'>Pixies</a></div>",
        "<div><a href='artists/2'>ABBA</a></div>"
      )
    end
  end

  context 'GET /artists/new' do
    it 'displays a new form for user to populate' do
      response = get('artists/new')
      expect(response.status).to eq 200
      expect(response.body).to include("<form action='/artists/new' method='POST'>")
      expect(response.body).to include("<input type='text' placeholder='name' name='name'>")
      expect(response.body).to include("<input type='text' placeholder='genre' name='genre'>")
      expect(response.body).to include("<input type='submit' value='add new artist!'>")
    end
  end


  context 'POST /artists/new' do
    it 'posts the artist and returns the user back to artist list' do
      response = post('artists/new', 
        name: "Songmasters", 
        genre: "White Noise")
      expect(response.status).to eq 200
      expect(response.body).to include("<a href='/artists'>Go to artists</a>")
    end
  end

  ### Album Tests

  context 'GET /albums' do
    it 'prints the album titles in html' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include(
        "<div><a href= 'albums/1'>Doolittle</a></div>",
        "<div><a href= 'albums/2'>Surfer Rosa</a></div>"
      )
    end
  end

  # context 'POST /albums' do
  #   it 'should create a new album' do
  #     response = post('/albums', 
  #       title: "OK Computer", 
  #       release_year: 1997, 
  #       artist_id: 1)
  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq ""

  #     response = get('/albums')
  #     expect(response.body).to include('OK Computer')
  #   end
  # end

  context 'GET /albums/new' do
    it 'displays a new form for user to populate' do
      response = get('albums/new')
      expect(response.status).to eq 200
      expect(response.body).to include("<form action='/albums/new' method='POST'>")
      expect(response.body).to include("<input type='text' placeholder='title' name='title'>")
      expect(response.body).to include("<input type='text' placeholder='release year' name='release_year'>")
      expect(response.body).to include("<input type='text' placeholder='artist id' name='artist_id'>")
      expect(response.body).to include("<input type='submit' value='add new album!'>")
    end
  end
  
  context 'POST /albums/new' do
    it 'posts the albums and returns the user back to album list' do
      response = post('albums/new', 
        title: "Leave Them There", 
        release_year: 1989,
        artist_id: 2)
      expect(response.status).to eq 302
      # expect(response.body).to include("<a href='/albums'>Go to albums</a>")
    end
  end

  context 'GET /albums/id' do
    it 'should return the relevant album' do
      response = get('/albums/2')
      expect(response.status).to eq 200
      expect(response.body).to include("Surfer Rosa")
      expect(response.body).to include("Release year: 1988")
      expect(response.body).to include("Pixies")
    end

    it 'should return the relevant album' do
      response = get('/albums/1')
      expect(response.body).to include("Doolittle")
      expect(response.body).to include("Release year: 1989")
      expect(response.body).to include("Pixies")
    end 

    it 'should return the relevant album' do
      response = get('/albums/3')
      expect(response.body).to include("Waterloo")
      expect(response.body).to include("Release year: 1974")
      expect(response.body).to include("ABBA")
    end
  end
end
