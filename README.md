# labels
labels is a ruby web based on sinatra app to generate printable label pdfs.

these kind of labels are used by libraries to tag books e.a. with author shortcut or genre.

## install
install the sinatra, prawn and json gems:

```shell
git clone git@github.com:davidtrautmann/labels.git
bundle install
bundle update
```

## usage
`default port: 5656`

### paper styles
paper style can be set in paper.json

```json
{
  "paper_name": "testpaper",

  "page_size": "A4",
  "margin_top": "21.5",
  "margin_right": "9.75",
  "margin_bottom": "21.5",
  "margin_left": "9.75",
  "width": "45.72",
  "height": "21.167",
  "size_standard": "14",
  "size_big": "22",
  "rows": "12",
  "columns": "4"
}
```

### run
```shell
ruby labels.rb
```


## utilizes
[sinatra](https://github.com/sinatra/sinatra)

[sinatra-prawn](https://github.com/sbfaulkner/sinatra-prawn)

[json](https://github.com/flori/json/tree/master)
