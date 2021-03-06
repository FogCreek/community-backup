model = require './model'
utils = require './utils'
user = require './user'

console.log user

_ = require 'underscore'

self = 

  index: (request, response) ->
    if request.get('Content-Type') is 'application/json'
      response.json model.projects()
    else
      type1Categories = _.filter model.categories(), (cat) ->
        return cat.type == 1
      response.render 'index.jade',
        title: 'Gomix'
        featured: _.shuffle model.featured()
        categories: _.shuffle type1Categories
        shuffledCategories: _.shuffle type1Categories
        projects: _.shuffle model.projects()
        isUserExisting: user.isExisting()
        isUserSignedIn: user.isSignedIn()

  categories: (request, response) ->
    if request.get('Content-Type') is 'application/json'
      response.json model.categories()
    else
      response.render 'categories.jade',
        title: 'Gomix Community Categories'
        categories: model.categories()
        # searchSuggestions: SEARCH_SUGGESTIONS
  
  category: (request, response, category) ->
    projects = utils.projectsInCategory category.id
    if request.get('Content-Type') is 'application/json'
      response.json projects
    else
      projects = projects.reverse()
      response.render 'category.jade',
        title: category.name
        category: category
        categories: model.categories()
        projects: projects
        # searchSuggestions: SEARCH_SUGGESTIONS
  
  search: (request, response, query) ->
    results = utils.searchProjects query
    if request.get('Content-Type') is 'application/json'
      response.send results
    else
      response.render 'search.jade',
        title: query
        results: results
        query: query
        categories: model.categories()
        # searchSuggestions: SEARCH_SUGGESTIONS
  
  pageNotFound: (response) ->
    response.status 404
    response.render '404.jade',
      title: "404"


module.exports = self
