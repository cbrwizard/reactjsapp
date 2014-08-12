###* @jsx React.DOM ###

$ =>
  # Important dynamic values
  authorValue = {id:"", text: ""}
  bookValue = {id:"", text: ""}
  titleValue = "Выберите автора"

  # Whole dynamic container
  # @note is rendered in $(".js-literature-box")
  # @props
  #   action: route to action
  #   method type of action
  @LiteratureBox = React.createClass
    getInitialState: -> {
      authors_data: []
      books_data: []
    }

    # Loads authors
    componentDidMount: ->
      $.ajax
        url: this.props.authorsAction
        dataType: 'json'
        success: (data) =>
          this.setState({authors_data: data})
        error: (xhr, status, err) =>
          console.error(this.props.url, status, err.toString())

    # Changes books to a selected author
    # @note Triggers on author select change
    # @param randomMode [Boolean] determines whenever it should work with random values
    onAuthorChange: (e, randomMode) ->
      if randomMode == true
        text = e.target.text
      else
        text = if e.target.value == "" then "" else $(e.target).find("option[value=#{e.target.value}]").text()
      authorValue =
        id: e.target.value
        text: text

      # Gets books of selected author
      $.ajax
        url: this.props.booksAction
        dataType: 'json'
        data:
          author_id: authorValue.id
        # Populates books select
        success: (data) =>
          this.setState({books_data: data})
          $("#get_books_book").val("")

          # Triggers book change for a random book
          if randomMode == true
            max = data.length + 1
            min = 2
            random = get_random(min, max)
            option = $("#get_books_book option:nth-child(#{random})")
            option.attr('selected','selected')
            fake_change_object =
              target:
                value: option.val()
                text: option.text()
            this.onBookChange(fake_change_object, randomMode)
          else
            if authorValue.id != ""
              titleValue = "Выберите произведение"
            else
              titleValue = "Выберите автора"
            this.forceUpdate()
        fail: (xhr, status, err) =>
          console.error(this.props.url, status, err.toString())

    # Changes title to selected book
    # @note triggers on book select change
    # @param randomMode [Boolean] determines whenever it should work with random values
    onBookChange: (e, randomMode) ->
      if randomMode == true
        text = e.target.text
      else
        text = if e.target.value == "" then "" else $(e.target).find("option[value=#{e.target.value}]").text()
      bookValue =
        id: e.target.value
        text: text

      if bookValue.id != ""
        titleValue = "#{authorValue.text} написал произведение #{bookValue.text}"
      else
        titleValue = "Выберите произведение"
      this.forceUpdate()

    # On lucky button click randomize author and books
    onSubmit: (e) ->
      e.preventDefault()
      max = $("#get_books_author option").length
      min = 2
      random = get_random(min, max)
      option = $("#get_books_author option:nth-child(#{random})")
      option.attr('selected','selected')
      fake_change_object =
        target:
          value: option.val()
          text: option.text()
      randomMode = true
      this.onAuthorChange(fake_change_object, randomMode)

    render: ->
      `<section>
         <LiteratureForm booksAction={this.props.booksAction} authorsAction={this.props.authorsAction} method={this.props.method} onAuthorChange={this.onAuthorChange} onBookChange={this.onBookChange} onSubmitMethod = {this.onSubmit} books_data= {this.state.books_data} authors_data= {this.state.authors_data} key="literatureForm"/>
         <ResultTitle text={titleValue}/>
       </section>`

  # Resulting title
  # @note is used in LiteratureBox
  # @props
  #   text [String] text of this title
  @ResultTitle = React.createClass
    render: ->
      `<h2 className="text-center" id="main-text">
        {this.props.text}
      </h2>`


  # Dynamic form
  # @note is used in LiteratureBox
  # @props
  #   action: route to action
  #   method type of action
  @LiteratureForm = React.createClass
    onSubmit: (e) ->
      this.props.onSubmitMethod(e)

    render: ->
      `<form accept-charset="UTF-8" action={this.props.action} className="simple_form" method={this.props.method} noValidate="novalidate" onSubmit={this.onSubmit}>
        <div style={{"display":"none"}}>
          <input name="utf8" type="hidden" value="✓" />
        </div>
        <LiteratureFormGroup id="get_books_author" name="get_books[author]" label="Имя автора" data={this.props.authors_data} onChangeMethod={this.props.onAuthorChange} key="authorInput" />
        <LiteratureFormGroup id="get_books_book" name="get_books[book]" label="Произведение" data={this.props.books_data} onChangeMethod={this.props.onBookChange} key="booksInput"/>
        <input className="btn btn-success" name="commit" type="submit" value="Мне повезёт!" />
      </form>`


  # Form group with input etc
  # @note is used in LiteratureForm
  # @props
  #   id: html id of select
  #   name: html name of select
  #   data: data for options
  #   label: label text
  @LiteratureFormGroup = React.createClass
    render: ->
      # kinda .downcases a label
      placeholder = "Выберите" + " " + this.props.label.charAt(0).toLowerCase() + this.props.label.slice(1)
      `<div className="form-group">
        <label htmlFor={this.props.id}>{this.props.label}</label>
        <LiteratureSelect id={this.props.id} name={this.props.name} data={this.props.data} placeholder={placeholder} onChangeMethod={this.props.onChangeMethod} key={this.props.name} />
      </div>`


  # Option for literature select
  # @note is used in LiteratureSelect
  # @props
  #   id: id of data element
  #   text: text of data element
  @LiteratureOption = React.createClass
    render: ->
      `<option value={this.props.id}>{this.props.text}</option>`


  # Select for literature form
  # @note is used in LiteratureFormGroup
  # @props
  #   id: html id of select
  #   name: html name of select
  #   data: data for options
  @LiteratureSelect = React.createClass
    onInputChange: (e) ->
      this.props.onChangeMethod(e)

    render: ->
      select_options = this.props.data.map((option) ->
        `<LiteratureOption id={option.id} text={option.text} key={option.id} />`
      )
      `<select className="form-control" id={this.props.id} name={this.props.name} onChange={this.onInputChange}>
        <option value="">{this.props.placeholder}</option>
        {select_options}
       </select>`

  container = $(".js-literature-box")
  if container.length > 0
    renderForm(container)


# Gets random number
# @param min [Integer] min of range
# @param max [Integer] max of range
# @return [Integer]
get_random = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


# Renders the whole form
# param container [jQuery selector] where the form should be rendered
@renderForm = (container) ->
  # Renders stuff on page
  # React.renderComponent(
  React.renderComponent(
    new LiteratureBox({
      booksAction: container.attr("data-books-action")
      authorsAction: container.attr("data-authors-action")
      method: container.attr("data-method")
    }), container[0]
  )