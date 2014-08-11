# include spec/javascripts/helpers/some_helper_file.js and app/assets/javascripts/foo.js
# require helpers/some_helper_file
#= require literature
describe "Literature", ->
  reactUtils = React.addons.TestUtils
  title = null
  literatureBox = null

  beforeEach ->
    literatureBox = reactUtils.renderIntoDocument(
      new LiteratureBox({
        booksAction: "/authors/get_books"
        authorsAction: "/authors"
        method: "get"
      })
    )
    title = reactUtils.findRenderedDOMComponentWithTag(literatureBox, 'h2')

  it "has no data at start", ->
    expect(literatureBox.state.authors_data).toEqual []
    expect(literatureBox.state.books_data).toEqual []

  it "shows initial title", ->
    expect(title.getDOMNode().textContent).toEqual 'Выберите автора'