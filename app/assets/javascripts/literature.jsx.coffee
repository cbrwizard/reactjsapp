###* @jsx React.DOM ###

$ ->
  titleValue = "Выберите автора"
  authorValue = ""
  bookValue = ""

  # Whole dynamic container
  # @note is rendered in $(".js-literature-box")
  # @props
  #   action: route to action
  #   method type of action
  LiteratureBox = React.createClass
    # Triggers on author select change
    onAuthorChange: (e) ->
      authorValue = e.target.value
      console.log "triggered authorValue #{authorValue}"
      # Сделать ajax запрос и взять список книг автора
      if authorValue != ""
        titleValue = "Выберите произведение"
      else
        titleValue = "Выберите автора"
      this.forceUpdate()

    # Triggers on book select change
    onBookChange: (e) ->
      bookValue = e.target.value
      console.log "triggered book #{bookValue}"
      if bookValue != ""
        titleValue = "#{authorValue} написал произведение #{bookValue}"
      else
        titleValue = "Выберите произведение"
      this.forceUpdate()

    render: ->
      `<section>
         <LiteratureForm booksAction={this.props.booksAction} authorsAction={this.props.authorsAction} method={this.props.method} onAuthorChange={this.onAuthorChange} onBookChange={this.onBookChange}/>
         <ResultTitle text={titleValue}/>
       </section>`

  # Resulting title
  # @note is used in LiteratureBox
  # @props
  #   text [String] text of this title
  ResultTitle = React.createClass
    render: ->
      `<h2 className="text-center" id="main-text">
        {this.props.text}
      </h2>`


  # Dynamic form
  # @note is used in LiteratureBox
  # @props
  #   action: route to action
  #   method type of action
  LiteratureForm = React.createClass
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

    render: ->
      `<form accept-charset="UTF-8" action={this.props.action} className="simple_form" method={this.props.method} noValidate="novalidate">
        <div style={{"display":"none"}}>
          <input name="utf8" type="hidden" value="✓" />
        </div>
        <LiteratureFormGroup id="get_books_author" name="get_books[author]" label="Имя автора" data={this.state.authors_data} onChangeMethod={this.props.onAuthorChange} />
        <LiteratureFormGroup id="get_books_book" name="get_books[book]" label="Произведение" data={this.state.books_data} onChangeMethod={this.props.onBookChange} />
        <input className="btn btn-success" name="commit" type="submit" value="Мне повезёт!" />
      </form>`


  # Form group with input etc
  # @note is used in LiteratureForm
  # @props
  #   id: html id of select
  #   name: html name of select
  #   data: data for options
  #   label: label text
  LiteratureFormGroup = React.createClass
    render: ->
      # kinda .downcases a label
      placeholder = "Выберите" + " " + this.props.label.charAt(0).toLowerCase() + this.props.label.slice(1)
      `<div className="form-group">
        <label htmlFor={this.props.id}>{this.props.label}</label>
        <LiteratureSelect id={this.props.id} name={this.props.name} data={this.props.data} placeholder={placeholder} onChangeMethod={this.props.onChangeMethod} />
      </div>`


  # Option for literature select
  # @note is used in LiteratureSelect
  # @props
  #   id: id of data element
  #   text: text of data element
  LiteratureOption = React.createClass
    render: ->
      `<option value={this.props.id}>{this.props.text}</option>`


  # Select for literature form
  # @note is used in LiteratureFormGroup
  # @props
  #   id: html id of select
  #   name: html name of select
  #   data: data for options
  LiteratureSelect = React.createClass
    onInputChange: (e) ->
      this.props.onChangeMethod(e)

    render: ->
      select_options = this.props.data.map((option) ->
        `<LiteratureOption id={option.id} text={option.text} />`
      )
      `<select className="form-control" id={this.props.id} name={this.props.name} onChange={this.onInputChange}>
        <option value="">{this.props.placeholder}</option>
        {select_options}
       </select>`


  # Renders stuff on page
  # React.renderComponent(
  container = $(".js-literature-box")
  React.renderComponent(
    new LiteratureBox({
      booksAction: container.attr("data-books-action")
      authorsAction: container.attr("data-authors-action")
      method: container.attr("data-method")
    }), container[0]
  )