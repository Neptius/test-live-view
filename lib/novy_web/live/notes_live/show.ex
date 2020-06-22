defmodule NovyWeb.NotesLive.Show do
  use NovyWeb, :live_view

  alias Novy.Blog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:notes, Blog.get_notes!(id))}
  end

  defp page_title(:show), do: "Show Notes"
  defp page_title(:edit), do: "Edit Notes"
end
