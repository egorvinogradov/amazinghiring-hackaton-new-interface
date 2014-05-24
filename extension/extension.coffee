AH = {}

AH.css =
    hidden: "ah-m-hidden"

AH.elements =
    html: $ "html"
    body: $ "body"
    document: $ document

AH.helpers =
    elements:
        dropdown:

            selectors:
                container: ".ah-dropdown"
                title: ".ah-dropdown__title"
                block: ".ah-dropdown__block"
                list: ".ah-dropdown__list"
                listItem: ".ah-dropdown__item"
                listItemInner: ".ah-dropdown__item-inner"

            classes:
                staticDropdown: "ah-dropdown_static"

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

    initialize: ->
        for name, element of @elements
            element.initialize()

AH.helpers.initialize()




#############


$("body").delegate ".ah-profile__links-more", "click", (e) =>
    $(e.currentTarget)
        .parents(".ah-profile__links")
        .addClass("ah-profile__links_expanded")

$("body").delegate ".ah-profile__add-comment-textarea", "focus", (e) =>
    $(e.currentTarget).addClass("ah-profile__add-comment-textarea_focused")

$("body").delegate ".ah-profile__add-comment-textarea", "blur", (e) =>
    unless $(e.currentTarget).val().trim()
        $(e.currentTarget).removeClass("ah-profile__add-comment-textarea_focused")

$("body").delegate ".ah-profile__add-comment-button", "click", (e) =>
    textarea = $(e.currentTarget).siblings(".ah-profile__add-comment-textarea")
    value = textarea.val().trim()
    if value
        html = '<li class="ah-profile__comments-item"><div class="ah-profile__comments-name">Егор Виноградов<div class="ah-profile__comments-dropdown"><span class="ah-profile__comments-dropdown-title caret"></span></div></div><div class="ah-profile__comments-date">Сегодня</div><div class="ah-profile__comments-text">' + value + '</div></li>'
        textarea
            .parent()
            .siblings(".ah-profile__comments")
            .prepend(html)
        textarea
            .val("")
            .removeClass("ah-profile__add-comment-textarea_focused")

$("body").delegate ".ah-profile__comments-more-button", "click", (e) =>
    $(e.currentTarget)
        .parents(".ah-profile__comments")
        .addClass("ah-profile__comments_expanded")

$("body").delegate "a[href=#]", "click", =>
    return false

$(".ah-profile__save-resume-button").on "click", (e) ->
    el = $(e.currentTarget)
    el.text(el.data("alternate-text"))
    setTimeout ->
        $(".ah-profile__save-resume-message").removeClass("ah-m-hidden")
        el.addClass("ah-m-hidden")
    , 1500


$(".ah-icons").on "click", (e) ->
    $(".ah-panel").removeClass("ah-m-hidden")
    $(".ah-toggle").removeClass("ah-m-hidden")

$(".ah-toggle").on "click", ->
    $(".ah-panel").addClass("ah-m-hidden")
    $(".ah-toggle").addClass("ah-m-hidden")

$(".ah-similar-profile").on "click", ->
    $(".ah-profile").removeClass("ah-m-hidden")
    $(".ah-similar").addClass("ah-m-hidden")


