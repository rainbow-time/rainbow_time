module ManagedApi
  def response
    debug "#{@method} #{@uri} with #{request_options}"
    # todo: safe to retry several times here
    http_party_response = super
    code = http_party_response.code
    debug "returned #{code}"

    if code.to_s !~ /2\d\d/
      text = http_party_response.parsed_response
      if text =~ /!DOCTYPE/
        debug Nokogiri::HTML(text).to_html
      else
        debug text
      end
      failure =  "#{@method} #{@uri} #{request_options} returned #{code}"
      error failure
      raise failure
    end

    mash(http_party_response.parsed_response)
  end
end

class TraktApi::Base
  prepend ManagedApi
end