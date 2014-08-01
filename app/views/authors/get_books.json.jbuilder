json.array! @books do |book|
  json.id book.id
  json.text book.name
end