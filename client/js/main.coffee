#
# Overflow 1.1 by HTML5 UP
# html5up.net | @n33co
# Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
#

###
###

# Settings

###
###
_settings =

  # Full screen header
  useFullScreenHeader: true

  # Parallax Background
  useParallax: true
  parallaxFactor: 10 # Lower = more intense. Higher = less intense.
  parallaxLimit: 1920 # Performance tweak: turns off parallax if the viewport width exceeds this value

  # skelJS
  skelJS:
    prefix: "css/style"
    resetCSS: true
    boxModel: "border"
    useOrientation: true
    containers: 1140
    grid:
      gutters: 40

    breakpoints:
      widest:
        range: "*"
        containers: 1140
        hasStyleSheet: false

      wide:
        range: "-1680"
        containers: 960

      normal:
        range: "-1080"
        containers: "95%"

      narrow:
        range: "-840"
        containers: "95%"
        grid:
          gutters: 30

      mobile:
        range: "-640"
        lockViewport: true
        containers: "95%"
        grid:
          collapse: true
          gutters: 20


  # poptrox
  poptrox:
    useBodyOverflow: false
    usePopupEasyClose: false
    overlayColor: "#0a1919"
    overlayOpacity: 0.75
    usePopupDefaultStyling: false
    usePopupCaption: true
    popupLoaderText: ""
    windowMargin: 10
    usePopupNav: true


###
###

# jQuery Plugins

###
###

# formerize
jQuery.fn.n33_formerize = ->
  _fakes = new Array()
  _form = jQuery(this)
  _form.find("input[type=text],textarea").each(->
    e = jQuery(this)
    if e.val() is "" or e.val() is e.attr("placeholder")
      e.addClass "formerize-placeholder"
      e.val e.attr("placeholder")
    return
  ).blur(->
    e = jQuery(this)
    return  if e.attr("name").match(/_fakeformerizefield$/)
    if e.val() is ""
      e.addClass "formerize-placeholder"
      e.val e.attr("placeholder")
    return
  ).focus ->
    e = jQuery(this)
    return  if e.attr("name").match(/_fakeformerizefield$/)
    if e.val() is e.attr("placeholder")
      e.removeClass "formerize-placeholder"
      e.val ""
    return

  _form.find("input[type=password]").each ->
    e = jQuery(this)
    x = jQuery(jQuery("<div>").append(e.clone()).remove().html().replace(/type="password"/i, "type=\"text\"").replace(/type=password/i, "type=text"))
    x.attr "id", e.attr("id") + "_fakeformerizefield"  unless e.attr("id") is ""
    x.attr "name", e.attr("name") + "_fakeformerizefield"  unless e.attr("name") is ""
    x.addClass("formerize-placeholder").val(x.attr("placeholder")).insertAfter e
    if e.val() is ""
      e.hide()
    else
      x.hide()
    e.blur (event) ->
      event.preventDefault()
      e = jQuery(this)
      x = e.parent().find("input[name=" + e.attr("name") + "_fakeformerizefield]")
      if e.val() is ""
        e.hide()
        x.show()
      return

    x.focus (event) ->
      event.preventDefault()
      x = jQuery(this)
      e = x.parent().find("input[name=" + x.attr("name").replace("_fakeformerizefield", "") + "]")
      x.hide()
      e.show().focus()
      return

    x.keypress (event) ->
      event.preventDefault()
      x.val ""
      return

    return

  _form.submit(->
    jQuery(this).find("input[type=text],input[type=password],textarea").each (event) ->
      e = jQuery(this)
      e.attr "name", ""  if e.attr("name").match(/_fakeformerizefield$/)
      if e.val() is e.attr("placeholder")
        e.removeClass "formerize-placeholder"
        e.val ""
      return

    return
  ).bind "reset", (event) ->
    event.preventDefault()
    jQuery(this).find("select").val jQuery("option:first").val()
    jQuery(this).find("input,textarea").each ->
      e = jQuery(this)
      x = undefined
      e.removeClass "formerize-placeholder"
      switch @type
        when "submit", "reset", "password"
          e.val e.attr("defaultValue")
          x = e.parent().find("input[name=" + e.attr("name") + "_fakeformerizefield]")
          if e.val() is ""
            e.hide()
            x.show()
          else
            e.show()
            x.hide()
        when "checkbox", "radio"
          e.attr "checked", e.attr("defaultValue")
        when "text", "textarea"
          e.val e.attr("defaultValue")
          if e.val() is ""
            e.addClass "formerize-placeholder"
            e.val e.attr("placeholder")
        else
          e.val e.attr("defaultValue")

    window.setTimeout (->
      for x of _fakes
        continue
      return
    ), 10
    return

  _form


# scrolly
jQuery.fn.n33_scrolly = (offset) ->
  jQuery(this).click (e) ->
    t = jQuery(this)
    h = t.attr("href")
    target = undefined
    if h.charAt(0) is "#" and h.length > 1 and (target = jQuery(h)).length > 0
      x = undefined
      pos = undefined
      x = target.offset().top
      if t.hasClass("scrolly-centered")
        pos = x - (($(window).height() - target.outerHeight()) / 2)
      else
        pos = Math.max(x, 0)
        if offset
          if typeof (offset) is "function"
            pos -= (offset)()
          else
            pos -= offset
      e.preventDefault()
      jQuery("body,html").animate
        scrollTop: pos
      , 1000, "swing"
    return

  return


###
###

# Initialize

###
###

# skelJS
skel.init _settings.skelJS

# jQuery
jQuery ->
  $window = $(window)
  $body = $("body")

  # Scrolly links
  $(".scrolly").n33_scrolly ->
    (if skel.isActive("mobile") then 70 else 190)


  # Forms
  $("form").n33_formerize()  if skel.vars.IEVersion < 10

  # Full Screen Header
  if _settings.useFullScreenHeader
    $header = $("#header")
    if $header.length > 0
      $header_header = $header.find("header")
      $window.on("resize.overflow_fsh", ->
        if skel.isActive("mobile")
          $header.css "padding", ""
        else
          p = Math.max(192, ($window.height() - $header_header.outerHeight()) / 2)
          $header.css "padding", p + "px 0 " + p + "px 0"
        return
      ).trigger "resize.overflow_fsh"
      $window.load ->
        $window.trigger "resize.overflow_fsh"
        return


  # Parallax Background
  if _settings.useParallax
    $dummy = $()
    $bg = undefined
    $window.on("scroll.overflow_parallax", ->
      $bg.css "background-position", "center " + (-1 * (parseInt($window.scrollTop()) / _settings.parallaxFactor)) + "px"
      return
    ).on("resize.overflow_parallax", ->
      if $window.width() > _settings.parallaxLimit or skel.isActive("narrow")
        $body.css "background-position", ""
        $bg = $dummy
      else
        $bg = $body
      return
    ).trigger "resize.overflow_parallax"

    # IE's smooth scroll kind of screws this up, so we have to turn it off.
    $window.unbind "scroll.overflow_parallax"  if skel.vars.IEVersion < 11

  # Poptrox
  _settings.poptrox.overlayOpacity = 0  if skel.vars.IEVersion < 9
  $(".gallery").poptrox _settings.poptrox
  return
