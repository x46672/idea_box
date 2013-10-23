require './idea'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true

  not_found do
    erb :error
  end

  configure :development do
    register Sinatra::Reloader
  end

  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect '/'
  end

  get '/' do
    erb :index, locals: {ideas: Idea.all}  
  end

  post '/' do
    #idea = Idea.new(title: params['title'], description: params['idea_description'])
    idea = Idea.new(params[:idea])
    idea.save
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = Idea.find(id.to_i)
    erb :edit, locals: {id: id, idea: idea}
  end

  get '/search' do
    # idea = Idea.find(1)
    # ideas = Idea.all
    ideas = Idea.search(params[:terms])
    erb :search, locals: {ideas: ideas}
  end



  put '/:id' do |id|
    #data = {
    #  :title => params['idea_title'],
    #  :description => params['idea_description'],
    #  :tags => params['idea_tag']
    #}
    data = params['idea']
    Idea.update(id.to_i, data)
    redirect '/'


  end


end
