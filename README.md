# labels
labels is a ruby web based on sinatra app to generate printable label pdfs.

these kind of labels are used by libraries to tag books e.a. with author shortcut or genre.

## install
install the sinatra and prawn gem

`bundle install`

`bundle update`

## usage
default port: 5656

paperstyle can be set in paper.json

### run
`ruby labels.rb`


## utilizes
[sinatra](https://github.com/sinatra/sinatra)

[sinatra-prawn](https://github.com/sbfaulkner/sinatra-prawn)

[json](https://github.com/flori/json/tree/master)