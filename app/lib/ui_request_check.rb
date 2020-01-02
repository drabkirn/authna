class UiRequestCheck
  
  def matches?(request)
    if check_content_type_header(request.content_type)
      false
    else
      true
    end
  end

  private

  def check_content_type_header(content_type)
    content_type && content_type == "application/json"
  end
end