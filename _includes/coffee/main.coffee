twitter_template = false
github_template = false
instagram_template = false

show_profile = (html) ->
  modal = $(html)
  $("body").append(modal)
  close_all_modals()
  modal.modal('show')

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

  show_profile(twitter_template(context))

render_github = (user_data, repo_data) ->
  context =
    user: user_data

    repos: repo_data

  show_profile(github_template(context))

render_instagram = (user_data, photo_data) ->
  context =
    user: user_data.data
    media: photo_data.data

  show_profile(instagram_template(context))

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
        dataType: "jsonp"
        success: (user_data) ->

          $.ajax
            url: "https://api.github.com/users/{{site.github}}/repos"
            dataType: "jsonp"
            success: (repo_data) ->
              render_github(user_data.data, repo_data.data)

show_instagram = ->
  instagram_modal = $(".instagram.modal")
  if instagram_modal.length
    close_all_modals()
    return instagram_modal.modal('show')

  $.ajax
    url: "{{site.url}}/templates/instagram.tpl"
    success: (data) ->
      instagram_template = Handlebars.compile(data)

      $.ajax
        url: "https://api.instagram.com/v1/users/{{site.instagram_id}}?access_token=18360510.f59def8.d8d77acfa353492e8842597295028fd3"
        dataType: "jsonp"
        success: (user_data) ->

          $.ajax
            url: "https://api.instagram.com/v1/users/{{site.instagram_id}}/media/recent?access_token=18360510.f59def8.d8d77acfa353492e8842597295028fd3"
            dataType: "jsonp"
            success: (photo_data) ->
              render_instagram(user_data, photo_data)


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
$(document).on "click", "#instagram-link", show_instagram

$(document).on "show", ".twitter.modal", ->
  set_active_nav($("#twitter-link").parent())

$(document).on "show", ".github.modal", ->
  set_active_nav($("#github-link").parent())

$(document).on "show", ".instagram.modal", ->
  set_active_nav($("#instagram-link").parent())

$(document).on "hide", ".profile.modal", ->
  reset_active_nav()