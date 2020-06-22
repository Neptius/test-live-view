defmodule NovyWeb.NotesLiveTest do
  use NovyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Novy.Blog

  @create_attrs %{content: "some content", show: true, tag: "some tag", title: "some title"}
  @update_attrs %{content: "some updated content", show: false, tag: "some updated tag", title: "some updated title"}
  @invalid_attrs %{content: nil, show: nil, tag: nil, title: nil}

  defp fixture(:notes) do
    {:ok, notes} = Blog.create_notes(@create_attrs)
    notes
  end

  defp create_notes(_) do
    notes = fixture(:notes)
    %{notes: notes}
  end

  describe "Index" do
    setup [:create_notes]

    test "lists all notes", %{conn: conn, notes: notes} do
      {:ok, _index_live, html} = live(conn, Routes.notes_index_path(conn, :index))

      assert html =~ "Listing Notes"
      assert html =~ notes.content
    end

    test "saves new notes", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.notes_index_path(conn, :index))

      assert index_live |> element("a", "New Notes") |> render_click() =~
               "New Notes"

      assert_patch(index_live, Routes.notes_index_path(conn, :new))

      assert index_live
             |> form("#notes-form", notes: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notes-form", notes: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.notes_index_path(conn, :index))

      assert html =~ "Notes created successfully"
      assert html =~ "some content"
    end

    test "updates notes in listing", %{conn: conn, notes: notes} do
      {:ok, index_live, _html} = live(conn, Routes.notes_index_path(conn, :index))

      assert index_live |> element("#notes-#{notes.id} a", "Edit") |> render_click() =~
               "Edit Notes"

      assert_patch(index_live, Routes.notes_index_path(conn, :edit, notes))

      assert index_live
             |> form("#notes-form", notes: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notes-form", notes: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.notes_index_path(conn, :index))

      assert html =~ "Notes updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes notes in listing", %{conn: conn, notes: notes} do
      {:ok, index_live, _html} = live(conn, Routes.notes_index_path(conn, :index))

      assert index_live |> element("#notes-#{notes.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#notes-#{notes.id}")
    end
  end

  describe "Show" do
    setup [:create_notes]

    test "displays notes", %{conn: conn, notes: notes} do
      {:ok, _show_live, html} = live(conn, Routes.notes_show_path(conn, :show, notes))

      assert html =~ "Show Notes"
      assert html =~ notes.content
    end

    test "updates notes within modal", %{conn: conn, notes: notes} do
      {:ok, show_live, _html} = live(conn, Routes.notes_show_path(conn, :show, notes))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Notes"

      assert_patch(show_live, Routes.notes_show_path(conn, :edit, notes))

      assert show_live
             |> form("#notes-form", notes: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#notes-form", notes: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.notes_show_path(conn, :show, notes))

      assert html =~ "Notes updated successfully"
      assert html =~ "some updated content"
    end
  end
end
