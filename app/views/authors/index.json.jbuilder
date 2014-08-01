json.array! @authors do |author|
  json.id author.id
  json.text author.name
end