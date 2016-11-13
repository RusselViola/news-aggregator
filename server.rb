require 'sinatra'
require 'CSV'
require 'pry'
require_relative 'models/input_validation'
require 'uri'

get '/' do
  redirect '/articles'
end

get '/articles' do
  erb :articles
end

get '/articles/new' do
  erb :new_article
end

post '/articles/new' do
  @url = params[:article_url]
  @title = params[:article_title]
  @description = params[:article_description]

  if Input_valid.invalid_url?(@url)
    @input_error = true
    erb :new_article
  elsif @description.length < 20
    @char_error = true
    erb :new_article
  elsif @url != '' && @title != '' && @description != ''
    CSV.open('articles.csv', 'a') do |csv|
      csv << [@url, @title, @description]
    erb :new_article
    redirect '/articles'
    end
  else
    @error = true
    erb :new_article
  end

end
