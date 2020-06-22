defmodule Novy.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :tag, :string
      add :content, :text
      add :show, :boolean, default: false, null: false

      timestamps()
    end

  end
end
