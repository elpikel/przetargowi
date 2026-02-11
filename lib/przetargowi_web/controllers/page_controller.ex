defmodule PrzetargowiWeb.PageController do
  use PrzetargowiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
