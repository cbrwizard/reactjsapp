# include spec/javascripts/helpers/some_helper_file.js and app/assets/javascripts/foo.js
# require helpers/some_helper_file
#= require literature
describe "Foo", ->
  it "does something", ->
    reactUtils = React.addons.TestUtils
    expect(test).toBe true
    label = React.DOM.label({className: "commentBox"},
      "Hello, world! I am a CommentBox."
    )
    reactUtils.renderIntoDocument(label)
    expect(label).toBeDefined()