AH = {}

AH.css =
    hidden: "m-hidden"

AH.elements =
    html: $ "html"
    body: $ "body"
    document: $ document

AH.helpers =
    elements:
        dropdown:

            selectors:
                container: ".b-dropdown"
                title: ".b-dropdown__title"
                block: ".b-dropdown__block"
                list: ".b-dropdown__list"
                listItem: ".b-dropdown__item"
                listItemInner: ".b-dropdown__item-inner"

            classes:
                staticDropdown: "b-dropdown_static"

            initialize: (selector) ->

                @onItemInnerClickProxy = $.proxy(@onItemInnerClick, @)
                @onTitleClickProxy = $.proxy(@onTitleClick, @)
                @onBodyClickProxy = $.proxy(@onBodyClick, @)

                AH.elements.html
                    .undelegate(@selectors.listItemInner, "click", @onItemInnerClickProxy)
                    .delegate(@selectors.listItemInner, "click", @onItemInnerClickProxy)

                AH.elements.html
                    .undelegate(@selectors.title, "click", @onTitleClickProxy)
                    .delegate(@selectors.title, "click", @onTitleClickProxy)

                AH.elements.html
                    .undelegate("body", "click", @onBodyClickProxy)
                    .delegate("body", "click", @onBodyClickProxy)

            onItemInnerClick: (e) ->
                container = $(e.currentTarget).parents(@selectors.container)
                unless container.hasClass(@classes.staticDropdown)
                    container
                        .find(@selectors.block)
                        .addClass(AH.css.hidden)

            onTitleClick: (e) ->
                block = $(e.currentTarget)
                    .parents(@selectors.container)
                    .find(@selectors.block)
                AH.elements.body
                    .find(@selectors.block)
                    .not(block)
                    .addClass(AH.css.hidden)
                block.toggleClass(AH.css.hidden)

            onBodyClick: (e) ->
                target = $(e.target)
                unless target.parents().is(@selectors.container)
                    AH.elements.body
                        .find(@selectors.block)
                        .addClass(AH.css.hidden)

        switcher:

            selectors:
                container: ".b-switcher"
                control: ".b-switcher__control"
                inner: ".b-switcher__inner"
                label: ".b-switcher__label"
                labelOn: ".b-switcher__label_on"
                labelOff: ".b-switcher__label_off"

            classes:
                on: "b-switcher_on"

            initialize: ->

                @onControlClickProxy = $.proxy(@onControlClick, @)
                @onOnLabelClickProxy = $.proxy(@onOnLabelClick, @)
                @onOffLabelClickProxy = $.proxy(@onOffLabelClick, @)

                AH.elements.html
                    .undelegate(@selectors.control, "click", @onControlClickProxy)
                    .delegate(@selectors.control, "click", @onControlClickProxy)

                AH.elements.html
                    .undelegate(@selectors.labelOn, "click", @onOnLabelClickProxy)
                    .delegate(@selectors.labelOn, "click", @onOnLabelClickProxy)

                AH.elements.html
                    .undelegate(@selectors.labelOff, "click", @onOffLabelClickProxy)
                    .delegate(@selectors.labelOff, "click", @onOffLabelClickProxy)

            onControlClick: (e) ->
                container = $(e.currentTarget).parents(@selectors.container)
                container.toggleClass(@classes.on)
                if container.hasClass(@classes.on)
                    container.data value: "on"
                else
                    container.data value: "off"

            onOnLabelClick: (e) ->
                $(e.currentTarget)
                    .parents(@selectors.container)
                    .addClass(@classes.on)
                    .data value: "on"

            onOffLabelClick: (e) ->
                $(e.currentTarget)
                    .parents(@selectors.container)
                    .removeClass(@classes.on)
                    .data value: "off"

    initialize: ->
        for name, element of @elements
            element.initialize()

AH.helpers.initialize()




$("body").delegate ".b-form__value-input", "focus", (e) =>
    $(e.currentTarget)
        .parents(".b-form__value-input-outer")
        .addClass("b-form__value-input-outer_editing")

$("body").delegate ".b-form__value-input", "blur", (e) =>
    fixInputWidth $(e.currentTarget)

fixInputWidth = (inputs) ->
    inputs.each (i, input) ->
        input = $(input)
        fake = input.siblings(".b-form__value-input_fake")
        value = input.val().trim()
        if value
            fake.text(value)
            input
                .parents(".b-form__value-input-outer")
                .removeClass("b-form__value-input-outer_editing")
            width = fake.width()
            input.width(width)

