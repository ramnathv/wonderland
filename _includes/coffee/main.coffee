twitter_template = false
github_template = false

close_all_modals = ->
  $(".modal.in").modal('hide')

render_twitter = (data) ->

  context =
    user:
      name: data[0].user.name
      screen_name: data[0].user.screen_name
      profile_image_url: data[0].user.profile_image_url
      f_description: data[0].user.description
      location: data[0].user.location
      url: data[0].user.url

      statuses_count: data[0].user.statuses_count
      friends_count: data[0].user.friends_count
      followers_count: data[0].user.followers_count

    tweets: data

  modal = $(twitter_template(context))
  $("body").append(modal)
  close_all_modals()
  modal.modal('show')

render_github = (user_data, repo_data) ->
  context =
    user: user_data

    repos: repo_data

  modal = $(github_template(context))
  $("body").append(modal)
  close_all_modals()
  modal.modal('show')

show_twitter = ->
  twitter_modal = $(".twitter.modal")
  if twitter_modal.length
    close_all_modals()
    return twitter_modal.modal('show')

  $.ajax
    url: "{{site.url}}/templates/twitter.tpl"
    success: (data) ->
      twitter_template = Handlebars.compile(data)

      $.ajax
        url: "http://api.twitter.com/1/statuses/user_timeline.json?include_rts=true&screen_name={{site.twitter}}"
        dataType: "jsonp"
        success: render_twitter

show_github = ->
  github_modal = $(".github.modal")
  if github_modal.length
    close_all_modals()
    return github_modal.modal('show')

  $.ajax
    url: "{{site.url}}/templates/github.tpl"
    success: (data) ->
      github_template = Handlebars.compile(data)

      $.ajax
        url: "https://api.github.com/users/{{site.github}}"
        dataType: "json"
        success: (user_data) ->

          $.ajax
            url: "https://api.github.com/users/{{site.github}}/repos"
            dataType: "json"
            success: (repo_data) ->
              render_github(user_data, repo_data)

first_active = false

set_active_nav = (el) ->
  nav = $("#links")

  if !first_active
    first_active = nav.find("li.active")

  nav.find("li").removeClass("active")
  el.addClass("active")

reset_active_nav = ->
  nav = $("#links")
  nav.find("li").removeClass("active")
  if first_active then first_active.addClass("active")

$(document).on "click", "#twitter-link", show_twitter
$(document).on "click", "#github-link", show_github

$(document).on "show", ".twitter.modal", ->
  set_active_nav($("#twitter-link").parent())

$(document).on "show", ".github.modal", ->
  set_active_nav($("#github-link").parent())

$(document).on "hide", ".profile.modal", ->
  reset_active_nav()