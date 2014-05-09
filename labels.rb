# labels.rb
require 'rubygems'
require 'sinatra'
require 'prawn'
require 'prawn/measurement_extensions'
require 'json'

set :port, 5656

# read paper styles from json file
paper_styles = JSON.parse(File.read('./public/paper.json'))['paper_styles']

##
# get action for initial url
#
get '/'  do
  redirect '/0'
end

##
# get action to show the input form
#
get '/:paper' do
  # TODO: change paperstyle
  paper = params[:paper].to_i
  erb :index,
    locals: {
      paper_styles: paper_styles,
      paper: paper,
      rows: paper_styles[paper]['rows'].to_i,
      columns: paper_styles[paper]['columns'].to_i
    }
end

##
# post action to generate the pdf
#
post '/:paper' do
  # paper style
  paper = params[:paper].to_i
  # TODO: multiple paper_styles in json
  margin = [
    paper_styles[paper]['margin_top'].to_f.mm,
    paper_styles[paper]['margin_right'].to_f.mm,
    paper_styles[paper]['margin_bottom'].to_f.mm,
    paper_styles[paper]['margin_left'].to_f.mm
  ]
  height        = paper_styles[paper]['height'].to_f.mm
  width         = paper_styles[paper]['width'].to_f.mm
  size_standard = paper_styles[paper]['size_standard'].to_i
  size_big      = paper_styles[paper]['size_big'].to_i
  rows          = paper_styles[paper]['rows'].to_i
  columns       = paper_styles[paper]['columns'].to_i

  # variable used for all cells
  rotation = 0
  post_params = params

  # call prawn document generator
  Prawn::Document.generate 'labels.pdf',
  margin:    margin,
  page_size: paper_styles[0]['page_size'] do
    (0..(rows - 1)).each do |row|
      (0..(columns - 1)).each do |column|
        size = size_standard

        # POST parameters from form
        orientation = post_params['orientation' + row.to_s + '_' + column.to_s]
        cell = post_params['field' + row.to_s + '_' + column.to_s]

        height_after_rotation = height
        width_after_rotation = width
        dx = 0.mm
        dy = 0.mm

        # get orientation from post parameters
        case orientation
        when 'vertical', 'verticalBig'
          rotation = 90
          # swap height and width due to rotation
          height_after_rotation = width
          width_after_rotation = height
          # location adjustments due to rotation
          # TODO: calculate from height and width
          dx = 12.9.mm
          dy = 12.9.mm
          # uppercase and big fontsize fro verticalBig
          if orientation == 'verticalBig'
            cell = to_upcase_vertical(cell)
            size = size_big
          end
        else
          rotation = 0
        end

        # create the textbox
        text_box cell,
          at: [(column * width) + dx , ((row + 1) * height) + dy],
          height: height_after_rotation,
          width: width_after_rotation,
          size: size,
          align: :center,
          valign: :center,
          rotate_around: :center,
          rotate: rotation,
          style: :bold
      end
    end
  end

  # return the odf file as the correct type
  send_file 'labels.pdf', type: 'application/pdf', disposition: 'inline'
end

##
# method to make a text uppercase and vertical
#
def to_upcase_vertical(cell_text)
  text_vertical = ''
  cell_text.split('').each do |letter|
    text_vertical << "#{letter.upcase}\n"
  end
  return text_vertical
end
