EDITOR_DOMAIN = "https://gomix.com"
PROJECT_DOMAIN = "gomix.me"
API_DOMAIN = "https://api.gomix.com"

md = window.markdownit()

$('.video').click (event) ->
  showVideoOverlay()

$('.featured-container').click (event) ->
  featured = $(event.target).closest('.featured-container')
  showOverlay featured.data()

$('.project').click (event) ->
  project = $(event.target).closest('.project')
  showOverlay project.data()

$('.overlay').click (event) ->
  event.stopPropagation()

$('.overlay-background, .overlay-video-background').click (event) ->
  hideOverlay()

$(document).keydown (event) ->
  escapeKey = 27
  if event.which is escapeKey
    hideOverlay()

showVideoOverlay = ->
  console.log '🌱'
  $('.overlay-video-background').removeClass 'hidden'


hideOverlay = ->
  $('.overlay-background, .overlay-video-background').addClass 'hidden'

showOverlay = (data) ->
  title = $('.overlay .overlay-title')
  remix = $('.overlay .remix-link')
  show = $('.overlay .show-app-link')
  project = $('.overlay .project-link')
  thoughts = $('.overlay .thoughts-link')
  name = data.projectName
  id = data.projectId
  remixLink = "#{EDITOR_DOMAIN}/#!/remix/#{name}/#{id}"
  showLink = "https://#{name}.#{PROJECT_DOMAIN}"
  projectLink = "#{EDITOR_DOMAIN}/#!/project/#{name}"

  remix.attr "href", remixLink
  show.attr "href", showLink
  project.attr "href", projectLink
  thoughts.attr "href", thoughtsMailto(data)
  title.text name
  $('.overlay-background').removeClass 'hidden'
  $('.overlay .loader').removeClass 'hidden'
  getProjectReadme data

getProjectReadme = (data) ->
  id = data.projectId
  readmeUrl = "#{API_DOMAIN}/projects/#{id}/readme"
  container = $('.overlay .markdown-container')
  contentArea = $('.overlay .markdown-content')
  container.removeClass 'warning'
  contentArea.html("")

  $.get readmeUrl, (data) ->
    contentArea.html(md.render data)
  .always ->
    $('.overlay .loader').addClass 'hidden'
  .fail ->
    console.log 'get readme failed' # error state
    container.addClass 'warning'
    contentArea.html "<h1>Couldn't get project info</h1><p>Maybe try another project? Maybe we're too popular right now?</p><p>(シ_ _)シ</p>"

thoughtsMailto = (data) ->
  name = data.projectName
  id = data.projectId
  support = "customer-service@fogcreek.com"
  subject = "[Gomix] I have feelings about #{name}"
  body = """
    What do you think of the #{name} project? 
    Is it great? Should we feature it? Is it malicious?
    
    Let us know:





    --------------------
    
    Thanks 💖

    – Gomix Team
    
    (project id: #{id})
  """
  encodeURI "mailto:#{support}?subject=#{subject}&body=#{body}"