fixInputWidth $(".b-form__value-input")

$("body").delegate ".b-form__key-dropdown-item .b-dropdown__item-inner", "click", (e) =>
    target = $(e.currentTarget)
    value = $.trim target.text()
    companySwitcher = target
        .parents(".b-form__key-dropdown-item")
        .find(".b-switcher")
    if companySwitcher.length and companySwitcher.data("value") is "on"
        value = "Текущая компания"
    target
        .parents(".b-form__key-dropdown")
        .siblings(".b-form__key-title")
        .find(".b-form__key-title-inner")
        .text(value)

$("body").delegate ".b-form__key-dropdown-item .b-switcher", "click", (e) =>
    setTimeout ->
        switcher = $(e.currentTarget)
        title = switcher
            .parents(".b-form__key-dropdown")
            .siblings(".b-form__key-title")
            .find(".b-form__key-title-inner")
        if title.text() is "Компания" or title.text() is "Текущая компания"
            if switcher.data("value") is "on"
                title.text("Текущая компания")
            else
                title.text("Компания")

$("body").delegate ".b-form__values-add", "click", (e) =>
    el = $(e.currentTarget).prev(".b-form__value")
    html = el.get(0).outerHTML
    el.after(html)
    fixInputWidth $(".b-form__value-input")

$("body").delegate ".b-form__value-remove", "click", (e) =>
    $(e.currentTarget)
        .prev(".b-form__value")
        .remove()

$("body").delegate ".b-form__find", "click", (e) =>
    $(".b-app__body-title").addClass("b-app__body-title_collapsed")
    $(".b-form").addClass("b-form_collapsed")
    $(".b-search").removeClass("m-hidden")

availableTags = [
    "actionscript"
    "applescript"
    "asp"
    "basic"
    "c"
    "c++"
    "clojure"
    "cobol"
    "coldfusion"
    "erlang"
    "fortran"
    "groovy"
    "haskell"
    "java"
    "javascript"
    "lisp"
    "perl"
    "php"
    "python"
    "ruby"
    "scala"
    "scheme"
]

$(".b-form__value-input").autocomplete
    source: availableTags
    close: (e, ui) ->
        $(e.target).focusout().blur()

$(".b-form__key-exclude-checkbox").on "change", (e) =>
    checkbox = $(e.currentTarget)
    query = checkbox.parents(".b-form__row")
    if checkbox.is(":checked")
        query.addClass("b-form__row_excluded")
    else
        query.removeClass("b-form__row_excluded")

$(".b-filter__range").eq(0).slider
    range: true
    min: 20
    max: 60
    step: 5
    values: [25, 45]
    stop: -> randomizeSearch()

$(".b-filter__range").eq(1).slider
    range: true
    min: 20
    max: 60
    step: 5
    values: [20, 35]
    stop: -> randomizeSearch()

$(".b-filter__range").eq(2).slider
    range: true
    min: 20
    max: 60
    step: 5
    values: [35, 50]
    stop: -> randomizeSearch()

$("body").delegate ".b-filter__list-checkbox input[type=checkbox]", "change", =>
    randomizeSearch()

randomizeSearch = ->
    $(".b-app__body-spinner").removeClass("m-hidden")
    setTimeout ->
        $(".b-search__results").html(_.shuffle($(".b-profile-short")))
        $(".b-app__body-spinner").addClass("m-hidden")
    , 600

$("body").delegate ".b-profile__links-more", "click", (e) =>
    $(e.currentTarget)
        .parents(".b-profile__links")
        .addClass("b-profile__links_expanded")

$("[data-toggle=tooltip]").tooltip()

$(".b-big-photo__close, .b-big-photo__bg").on "click", =>
    $(".b-big-photo").addClass("m-hidden")

$("body").delegate ".b-profile__photo", "click", (e) =>
    photo = $(e.currentTarget)
    url = photo.css("backgroundImage").replace(/^url\(/, '').replace(/\)$/, '')
    $(".b-big-photo__img").attr src: url
    $(".b-big-photo").removeClass("m-hidden")

$("body").delegate ".b-profile-preview__bg, .b-profile-preview__close", "click", =>
    $(".b-profile-preview").addClass("m-hidden")
    $("body").removeClass("b-app_no-scroll")

