# -*- coding: utf-8 -*-
# encoding: utf-8
require 'sinatra'
require 'sqlite3'
require 'securerandom'

db =　SQLite3::Database.new "db/post.db"
db.results_as_hash = true

get '/' do
  posts = db.execute("SELECT * FROM posts ORDER BY id DESC")
  erb :index, { :locals => { :posts => posts } }
end

post '/' do
  file_name = ""

  if params["file"]
    ext = ""
    if params["file"][:type].include? "jpeg"
      ext = "jpg"
    elsif params["file"][:type].include? "png"
      ext = "png"
    else
      return "投稿出来る画像形式はjpgとpngだけです"
    end

    #適当なファイル名をつける
    file_name = SecureRandom.hex + "." + ext

    #画像を保存
    File.open("./public/uploads/" + file_name, 'wb') do |f|
      f.write paramas["file"][:tempfile].read
    end
  else
    return "画像が必須です"
  end
  
  stmt = db.prepare("INSERT INTO posts (text, img_file_name) VALUES (?, ?)")
  stmt.bind_params(params["ex_text"], file_name)
  stmt.execute
  redirect '/'
end

get '/hello' do
  "Hello world"
end

get '/example' do
  erb :example
end

get '/star' do
  post_id = params["post_id"].to_i
  post = db.execute("SELECT star_count FROM posts WHERE id = ?", post_id)
  if 
