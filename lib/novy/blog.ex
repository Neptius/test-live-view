defmodule Novy.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Novy.Repo

  alias Novy.Blog.Notes

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Notes{}, ...]

  """
  def list_notes do
    Repo.all(from n in Notes, order_by: [desc: n.id])
  end

  @doc """
  Gets a single notes.

  Raises `Ecto.NoResultsError` if the Notes does not exist.

  ## Examples

      iex> get_notes!(123)
      %Notes{}

      iex> get_notes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notes!(id), do: Repo.get!(Notes, id)

  @doc """
  Creates a notes.

  ## Examples

      iex> create_notes(%{field: value})
      {:ok, %Notes{}}

      iex> create_notes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notes(attrs \\ %{}) do
    %Notes{}
    |> Notes.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:note_created)
  end

  @doc """
  Updates a notes.

  ## Examples

      iex> update_notes(notes, %{field: new_value})
      {:ok, %Notes{}}

      iex> update_notes(notes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notes(%Notes{} = notes, attrs) do
    notes
    |> Notes.changeset(attrs)
    |> Repo.update()
    |> broadcast(:note_created)
    |> broadcast(:note_created)
  end

  @doc """
  Deletes a notes.

  ## Examples

      iex> delete_notes(notes)
      {:ok, %Notes{}}

      iex> delete_notes(notes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notes(%Notes{} = notes) do
    notes
    |> Repo.delete()
    |> broadcast(:note_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notes changes.

  ## Examples

      iex> change_notes(notes)
      %Ecto.Changeset{data: %Notes{}}

  """
  def change_notes(%Notes{} = notes, attrs \\ %{}) do
    Notes.changeset(notes, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Novy.PubSub, "notes")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, note}, event) do
    Phoenix.PubSub.broadcast(Novy.PubSub, "notes", {event, note})
    {:ok, note}
  end

end
