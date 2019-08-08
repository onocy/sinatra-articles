require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'csv'

require_relative "config/application.rb"
require_relative "models/article.rb"

set :public_folder, 'public'
set :bind, '0.0.0.0'

# HELPER METHODS

def generate_articles()
    articles = []
    CSV.foreach("articles.csv").with_index do |row, index|
        articles << Article.new(index, row[0], row[1], row[2])
    end
    articles
end

def find_article(id)
    article = CSV.readlines("articles.csv")[id.to_i]
end

def random_article()
    CSV.readlines("articles.csv").sample
end

def url_exists(url) 
    lines = CSV.readlines("articles.csv")
    return lines.find {|line| line[1] == url}
end

def edit_article(id, newRow)
    articles = CSV.readlines("articles.csv")
    articles[id.to_i] = newRow
    list_to_csv(articles)
end

def delete_article(id)
    articles = CSV.readlines("articles.csv")
    articles.delete_at(id.to_i)
    list_to_csv(articles)
end

def list_to_csv(list)
    CSV.open("articles.csv", "w") do |csv|
        list.each do |row|
            csv << row 
        end
    end
end

# ENDPOINTS 

get "/" do
    redirect("/articles")
end

get "/articles" do 
    @articles = generate_articles()
    erb :articles
end

get "/article/new" do
    erb :create_article
end

post "/article/new" do
    if params[:title].empty? || params[:url].empty? || params[:description].empty?
        @error = "You need to specify these parameters"
    elsif params[:url][0..3] != "http"
        @error = "Invalid Url"
    elsif params[:description].length < 20 
        @error = "There are too few characters in the description"
    elsif url_exists(params[:url])
        @error = "URL already exists"
    else 
        CSV.open('articles.csv', 'a')  do |file|
            file << [params[:title], params[:url], params[:description]]
        end
        redirect("/articles")
    end
    erb :create_article
end

get "/article/:id" do
    articles = generate_articles()
    @article = articles.find {|article| article.id == params[:id].to_i}
    erb :article
end

get "/article/:id/edit" do
    @current_id = params[:id]
    @current_article = find_article(@current_id)
    erb :create_article
end

get "/article/:id/delete" do
    @current_id = params[:id]
    @current_article = delete_article(@current_id)
    redirect ("/articles")
end

post "/article/edit/" do 
    if params[:title].empty? || params[:url].empty? || params[:description].empty?
        @error = "You need to specify these parameters"
    elsif params[:url][0..3] != "http"
        @error = "Invalid Url"
    elsif params[:description].length < 20 
        @error = "There are too few characters in the description"
    elsif url_exists(params[:url])
        @error = "URL already exists"
    else 
        newRow = [params[:title], params[:url], params[:description]]
        edit_article(params[:id], newRow)
        redirect("/articles")
    end
    erb :create_article
end

get "/random" do
    erb :random
end

get "/random_article" do
    content_type :json
    status 200
    random_article().to_json
end



