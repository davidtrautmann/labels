# labels.rb
require 'rubygems'
require 'sinatra'
require 'prawn'
require 'prawn/measurement_extensions'

set :port, 5656

get '/' do
  erb :index
end

##
# post action to generate the pdf
#
post '/' do
  row = 0
  column = 0
  postParams = params
  Prawn::Document.generate "labels.pdf",
  :margin => [0,0,0,0],
  :page_size   => 'A4' do
    while row < 12
      while column < 4
        rotation = 0
        size = 14
        width = 45.72.mm
        height = 21.167.mm
        dx = 0.mm
        dy = 0.mm

        # get orientation from post parameters
        case postParams["orientation" + row.to_s + "_" + column.to_s]
        when "vertical"
          rotation = 90
          width,height = height,width
          dx = 12.9.mm
          dy = 12.9.mm
        when "verticalBig"
          rotation = 90
          size = 22
          width,height = height,width
          dx = 12.9.mm
          dy = 12.9.mm
        else
          rotation = 0
        end

        # create the textbox
        text_box postParams["field" + row.to_s + "_" + column.to_s],
        :at => [9.75.mm + column * (45.72.mm + 2.54.mm) + dx, dy + (21.5.mm + 21.167.mm) + row * 21.167.mm],
        :height => height,
        :width => width,
        :size => size,
        :align => :center,
        :valign => :center,
        :rotate_around => :center,
        :rotate => rotation,
        :style => :bold
        column += 1
      end
      column = 0
      row += 1
    end
  end

  # return the odf file as the correct type
  send_file 'labels.pdf', :type => 'application/pdf', :disposition => 'inline'
end