defmodule NovyWeb.NotesLive.Index do
  use NovyWeb, :live_view

  alias Novy.Blog
  alias Novy.Blog.Notes

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Blog.subscribe()
    {:ok, assign(socket, :notes_collection, list_notes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Notes")
    |> assign(:notes, Blog.get_notes!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Notes")
    |> assign(:notes, %Notes{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notes")
    |> assign(:notes, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notes = Blog.get_notes!(id)
    {:ok, _} = Blog.delete_notes(notes)

    {:noreply, assign(socket, :notes_collection, list_notes())}
  end

  @impl true
  def handle_info({:note_created, note}, socket) do
    IO.inspect("-----note_created-------")
    {:noreply, update(socket, :notes_collection, fn notes -> [note | notes] end)}
  end

  @impl true
  def handle_info({:note_updated, updated_note}, socket) do
    IO.inspect("-----note_updated-------")
    {:noreply, update(socket, :notes_collection, fn notes ->
      for note <- notes do
        case note.id == updated_note.id do
          true -> updated_note
          _ -> note
        end
      end
    end)}
  end

  @impl true
  def handle_info({:note_deleted, deleted_note}, socket) do
    IO.inspect("-----note_deleted-------")
    {:noreply,
      update(socket, :notes_collection, fn notes ->
        notes
        |> Enum.reject(fn note ->
          note.id == deleted_note.id
        end)
      end)}
  end

  defp list_notes do
    Blog.list_notes()
  end
end
