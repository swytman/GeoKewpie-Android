module TeamLogosHelper

  def select_with_icons collection, selected_id
    res = collection.map do |item|
      sel = "selected = \"selected\"" if  item.id == selected_id
      "<option value = #{item.id}  data-imagesrc = \"#{item.logo.url(:standart)}\"#{sel}></option>".html_safe
    end.join("\n").html_safe

    return res = "<option data-imagesrc = \"/pict/missing.jpg\" value></option>\n".html_safe + res
  end
end
