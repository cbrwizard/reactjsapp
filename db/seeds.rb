# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

pushkin = Author.create(name: "Александр Сергеевич Пушкин")
mayakovskiy = Author.create(name: "Владимир Владимирович Маяковский")
esenin = Author.create(name: "Есенин, Сергей Александрович")

Book.create([
  {name: "Капитанская дочка", author: pushkin},
  {name: "Дубровский", author: pushkin},
  {name: "Сказка о Царе Салтане", author: pushkin},
  {name: "Осень", author: esenin},
  {name: "Пропавший месяц", author: esenin},
  {name: "Я сам", author: mayakovskiy},
])