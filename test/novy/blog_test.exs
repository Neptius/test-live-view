defmodule Novy.BlogTest do
  use Novy.DataCase

  alias Novy.Blog

  describe "notes" do
    alias Novy.Blog.Notes

    @valid_attrs %{content: "some content", show: true, tag: "some tag", title: "some title"}
    @update_attrs %{content: "some updated content", show: false, tag: "some updated tag", title: "some updated title"}
    @invalid_attrs %{content: nil, show: nil, tag: nil, title: nil}

    def notes_fixture(attrs \\ %{}) do
      {:ok, notes} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_notes()

      notes
    end

    test "list_notes/0 returns all notes" do
      notes = notes_fixture()
      assert Blog.list_notes() == [notes]
    end

    test "get_notes!/1 returns the notes with given id" do
      notes = notes_fixture()
      assert Blog.get_notes!(notes.id) == notes
    end

    test "create_notes/1 with valid data creates a notes" do
      assert {:ok, %Notes{} = notes} = Blog.create_notes(@valid_attrs)
      assert notes.content == "some content"
      assert notes.show == true
      assert notes.tag == "some tag"
      assert notes.title == "some title"
    end

    test "create_notes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_notes(@invalid_attrs)
    end

    test "update_notes/2 with valid data updates the notes" do
      notes = notes_fixture()
      assert {:ok, %Notes{} = notes} = Blog.update_notes(notes, @update_attrs)
      assert notes.content == "some updated content"
      assert notes.show == false
      assert notes.tag == "some updated tag"
      assert notes.title == "some updated title"
    end

    test "update_notes/2 with invalid data returns error changeset" do
      notes = notes_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_notes(notes, @invalid_attrs)
      assert notes == Blog.get_notes!(notes.id)
    end

    test "delete_notes/1 deletes the notes" do
      notes = notes_fixture()
      assert {:ok, %Notes{}} = Blog.delete_notes(notes)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_notes!(notes.id) end
    end

    test "change_notes/1 returns a notes changeset" do
      notes = notes_fixture()
      assert %Ecto.Changeset{} = Blog.change_notes(notes)
    end
  end
end
