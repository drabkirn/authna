class ApiRequestCheck

  def matches?(request)
    if check_content_type_header(request.content_type)
      true
    else
      false
    end
  end

  private

  def check_content_type_header(content_type)
    content_type && content_type == "application/json"
  end
end