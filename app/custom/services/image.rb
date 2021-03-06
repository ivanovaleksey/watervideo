module Services
  class Image
    def initialize(args)
      @args   = args
      @height = args[:height]
      @width  = args[:width]
      @text   = args[:text]
    end

    def call
      Rails.logger.debug("Image#call: #{@args}")

      image = create_image
      image.filename
    end

    private

    def create_image
      canvas = Magick::Image.new(@width, @height) do |c|
        c.background_color = 'none'
      end

      draw = Magick::Draw.new do |d|
        d.pointsize   = 50
        d.fill        = '#ffffff'
        d.stroke      = '#000000'
        d.font_weight = Magick::BoldWeight
        d.gravity     = Magick::CenterGravity
      end

      draw.fill_opacity('80%')
      draw.stroke_opacity('60%')
      draw.text(0, 0, @text)
      draw.draw(canvas)

      tmp_file = Tempfile.new(%w(image .png), Rails.root.join('tmp')).path
      canvas.write(tmp_file)
    end
  end
end
