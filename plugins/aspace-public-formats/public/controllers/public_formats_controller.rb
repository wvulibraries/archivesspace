class PublicFormatsController < ApplicationController

  def generate
    check_format params[:type], params[:format]
    handle params[:repo_id], params[:type], params[:format], params[:id]
  end

  private

  def handle(repo_id, type, format, id)
    uri      = URI.parse AppConfig[:backend_url]
    http     = Net::HTTP.new uri.host, uri.port
    
    format, mime = format.split("_") 
    mime ||= "xml" 

    request  = Net::HTTP::Get.new "/plugins/public_formats/repository/#{repo_id}/#{type}/#{format}/#{id}.#{mime}"
    response = http.request request 
    if response.code == "200"
      content_type = format == "html" ? format : mime 
      content = response.body

      if content_type == "html"
        raise "XSLTPROC not found" unless File.file? AppConfig[:xsltproc_path]
        raise "XSLT not found" unless File.file? AppConfig[:xslt_path]
        ead  = Tempfile.new('public-formats-ead')
        html = Tempfile.new('public-formats-html')
        ead.write content

        system("#{AppConfig[:xsltproc_path]} -o #{html.path} #{AppConfig[:xslt_path]} #{ead.path}")
        content = html.read

        [ead, html].each { |f| f.close; f.unlink }
      end
      if content_type == "pdf"
        send_data content, :filename => "#{id}_#{format}.pdf", :type => "application/pdf"   
      else
        render text: content, :content_type => "text/#{content_type}"
      end
    else
      raise RecordNotFound.new
    end
  end

  def check_format(type, format)
    formats = {
      resources: [ "ead", "ead_pdf", "html", "marcxml" ],
      digital_objects: ["dc", "mets", "mods"],
    }
    raise RecordNotFound.new unless formats[type.intern].include? format
  end

end
