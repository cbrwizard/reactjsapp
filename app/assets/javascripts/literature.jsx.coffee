###* @jsx React.DOM ###

$ ->
  authors_data = [
    {id: 1
    text: "Александр Сергеевич Пушкин"},
    {id: 2
    text: "Владимир Владимирович Маяковский"},
    {id: 3
    text: "Есенин, Сергей Александрович"}
  ]
  books_data = []

  # Whole dynamic container
  # @props
  #   action: route to action
  #   method type of action
  LiteratureBox = React.createClass
    render: ->
      `<section>
         <LiteratureForm action={this.props.action} method={this.props.method} />
         <ResultTitle />
       </section>`


  # Resulting title
  # @states
  #   text [String] text of this title
  ResultTitle = React.createClass
    getInitialState: ->
      text: "Выберите автора"
    render: ->
      `<h2 className="text-center" id="main-text">
        {this.state.text}
      </h2>`


  # Dynamic form
  # Whole dynamic container
  # @props
  #   action: route to action
  #   method type of action
  LiteratureForm = React.createClass
    render: ->
      `<form accept-charset="UTF-8" action={this.props.action} className="simple_form" method={this.props.method} noValidate="novalidate">
        <div style={{"display":"none"}}>
          <input name="utf8" type="hidden" value="✓" />
        </div>
        <LiteratureFormGroup id="get_books_author" name="get_books[author]" label="Имя автора" data={authors_data} />
        <LiteratureFormGroup id="get_books_book" name="get_books[book]" label="Произведение" data={books_data} />
        <input className="btn btn-success" name="commit" type="submit" value="Мне повезёт!" />
      </form>`


  # Form group with input etc
  # @props
  #   id: html id of select
  #   name: html name of select
  #   data: data for options
  #   label: label text
  LiteratureFormGroup = React.createClass
    render: ->
      `<div className="form-group">
        <label htmlFor={this.props.id}>{this.props.label}</label>
        <LiteratureSelect id={this.props.id} name={this.props.name} data={this.props.data} />
      </div>`


  # Option for literature select
  # @props
  #   id: id of data element
  #   text: text of data element
  LiteratureOption = React.createClass
    render: ->
      `<option value={this.props.id}>{this.props.text}</option>`


  # Select for literature form
  # @props
  #   id: html id of select
  #   name: html name of select
  #   data: data for options
  LiteratureSelect = React.createClass
    render: ->
      select_options = this.props.data.map((option) ->
        `<LiteratureOption id={option.id} text={option.text} />`
      )
      `<select className="form-control" id={this.props.id} name={this.props.name}>
        {select_options}
       </select>`


#  # Renders stuff on page
#  React.renderComponent(
  container = $(".js-literature-box")
  React.renderComponent(
    new LiteratureBox({
      action: container.attr("data-action")
      method: container.attr("data-method")
    }), container[0]
  )