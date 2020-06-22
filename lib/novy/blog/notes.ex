defmodule Novy.Blog.Notes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :content, :string
    field :show, :boolean, default: false
    field :tag, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(notes, attrs) do
    notes
    |> cast(attrs, [:title, :tag, :content, :show])
    |> validate_required([:title, :tag, :content, :show])
  end
end
