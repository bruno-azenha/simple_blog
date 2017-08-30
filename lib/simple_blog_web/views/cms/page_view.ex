defmodule SimpleBlogWeb.CMS.PageView do
  use SimpleBlogWeb, :view

  alias SimpleBlog.CMS

  def author_name(%CMS.Page{author: author}) do
    author.user.name
  end
end