$("body").delegate ".b-profile__short-button_preview", "click", (e) =>
    profile = $(e.currentTarget).parents(".b-profile-short")
    img = profile.find(".b-profile__photo")
        .css("backgroundImage")
    name = profile.find('.b-profile__name')
        .text()
        .split(/\d/)[0]
        .split('~')[0]
        .trim()
    $(".b-profile-preview")
        .find(".b-profile__photo")
        .css("backgroundImage", img)

    $(".b-profile-preview").removeClass("m-hidden")
    $("body").addClass("b-app_no-scroll")

    $(".b-profile-preview")
        .find(".b-profile__name_temp_inner").text(name)


$("body").delegate ".b-profile__add-comment-textarea", "focus", (e) =>
    $(e.currentTarget).addClass("b-profile__add-comment-textarea_focused")

$("body").delegate ".b-profile__add-comment-textarea", "blur", (e) =>
    unless $(e.currentTarget).val().trim()
        $(e.currentTarget).removeClass("b-profile__add-comment-textarea_focused")

$("body").delegate ".b-profile__add-comment-button", "click", (e) =>
    textarea = $(e.currentTarget).siblings(".b-profile__add-comment-textarea")
    value = textarea.val().trim()
    if value
        html = '<li class="b-profile__comments-item"><div class="b-profile__comments-name">Егор Виноградов<div class="b-profile__comments-date">Сегодня</div><div class="b-profile__comments-dropdown"><span class="b-profile__comments-dropdown-title caret"></span></div></div><div class="b-profile__comments-text">' + value + '</div></li>'
        textarea
            .parent()
            .siblings(".b-profile__comments")
            .prepend(html)
        textarea
            .val("")
            .removeClass("b-profile__add-comment-textarea_focused")

$("body").delegate ".b-profile__comments-more-button", "click", (e) =>
    $(e.currentTarget)
        .parents(".b-profile__comments")
        .addClass("b-profile__comments_expanded")

$("body").delegate ".b-filters__reset", "click", =>
    randomizeSearch()
    $(".b-filter__range").slider "values", [20, 60]
    _.each $(".b-filter__list-checkbox input[type=checkbox]"), (checkbox) ->
        checkbox.checked = false

$("body").delegate ".b-profile__short-button_open", "click", =>
    window.open("profile.html")

$("body").delegate "a[href=#]", "click", =>
    return false

$("body").delegate ".b-search__pagination-item_number", "click", (e) =>
    current = $(e.currentTarget)
    unless current.hasClass("b-search__pagination-item_current")
        number = current.text()
        html = '<div class="b-search__divider"><div class="b-search__divider-inner">' + number + ' из 207</div></div>'
        $(".b-search__more").before(html)
        $(".b-search__more").before(_.shuffle($(".b-profile-short").clone()))
        current
            .addClass("b-search__pagination-item_current")
            .siblings()
            .removeClass("b-search__pagination-item_current")

$("body").delegate ".b-search__more", "click", (e) =>
    current = $(".b-search__pagination-item_current").next()
    number = current.text()
    html = '<div class="b-search__divider"><div class="b-search__divider-inner">' + number + ' из 207</div></div>'
    $(".b-search__more").before(html)
    $(".b-search__more").before(_.shuffle($(".b-profile-short").clone()))
    current
        .addClass("b-search__pagination-item_current")
        .siblings()
        .removeClass("b-search__pagination-item_current")

$("body").delegate ".b-form__value-remove", "click", (e) =>
    $(e.currentTarget).parents(".b-form__value").remove()

$("body").delegate ".b-form__row-remove", "click", (e) =>
    $(e.currentTarget).parents(".b-form__row").remove()

$("body").delegate ".b-form__rows-add", "click", (e) =>
    row = $(".b-form__row")
        .first()
        .clone()
    value = row
        .find(".b-form__value")
        .first()
        .clone()
    #value.find(".b-form__value-input").val("")
    row
        .find(".b-form__values")
        .empty()
        .append(value)
        .append('<span class="b-form__values-add">+</span>')
        .find(".b-form__value-input")
        .val("")
    $(".b-form__rows").append(row)
    setTimeout ->
        row
            .find(".b-form__value-input-outer")
            .addClass("b-form__value-input-outer_editing")
            .find(".b-form__value-input")
            .focus()

