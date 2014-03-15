class window.GuideGuideHTMLUI

  # The GuideGuide HTML user interface. This should only contain UI concerns and
  # not anything related to GuideGuide's logic.
  constructor: (args, @panel) ->
    return if !@panel
    @panel.on 'guideguide:exitform', @onExitGridForm
    @panel.on 'guideguide:exitcustom', @onExitCustomForm
    @panel.on 'click', '.js-tabbed-page-tab', @onTabClick
    @panel.on 'click', '.js-alert-body .js-button', @onAlertButtonClick
    @panel.on 'click', '.js-link', @onClickLink
    @panel.on 'click', '.js-toggle-guide-visibility', @onToggleGuides
    @panel.on 'click', '.js-action-bar .js-top', @onClickTopGuide
    @panel.on 'click', '.js-action-bar .js-bottom', @onClickBottomGuide
    @panel.on 'click', '.js-action-bar .js-left', @onClickLeftGuide
    @panel.on 'click', '.js-action-bar .js-right', @onClickRightGuide
    @panel.on 'click', '.js-action-bar .js-horizontal-midpoint', @onClickHorizontalMidpoint
    @panel.on 'click', '.js-action-bar .js-vertical-midpoint', @onClickVerticalMidpoint
    @panel.on 'click', '.js-action-bar .js-clear', @onClickClearGuides
    @panel.on 'focus', '.js-input input, .js-input textarea', @onInputFocus
    @panel.on 'blur', '.js-input input, .js-input textarea', @onInputBlur
    @panel.on 'input:invalidate', '.js-input', @onInputInvalidate
    @panel.on 'mouseover', '.js-grid-form [data-distribute] .js-iconned-input-button', @onMouseOverDistributeIcon
    @panel.on 'mouseout', '.js-grid-form [data-distribute] .js-iconned-input-button', @onMouseOutDistributeIcon
    @panel.on 'click', '.js-dropdown', @onToggleDropdown
    @panel.on 'click', '.js-dropdown .js-dropdown-item', @onClickDropdownItem
    @panel.on 'click', '.js-import-sets', @onShowImporter
    @panel.on 'click', '.js-cancel-import', @onClickCancelImport
    @panel.on 'click', '.js-export-sets', @onClickExportSets
    @panel.on 'click', '.js-import', @onClickImportSets
    @panel.on 'click', '.js-input-shell', @onClickInputBackground
    @panel.on 'click', '.js-help-target', @onClickHelpTarget

    @messages = args.messages

    @panel.removeClass 'hideUI'
    @updateTheme args.theme
    @panel.find('textarea').autosize();
    console.log "HTML UI Loaded"

  # Update all of the ui with local messages.
  #
  # Returns nothing.
  localizeUI: =>
    $elements = $('[data-localize]')
    $elements.each (index, el) =>
      $(el).text @messages[$(el).attr('data-localize')]()

  # When an input gains focus, outline it's parent and get the most up to date
  # document info.
  #
  # Returns nothing.
  onInputFocus: (event) =>
    $(event.currentTarget).closest('.js-input').addClass 'is-focused'
    $(event.currentTarget).closest('.js-input').removeClass 'is-invalid'

  # When an input blurs remove its outline.
  #
  # Returns nothing.
  onInputBlur: (event) =>
    $(event.currentTarget).closest('.js-input').removeClass 'is-focused'

  # Outline an invalid input with red.
  #
  # Returns nothing.
  onInputInvalidate: (event) =>
    $(event.currentTarget).addClass 'is-invalid'

  # Highlight all field icons of similar type
  #
  # Returns nothing.
  onMouseOverDistributeIcon: (event) =>
    $form   = $(event.currentTarget).closest '.js-grid-form'
    type    = $(event.currentTarget).closest('[data-distribute]').attr 'data-distribute'
    $fields = @filteredList $form.find('.js-grid-form-iconned-input'), type
    $fields.addClass 'distribute-highlight'

  # Remove highlight from field icons
  #
  # Returns nothing.
  onMouseOutDistributeIcon: (event) =>
    @panel.find('.distribute-highlight').removeClass('distribute-highlight')

  # When exiting the Custom form, clear the new set form.
  #
  # Returns nothing
  onExitGridForm: =>
    @hideNewSetForm()

  # When exiting the Custom form, clear it.
  #
  # Returns nothing
  onExitCustomForm: =>
    @hideNewSetForm()

  # Hide the new set form and clear any data if it exists.
  #
  # Returns nothing.
  hideNewSetForm: =>
    @panel.find('.js-grid-form').find('.js-set-name').val('')
    @panel.find('.js-grid-form').find('.js-set-id').val('')
    @panel.removeClass('is-showing-new-set-form')

  # Behavior for navigating a collection of "pages" via a set of tabs
  #
  # Returns nothing.
  onTabClick: (event) =>
    event.preventDefault()

    exitPage   = @panel.find('.js-tabbed-page-tab.is-selected').attr 'data-page'
    enterPage  = $(event.currentTarget).attr 'data-page'

    return if enterPage == exitPage

    $('#guideguide').trigger "guideguide:exit#{ exitPage }"

    if filter = enterPage
      @selectTab filter

    $('#guideguide').trigger "guideguide:enter#{ enterPage }"

  # Select the tab that has the given tab-filter. If there is none, select the first tab.
  #
  # name - (String) content of the data-page attribute. this item will be selected
  #
  # Returns nothing.
  selectTab: (name) =>
    @panel.find("[data-page]").removeClass 'is-selected'

    if name
      filter = -> $(this).attr('data-page') is name
      tab = @panel.find('.js-tabbed-page-tab').filter filter
      tabBucket = @panel.find('.js-tabbed-page').filter filter
    else
      tab = $container.find '.js-tabbed-page-tab:first'
      tabBucket = @panel.find '.js-tabbed-page:first'

    # Select tab and bucket
    tab.addClass 'is-selected'
    tabBucket.addClass 'is-selected'

  # Toggle dropdown visibilty
  #
  # Returns nothing.
  onToggleDropdown: (event) =>
    event.preventDefault()

    if $(event.target).hasClass 'js-dropdown-backdrop'
      $('.js-dropdown').removeClass('is-active')
    else
      $dropdown = $(event.currentTarget)
      $dropdown.toggleClass 'is-active'
      $list = $dropdown.find('.js-dropdown-list')
      visibleBottom = $('.js-settings-list').scrollTop() + $('.js-settings-list').outerHeight()
      listBottom = $dropdown.position().top + $list.position().top + $list.outerHeight() + 3

      if listBottom > visibleBottom
        offset = listBottom - visibleBottom
        $('.js-settings-list').scrollTop $('.js-settings-list').scrollTop() + offset

    @panel.toggleClass 'has-dropdown'

  # Update settings and dropdown button when a dropdown item is clicked.
  #
  # Returns nothing.
  onClickDropdownItem: (event) =>
    event.preventDefault()
    $item     = $ event.currentTarget
    $dropdown = $item.closest '.js-dropdown'
    setting   = $dropdown.attr 'data-setting'
    value     = $item.attr 'data-value'
    value     = true if value is "true"
    value     = false if value is "false"

    $dropdown.find('.js-dropdown-button').text $item.text()
    data =
      settings: {}
    data.settings[setting] = value
    GuideGuide.saveData data

  # Display the correct settings in the Settings tab.
  #
  # Returns nothing.
  refreshSettings: (settings) =>
    $dropdowns = $('.js-dropdown')

    $dropdowns.each (index, el) =>
      $dropdown = $ el
      setting   = $dropdown.attr 'data-setting'
      value     = settings[setting]
      $selected = $dropdown.find("[data-value='#{ value }']")
      $dropdown.find('.js-dropdown-button').text @messages[$selected.attr('data-localize')]()

  # Show the set importer
  #
  # Returns nothing.
  onShowImporter: (event) =>
    event.preventDefault()
    return if GuideGuide.isDemo()
    @panel.addClass 'is-showing-importer'
    @panel.find('.js-import-input').val ''

  # Hide the set importer
  #
  # Returns nothing.
  hideImporter: =>
    @panel.removeClass 'is-showing-importer'

  # Dismiss the importer
  #
  # Returns nothing
  onClickCancelImport: (event) =>
    event.preventDefault()
    @panel.removeClass 'is-showing-importer'

  onClickExportSets: (event) =>
    event.preventDefault()
    GuideGuide.exportSets()

  onClickImportSets: (event) =>
    event.preventDefault()
    return if GuideGuide.isDemo()

    data = $(".js-import-input").val()

    # Is it a gist?
    if data.indexOf("gist.github.com") > 0
      id = data.substring data.lastIndexOf('/') + 1
      GuideGuide.importSets id
    else
      GuideGuide.importSets null

  # Show the indeterminate loader.
  #
  # Returns nothing
  showLoader: =>
    @panel.addClass 'is-loading'

  # Hide the indeterminate loader.
  #
  # Returns nothing
  hideLoader: =>
    @panel.removeClass 'is-loading'

  # Toggle guide visibility.
  #
  # Returns nothing.
  onToggleGuides: (event) =>
    event.preventDefault()
    GuideGuide.log "Toggle guides"
    GuideGuide.toggleGuides()

  # When an alert button is clicked, dismiss the alert and execute the callback
  #
  # Returns nothing.
  onAlertButtonClick: (event) =>
    event.preventDefault()
    @panel.find('.js-alert-title').text ''
    @panel.find('.js-alert-message').text ''
    @panel.removeClass 'has-alert'
    callback = $(event.currentTarget).attr('data-callback')
    GuideGuide[callback]()

  # When this install of GuideGuide is out of date, alert the user.
  #
  # Returns nothing.
  showUpdateIndicator: (data) =>
    @panel.addClass 'has-update'
    button = @panel.find '.js-has-update-button'
    button.attr 'data-title', data.title
    button.attr 'data-message', data.message

  refreshSets: (sets) =>
    $list = @panel.find('.js-set-list')
    $list.find('.js-set').remove()
    $.each sets, (index,set) =>
      item = $('.js-set-item-template').clone(true).removeClass('js-set-item-template')
      item.find('.js-set-item-name').html set.name
      item.attr 'data-group', "Default"
      item.attr 'data-id', set.id
      $list.append item

  # Show the alert and fill its fields
  #
  #   title    - Array. The first value is the title to be used, and the second is the message.
  #   message  - Array of class strings for buttons. A button will be created for each
  #   buttons  - Array of IDs of button messages
  #
  # Returns nothing.
  alert: (args) =>
    @panel.find('.js-alert-title').text args.title
    @panel.find('.js-alert-message').html args.message
    @panel.find('.js-alert-actions').html ''

    $.each args.buttons, (i, value) =>
      data = args.buttons[i]
      button = $('.js-button-template').clone().removeClass('js-button-template')
      button.find('a')
        .text(if data.label then data.label else '')
        .addClass(if data.primary then 'primary' else '')
        .attr('data-callback', if data.callback then data.callback else '')
      @panel.find('.js-alert-actions').append button

    @panel.addClass 'has-alert'

  # Collect data from the grid form.
  #
  #   $form - jQuery object of the form to be used
  #
  # Returns an Object
  getFormData: =>
    $form = $('.js-grid-form')
    obj =
      name: $('.js-grid-form .js-set-name').val()

    $fields = $form.find '.js-grid-form-input'
    $fields.each (index, element) ->
      key = $(element).attr 'data-type'
      obj[key] = $(element).val()

    $checkboxes = $form.find '.js-checkbox'
    $checkboxes.each (index, element) ->
      key = $(element).attr 'data-type'
      obj[key] = true if $(element).hasClass 'checked'
    obj

  # Open a exported sets url
  #
  # Returns nothing
  onClickLink: (event) =>
    event.preventDefault()
    url = $(event.currentTarget).attr 'href'
    GuideGuide.openURL url

  # Draw a guide at the top of the document/selection
  #
  # Return nothing.
  onClickTopGuide: (event) =>
    event.preventDefault()
    GuideGuide.quickGuide "top"

  # Draw a guide at the bottom of the document/selection
  #
  # Return nothing.
  onClickBottomGuide: (event) =>
    event.preventDefault()
    GuideGuide.quickGuide "bottom"

  # Draw a guide to the left of the document/selection
  #
  # Return nothing.
  onClickLeftGuide: (event) =>
    event.preventDefault()
    GuideGuide.quickGuide "left"

  # Draw a guide to the right of the document/selection
  #
  # Return nothing.
  onClickRightGuide: (event) =>
    event.preventDefault()
    GuideGuide.quickGuide "right"

  # Draw a guide at the horizontal midpoint of the document/selection
  #
  # Return nothing.
  onClickHorizontalMidpoint: (event) =>
    event.preventDefault()
    GuideGuide.quickGuide "horizontalMidpoint"

  # Draw a guide at the vertical midpoint of the document/selection
  #
  # Return nothing.
  onClickVerticalMidpoint: (event) =>
    event.preventDefault()
    GuideGuide.quickGuide "verticalMidpoint"

  # Handle clicks on the clear guides button.
  #
  # Returns nothing.
  onClickClearGuides: (event) =>
    event.preventDefault()
    GuideGuide.clearGuides()

  # When the input shell is clicked rather than the input inside, focus the
  # input.
  #
  # Returns nothing.
  onClickInputBackground: (event) =>
    return unless $(event.target).hasClass "js-input-shell"
    $inputs = $(event.currentTarget).find('input')
    $textAreas = $(event.currentTarget).find('textarea')

    $inputs.focus() if $inputs.length
    $textAreas.focus() if $textAreas.length

  # Hide and reveal help text.
  #
  # Returns nothing
  onClickHelpTarget: (event) =>
    event.preventDefault()
    $(event.currentTarget).closest('.js-help').toggleClass "is-helping"

  # Sort a list of form fields and return ones that match a filter
  #
  #    $list - list of objects to be filtered
  #    type  - type of form field to return
  #
  # Returns an Array of jquery objects
  filteredList: ($list,type) ->
    filter  = -> $(this).attr('data-distribute') is type
    $fields = $list.filter filter

  # Switch themes and add the theme to a list for later use
  #
  #   colors           - an object of colors
  #     background     - background color
  #     button         - buttons and inputs
  #     buttonHover    - button and input hover
  #     buttonSelect   - button and input selected
  #     text           - text
  #     highlight      - primary button and links
  #     highlightHover - primary button and links hover
  #     danger         - highlight for negative/warning actions
  #
  # Returns nothing
  updateTheme: (colors) =>
    @panel
      .removeClass('dark-theme light-theme')
      .addClass("#{ colors.prefix || 'dark' }-theme")
    $("head").append('<style id="theme">') if !$("#theme").length
    $("#theme").text """
      #guideguide {
        color: #{ colors.text };
        background-color: #{ colors.background };
      }
      #guideguide a {
        color: #{ colors.text };
      }
      #guideguide a:hover {
        color: #{ colors.highlight };
      }
      #guideguide .nav a.is-selected {
        color: #{ colors.buttonSelect };
      }
      #guideguide .input {
        background-color: #{ colors.button };
      }
      #guideguide .input input, #guideguide .input textarea {
        color: #{ colors.text };
      }
      #guideguide .input.is-focused .input-shell {
        border-color: #{ colors.highlight };
      }
      #guideguide .input.is-invalid .input-shell {
        border-color: #{ colors.danger };
      }
      #guideguide .distribute-highlight .icon {
        color: #{ colors.highlight };
      }
      #guideguide .button {
        background-color: #{ colors.button };
      }
      #guideguide .button:hover {
        background-color: #{ colors.buttonHover };
        color: #{ colors.text };
      }
      #guideguide .button.primary {
        background-color: #{ colors.highlight };
        color: #eee;
      }
      #guideguide .button.primary:hover {
        background-color: #{ colors.highlightHover };
        color: #eee;
      }
      #guideguide .button-clear-guides:hover {
        background-color: #{ colors.danger };
      }
      #guideguide .set-list-set {
        background-color: #{ colors.button };
      }
      #guideguide .set-list-set:hover {
        background-color: #{ colors.buttonHover };
      }
      #guideguide .set-list-set:hover a {
        color: #{ colors.text };
      }
      #guideguide .set-list-set.is-selected {
        background-color: #{ colors.highlight };
        color: #eee;
      }
      #guideguide .set-list-set.is-selected a {
        color: #eee;
      }
      #guideguide .set-list-set.is-selected:hover {
        background-color: #{ colors.highlightHover };
      }
      #guideguide .dropdown.is-active .dropdown-button {
        background-color: #{ colors.highlight };
      }
      #guideguide .dropdown.is-active .dropdown-button:after {
        background-color: #{ colors.highlight };
      }
      #guideguide .dropdown.is-active .dropdown-button:hover, #guideguide .dropdown.is-active .dropdown-button:hover:after {
        background-color: #{ colors.highlightHover };
      }
      #guideguide .dropdown-button {
        background-color: #{ colors.button };
      }
      #guideguide .dropdown-button:before {
        border-color: #{ colors.text } transparent transparent;
      }
      #guideguide .dropdown-button:hover, #guideguide .dropdown-button:hover:after {
        background-color: #{ colors.buttonHover };
      }
      #guideguide .dropdown-button:hover {
        color: #{ colors.text };
      }
      #guideguide .dropdown-button:after {
        background-color: #{ colors.button };
        border-left: 2px solid #{ colors.background };
      }
      #guideguide .dropdown-item {
        background-color: #{ colors.button };
        border-top: 2px solid #{ colors.background };
      }
      #guideguide .dropdown-item:hover {
        color: #{ colors.text };
        background-color: #{ colors.buttonHover };
      }
      #guideguide .alert-body {
        background-color: #{ colors.background };
      }
      #guideguide .scrollbar .handle {
        background-color: #{ colors.buttonSelect };
      }
      #guideguide .importer {
        background-color: #{ colors.background };
      }
      #guideguide .loader-background {
        background-color: #{ colors.background };
      }
      """
