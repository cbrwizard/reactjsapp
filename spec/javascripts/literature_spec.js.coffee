# include spec/javascripts/helpers/some_helper_file.js and app/assets/javascripts/foo.js
# require helpers/some_helper_file
#= require literature
reactUtils = React.addons.TestUtils
title = null
literatureBox = null

# Creates initial vars for future usage
beforeEach ->
  literatureBox = reactUtils.renderIntoDocument(
    new LiteratureBox({
      booksAction: "/authors/get_books"
      authorsAction: "/authors"
      method: "get"
    })
  )
  title = reactUtils.findRenderedDOMComponentWithTag(literatureBox, 'h2')

# Just checks that all data is correct at start
describe "Initial state", ->
  it "has no data at start", ->
    expect(literatureBox.state.authors_data).toEqual []
    expect(literatureBox.state.books_data).toEqual []

  it "shows initial title", ->
    expect(title.getDOMNode().textContent).toEqual 'Выберите автора'

  it "loads authors data with ajax",(done) ->
    setTimeout  ->
      expect(literatureBox.state.authors_data).not.toEqual []
      done()
    , 200


# Checks that author and books select trigger select events
describe "Selects change", ->
  # Gets authors data and selects a random author
  beforeEach (done) ->
    setTimeout ->
      expect(literatureBox.state.authors_data.length).not.toEqual 0
      done()
    , 200

    authorsSelect = reactUtils.findAllInRenderedTree(literatureBox,(component) ->
      component.getDOMNode().id == "get_books_author"
    )[0]
    fake_change_object =
      target:
        value: 2
        text: "Мега автор"
      fake: true

    reactUtils.Simulate.change(authorsSelect.getDOMNode(), fake_change_object)

  describe "Author change", ->
    it "changes title on author change", (done) ->
      setTimeout ->
        expect(title.getDOMNode().textContent).toEqual 'Выберите произведение'
        done()
      , 200

  describe "Book change", ->
    it "changes title on book change", (done) ->
      booksSelect = reactUtils.findAllInRenderedTree(literatureBox,(component) ->
        component.getDOMNode().id == "get_books_book"
      )[0]

      fake_change_object =
        target:
          value: 2
          text: "Мега произведение"
        fake: true
      reactUtils.Simulate.change(booksSelect.getDOMNode(), fake_change_object)

      setTimeout ->
        expect(title.getDOMNode().textContent).toEqual 'Мега автор написал произведение Мега произведение'
        done()
      , 200

# Checks that lucky button click turns on change events
describe "Lucky button", ->
  beforeEach (done) ->
    setTimeout ->
      expect(literatureBox.state.authors_data.length).not.toEqual 0
      done()
    , 200

  it "changes title on lucky change", (done) ->
    form = reactUtils.findRenderedComponentWithType(literatureBox, LiteratureForm)

    fake_change_object =
      value: 2
      text: "Случайный автор"
      fake: true
    reactUtils.Simulate.submit(form.getDOMNode(), fake_change_object)

    setTimeout ->
      expect(title.getDOMNode().textContent).toEqual 'Случайный автор написал произведение '
      done()
    , 200
